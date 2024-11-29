*&---------------------------------------------------------------------*
*& Report  zdyn_table_proc_client
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zdyn_table_proc_client.

data: lo_dynamic_select type ref to zif_dynamic_select,
      ls_where_cond      type wherecond,
      lt_where_cond      type whereconds,
      ls_field           type wherecond,
      lt_fields          type whereconds,
      lr_results_tab     type ref to data,
      lv_exec_time       type integer,
      lv_fetched_records type integer.

field-symbols <fs_result> type any.

*ls_where_cond = 'RFCRESOURCE = ''WEBADMIN'''.
*append ls_where_cond to lt_where_cond.

ls_field = 'JOBNAME'.
append ls_field to lt_fields.

ls_field = 'STATUS'.
append ls_field to lt_fields.

lo_dynamic_select = new zcl_dynamic_select(
    ip_table_name = 'ZTBTCO'
    it_where_cond = lt_where_cond
    it_field_list = lt_fields
).

lo_dynamic_select->prepare_query( ).

lo_dynamic_select->execute_query( ).

lv_exec_time = lo_dynamic_select->get_execution_time( ).

lv_fetched_records = lo_dynamic_select->get_feteched_records_count( ).

new-line.

write: |total records fetched  = | && |{ lv_fetched_records }|.

new-line.

write: |total processing time = | && |{ lv_exec_time }|.

*lr_results_tab = lo_dynamic_select->get_select_query_result( ).
*
*assign lr_results_tab->* to <fs_result>.

"cl_demo_output=>display( <fs_result> ).

*data: lt_tbtco type table of tbtco.
*
*select * from tbtco into table lt_tbtco.
*
*insert ztbtco from table lt_tbtco.
