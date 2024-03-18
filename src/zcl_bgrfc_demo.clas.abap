class zcl_bgrfc_demo definition
  public
  final
  create public .

  public section.

    interfaces zif_bgrfc_demo .

  protected section.
  private section.

    data:
      mr_inbound_destination  type ref to if_bgrfc_destination_inbound,
      mr_inbound_qrfc_unit    type ref to if_qrfc_unit_inbound,
      mr_inbound_trfc_unit    type ref to if_trfc_unit_inbound,
      mr_outbound_destination type ref to if_bgrfc_destination_outbound,
      mr_outbound_qrfc_unit   type ref to if_qrfc_unit_outbound,
      mr_outbound_trfc_unit   type ref to if_trfc_unit_outbound.

endclass.

class zcl_bgrfc_demo implementation.

  method zif_bgrfc_demo~set_inbound_destination.

    try.

        mr_inbound_destination = cl_bgrfc_destination_inbound=>create( ip_destination_name ).

      catch cx_bgrfc_invalid_destination.

        raise exception type zcx_bgrfc_interface
          exporting
            textid = zcx_bgrfc_interface=>incorrect_inbound_dest_name.

    endtry.

  endmethod.

  method zif_bgrfc_demo~set_inbound_trfc_unit.

    if mr_inbound_destination is bound.

      mr_inbound_trfc_unit = mr_inbound_destination->create_trfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_dest_not_set.

    endif.

  endmethod.

  method zif_bgrfc_demo~set_inbound_qrfc_unit.

    if mr_inbound_destination is bound.

      mr_inbound_qrfc_unit = mr_inbound_destination->create_qrfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_dest_not_set.

    endif.

  endmethod.

  method zif_bgrfc_demo~get_inbound_trfc_unit.

    if mr_inbound_trfc_unit is bound.

      rr_inbound_trfc_unit = mr_inbound_trfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_trfc_unit_not_set.


    endif.

  endmethod.

  method zif_bgrfc_demo~get_inbound_qrfc_unit.

    if mr_inbound_qrfc_unit is bound.

      rr_inbound_qrfc_unit = mr_inbound_qrfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>inbound_trfc_unit_not_set.
    endif.

  endmethod.




  method zif_bgrfc_demo~set_outbound_destination.

    try.

        mr_outbound_destination = cl_bgrfc_destination_outbound=>create( ip_destination_name ).

      catch cx_bgrfc_invalid_destination.

        raise exception type zcx_bgrfc_interface
          exporting
            textid = zcx_bgrfc_interface=>incorrect_outbound_dest_name.

    endtry.

  endmethod.

  method zif_bgrfc_demo~set_outbound_trfc_unit.

    if mr_outbound_destination is bound.

      mr_outbound_trfc_unit = mr_outbound_destination->create_trfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_dest_not_set.

    endif.

  endmethod.

  method zif_bgrfc_demo~set_outbound_qrfc_unit.

    if mr_outbound_destination is bound.

      mr_outbound_qrfc_unit = mr_outbound_destination->create_qrfc_unit( ).

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_dest_not_set.

    endif.

  endmethod.

  method zif_bgrfc_demo~get_outbound_trfc_unit.

    if mr_outbound_trfc_unit is bound.

      rr_outbound_trfc_unit = mr_outbound_trfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_trfc_unit_not_set.


    endif.

  endmethod.

  method zif_bgrfc_demo~get_outbound_qrfc_unit.

    if mr_outbound_qrfc_unit is bound.

      rr_outbound_qrfc_unit = mr_outbound_qrfc_unit.

    else.

      raise exception type zcx_bgrfc_interface
        exporting
          textid = zcx_bgrfc_interface=>outbound_trfc_unit_not_set.
    endif.

  endmethod.







endclass.
