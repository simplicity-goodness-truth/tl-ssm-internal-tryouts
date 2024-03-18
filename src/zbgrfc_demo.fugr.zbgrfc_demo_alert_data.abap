FUNCTION ZBGRFC_DEMO_ALERT_DATA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
data:
  lt_context                  type zcl_alert_data_spta_pack_mgr=>tt_alerts_list,
  lt_output                   type zcl_alert_data_spta_iterator=>tt_alert_data,
  lo_salv_table               type ref to cl_salv_table,
  wa_output                   type zcl_alert_data_spta_iterator=>ty_alert_data,
  lo_alert_data_spta_iterator type ref to zcl_alert_data_spta_iterator,
  lv_runtime_start            type integer,
  lv_runtime_end              type integer.

get run time field lv_runtime_start.

" getting all alerts list

new zcl_alert_data_spta_pack_mgr( )->get_alerts_list(
    importing
        et_result = lt_context
    ).

loop at lt_context assigning field-symbol(<fs_context>).

  lo_alert_data_spta_iterator = new zcl_alert_data_spta_iterator( <fs_context> ).

  lo_alert_data_spta_iterator->get_results(
      importing
        es_results = wa_output ).

  append wa_output to lt_output.

endloop.

get run time field lv_runtime_end.

write: |processing time = | && |{ lv_runtime_end - lv_runtime_start }|.
new-line.
write: |lines = | && |{ lines( lt_output ) }|.



ENDFUNCTION.
