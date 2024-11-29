class zcx_dynamic_select definition
  public
  inheriting from cx_static_check
  final
  create public .

  public section.

    interfaces if_t100_message .

    constants:
      begin of dynamic_select_execution_error,
        msgid type symsgid value 'ZDYNAMIC_SELECT',
        msgno type symsgno value '001',
        attr1 type scx_attrname value 'MV_TABLE_NAME',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of dynamic_select_execution_error .

    constants:
      begin of table_does_not_exist,
        msgid type symsgid value 'ZDYNAMIC_SELECT',
        msgno type symsgno value '002',
        attr1 type scx_attrname value 'MV_TABLE_NAME',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of table_does_not_exist .


    class-data mv_table_name type tabname .

    methods constructor
      importing
        !textid        like if_t100_message=>t100key optional
        !previous      like previous optional
        !ip_table_name type tabname.
  protected section.
  private section.
endclass.



class zcx_dynamic_select implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    call method super->constructor
      exporting
        previous = previous.

    me->mv_table_name = ip_table_name .

    clear me->textid.
    if textid is initial.
      if_t100_message~t100key = if_t100_message=>default_textid.
    else.
      if_t100_message~t100key = textid.
    endif.
  endmethod.
endclass.
