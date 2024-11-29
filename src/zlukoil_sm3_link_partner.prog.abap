*&---------------------------------------------------------------------*
*& Report  zlukoil_sm3_link_partner
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zlukoil_sm3_link_partner.

data: it_app_ids          type smud_crm_guid_t,
      wa_app_id           type smud_crm_guid,
      iv_uname            type uname,
      displayable_app_ids type smud_crm_guid_t.

iv_uname = sy-uname.

*cl_smudk_tool_contract=>require( boolc( iv_uname is not initial ) ).
*cl_smudk_tool_contract=>require( boolc( it_app_ids is not initial ) ).

data lt_header_guid   type crmt_object_guid_tab.
data lv_header_guid   type crmt_object_guid.
data lr_header_guid   type range of crmt_object_guid.
data lrs_header_guid  like line of lr_header_guid.
data lt_link          type table of crmd_link.
data lr_link          type range of crmt_object_guid.
data lrs_link         like line of lr_link.
data lt_status        type crmt_status_wrkt.
data lt_partner_db    type table of crmd_partner.
data lv_partner_guid  type bu_partner_guid.

data partner_no type crmt_partner_no.

data: lv_runtime_start type integer,
      lv_runtime_end   type integer,
      lv_tests_count   type int4.


data(bp_user) = cl_smud_tools=>uname_2_bpuser( iv_uname ).

if bp_user co '1234567890 '.

  call function 'CONVERSION_EXIT_ALPHA_OUTPUT' " Remove leading zeroes for comparision
    exporting
      input  = bp_user
    importing
      output = partner_no.

else.

  partner_no = bp_user.

endif.


data: lt_crmd_link type table of crmd_link,
      lv_guid_hi   type smud_crm_guid.


" ========preparting it_app_ids===================


do 20000 times.

  wa_app_id = cl_system_uuid=>create_uuid_x16_static( ).

  append wa_app_id to it_app_ids.

enddo.

select guid_hi from crmd_link into  corresponding fields of table lt_crmd_link.

delete adjacent duplicates from lt_crmd_link.

loop at lt_crmd_link assigning field-symbol(<fs_crmd_link>).

  wa_app_id = <fs_crmd_link>-guid_hi.

  insert wa_app_id into table  it_app_ids.

endloop.



"cl_demo_output=>display( it_app_ids ).


