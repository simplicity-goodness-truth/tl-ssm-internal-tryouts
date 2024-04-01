interface zif_bgrfc_exec_control
  public .

  methods:

    get_fm_unit_interface
      returning
        value(rt_fm_unit_interface) type rsfbintfv,

    set_exec_parameters
      importing
        is_exec_parameters type zbgrfc_ts_exec_param
        it_ptab            type abap_func_parmbind_tab,

    execute.

endinterface.
