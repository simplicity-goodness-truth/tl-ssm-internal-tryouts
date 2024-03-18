*&---------------------------------------------------------------------*
*& Report  zbgrfc_units_order
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zbgrfc_units_order.

data: lr_inbound_destination type ref to if_bgrfc_destination_inbound,
      lr_inbound_qrfc_unit   type ref to if_qrfc_unit_inbound,
      lv_inbound_queue_name  type qrfc_queue_name,
      lv_finished            type abap_bool,
      lv_order_id            type int4,
      lv_package_id          type int4,
      lv_rem                 type p decimals 2,
      lv_queue_name          type char40.

" AS-IS Situation

lv_order_id = 555777.
lv_package_id = 100.

lr_inbound_destination = cl_bgrfc_destination_inbound=>create( 'ZBG_RFC_DEMO_INBOUND' ).

do 40 times.

  try.

      lr_inbound_qrfc_unit = lr_inbound_destination->create_qrfc_unit( ).


    "  lv_queue_name = 'ZQ1'.

    lv_rem = sy-index mod 10.

if lv_rem eq 0.

  lv_package_id = lv_package_id + 1.

endif.

      lv_queue_name = |ZBGRFC_| && |{ lv_package_id }|  && |_| && |{ lv_order_id }|.


      lr_inbound_qrfc_unit->add_queue_name_inbound( lv_queue_name ).

      call function 'ZBGRFC_UNIT' in background unit lr_inbound_qrfc_unit
        exporting
          ip_number   = sy-index
         ip_unit_id  = lr_inbound_qrfc_unit->unit_id
          ip_queue    = lv_queue_name
          ip_finished = lv_finished.

    catch cx_sy_dynamic_osql_semantics.


  endtry.

  commit work.

enddo.
