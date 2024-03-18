class zcl_km_order_save definition
  public
  final
  create public .

  public section.

    interfaces if_ex_order_save .
  protected section.
  private section.
endclass.



class zcl_km_order_save implementation.


  method if_ex_order_save~change_before_update.

    data lo_order_save_badi type ref to zorder_save.

    try.

        get badi lo_order_save_badi
        filters
          operation_status    = '6'
         zdocs_migr_badi_off = 'X'.

        call badi lo_order_save_badi->change_before_update
          exporting
            iv_guid = iv_guid.


      catch cx_badi_context_error cx_badi_filter_error cx_badi_initial_context cx_badi_multiply_implemented cx_badi_not_implemented cx_badi_unknown_error
        into data(lcx_process_exception).

        data(lv_error_text) = lcx_process_exception->get_longtext( ).

    endtry.

  endmethod.


  method if_ex_order_save~check_before_save.

  endmethod.


  method if_ex_order_save~prepare.
  endmethod.
endclass.
