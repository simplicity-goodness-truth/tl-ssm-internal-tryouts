interface zif_qtb_rfc_interface
  public .

  methods:

    add_fm_to_run_list
      importing
        ip_destination type char32 optional
        ip_fm_name     type funcname
        ip_queue_name  type trfcqnam optional
        ip_commit      type abap_bool optional,

    execute_and_commit,

    print_runtimes
      importing
        ip_print_every_execution type abap_bool optional.

endinterface.
