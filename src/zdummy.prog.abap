*&---------------------------------------------------------------------*
*& Report  zdummy
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zdummy.

data: lt_qrfc_tab     type bgrfc_unit_table,
      lt_qrfc_tab_out type qrfc_inb_unit_info_tab.


append '0050569AF56B1EDEB7F18B16901900F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B16901920F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B16901940F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B16901960F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B16901980F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B169019A0F8' to lt_qrfc_tab.
*append '0050569AF56B1EDEB7F18B169019C0F8' to lt_qrfc_tab.

call method cl_qrfc_inbound_monitor=>get_unit_information_list( exporting unit_table = lt_qrfc_tab receiving unit_information = lt_qrfc_tab_out ).

data(a) = 3.

*data: lo_acc                    type ref to if_alert_consumer_connector,
*      lv_tech_scenario          type ac_technical_scenario,
*      lt_alert_groups_2_confirm type e2ea_t_guid,
*      lv_confirmation_text      type string value 'Confirmed due to redundancy',
*      lv_alerts_with_inc        type integer.
*
*
*select single tech_scenario into lv_tech_scenario
*from acalertdir
*where alert_type_id = '005056B44CB91EE3ABBB7F11F609C311'
*and ac_variant = 'A'.
*
*if lv_tech_scenario eq 'EX_MON'.
*
*  try.
*
*      lo_acc = new cl_alert_consumer_connector( ).
*
*      append '0050569AF56B1EDEB49DF7A030C140F8' to lt_alert_groups_2_confirm.
*
*      lo_acc->confirm_alert_groups(
*        exporting
*          it_algroupid = lt_alert_groups_2_confirm
*          i_comments = lv_confirmation_text
*          i_category_id = 'Z01'
*          i_classification_id = 'Z01'
*        importing
*          e_incident_alert  = lv_alerts_with_inc ).
*
*    catch cx_alert_consm_database cx_alert_consm_connector into data(lcx_process_exception).
*
*      data(lv_error_text) = lcx_process_exception->get_longtext( ).
*
*      write lv_error_text.
*  endtry.
*
*
*endif.
*
