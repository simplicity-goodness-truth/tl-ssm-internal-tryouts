FUNCTION ZQRFC_ALERT_DATA_READ.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_ALERTS_LIST) TYPE  ZMAI_TT_ALERTS_LIST OPTIONAL
*"----------------------------------------------------------------------
  data: wa_taskdata_out             type zcl_alert_data_spta_iterator=>ty_alert_data,
        lo_alert_data_spta_iterator type ref to zcl_alert_data_spta_iterator,
        wa_qrfc_alrt_data          type zqrfc_alrt_data.

  loop at it_alerts_list assigning field-symbol(<fs_taskdata_in>).

    clear wa_qrfc_alrt_data.

    lo_alert_data_spta_iterator = new zcl_alert_data_spta_iterator( <fs_taskdata_in> ).

    lo_alert_data_spta_iterator->get_results(
        importing
          es_results = wa_taskdata_out ).

    move-corresponding wa_taskdata_out to wa_qrfc_alrt_data.

    try.

        wa_qrfc_alrt_data-record_id = cl_system_uuid=>create_uuid_x16_static( ).

        insert zqrfc_alrt_data from wa_qrfc_alrt_data.

      catch cx_uuid_error.

    endtry.

  endloop.
endfunction.
