class zcl_os_badi_del_blocks definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_ex_order_save .
    interfaces zif_badi_order_save .
  protected section.
  private section.
endclass.



class zcl_os_badi_del_blocks implementation.


  method if_ex_order_save~change_before_update.
  endmethod.


  method if_ex_order_save~check_before_save.

    data(a) = 3.

  endmethod.


  method if_ex_order_save~prepare.
  endmethod.
endclass.
