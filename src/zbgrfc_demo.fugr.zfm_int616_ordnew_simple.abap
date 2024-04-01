FUNCTION ZFM_INT616_ORDNEW_SIMPLE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BGRFC_UNIT_ID) TYPE  BGRFC_UNIT_ID OPTIONAL
*"     VALUE(IV_BGRFC_MAX_COUNT) TYPE  INT4 OPTIONAL
*"     VALUE(IV_BGRFC_DELAY) TYPE  INT4 OPTIONAL
*"     VALUE(IS_ORDER) TYPE  ZINT616_TS_ELITE_ORDER OPTIONAL
*"----------------------------------------------------------------------
*  data: lv_order_was_created type abap_bool,
*        lo_int616_log        type ref to zcl_int616_log.
*
*  lv_order_was_created = zcl_int616_orders=>process( is_order ).
*
*  lo_int616_log = new zcl_int616_log( ).
*
*  lo_int616_log->add_record( |ZFM_INT616_ORDNEW: из класса ZCL_INT616_ORDERS получен статус создания заказа = | && |{ lv_order_was_created }| ).
*
*  " Перезапуск выполнения bgRFC если заказ не был создан
*
*  if lv_order_was_created <> abap_true.
*
*    clear lo_int616_log.
*
*    lo_int616_log = new zcl_int616_log( ).
*
*    lo_int616_log->add_record( |ZFM_INT616_ORDNEW: начинаем перезапуск блока bgRFC c unit id = | && |{ iv_bgrfc_unit_id }| ).
*
*    perform retry_bgrfc
*        using iv_bgrfc_unit_id iv_bgrfc_max_count iv_bgrfc_delay.
*
*  endif.
*
*
*  if lv_order_was_created = abap_true or iv_bgrfc_max_count = iv_bgrfc_delay.
*
*    clear lo_int616_log.
*
*    lo_int616_log = new zcl_int616_log( ).
*
*    lo_int616_log->add_record( |ZFM_INT616_ORDNEW: выполение завершено для unit id = | && |{ iv_bgrfc_unit_id }| ).
*
*    if iv_bgrfc_max_count = iv_bgrfc_delay.
*
*      clear lo_int616_log.
*
*      lo_int616_log = new zcl_int616_log( ).
*
*      lo_int616_log->add_record( |ZFM_INT616_ORDNEW: превышено количество допустимых попыток| ).
*
*    endif.
*
*    " Отправить статус создания заказа в системе SAP CRM в систему "Элита"
*
*  endif.


endfunction.
