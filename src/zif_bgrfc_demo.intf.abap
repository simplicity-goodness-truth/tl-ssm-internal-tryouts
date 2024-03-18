interface zif_bgrfc_demo
  public .

  methods:
    set_inbound_destination
      importing
        ip_destination_name type bgrfc_dest_name_inbound
      raising
        zcx_bgrfc_interface,

    set_inbound_trfc_unit
      raising
        zcx_bgrfc_interface,

    set_inbound_qrfc_unit
      raising
        zcx_bgrfc_interface,

    get_inbound_trfc_unit
      returning
        value(rr_inbound_trfc_unit) type ref to if_trfc_unit_inbound
      raising
        zcx_bgrfc_interface,

    get_inbound_qrfc_unit
      returning
        value(rr_inbound_qrfc_unit) type ref to if_qrfc_unit_inbound
      raising
        zcx_bgrfc_interface,

    set_outbound_destination
      importing
        ip_destination_name type bgrfc_dest_name_outbound
      raising
        zcx_bgrfc_interface,

    set_outbound_trfc_unit
      raising
        zcx_bgrfc_interface,

    set_outbound_qrfc_unit
      raising
        zcx_bgrfc_interface,

    get_outbound_trfc_unit
      returning
        value(rr_outbound_trfc_unit) type ref to if_trfc_unit_outbound
      raising
        zcx_bgrfc_interface,

    get_outbound_qrfc_unit
      returning
        value(rr_outbound_qrfc_unit) type ref to if_qrfc_unit_outbound
      raising
        zcx_bgrfc_interface.

endinterface.
