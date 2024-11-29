*&---------------------------------------------------------------------*
*& Report  zalert_data_spta
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zalert_data_spta.

constants: lv_serv_group type spta_rfcgr value 'SPTA'.

data:
  lt_context           type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
  lt_output            type zcl_alert_data_spta_iterator=>tt_alert_data,
  lo_salv_table        type ref to cl_salv_table,
  lv_runtime_start     type integer,
  lv_runtime_end       type integer,
  lv_log_record_text   type string,
  mv_app_log_object    type balobj_d,
  mv_app_log_subobject type balsubobj,
  lo_log               type ref to zcl_logger_to_app_log.

mv_app_log_object = 'ZDEMO'.
mv_app_log_subobject = 'ZSPTA'.

lo_log = zcl_logger_to_app_log=>get_instance( ).
lo_log->set_object_and_subobject(
      exporting
        ip_object    =   mv_app_log_object
        ip_subobject =   mv_app_log_subobject ).



get run time field lv_runtime_start.

" getting all alerts list

new zcl_alert_data_spta_pack_mgr( )->get_alerts_list(
    importing
        et_result = lt_context
    ).


write: |Starting SPTA processing in a server group | && |{ lv_serv_group }|.
new-line.

lo_log->zif_logger~info( 'Starting SPTA processing in a server group' ).

" starting SPTA processing

call function 'SPTA_PARA_PROCESS_START_2'
  exporting
    server_group             = lv_serv_group
    before_rfc_callback_form = 'BEFORE_RFC'
    in_rfc_callback_form     = 'IN_RFC'
    after_rfc_callback_form  = 'AFTER_RFC'
    callback_prog            = sy-repid
  changing
    user_param               = lt_context
  exceptions
    invalid_server_group     = 1
    no_resources_available   = 2
    others                   = 3.

if sy-subrc <> 0.

  write: 'SPTA execution failure'.

endif.

get run time field lv_runtime_end.

write: |processing time = | && |{ lv_runtime_end - lv_runtime_start }|.
new-line.
write: |lines = | && |{ lines( lt_output ) }|.

*try.
*    cl_salv_table=>factory( importing r_salv_table = lo_salv_table
*                             changing t_table = lt_output ).
*
*    lo_salv_table->display( ).
*
*  catch cx_salv_msg.                                    "#EC NO_HANDLER
*endtry.

" here we split alert group IDs per every task

form before_rfc
   using
      p_before_rfc_imp     type spta_t_before_rfc_imp
   changing
      p_before_rfc_exp     type spta_t_before_rfc_exp
      pt_rfcdata           type spta_t_indxtab
      p_failed_objects     type spta_t_failed_objects
      p_objects_in_process type spta_t_objects_in_process
      p_user_param         type zcl_alert_data_spta_pack_mgr=>tt_alerts_list.


  data: lv_max_tasks        type integer,
        lv_tab_lines        type integer,
        lv_cnt              type integer,
        lt_task_algroup_ids type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
        lo_log              type ref to zcl_logger_to_app_log.

  mv_app_log_object = 'ZDEMO'.
  mv_app_log_subobject = 'ZSPTA'.

  lo_log = zcl_logger_to_app_log=>get_instance( ).
  lo_log->set_object_and_subobject(
        exporting
          ip_object    =   mv_app_log_object
          ip_subobject =   mv_app_log_subobject ).


  statics: sv_package_size type i.

  data lv_dwp_number  type wpno.
  call function 'TH_GET_OWN_WP_NO'
    importing
      wp_no = lv_dwp_number.


  write: |Before RFC started in DWP | && |{ lv_dwp_number }| && | with tasks to be processed | && |{ lines( lt_task_algroup_ids ) }|.
  new-line.

  lo_log->zif_logger~info( |Before RFC started in DWP | && |{ lv_dwp_number }| ).


  if sv_package_size is initial.

    write: |Starting initial calculation of a package size|.
    new-line.

    " getting maximum of available dialog tasks

    perform get_max_tasks changing lv_max_tasks.

    lv_tab_lines = lines( p_user_param ).

    write: |Total lines = | && |{ lv_tab_lines }|.
    new-line.

    write: |Max tasks = | && |{ lv_max_tasks }|.
    new-line.

    " Checking how many alerts will be processed by a single task
    " If there is anything left from a division, then the leftover
    " to be added to a last package

    sv_package_size = lv_tab_lines / lv_max_tasks.

    if sv_package_size = 0.
    sv_package_size = 1.
  endif.

  write: |Calculated package size = | && |{ sv_package_size }|.
  new-line.

  write: |Ending initial calculation of a package size|.
  new-line.

