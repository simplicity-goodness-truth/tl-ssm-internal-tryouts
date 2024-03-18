class zcl_km_order_save_1 definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces zif_ex_order_save .
  protected section.
  private section.
endclass.



class zcl_km_order_save_1 implementation.

  method zif_ex_order_save~change_before_update.

    data(a) = 'badi 1: hello world aaaa'.

  endmethod.

  method zif_ex_order_save~prepare.

  endmethod.

  method zif_ex_order_save~check_before_save.

  endmethod.

endclass.
