*&---------------------------------------------------------------------*
*& Report  zperformance_tests
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zperformance_tests.

data:lt_req_objects     type crmt_object_name_tab,
     lv_loghandle       type balloghndl,
     lv_crmt_guid       type crmt_object_guid,
     lt_crm_jest        type table of crm_jest,
     lt_crm_jsto        type table of crm_jsto,
     ls_crm_jsto        type crm_jsto,
     lt_jsto_pre        type table of crm_jsto_pre,
     ls_jsto_pre        type crm_jsto_pre,
     lt_status_profile  type table of tj30,
     ls_crm_jest        type crm_jest,
     ls_crmt_user_stat  type crmt_status_wrk,
     ls_crmt_header     type crmt_orderadm_h_wrk,
     lt_user_stat_cust  type table of bapibus20001_status_cust,
     ls_user_stat_cust  type bapibus20001_status_cust,
     lt_trans_guid      type crmt_object_guid_tab,
     et_crmt_orderadm_h type crmt_orderadm_h_wrkt,
     et_crmt_partner    type crmt_partner_external_wrkt,
     et_crmt_doc_flow   type    crmt_doc_flow_wrkt,
     et_service_os      type    crmt_srv_osset_wrkt,
     lv_runtime_start   type integer,
     lv_runtime_end     type integer,
     lv_tests_count     type int4.

data:
      lt_crm_jest_with_key type table of crm_jest with non-unique sorted key sort_key components  objnr.

lv_tests_count = 10.

do lv_tests_count times.

  get run time field lv_runtime_start.

  clear:
    lt_trans_guid,
    et_crmt_orderadm_h,
    et_crmt_partner,
    et_crmt_doc_flow,
    et_service_os,
    lt_crm_jest_with_key.

  select guid into table lt_trans_guid from crmd_orderadm_h.

  call function 'CRM_ORDER_READ_OW'
    exporting
      it_header_guid        = lt_trans_guid
      it_requested_objects  = lt_req_objects
      iv_mode               = cl_ags_work_bp_info=>c_crm_order_mode-display
      iv_no_auth_check      = abap_true "Do not check authorization here for performance
      iv_collect_exceptions = abap_true "Exception thrown not expected
      iv_only_spec_items    = abap_true "Specify for performance
    importing
      et_orderadm_h         = et_crmt_orderadm_h
      et_partner            = et_crmt_partner
      et_doc_flow           = et_crmt_doc_flow
      et_service_os         = et_service_os
    changing
      cv_log_handle         = lv_loghandle
    exceptions
      others                = 0.


  "Read status data from DB directly

  loop at lt_trans_guid into lv_crmt_guid.
    ls_jsto_pre-objnr = lv_crmt_guid.
    append ls_jsto_pre to lt_jsto_pre.
  endloop.

  call function 'CRM_STATUS_PRE_READ_DATA'
    tables
      jsto_pre_tab    = lt_jsto_pre
      jsto_data_table = lt_crm_jsto
      jest_data_table = lt_crm_jest.
  check lt_crm_jsto is not initial.

  "cl_demo_output=>display( lt_crm_jsto ).

  append lines of lt_crm_jest to lt_crm_jest_with_key.

read table lt_crm_jsto into ls_crm_jsto
        with key objnr = lv_crmt_guid.

  loop at lt_trans_guid into lv_crmt_guid.

    " loop at lt_crm_jest into ls_crm_jest
     "   where objnr = lv_crmt_guid.

   loop at lt_crm_jest_with_key into ls_crm_jest
       using key sort_key where objnr = lv_crmt_guid.




    endloop.

  endloop.

enddo.

get run time field lv_runtime_end.

new-line.

write: |test executions = | && |{ lv_tests_count }|.


new-line.

write: |total CRM documents amount = | && |{ lv_tests_count * lines( lt_trans_guid ) }|.

new-line.

write: |total processing time = | && |{ lv_runtime_end - lv_runtime_start }|.

new-line.

write: |average processing time = | && |{ ( lv_runtime_end - lv_runtime_start ) / lv_tests_count }|.
