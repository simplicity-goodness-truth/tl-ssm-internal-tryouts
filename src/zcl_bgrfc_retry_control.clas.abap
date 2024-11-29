class zcl_bgrfc_retry_control definition
  public
  final
  create public .

  public section.

    methods:
      constructor
        importing
          ip_bgrfc_unit_id   type bgrfc_unit_id
          ip_bgrfc_max_count type int4 optional
          ip_bgrfc_delay     type int4 optional.

    interfaces zif_bgrfc_retry_control .
  protected section.
  private section.

    data:
      mv_bgrfc_unit_id   type bgrfc_unit_id,
      mv_bgrfc_max_count type int4,
      mv_bgrfc_delay     type int4.

endclass.


class zcl_bgrfc_retry_control implementation.

  method constructor.

    mv_bgrfc_unit_id  = ip_bgrfc_unit_id.
    mv_bgrfc_max_count = ip_bgrfc_max_count.
    mv_bgrfc_delay    = ip_bgrfc_delay.

  endmethod.

  method zif_bgrfc_retry_control~retry_unit.

    data: ls_unit_information type  qrfc_unit_info_inbound,
          lv_queue_name       type bgrfc_retry_key,
          lv_count            type int4,
          lo_int616_log       type ref to zcl_int616_log.

    if mv_bgrfc_unit_id is initial.

      return.

    endif.

    " Перезапуск выполнения блока bgRFC

    ls_unit_information = cl_qrfc_inbound_monitor=>get_unit_information( unit_id = mv_bgrfc_unit_id ).

    lv_queue_name = shift_left( val = ls_unit_information-queue_name sub = '%_QRFC_RETRY_' ).

    lv_count = ls_unit_information-redo_cnt_manual + ls_unit_information-redo_cnt_auto.

    if lv_count < mv_bgrfc_max_count.

      cl_bgrfc_server=>retry_unit( key        = lv_queue_name
                                   max_count  = mv_bgrfc_max_count
                                   delay_time = mv_bgrfc_delay  ).

      clear lo_int616_log.

      lo_int616_log = new zcl_int616_log( ).

      lo_int616_log->add_record( 'ZFM_INT616_ORDNEW: блок bgRFC перезапущен в процедуре RETRY_BGRFC / unit id = ' && |{ mv_bgrfc_unit_id }| ).

    endif.


  endmethod.

endclass.