if partner_no is not initial.

  data(assigned_guids) = value crmt_object_guid_tab( ).

  if lines( it_app_ids ) eq 1.

    data(crm_guid) = conv crmt_object_guid( it_app_ids[ 1 ] ).

    cl_ags_crm_1o_api=>get_instance(
      exporting
        iv_header_guid                =  crm_guid
        iv_process_mode               =  cl_ags_crm_1o_api=>ac_mode-display
      importing
        eo_instance                   =  data(lo_crm_api)
      exceptions
        invalid_parameter_combination = 1
        error_occurred                = 2
        others                        = 3 ).

    if sy-subrc eq 0 and lo_crm_api is bound.

      lo_crm_api->get_partners(
        importing
          et_partner           = data(lt_partner)
        exceptions
          document_not_found   = 1
          error_occurred       = 2
          document_locked      = 3
          no_change_authority  = 4
          no_display_authority = 5
          no_change_allowed    = 6
          others               = 7
      ).

      if sy-subrc eq 0.

        read table lt_partner transporting no fields
          with key partner_no = partner_no.

        if sy-subrc eq 0.

          insert crm_guid into table assigned_guids.

        endif.

      endif.

    endif.

  else.

    "Improve performance by direct calling DB instead of CRM_ORDER_READ

    lv_tests_count = 100.

    get run time field lv_runtime_start.



    loop at it_app_ids into data(lv_app_id).
      check lv_app_id is not initial.
      lv_header_guid = lv_app_id.
      insert lv_header_guid into table lt_header_guid.
      lrs_header_guid-sign = 'I'.
      lrs_header_guid-option = 'EQ'.
      lrs_header_guid-low = lv_header_guid.
      insert lrs_header_guid into table lr_header_guid.
    endloop.

    select * from crmd_link into table lt_link
      where guid_hi in lr_header_guid and
            objtype_hi = '05' and
            objtype_set = '07'.

    loop at lt_link into data(ls_link).
      lrs_link-sign = 'I'.
      lrs_link-option = 'EQ'.
      lrs_link-low = ls_link-guid_set.
      insert lrs_link into table lr_link.
    endloop.

    select * from crmd_partner into table lt_partner_db
      where guid in lr_link.

    call function 'CRM_STATUS_READ_OW'
      exporting
        it_guid       = lt_header_guid
      importing
        et_status_wrk = lt_status
      exceptions
        others        = 0.

    data(bpuser) = cl_smud_tools=>uname_2_bpuser( sy-uname ).
    select single partner_guid from but000 into lv_partner_guid where partner = bpuser.

    loop at lt_partner_db into data(ls_partner_db) where partner_no = lv_partner_guid.
      read table lt_link into ls_link with key guid_set = ls_partner_db-guid.
      if ls_link-guid_hi is not initial.
        insert ls_link-guid_hi into table assigned_guids.
      endif.
    endloop.

    delete adjacent duplicates from assigned_guids.



    data(lt_transaction_types) = cl_al_crm_cm_utility=>get_all_proc_type( ).

    loop at assigned_guids reference into data(assigned_guid).

      read table it_app_ids transporting no fields
        with key table_line = assigned_guid->*.

      if sy-subrc eq 0.

        cl_ags_crm_1o_api=>get_instance(
          exporting
            iv_header_guid                = assigned_guid->*
            iv_process_mode               = cl_ags_crm_1o_api=>ac_mode-display
          importing
            eo_instance                   = lo_crm_api
          exceptions
            invalid_parameter_combination = 1
            error_occurred                = 2
            others                        = 3 ).

        if sy-subrc eq 0 and lo_crm_api is bound.

          if lo_crm_api->is_change_allowed( ) eq abap_true and
             lo_crm_api->is_authorized_to_change( ) eq abap_true.

            cl_wdcm_extchreq_scoping_asst=>editability_depending_on_field(
              exporting
                iv_header_guid    = assigned_guid->*
                iv_field_name     = cl_wdcm_extchreq_scoping_asst=>c_scope_button
              importing
                ev_editable       = data(editable)
                ev_visible        = data(visible)
              exceptions
                parameter_missing = 1
                no_document       = 2
                no_entry_found    = 3
                others            = 4
            ).

            if sy-subrc eq 0 and editable = abap_true and visible = abap_true.

              "check change document has a change cycle assignment.
              data(ls_context) = cl_ai_crm_cm_cr_cont_run_btil=>get_cr_context( assigned_guid->* ).
              if ls_context-sbra_id is not initial.

                read table lt_transaction_types transporting no fields with key table_line = ls_context-process_type.
                if sy-subrc = 0.
                  insert conv smud_crm_guid( assigned_guid->* ) into table displayable_app_ids.
                endif.


              endif.

            endif.

          endif.

        endif.

      endif.

    endloop.

    get run time field lv_runtime_end.



    new-line.

    write: |user bp = | && |{ partner_no }|.

    new-line.

    write: |test executions = | && |{ lv_tests_count }|.

    new-line.

    write: |it_app_ids records = | && |{ lines( it_app_ids ) }|.

    new-line.

    write: |lt_link records = | && |{ lines( lt_link ) }|.

    new-line.

    write: |lt_partner_db records = | && |{ lines( lt_partner_db ) }|.

    new-line.

    write: |assigned_guids records = | && |{ lines( assigned_guids ) }|.

    new-line.

    write: |total processing time = | && |{ lv_runtime_end - lv_runtime_start }|.

    new-line.

    write: |average processing time = | && |{ ( lv_runtime_end - lv_runtime_start ) / lv_tests_count }|.

  endif.

endif.
