interface zif_ex_order_save
  public .

  interfaces if_badi_interface.

  methods change_before_update
    importing
      !iv_guid type crmt_object_guid
    exceptions
      error_occured .
  methods prepare
    importing
      !iv_guid        type crmt_object_guid
    changing
      !cv_own_message type crmt_boolean optional
    exceptions
      do_not_save .
  methods check_before_save
    importing
      !iv_guid        type crmt_object_guid
    changing
      !cv_own_message type crmt_boolean optional
    exceptions
      do_not_save .

endinterface.
