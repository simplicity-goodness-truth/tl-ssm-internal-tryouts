class zcl_bgrfc_exec_control definition
  public
  final
  create public .

  public section.

    methods:
      constructor
        importing
          ip_funcname type funcname.

    interfaces zif_bgrfc_exec_control .
  protected section.
  private section.

    data:
      mv_funcname        type funcname,
      mt_ptab            type abap_func_parmbind_tab,
      ms_exec_parameters type zbgrfc_ts_exec_param.


    methods retry.

endclass.



class zcl_bgrfc_exec_control implementation.


  method constructor.

    mv_funcname = ip_funcname.

  endmethod.


  method zif_bgrfc_exec_control~get_fm_unit_interface.

    data lv_limu_name type eu_lname.

    if mv_funcname is not initial.

      lv_limu_name = mv_funcname.

      call method cl_fb_function_utility=>meth_get_interface
        exporting
          im_name             = lv_limu_name
        importing
          ex_interface        = rt_fm_unit_interface
        exceptions
          error_occured       = 1
          object_not_existing = 2
          others              = 3.

    endif.


  endmethod.

  method zif_bgrfc_exec_control~set_exec_parameters.

    ms_exec_parameters = is_exec_parameters.
    mt_ptab = it_ptab.

  endmethod.

  method zif_bgrfc_exec_control~execute.


    data: lr_inbound_destination type ref to if_bgrfc_destination_inbound,
          lr_inbound_qrfc_unit   type ref to if_qrfc_unit_inbound.


    lr_inbound_destination = cl_bgrfc_destination_inbound=>create( ms_exec_parameters-destination ).

    if lr_inbound_destination is not bound.

      exit.

      " ZZZZZZZZZZZZZZZZ ERROR HANDLING
      " ZZZZZZZZZZZZZZZZ ERROR HANDLING
      " ZZZZZZZZZZZZZZZZ ERROR HANDLING

    endif.
*
*    try.
*
    lr_inbound_qrfc_unit = lr_inbound_destination->create_qrfc_unit( ).

    lr_inbound_qrfc_unit->add_queue_name_inbound( ms_exec_parameters-queuename ).

    if ms_exec_parameters-initialdelay    is not initial.
      lr_inbound_qrfc_unit->delay( ms_exec_parameters-initialdelay ).
    endif.

    lr_inbound_qrfc_unit->disable_commit_checks( ).

*    call function mv_funcname in background unit lr_inbound_qrfc_unit
*      parameter-table mt_ptab
*      .

    call function mv_funcname in background unit lr_inbound_qrfc_unit.



  endmethod.

  method retry.

  endmethod.

endclass.
