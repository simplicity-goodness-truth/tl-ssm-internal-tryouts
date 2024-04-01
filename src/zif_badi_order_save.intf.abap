interface zif_badi_order_save
  public .

  interfaces if_badi_interface .
  interfaces if_ex_order_save .

*  methods change_before_update
*    importing
*      !iv_guid              type crmt_object_guid
*      ip_docs_migr_badi_off type char1 optional
*    exceptions
*      error_occured .
*  methods prepare
*    importing
*      !iv_guid              type crmt_object_guid
*      ip_docs_migr_badi_off type char1 optional
*    changing
*      !cv_own_message       type crmt_boolean optional
*    exceptions
*      do_not_save .
*  methods check_before_save
*    importing
*      !iv_guid              type crmt_object_guid
*      ip_docs_migr_badi_off type char1 optional
*    changing
*      !cv_own_message       type crmt_boolean optional
*    exceptions
*      do_not_save .

endinterface.
