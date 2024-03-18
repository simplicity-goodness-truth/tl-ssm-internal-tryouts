
report zqtb_rfc_demo_client.

data: lo_qrfc_inbound_interface   type ref to zcl_qrfc_interface,
      lo_qrfc_outbound_interface  type ref to zcl_qrfc_interface,
      lo_bgrfc_inbound_interface  type ref to zcl_bgrfc_interface,
      lo_bgrfc_outbound_interface type ref to zcl_bgrfc_interface.

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



" Execution of inbound Q bgRFC

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


" Execution of outbound Q bgRFC
new-line.
uline.

write: 'outbound queued bgRFC execution results'.
new-line.


lo_bgrfc_outbound_interface = new zcl_bgrfc_interface( ip_direction = 'O' ip_type = 'Q').

do 100 times.

  lo_bgrfc_outbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

      ip_destination = 'ZBG_RFC_DEMO_OUTBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_4' ip_commit = ''

  ).


enddo.

lo_bgrfc_outbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

    ip_destination = 'ZBG_RFC_DEMO_OUTBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_4' ip_commit = 'X'

).


lo_bgrfc_outbound_interface->zif_qtb_rfc_interface~execute_and_commit( ).

lo_bgrfc_outbound_interface->zif_qtb_rfc_interface~print_runtimes( ).





" Execution of outbound qRFC

new-line.
uline.

write: 'outbound qRFC execution results'.
new-line.


lo_qrfc_outbound_interface = new zcl_qrfc_interface( ip_direction = 'O' ).

do 100 times.

  lo_qrfc_outbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

     ip_destination = 'ZQRFC_DEMO_OUTBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_5' ip_commit = ''

  ).


enddo.

lo_qrfc_outbound_interface->zif_qtb_rfc_interface~add_fm_to_run_list(

   ip_destination = 'ZQRFC_DEMO_OUTBOUND' ip_fm_name = 'ZBGRFC_DEMO_INSERT_RECORDS' ip_queue_name = 'ZQRFC_DEMO_5' ip_commit = 'X'

).

lo_qrfc_outbound_interface->zif_qtb_rfc_interface~execute_and_commit( ).


lo_qrfc_outbound_interface->zif_qtb_rfc_interface~print_runtimes(  ).
