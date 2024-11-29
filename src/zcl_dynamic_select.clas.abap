class zcl_dynamic_select definition
  public
  final
  create public .

  public section.

    interfaces zif_dynamic_select.

    methods: constructor
      importing
        ip_table_name type tabname
        it_where_cond type whereconds optional
        it_field_list type whereconds optional.

  protected section.

  private section.

    data:
      mv_table_name      type tabname,
      mt_where_cond      type whereconds,
      mt_field_list      type whereconds,
      mv_tab_type        type ref to cl_abap_tabledescr,
      mv_struct_type     type ref to cl_abap_typedescr,
      mv_line_type       type ref to cl_abap_datadescr,
      mv_dref            type ref to data,
      mt_result_tab      type ref to data,
      mv_execution_time  type integer,
      mv_fetched_records type integer.


endclass.


class zcl_dynamic_select implementation.

  method constructor.

    mv_table_name = ip_table_name.
    mt_where_cond = it_where_cond.
    mt_field_list = it_field_list.

  endmethod.

  method zif_dynamic_select~prepare_query.

    cl_abap_typedescr=>describe_by_name(
          exporting
            p_name         = mv_table_name
          receiving
            p_descr_ref    = mv_struct_type
          exceptions
            type_not_found = 1
            others         = 2
        ).

    if sy-subrc <> 0.

      raise exception type zcx_dynamic_select
        exporting
          textid        = zcx_dynamic_select=>table_does_not_exist
          ip_table_name = mv_table_name.

    endif.

    mv_line_type ?= mv_struct_type.

    mv_tab_type   = cl_abap_tabledescr=>create( mv_line_type ).

    create data mv_dref type handle mv_tab_type.


  endmethod.

  method zif_dynamic_select~execute_query.

    data:
      lv_runtime_start type integer,
      lv_runtime_end   type integer.

    field-symbols : <lt_outtab> type any table.


    assign mv_dref->* to <lt_outtab>.

    get run time field lv_runtime_start.


    select (mt_field_list)
        from (mv_table_name)
        into corresponding fields of table <lt_outtab>
        where (mt_where_cond).


    if ( sy-subrc eq 0 ) or ( sy-subrc eq 4 ).

      get run time field lv_runtime_end.

      mv_execution_time = lv_runtime_end - lv_runtime_start.

      mv_fetched_records = lines( <lt_outtab> ).

      get reference of <lt_outtab> into mt_result_tab.

    else.

      raise exception type zcx_dynamic_select
        exporting
          textid        = zcx_dynamic_select=>dynamic_select_execution_error
          ip_table_name = mv_table_name.

    endif.


  endmethod.

  method zif_dynamic_select~get_query_result.

    rt_result_tab = mt_result_tab.

  endmethod.


  method zif_dynamic_select~get_execution_time.

    rp_exec_time = mv_execution_time.

  endmethod.

  method zif_dynamic_select~get_feteched_records_count.

    rp_feteched_records_count = mv_fetched_records.

  endmethod.

endclass.
