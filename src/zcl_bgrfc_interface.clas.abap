class zcl_bgrfc_interface definition
  public
  inheriting from zcl_qtb_rfc_interface
  final
  create public .

  public section.

    methods:

      constructor
        importing
          ip_direction type char1
          ip_type      type char1,

      set_inbound_destination
        importing
          ip_destination_name type bgrfc_dest_name_inbound
        raising
          zcx_bgrfc_interface,

      set_inbound_trfc_unit
        raising
          zcx_bgrfc_interface,

      set_inbound_qrfc_unit
        raising
          zcx_bgrfc_interface,

      get_inbound_trfc_unit
        returning
          value(rr_inbound_trfc_unit) type ref to if_trfc_unit_inbound
        raising
          zcx_bgrfc_interface,

      get_inbound_qrfc_unit
        returning
          value(rr_inbound_qrfc_unit) type ref to if_qrfc_unit_inbound
        raising
          zcx_bgrfc_interface,

      set_outbound_destination
        importing
          ip_destination_name type bgrfc_dest_name_outbound
        raising
          zcx_bgrfc_interface,

      set_outbound_trfc_unit
        raising
          zcx_bgrfc_interface,

      set_outbound_qrfc_unit
        raising
          zcx_bgrfc_interface,

      get_outbound_trfc_unit
        returning
          value(rr_outbound_trfc_unit) type ref to if_trfc_unit_outbound
        raising
          zcx_bgrfc_interface,

      get_outbound_qrfc_unit
        returning
          value(rr_outbound_qrfc_unit) type ref to if_qrfc_unit_outbound
        raising
          zcx_bgrfc_interface,

      zif_qtb_rfc_interface~execute_and_commit redefinition,

      inboundqrfc_execute_and_commit,

      outbndqrfc_execute_and_commit.

  protected section.
  private section.

    data:
      mr_inbound_destination  type ref to if_bgrfc_destination_inbound,
      mr_inbound_qrfc_unit    type ref to if_qrfc_unit_inbound,
      mr_inbound_trfc_unit    type ref to if_trfc_unit_inbound,
      mr_outbound_destination type ref to if_bgrfc_destination_outbound,
      mr_outbound_qrfc_unit   type ref to if_qrfc_unit_outbound,
      mr_outbound_trfc_unit   type ref to if_trfc_unit_outbound.


endclass.


