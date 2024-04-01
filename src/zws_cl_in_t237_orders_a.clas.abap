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
          lv_queue_name          type char40,
          ls_order               type  zint616_ts_elite_order.

    ls_order = is_order.

    if ls_order is initial.

      ls_order-order_id = '481516'.

    endif.

    lv_elite_order_id = ls_order-order_id.

    lv_queue_name = |ZSC08_| && |{ lv_elite_order_id }|.

    " Classic implementation

*    lr_inbound_destination = cl_bgrfc_destination_inbound=>create( 'ZBG_RFC_DEMO_INBOUND' ).
*
*    try.
*
*        lr_inbound_qrfc_unit = lr_inbound_destination->create_qrfc_unit( ).
*
*        lr_inbound_qrfc_unit->add_queue_name_inbound( lv_queue_name ).
*
*        if lv_initial_delay is not initial.
*          lr_inbound_qrfc_unit->delay( lv_initial_delay ).
*        endif.
*
*        lr_inbound_qrfc_unit->disable_commit_checks( ).
*
*        lo_int616_log = new zcl_int616_log( ).
*
*        lo_int616_log->add_record( 'ZWS_CL_IN_T237_ORDERS_A: вызываем ZFM_INT616_ORDNEW в очереди bgRFC / unit id = ' && |{ lr_inbound_qrfc_unit->unit_id }| ).
*
*
*        call function 'ZFM_INT616_ORDNEW' in background unit lr_inbound_qrfc_unit
*          exporting
*            iv_bgrfc_unit_id   = lr_inbound_qrfc_unit->unit_id
*            iv_bgrfc_max_count = lv_counter
*            iv_bgrfc_delay     = lv_delay
*            is_order           = ls_order.
*
*
*      catch cx_sy_dynamic_osql_semantics.
*
*    endtry.
*
*    commit work.

    " Implementation through a class



    types: begin of ty_fm_params_and_local_vars,

             fm_parameter   type  rs38l_par_,
             local_variable type string,

           end of ty_fm_params_and_local_vars.


    data: lo_bgrfc_exec_control       type ref to zif_bgrfc_exec_control,
          lt_fm_unit_interface        type rsfbintfv,
          lr_parameter_value          type ref to data,
          lr_type_descr               type ref to cl_abap_typedescr,
          lt_ptab                     type abap_func_parmbind_tab,
          lt_fm_params_and_local_vars type table of ty_fm_params_and_local_vars,
          ls_exec_parameters          type zbgrfc_ts_exec_param,
          lv_local_variable           type string.

    field-symbols: <fs_parameter_value> type any,
                   <fs_variable_name>   type any.

    lo_bgrfc_exec_control = new zcl_bgrfc_exec_control( 'ZFM_INT616_ORDNEW_SIMPLE' ).

    " Получаем информацию о входящих параметрах ФМ

    lt_fm_unit_interface = lo_bgrfc_exec_control->get_fm_unit_interface( ).

    " Заполняем соответствие входящих паратмеров ФМ и локальных переменных
    " Параметры IV_BGRFC_MAX_COUNT и IV_BGRFC_DELAY можно также задать, чтобы не менять
    " интерфейс ФМ, однако, реальные значения COUNT, DELAY и INITIAL DELAY должны
    " устанавливаться в структуре LS_EXEC_PARAMETERS

    lt_fm_params_and_local_vars = value #(

        ( fm_parameter = 'IS_ORDER' local_variable = 'LS_ORDER' )
        ( fm_parameter = 'IV_BGRFC_MAX_COUNT' local_variable = 'LV_COUNTER' )
        ( fm_parameter = 'IV_BGRFC_DELAY' local_variable = 'LV_DELAY' )

    ).

    loop at lt_fm_unit_interface-import assigning field-symbol(<fs_unit_interface>).

      create data lr_parameter_value type (<fs_unit_interface>-structure).
      assign  lr_parameter_value->* to <fs_parameter_value>.

      if <fs_parameter_value> is assigned.

        try.

            lv_local_variable =  lt_fm_params_and_local_vars[ fm_parameter = <fs_unit_interface>-parameter ]-local_variable.

            assign (lv_local_variable) to <fs_variable_name>.
            <fs_parameter_value> = <fs_variable_name>.

          catch cx_sy_itab_line_not_found.

        endtry.

        if ( <fs_parameter_value> is initial ) and ( <fs_unit_interface>-optional eq abap_true ).

          continue.

        endif.

        insert value #( name = <fs_unit_interface>-parameter  kind = abap_func_exporting value = lr_parameter_value )
            into table lt_ptab.

        unassign <fs_parameter_value>.

      endif.

    endloop.

    ls_exec_parameters-queuename = lv_queue_name.
    ls_exec_parameters-retryunitonfail = 'X'.
    ls_exec_parameters-counter = lv_counter.
    ls_exec_parameters-delay = lv_delay.
    ls_exec_parameters-initialdelay = lv_initial_delay.
    ls_exec_parameters-destination = 'ZBG_RFC_DEMO_INBOUND'.

    lo_bgrfc_exec_control->set_exec_parameters( is_exec_parameters = ls_exec_parameters it_ptab = lt_ptab ).

    lo_bgrfc_exec_control->execute( ).

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
