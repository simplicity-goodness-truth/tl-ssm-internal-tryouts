*&---------------------------------------------------------------------*
*& Report  zalert_data_iqbgrfc
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zalert_data_iqrfc.

constants: lv_serv_group type spta_rfcgr value 'SPTA'.

types tt_alerts_list type table of e2ea_guid with default key.

types: begin of ty_alerts_per_task,
         task_number type int4,
         alerts_list type tt_alerts_list,
       end of ty_alerts_per_task.

types tt_alerts_per_task type table of ty_alerts_per_task.


data:
  lt_context            type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
  lv_free_pbt_wps       type i,
  lv_wp_data_received   type abap_bool,
  lv_max_tasks          type i,
  lv_alerts_per_task    type integer,
  lt_alerts_for_task    type tt_alerts_per_task,
  wa_alerts_for_task    type ty_alerts_per_task,
  lv_task_number        type int4 value 1,
  lv_inbound_queue_name type  trfcqnam.


" getting all alerts list

new zcl_alert_data_spta_pack_mgr( )->get_alerts_list(
    importing
        et_result = lt_context
    ).

" getting free available WP in idea to have one queue per one WP

call function 'SPBT_INITIALIZE'
  exporting
    group_name                     = lv_serv_group
  importing
    free_pbt_wps                   = lv_free_pbt_wps
  exceptions
    invalid_group_name             = 1
    internal_error                 = 2
    pbt_env_already_initialized    = 3
    currently_no_resources_avail   = 4
    no_pbt_resources_found         = 5
    cant_init_different_pbt_groups = 6
    others                         = 7.

if sy-subrc ne 0.

  case sy-subrc.

    when 1 or 2 or 4 or 5 or 6 or 7.

      lv_wp_data_received = abap_false.

    when 3.

      call function 'SPBT_GET_CURR_RESOURCE_INFO' "try to get free work processes
        importing
          free_pbt_wps                = lv_free_pbt_wps
        exceptions
          internal_error              = 1
          pbt_env_not_initialized_yet = 2
          others                      = 3.

      if sy-subrc <> 0.

        lv_wp_data_received = abap_false.

      else.

        lv_wp_data_received = abap_true.

      endif.

  endcase.

else.

  lv_wp_data_received = abap_true.

endif.

if lv_wp_data_received eq abap_true.

  "   We will use 80% of all available dialog work processes

  lv_max_tasks = lv_free_pbt_wps * 80 / 100.

else.

  lv_max_tasks = 5.

endif.

" calculating amounts of tasks


new-line.
write: |total records to be fetched = | && |{ lines( lt_context ) }|.

"data(lt_context2) = lt_context.


lv_alerts_per_task = lines( lt_context ) / lv_max_tasks.

do lv_max_tasks times.

  clear wa_alerts_for_task.

  wa_alerts_for_task-task_number = lv_task_number.

  " creating subgroups of alerts for tasks

  loop at lt_context assigning field-symbol(<fs_context>).

    if lines(  wa_alerts_for_task-alerts_list ) < lv_alerts_per_task.
      append <fs_context> to  wa_alerts_for_task-alerts_list.
      delete lt_context index 1.

    else.
      exit.
    endif.

  endloop.


  append wa_alerts_for_task to lt_alerts_for_task.

  lv_task_number = lv_task_number + 1.

enddo.

" leftovers are put to a last package

if <fs_context> is assigned.
  unassign <fs_context>.
endif.

clear wa_alerts_for_task.

wa_alerts_for_task-task_number = lv_task_number.

loop at lt_context assigning <fs_context>.

  append <fs_context> to  wa_alerts_for_task-alerts_list.
  delete lt_context index 1.

endloop.

modify lt_alerts_for_task from wa_alerts_for_task index lv_task_number.


" preparing inbound queued bgRFC

data: lr_inbound_destination   type ref to if_bgrfc_destination_inbound,
      lr_inbound_qrfc_unit     type ref to if_qrfc_unit_inbound,
      lt_alerts_list           type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
      lt_alerrts_data          type zcl_alert_data_spta_iterator=>tt_alert_data,
      lv_runtime_start         type integer,
      lv_runtime_end           type integer,
      lv_lines_sent_to_qrfc    type integer,
      lv_zqrfc_alrt_data_count type integer.

get run time field lv_runtime_start.

do lines( lt_alerts_for_task ) times.

  lv_inbound_queue_name = |ZQUEALDATA_| && |{ sy-index }|.

  lt_alerts_list = lt_alerts_for_task[ task_number = sy-index ]-alerts_list.


  call function 'TRFC_SET_QUEUE_NAME'
    exporting
      qname = lv_inbound_queue_name.


  call function 'ZQRFC_ALERT_DATA_READ' in background task
    exporting
      it_alerts_list = lt_alerts_list.

  new-line.
  write: |{ sy-index }| && | lines = | && |{ lines( lt_alerts_list ) }|.

  lv_lines_sent_to_qrfc = lv_lines_sent_to_qrfc +  lines( lt_alerts_list ).

enddo.

commit work.

get run time field lv_runtime_end.

new-line.

write: |lines sent to qRFC = | && |{ lv_lines_sent_to_qrfc }|.


new-line.

write: |processing time = | && |{ lv_runtime_end - lv_runtime_start }|.



do.

  wait up to 1 seconds.

  select count( * ) into lv_zqrfc_alrt_data_count from zqrfc_alrt_data.

  if lv_lines_sent_to_qrfc eq lv_zqrfc_alrt_data_count.



    new-line.

    write: |lines in db table = | && |{ lv_zqrfc_alrt_data_count }|.

    delete from zqrfc_alrt_data.


    exit.

  endif.

enddo.
