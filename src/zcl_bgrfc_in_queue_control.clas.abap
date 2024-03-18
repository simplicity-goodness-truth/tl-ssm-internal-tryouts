class zcl_bgrfc_in_queue_control definition
  public
  final
  create public .

  public section.

    interfaces zif_bgrfc_queue_control.

    methods
      constructor
        importing
          ip_qrfc_queue_name type qrfc_queue_name optional.

  protected section.
  private section.

    data:
      mv_qrfc_queue_name type qrfc_queue_name,
      mt_exec_list       type table of zbgrfc_qunit_ord.

    methods:
      set_queue_units_exec_list.

endclass.



class zcl_bgrfc_in_queue_control implementation.

  method constructor.

    mv_qrfc_queue_name = ip_qrfc_queue_name.

  endmethod.

  method zif_bgrfc_queue_control~is_queue_in_error_state.

    data: lt_queue_range     type  qrfc_queue_range,
          wa_queue_range     type  qrfc_queue_sel,
          lt_queues_in_error type qrfc_inb_queue_error_table,
          lt_dest_range      type bgrfc_dest_range_inbound,
          lt_client_range    type bgrfc_client_range.

    if mv_qrfc_queue_name is not initial.

      wa_queue_range-sign = 'I'.
      wa_queue_range-option = 'EQ'.
      wa_queue_range-low =  mv_qrfc_queue_name.

      append wa_queue_range to lt_queue_range.

      call method cl_qrfc_inbound_monitor=>get_erroneous_queues(
        exporting
          queue_range  = lt_queue_range
          dest_range   = lt_dest_range
          client_range = lt_client_range
        receiving
          queue_table  = lt_queues_in_error ).

      if lt_queues_in_error is not initial.

        rp_is_in_error_state = abap_true.

      endif.

    endif.

  endmethod.

  method zif_bgrfc_queue_control~unit_can_be_executed_now.

    if mt_exec_list is initial.

      me->set_queue_units_exec_list( ).

    endif.

    if mt_exec_list is not initial.

      try.

          if mt_exec_list[ 1 ]-unitid eq ip_unit_id.

            rp_unit_can_be_executed_now = abap_true.

          endif.

        catch cx_sy_itab_line_not_found.

      endtry.

    endif.

  endmethod.

  method set_queue_units_exec_list.

    select unitid update_date update_time into corresponding fields of table mt_exec_list from zbgrfc_qunit_ord
      where direction = 'I'
      and queue = mv_qrfc_queue_name.

    sort mt_exec_list by update_date update_time ascending.

  endmethod.

  method zif_bgrfc_queue_control~add_queue_unit_to_exec_list.

    data wa_bgrfc_qunit_ord type zbgrfc_qunit_ord.

    if ( mv_qrfc_queue_name is not initial ) and
        ( ip_unit_id is not initial ).

      wa_bgrfc_qunit_ord-direction = 'I'.
      wa_bgrfc_qunit_ord-queue = mv_qrfc_queue_name.
      wa_bgrfc_qunit_ord-uname = sy-uname.
      wa_bgrfc_qunit_ord-unitid = ip_unit_id.
      wa_bgrfc_qunit_ord-update_date = sy-datum.
      wa_bgrfc_qunit_ord-update_time = sy-uzeit.

      insert zbgrfc_qunit_ord from wa_bgrfc_qunit_ord.

    endif.


  endmethod.

  method zif_bgrfc_queue_control~remove_queue_unit_to_exec_list.

    delete from zbgrfc_qunit_ord where unitid eq ip_unit_id.

  endmethod.

endclass.
