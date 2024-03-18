class zws_cl_in_t237_orders_a definition
  public
  final
  create public .

  public section.

    interfaces zws_ii_in_t237_orders_a .
  protected section.
  private section.

    methods:

      get_delay
        returning
          value(rp_delay) type integer,

      get_initial_delay
        returning
          value(rp_initial_delay) type integer,

      get_counter
        returning
          value(rp_counter) type integer.

endclass.



class zws_cl_in_t237_orders_a implementation.


  method zws_ii_in_t237_orders_a~in_t237_orders_a.

    data: lv_delay         type integer,
          lv_initial_delay type integer,
          lv_counter       type integer,
          lo_int616_log    type ref to zcl_int616_log.

    lv_delay = me->get_delay( ).
    lv_initial_delay = me->get_initial_delay( ).
    lv_counter = me->get_counter( ).



    data: lr_inbound_destination type ref to if_bgrfc_destination_inbound,
          lr_inbound_qrfc_unit   type ref to if_qrfc_unit_inbound,
          lv_inbound_queue_name  type qrfc_queue_name,
          lv_elite_order_id      type int4,
          lv_queue_name          type char40.

    lv_elite_order_id = is_order-order_id.
    lv_queue_name = |ZSC08_| && |{ lv_elite_order_id }|.

    lr_inbound_destination = cl_bgrfc_destination_inbound=>create( 'ZBG_RFC_DEMO_INBOUND' ).

    try.

        lr_inbound_qrfc_unit = lr_inbound_destination->create_qrfc_unit( ).

        lr_inbound_qrfc_unit->add_queue_name_inbound( lv_queue_name ).

        if lv_initial_delay is not initial.
          lr_inbound_qrfc_unit->delay( lv_initial_delay ).
        endif.

        lr_inbound_qrfc_unit->disable_commit_checks( ).

        lo_int616_log = new zcl_int616_log( ).

        lo_int616_log->add_record( 'ZWS_CL_IN_T237_ORDERS_A: вызываем ZFM_INT616_ORDNEW в очереди bgRFC / unit id = ' && |{ lr_inbound_qrfc_unit->unit_id }| ).

        call function 'ZFM_INT616_ORDNEW' in background unit lr_inbound_qrfc_unit
          exporting
            iv_bgrfc_unit_id   = lr_inbound_qrfc_unit->unit_id
            iv_bgrfc_max_count = lv_counter
            iv_bgrfc_delay     = lv_delay
            is_order           = is_order.

      catch cx_sy_dynamic_osql_semantics.

    endtry.

    commit work.

  endmethod.

  method get_delay.

    " Константа только в демонстрационных целях.
    " Актуальное значение следует брать из настроечных таблиц KCD с помощью методов класса ZCL_BGRFC_HELPER

    rp_delay = 60.

  endmethod.

  method get_initial_delay.

    " Константа только в демонстрационных целях.
    " Актуальное значение следует брать из настроечных таблиц KCD с помощью методов класса ZCL_BGRFC_HELPER

    rp_initial_delay = 0.

  endmethod.

  method get_counter.

    " Константа только в демонстрационных целях.
    " Актуальное значение следует брать из настроечных таблиц KCD с помощью методов класса ZCL_BGRFC_HELPER

    rp_counter = 3.

  endmethod.

endclass.
