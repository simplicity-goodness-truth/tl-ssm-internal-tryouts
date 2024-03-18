class ZCX_BGRFC_INTERFACE definition
  public
  inheriting from cx_static_check
  final
  create public .

  public section.

    interfaces if_t100_message .

    constants:
      begin of incorrect_inbound_dest_name,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '001',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of incorrect_inbound_dest_name .
    constants:
      begin of inbound_dest_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '002',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of inbound_dest_not_set .
    constants:
      begin of inbound_trfc_unit_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '003',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of inbound_trfc_unit_not_set .
    constants:
      begin of inbound_qrfc_unit_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '004',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of inbound_qrfc_unit_not_set .
    constants:
      begin of incorrect_outbound_dest_name,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '005',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of incorrect_outbound_dest_name .
    constants:
      begin of outbound_dest_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '006',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of outbound_dest_not_set .
    constants:
      begin of outbound_trfc_unit_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '007',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of outbound_trfc_unit_not_set .
    constants:
      begin of outbound_qrfc_unit_not_set,
        msgid type symsgid value 'ZBGRFC_INTERFACE',
        msgno type symsgno value '008',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of outbound_qrfc_unit_not_set .

    methods constructor
      importing
        !textid   like if_t100_message=>t100key optional
        !previous like previous optional .
  protected section.
  private section.
endclass.



class ZCX_BGRFC_INTERFACE implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    call method super->constructor
      exporting
        previous = previous.
    clear me->textid.
    if textid is initial.
      if_t100_message~t100key = if_t100_message=>default_textid.
    else.
      if_t100_message~t100key = textid.
    endif.
  endmethod.
endclass.
