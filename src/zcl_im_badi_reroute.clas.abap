class zcl_im_badi_reroute definition
  public
  final
  create public .

  public section.

    interfaces if_ex_order_save .
  protected section.
  private section.
endclass.



class zcl_im_badi_reroute implementation.


  method if_ex_order_save~change_before_update.

    data: lr_order_save   type ref to zbadi_order_save,
          lv_process_type type crmt_process_type.

    "  check zcl_im_badi_reserve_items=>gv_rec_reserve is initial.

    call function 'CRM_ORDERADM_H_READ_OW'
      exporting
        iv_orderadm_h_guid     = iv_guid
      importing
        ev_process_type        = lv_process_type
      exceptions
        admin_header_not_found = 1
        others                 = 2.
    if sy-subrc = 1.
      return.
    endif.

    check lv_process_type is not initial.
    try.
        get badi lr_order_save
          filters
            process_type        = lv_process_type
            zdocs_migr_badi_off = 'X'.

        check lr_order_save is bound.

        call badi lr_order_save->if_ex_order_save~change_before_update
          exporting
            iv_guid       = iv_guid
          exceptions
            error_occured = 1
            others        = 2.
        if sy-subrc <> 0.
          message id sy-msgid type sy-msgty number sy-msgno
                     with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 raising
        error_occured.
        endif.
      catch cx_root.
    endtry.

  endmethod.


  method if_ex_order_save~check_before_save.

    data: lr_order_save   type ref to zbadi_order_save,
          lv_process_type type crmt_process_type.

    " check zcl_im_badi_reserve_items=>gv_rec_reserve is initial.

    call function 'CRM_ORDERADM_H_READ_OW'
      exporting
        iv_orderadm_h_guid     = iv_guid
      importing
        ev_process_type        = lv_process_type
      exceptions
        admin_header_not_found = 1
        others                 = 2.
    if sy-subrc = 1.
      return.
    endif.

    check lv_process_type is not initial.
    try.
        get badi lr_order_save
          filters
            process_type        = lv_process_type
            zdocs_migr_badi_off = ''.

        check lr_order_save is bound.

         call badi lr_order_save->if_ex_order_save~check_before_save
          exporting
            iv_guid        = iv_guid
          changing
            cv_own_message = cv_own_message
          exceptions
            do_not_save    = 1
            others         = 2.
        if sy-subrc <> 0.
          cv_own_message = abap_true.
          message id sy-msgid type sy-msgty number sy-msgno
                     with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 raising
        do_not_save.
        endif.
      catch cx_root.
    endtry.

  endmethod.


  method if_ex_order_save~prepare.

    data: lr_order_save   type ref to zbadi_order_save,
          lv_process_type type crmt_process_type.

    "   check zcl_im_badi_reserve_items=>gv_rec_reserve is initial.

    call function 'CRM_ORDERADM_H_READ_OW'
      exporting
        iv_orderadm_h_guid     = iv_guid
      importing
        ev_process_type        = lv_process_type
      exceptions
        admin_header_not_found = 1
        others                 = 2.
    if sy-subrc = 1.
      return.
    endif.

    check lv_process_type is not initial.
    try.
        get badi lr_order_save
          filters
            process_type        = lv_process_type
            zdocs_migr_badi_off = 'X'.

        check lr_order_save is bound.

        call badi lr_order_save->if_ex_order_save~prepare
          exporting
            iv_guid        = iv_guid
          changing
            cv_own_message = cv_own_message
          exceptions
            do_not_save    = 1
            others         = 2.
        if sy-subrc <> 0.
          message id sy-msgid type sy-msgty number sy-msgno
                     with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 raising
        do_not_save.
        endif.
      catch cx_root.
    endtry.

  endmethod.
endclass.