endif.

lv_cnt = 0.

* Putting alerts to tasks
loop at p_user_param assigning field-symbol(<fs_algroup_id>).

  if lv_cnt < sv_package_size.

    append <fs_algroup_id> to lt_task_algroup_ids.

    " removing alert group ID, as it has been already added to a task
    delete p_user_param index 1.

    lv_cnt = lv_cnt + 1.

  else.
    exit.
  endif.

endloop.

if <fs_algroup_id> is assigned.

  unassign <fs_algroup_id>.

endif.

if lines( p_user_param ) < sv_package_size.

  write |Arrived to last task case as | && |{ lines( p_user_param ) }| && |<| && |{ sv_package_size }|.
  new-line.

  write |Starting finalization of the task list from | && |{ lines( lt_task_algroup_ids ) }|.
  new-line.

  " Last task case

  loop at p_user_param assigning <fs_algroup_id>.
    append <fs_algroup_id> to lt_task_algroup_ids.
    delete p_user_param index 1.
  endloop.

  write |Completing finalization of the task list from | && |{ lines( lt_task_algroup_ids ) }|.
  new-line.

endif.


" Packing the data

call function 'SPTA_INDX_PACKAGE_ENCODE'
  exporting
    data    = lt_task_algroup_ids
  importing
    indxtab = pt_rfcdata.

if lt_task_algroup_ids is initial.
  p_before_rfc_exp-start_rfc = space.

  write: |Task group is empty -> skipping|.
  new-line.

else.
  p_before_rfc_exp-start_rfc = abap_true.

  write: |Passed to execution task group size = | && |{ lines( lt_task_algroup_ids ) }|.
  new-line.


  return.
endif.


endform.


form get_max_tasks changing cv_max_tasks type i.

  statics: sv_max_tasks type i.

  data: lv_free_pbt_wps     type i,
        lv_wp_data_received type abap_bool.

  if sv_max_tasks is not initial.
    cv_max_tasks = sv_max_tasks.
    return.
  endif.

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


*   We will use 80% of all available dialog work processes

    cv_max_tasks = sv_max_tasks = lv_free_pbt_wps * 80 / 100.

  else.

    cv_max_tasks = sv_max_tasks = 5.

  endif.

endform.

form in_rfc

   using
      p_in_rfc_imp  type spta_t_in_rfc_imp                  "#EC NEEDED
   changing
      p_in_rfc_exp  type spta_t_in_rfc_exp                  "#EC NEEDED
      p_rfcdata     type spta_t_indxtab.                    "#EC CALLED

  data: lt_taskdata_in  type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
        lt_taskdata_out type zcl_alert_data_spta_iterator=>tt_alert_data,
        lo_log          type ref to zcl_logger_to_app_log.

  mv_app_log_object = 'ZDEMO'.
  mv_app_log_subobject = 'ZSPTA'.

  lo_log = zcl_logger_to_app_log=>get_instance( ).
  lo_log->set_object_and_subobject(
        exporting
          ip_object    =   mv_app_log_object
          ip_subobject =   mv_app_log_subobject ).


  " task processing routine

  " task data unpacking

  call function 'SPTA_INDX_PACKAGE_DECODE'
    exporting
      indxtab = p_rfcdata
    importing
      data    = lt_taskdata_in.

* Processing

  lo_log->zif_logger~info( |In RFC items count =  | && |{ lines( lt_taskdata_in ) }| ).


  perform run using lt_taskdata_in
              changing lt_taskdata_out.

* Packing back for further RFC usage

  call function 'SPTA_INDX_PACKAGE_ENCODE'
    exporting
      data    = lt_taskdata_out
    importing
      indxtab = p_rfcdata.

