class zos_badi_ic_payment_status_03 definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_ex_order_save .
    interfaces zif_badi_order_save .
  protected section.
  private section.

    methods:
      get_class_name
        returning value(rp_class_name) type abap_abstypename ,

      get_docs_migr_badi_off
        returning value(rp_get_docs_migr_badi_off) type abap_bool.

endclass.



class zos_badi_ic_payment_status_03 implementation.

  method if_ex_order_save~change_before_update.

  endmethod.

  method if_ex_order_save~prepare.

  endmethod.

  method if_ex_order_save~check_before_save.


    data(a) = 'helloworld'.


    "  data(a) = me->get_docs_migr_badi_off( ).

  endmethod.


  method get_class_name.

    rp_class_name = cl_abap_classdescr=>get_class_name( me ).

  endmethod.

  method get_docs_migr_badi_off.

    data: lv_enh_name        type enhname,
          lv_imp_name        type badi_impl_name,
          lv_class_type_name type abap_abstypename,
          lv_class_name      type classname.

    lv_class_type_name = get_class_name( ).

    find first occurrence of regex '(\\CLASS=)(.*)'
    in lv_class_type_name
    submatches data(lv_submatch_1) data(lv_submatch_2).

    if lv_submatch_2 is not initial.

      lv_class_name = lv_submatch_2.

      select single enhname badi_impl from badi_impl into ( lv_enh_name, lv_imp_name )
          where class_name eq lv_class_name.


      data lo_tool type ref to if_enh_tool.
      data lo_badi_impl type ref to cl_enh_tool_badi_impl.
      data ls_impl_data type enh_badi_impl_data.

      lo_tool = cl_enh_factory=>get_enhancement( lock           = 'X'
                                             ddic_enh       = space
                                             enhancement_id = lv_enh_name ).

      lo_badi_impl ?= lo_tool.
      lo_badi_impl->if_enh_object~set_locked( is_locked = abap_true ).
      ls_impl_data = lo_badi_impl->get_implementation( exporting impl_name =  lv_imp_name ).


*      select single value1 into rp_get_docs_migr_badi_off
*      from badi_char_cond where enhname = lv_enh_name and badi_impl = lv_imp_name and filter_name = 'ZDOCS_MIGR_BADI_OFF'.

    endif.


  endmethod.

endclass.
