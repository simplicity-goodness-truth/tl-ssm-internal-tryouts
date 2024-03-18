FUNCTION ZBGRFC_UNIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_NUMBER) TYPE  INT4
*"     VALUE(IP_FINISHED) TYPE  CHAR1 OPTIONAL
*"     VALUE(IP_QUEUE) TYPE  CHAR40 OPTIONAL
*"     VALUE(IP_UNIT_ID) TYPE  BGRFC_UNIT_ID OPTIONAL
*"  EXPORTING
*"     VALUE(EP_RESULT) TYPE  INT4
*"----------------------------------------------------------------------
  data wa_zbgrfc_units_ord type zbgrfc_units_ord.


  if ip_number eq 33.

    raise exception type cx_sy_dynamic_osql_semantics
      exporting
        textid = cx_sy_dynamic_osql_semantics=>unknown_table_name
        token  = 'Test'.




  endif.

  try.

      wa_zbgrfc_units_ord-guid = cl_system_uuid=>create_uuid_x16_static( ).
      wa_zbgrfc_units_ord-executiondate = sy-datum.
      wa_zbgrfc_units_ord-executiontime = sy-uzeit.
      wa_zbgrfc_units_ord-funcnumber = ip_number.
      wa_zbgrfc_units_ord-funcname = sy-repid.
      wa_zbgrfc_units_ord-queue = ip_queue.
      wa_zbgrfc_units_ord-unitid = ip_unit_id.

      insert zbgrfc_units_ord from wa_zbgrfc_units_ord .

    catch cx_uuid_error.

  endtry.



endfunction.