endform.


form run using it_taskdata_in type zcl_alert_data_spta_pack_mgr=>tt_alerts_list
         changing ct_taskdata_out type zcl_alert_data_spta_iterator=>tt_alert_data.

  data: wa_taskdata_out             type zcl_alert_data_spta_iterator=>ty_alert_data,
        lo_alert_data_spta_iterator type ref to zcl_alert_data_spta_iterator.



  loop at it_taskdata_in assigning field-symbol(<fs_taskdata_in>).

    write |Running processing|.
    new-line.



    lo_alert_data_spta_iterator = new zcl_alert_data_spta_iterator( <fs_taskdata_in> ).

    lo_alert_data_spta_iterator->get_results(
        importing
          es_results = wa_taskdata_out ).

    append wa_taskdata_out to ct_taskdata_out.

  endloop.

endform.


form after_rfc
   using
      p_rfcdata            type spta_t_indxtab
      p_rfcsubrc           type sy-subrc
      p_rfcmsg             type spta_t_rfcmsg
      p_objects_in_process type spta_t_objects_in_process
      p_after_rfc_imp      type spta_t_after_rfc_imp
   changing
      p_after_rfc_exp      type spta_t_after_rfc_exp
      p_user_param.

  data: lt_taskdata type zcl_alert_data_spta_iterator=>tt_alert_data.

  data:
    lv_tabsize        type sy-tabix,
    ls_obj_in_process like line of p_objects_in_process,
    lo_log            type ref to zcl_logger_to_app_log.

  mv_app_log_object = 'ZDEMO'.
  mv_app_log_subobject = 'ZSPTA'.

  lo_log = zcl_logger_to_app_log=>get_instance( ).
  lo_log->set_object_and_subobject(
        exporting
          ip_object    =   mv_app_log_object
          ip_subobject =   mv_app_log_subobject ).


  " this form is called after processing for an every task

  data lv_dwp_number  type wpno.
  call function 'TH_GET_OWN_WP_NO'
    importing
      wp_no = lv_dwp_number.

  write: |After RFC started in DWP | && |{ lv_dwp_number }|.
  new-line.


  if p_rfcsubrc is initial.

    " unpacking data from rfc

    call function 'SPTA_INDX_PACKAGE_DECODE'
      exporting
        indxtab = p_rfcdata
      importing
        data    = lt_taskdata.

    append lines of lt_taskdata to lt_output.

    exit.

  endif.




* Error handling
* Note: An incorrect way to handle application specific errors
*       may lead to an infinite loop in the application, because
*       if an error is returned to the task manager that object
*       ist rescheduled in the FAILED_OBJS table and is supposed
*       to be reprocessed again which may lead to another application
*       error. The only way out of this behaviour is to set
*       the flag 'NO_RESUBMISSION_ON_ERROR' to the task manager
*       and store an error message in the application's error log.
*       Hoever there are situations where is is appropriate
*       to not set this flag and thus allow a resubmission of those
*       objects:
*       - If one aRFC processes 100 objects and the task fails
*         return an application_error to the task manager.
*         Then reprocess each failed_objs one by one. If a task
*         fails that processes only one object then return
*         no_error to the task manager and store the error
*         in the application's log.

  describe table p_objects_in_process lines lv_tabsize.
  if lv_tabsize = 1.
* The failed task contained one object
* Inform task manager not to resubmit objects
    p_after_rfc_exp-no_resubmission_on_error = 'X'.

* Application specific error handling
* This is the point to report this error by
* storing an error message etc...
* The content of p_rfcmsg should be reported as well
* in this message as it contains important information
* about the nature of the error.
*    READ TABLE p_objects_in_process INDEX 1
*               INTO ls_obj_in_process.
*    CLEAR: gt_work_area.
*    gt_work_area-number = ls_obj_in_process-obj_id.
*    gt_work_area-string = text-err.
*    APPEND gt_work_area.
  else.
* The failed taks contained several objects.
* Enable resubmission to process objects individually.
    clear p_after_rfc_exp-no_resubmission_on_error.
  endif.

endform.                    "after_rfc
