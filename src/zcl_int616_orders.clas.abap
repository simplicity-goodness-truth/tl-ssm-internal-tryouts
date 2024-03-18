class zcl_int616_orders definition
  public
  final
  create public .

  public section.

    " Все типы данных только в демонстрационных целях

    class-methods:
      process
        importing
          is_order          type zint616_ts_elite_order
        returning
          value(rp_success) type abap_bool.

  protected section.
  private section.

    class-methods:

      order_set_header,

      order_set_items,

      order_maintain_and_save
        returning
          value(rp_success) type abap_bool.

endclass.



class zcl_int616_orders implementation.

  method process.

    " Метод для создания заголовка и позиций заказа
    " Названия методов только в демонстрационных целях

    order_set_header( ).

    order_set_items( ).

    rp_success = order_maintain_and_save( ).

    " Возврат признака успешности создания заказа в SAP CRM


  endmethod.

  method order_set_header.

    data lo_int616_log type ref to zcl_int616_log.

    " Создание заголовка заказа

    lo_int616_log = new zcl_int616_log( ).

    lo_int616_log->add_record( |ZCL_INT616_ORDERS: заголовок заказа создан| ).

  endmethod.

  method order_set_items.

    data lo_int616_log type ref to zcl_int616_log.

    " Создание позиций заказа

    lo_int616_log = new zcl_int616_log( ).

    lo_int616_log->add_record( |ZCL_INT616_ORDERS: позиции заказа созданы| ).


  endmethod.

  method order_maintain_and_save.

    data lo_int616_log type ref to zcl_int616_log.

    " Сохранение заказа в SAP CRM
    " Константа только в демонстрационных целях

    rp_success = abap_true.

    lo_int616_log = new zcl_int616_log( ).

    lo_int616_log->add_record( |ZCL_INT616_ORDERS: статус записи заказа = |  && |{ rp_success }| ).

  endmethod.

endclass.
