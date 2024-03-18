*&---------------------------------------------------------------------*
*& Report  zqtb_rfc_demo_cleaner
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zqtb_rfc_demo_cleaner.


data: lv_zbgrfc_demo_tab_count  type integer,
      lv_zbgrfc_alrt_data_count type integer.

" cleanup of ZBGRFC_DEMO_TAB


select count( * ) up to 1 rows into lv_zbgrfc_demo_tab_count from zbgrfc_demo_tab.

if lv_zbgrfc_demo_tab_count ne 0.

  delete from zbgrfc_demo_tab.

endif.


" cleanup of ZBGRFC_ALRT_DATA


select count( * ) up to 1 rows into lv_zbgrfc_alrt_data_count from zbgrfc_alrt_data.

if lv_zbgrfc_alrt_data_count ne 0.

  delete from zbgrfc_alrt_data.

endif.