class zcl_bgrfc_interface implementation.

  method zif_qtb_rfc_interface~execute_and_commit.

    case mv_type.

      when mc_qrfc.

        case mv_direction.

          when mc_inbound.

            me->inboundqrfc_execute_and_commit( ).


          when mc_outbound.

            me->outbndqrfc_execute_and_commit( ).


        endcase.


      when mc_trfc.

    endcase.

  endmethod.

  method constructor.

    super->constructor( ip_direction = ip_direction ip_type = ip_type ).


  endmethod.

  method set_inbound_destination.

    try.

        mr_inbound_destination = cl_bgrfc_destination_inbound=>create( ip_destination_name ).

      catch cx_bgrfc_invalid_destination.

        raise exception type zcx_bgrfc_interface
          exporting
            textid = zcx_bgrfc_interface=>incorrect_inbound_dest_name.

    endtry.

  endmethod.

  method set_inbound_trfc_unit.

    if mr_inbound_destination is bound.

      mr_inbound_trfc_unit = mr_inbound_destination->create_trfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_dest_not_set.

    endif.

  endmethod.

  method set_inbound_qrfc_unit.

    if mr_inbound_destination is bound.

      mr_inbound_qrfc_unit = mr_inbound_destination->create_qrfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_dest_not_set.

    endif.

  endmethod.

  method get_inbound_trfc_unit.

    if mr_inbound_trfc_unit is bound.

      rr_inbound_trfc_unit = mr_inbound_trfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_trfc_unit_not_set.


    endif.

  endmethod.

  method get_inbound_qrfc_unit.

    if mr_inbound_qrfc_unit is bound.

      rr_inbound_qrfc_unit = mr_inbound_qrfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_trfc_unit_not_set.
    endif.

  endmethod.




  method set_outbound_destination.

    try.

        mr_outbound_destination = cl_bgrfc_destination_outbound=>create( ip_destination_name ).

      catch cx_bgrfc_invalid_destination.

        raise exception type zcx_bgrfc_interface
          exporting
            textid = zcx_bgrfc_interface=>incorrect_outbound_dest_name.

    endtry.

  endmethod.

  method set_outbound_trfc_unit.

    if mr_outbound_destination is bound.

      mr_outbound_trfc_unit = mr_outbound_destination->create_trfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_dest_not_set.

    endif.

  endmethod.

  method set_outbound_qrfc_unit.

    if mr_outbound_destination is bound.

      mr_outbound_qrfc_unit = mr_outbound_destination->create_qrfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_dest_not_set.

    endif.

  endmethod.

  method get_outbound_trfc_unit.

    if mr_outbound_trfc_unit is bound.

      rr_outbound_trfc_unit = mr_outbound_trfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_trfc_unit_not_set.


    endif.

  endmethod.

  method get_outbound_qrfc_unit.

    if mr_outbound_qrfc_unit is bound.

      rr_outbound_qrfc_unit = mr_outbound_qrfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_trfc_unit_not_set.
    endif.

  endmethod.


  method inboundqrfc_execute_and_commit.

    data: lr_inbound_qrfc_unit      type ref to if_qrfc_unit_inbound,
          lv_inbound_queue_name     type qrfc_queue_name,
          lv_set_inbound_queue_name type qrfc_queue_name,
          lv_runtime                type integer,
          wa_runtime_record         type zqtb_rfc_ts_runtime.


    get run time field lv_runtime.

    mv_start_run_time = lv_runtime.

    wa_runtime_record-runtime = lv_runtime.

    append wa_runtime_record to mt_runtime.
    clear lv_runtime.

    try.

        " For now a single destination is supported, we take it from a first record

        try.

            me->set_inbound_destination( mt_execution_list[ 1 ]-destination ).

          catch cx_sy_itab_line_not_found.

        endtry.

        " Creating a unit

        me->set_inbound_qrfc_unit( ).

        lr_inbound_qrfc_unit = me->get_inbound_qrfc_unit( ).

        loop at  mt_execution_list assigning field-symbol(<fs_execution_object>).

          " Assign the unit to a queue


          if <fs_execution_object>-queue_name is not initial.

            lv_inbound_queue_name =  <fs_execution_object>-queue_name.

            if ( lv_set_inbound_queue_name is initial ) .

              lv_set_inbound_queue_name = lv_inbound_queue_name.

              lr_inbound_qrfc_unit->add_queue_name_inbound( lv_inbound_queue_name ).


            elseif ( lv_set_inbound_queue_name ne lv_inbound_queue_name ).


              lv_set_inbound_queue_name = lv_inbound_queue_name.

              lr_inbound_qrfc_unit->add_queue_name_inbound( lv_inbound_queue_name ).

            endif.

          endif.

          " Register first function module

          call function <fs_execution_object>-fm_name in background unit lr_inbound_qrfc_unit.

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

      catch zcx_bgrfc_interface into data(lcx_process_exception).

        data(lv_error_text) = lcx_process_exception->get_longtext( ).

    endtry.

  endmethod.

  method outbndqrfc_execute_and_commit.

    data:
      lr_outbound_qrfc_unit      type ref to if_qrfc_unit_outbound,
      lv_outbound_queue_name     type qrfc_queue_name,
      lv_set_outbound_queue_name type qrfc_queue_name,
      lv_runtime                 type integer,
      wa_runtime_record          type zqtb_rfc_ts_runtime.


    get run time field lv_runtime.

    mv_start_run_time = lv_runtime.

    wa_runtime_record-runtime = lv_runtime.

    append wa_runtime_record to mt_runtime.
    clear lv_runtime.

    try.

        " For now a single destination is supported, we take it from a first record

        try.

            me->set_outbound_destination( mt_execution_list[ 1 ]-destination ).

          catch cx_sy_itab_line_not_found.

        endtry.

        " Creating a unit

        me->set_outbound_qrfc_unit( ).

        lr_outbound_qrfc_unit = me->get_outbound_qrfc_unit( ).

        loop at  mt_execution_list assigning field-symbol(<fs_execution_object>).

          " Assign the unit to a queue


          if <fs_execution_object>-queue_name is not initial.

            lv_outbound_queue_name =  <fs_execution_object>-queue_name.

            if ( lv_set_outbound_queue_name is initial ) .

              lv_set_outbound_queue_name = lv_outbound_queue_name.

              lr_outbound_qrfc_unit->add_queue_name_outbound( lv_outbound_queue_name ).


            elseif ( lv_set_outbound_queue_name ne lv_outbound_queue_name ).


              lv_set_outbound_queue_name = lv_outbound_queue_name.

              lr_outbound_qrfc_unit->add_queue_name_outbound( lv_outbound_queue_name ).

            endif.

          endif.

          " Register first function module

          call function <fs_execution_object>-fm_name in background unit lr_outbound_qrfc_unit.

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

      catch zcx_bgrfc_interface into data(lcx_process_exception).

        data(lv_error_text) = lcx_process_exception->get_longtext( ).

    endtry.


  endmethod.

endclass.
