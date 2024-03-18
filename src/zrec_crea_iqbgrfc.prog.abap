*&---------------------------------------------------------------------*
*& Report  zrec_crea_iqbgrfc
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zrec_crea_iqbgrfc.


data:
      lo_bgrfc_inbound_interface  type ref to zcl_bgrfc_interface.

new-line.
uline.

write: 'inbound queued bgRFC execution results'.
new-line.


lo_bgrfc_inbound_interface = new zcl_bgrfc_interface( ip_direction = 'I' ip_type = 'Q').

do 100 times.

  lo_bgrfc_inbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

      ip_destination = 'ZBG_RFC_DEMO_INBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_1' ip_commit = ''

  ).


enddo.

lo_bgrfc_inbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

    ip_destination = 'ZBG_RFC_DEMO_INBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_1' ip_commit = 'X'

).


lo_bgrfc_inbound_interface->zif_qtb_rfc_interface~execute_and_commit( ).

lo_bgrfc_inbound_interface->zif_qtb_rfc_interface~print_runtimes( ).
