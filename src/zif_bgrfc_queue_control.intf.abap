interface zif_bgrfc_queue_control
  public .

  methods:
    is_queue_in_error_state
      returning
        value(rp_is_in_error_state) type abap_bool,

    unit_can_be_executed_now
      importing
        ip_unit_id                         type bgrfc_unit_id
      returning
        value(rp_unit_can_be_executed_now) type abap_bool,

    add_queue_unit_to_exec_list
      importing
        ip_unit_id type bgrfc_unit_id,

    remove_queue_unit_to_exec_list
      importing
        ip_unit_id type bgrfc_unit_id.

endinterface.
