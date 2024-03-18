*&---------------------------------------------------------------------*
*& Report  zbgrfc_demo_client
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zbgrfc_demo_client.

data: lv_outbound_destination_name type bgrfc_dest_name_outbound,
      lr_bgrfc_interface           type ref to zif_bgrfc_demo,
      lr_outbound_trfc_unit        type ref to if_trfc_unit_outbound,
      lv_msg                       type c length 60.

try.

    lv_outbound_destination_name = 'ZBG_RFC_DEMO_OUTBOUND'.

    lr_bgrfc_interface = new zcl_bgrfc_demo( ).

    lr_bgrfc_interface->set_outbound_destination( lv_outbound_destination_name ).

    lr_bgrfc_interface->set_outbound_trfc_unit( ).

    lr_outbound_trfc_unit = lr_bgrfc_interface->get_outbound_trfc_unit( ).

    call function 'ZBGRFC_DEMO_INSERT_RECORDS'
      in background unit lr_outbound_trfc_unit.

    commit work.

  catch zcx_bgrfc_interface.

endtry.
