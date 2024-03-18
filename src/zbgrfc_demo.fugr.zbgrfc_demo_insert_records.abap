function zbgrfc_demo_insert_records.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
  data:
    lv_random_records_count type int4,
    wa_zbgrfc_demo_tab      type zbgrfc_demo_tab.

  lv_random_records_count = 100.

  try.

      do lv_random_records_count times.

        wa_zbgrfc_demo_tab-guid = cl_system_uuid=>create_uuid_x16_static( ).
        wa_zbgrfc_demo_tab-creationdate = sy-datum.
        wa_zbgrfc_demo_tab-creationtime = sy-uzeit.

        insert zbgrfc_demo_tab from wa_zbgrfc_demo_tab.

      enddo.

    catch cx_uuid_error.

      " Error handling

  endtry.


endfunction.
