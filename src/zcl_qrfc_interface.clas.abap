class zcl_qrfc_interface definition
  public
  inheriting from zcl_qtb_rfc_interface
  final
  create public .

  public section.

    methods:

      constructor
        importing
          ip_direction type char1,

      zif_qtb_rfc_interface~execute_and_commit redefinition.

  protected section.
  private section.
endclass.


class zcl_qrfc_interface implementation.

  method zif_qtb_rfc_interface~execute_and_commit.

    data: lv_runtime        type integer,
          wa_runtime_record type zqtb_rfc_ts_runtime.


    get run time field lv_runtime.

    mv_start_run_time = lv_runtime.

    "wa_runtime_record-runtime = 0.

    append wa_runtime_record to mt_runtime.
    clear lv_runtime.



    loop at  mt_execution_list assigning field-symbol(<fs_execution_object>).

      if <fs_execution_object>-queue_name is not initial.

        call function 'TRFC_SET_QUEUE_NAME'
          exporting
            qname = <fs_execution_object>-queue_name.

      endif.

      case mv_direction.

        when mc_outbound.

          if <fs_execution_object>-destination is not initial.

            call function <fs_execution_object>-fm_name
              in background task
              destination <fs_execution_object>-destination.

          endif.

        when mc_inbound.

          call function <fs_execution_object>-fm_name
            in background task.

      endcase.

      if <fs_execution_object>-commit eq abap_true.

        commit work.

      endif.

      get run time field lv_runtime.

      wa_runtime_record-fm_name = <fs_execution_object>-fm_name.
      wa_runtime_record-destination = <fs_execution_object>-destination.
      wa_runtime_record-queue_name = <fs_execution_object>-queue_name.
      wa_runtime_record-commit = <fs_execution_object>-commit.
      wa_runtime_record-runtime = lv_runtime.

      append wa_runtime_record to mt_runtime.
      clear: lv_runtime, wa_runtime_record.

    endloop.

    get run time field lv_runtime.

    wa_runtime_record-runtime = lv_runtime.

    append wa_runtime_record to mt_runtime.
    clear lv_runtime.

  endmethod.

  method constructor.

    super->constructor( ip_direction = ip_direction ).

    mv_type = mc_qrfc.

  endmethod.

endclass.
