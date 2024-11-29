interface zif_dynamic_select
  public .

  methods:

    prepare_query
      raising
        zcx_dynamic_select,

    execute_query
      raising
        zcx_dynamic_select,

    get_feteched_records_count
      returning
        value(rp_feteched_records_count) type integer
      raising
        zcx_dynamic_select,

    get_execution_time
      returning
        value(rp_exec_time) type integer
      raising
        zcx_dynamic_select,

    get_query_result
      returning
        value(rt_result_tab) type ref to data
      raising
        zcx_dynamic_select.

endinterface.
