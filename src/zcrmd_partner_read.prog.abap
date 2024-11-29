*&---------------------------------------------------------------------*
*& Report  zcrmd_partner_read
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zcrmd_partner_read.

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


get run time field lv_runtime_start.



data(bpuser) = cl_smud_tools=>uname_2_bpuser( sy-uname ).
select single partner_guid from but000 into lv_partner_guid where partner = bpuser.


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

get run time field lv_runtime_start.


select * from crmd_partner into table lt_partner_db
  where guid in lr_link.

get run time field lv_runtime_end.


new-line.

write: |select * = | && |{ lv_runtime_end - lv_runtime_start }|.


data lt_partner_db_1    type table of crmt_object_guid .

get run time field lv_runtime_start.


select guid  from crmd_partner into table lt_partner_db_1
  where guid in lr_link
  and partner_no = lv_partner_guid.

get run time field lv_runtime_end.


new-line.

write: |select guid = | && |{ lv_runtime_end - lv_runtime_start }|.



*get run time field lv_runtime_start.
*
*
*
*select * from crmd_link into table lt_link
*  where guid_hi in lr_header_guid and
*        objtype_hi = '05' and
*        objtype_set = '07'.
*
*get run time field lv_runtime_end.
*
*
*new-line.
*
*write: |crmd_link select * = | && |{ lv_runtime_end - lv_runtime_start }|.
*
*
*

get run time field lv_runtime_start.


types: begin of ty_link,
         guid_set type crmt_object_guid,
         guid_hi  type crmt_object_guid,
       end of ty_link.

data:
  ls_link_with_key type ty_link,
  lt_link_with_key type table of ty_link.


select guid_set guid_hi from crmd_link into  table lt_link_with_key
  where guid_hi in lr_header_guid and
        objtype_hi = '05' and
        objtype_set = '07'.

*        select * from crmd_link into table lt_link
*  where guid_hi in lr_header_guid and
*        objtype_hi = '05' and
*        objtype_set = '07'.

get run time field lv_runtime_end.


new-line.

write: |crmd_link select guid_set guid_hi  = | && |{ lv_runtime_end - lv_runtime_start }|.
