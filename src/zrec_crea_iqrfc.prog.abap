*&---------------------------------------------------------------------*
*& Report  zrec_crea_iqrfc
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zrec_crea_iqrfc.

data:
     lo_qrfc_inbound_interface   type ref to zcl_qrfc_interface.


" Execution of inbound qRFC

new-line.
uline.

write: 'inbound qRFC execution results'.
new-line.


lo_qrfc_inbound_interface = new zcl_qrfc_interface( ip_direction = 'I' ).

do 100 times.

  lo_qrfc_inbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

      ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_1' ip_commit = ''

  ).


enddo.

lo_qrfc_inbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

    ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_1' ip_commit = 'X'

).

lo_qrfc_inbound_interface->zif_qtb_rfc_interface~execute_and_commit( ).


lo_qrfc_inbound_interface->zif_qtb_rfc_interface~print_runtimes( ).
