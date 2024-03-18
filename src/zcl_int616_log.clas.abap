class zcl_int616_log definition
  public
  final
  create public .

  public section.

    methods:

      constructor,

      add_record
        importing
          ip_text type string.

  protected section.
  private section.
    data:
        mv_guid type sysuuid_x16.

endclass.



class zcl_int616_log implementation.

  method add_record.

    data: wa_int616_log      type zint616_log,
          lv_timestamp       type timestampl.

    if ( mv_guid is not initial )
    and ( ip_text is not initial ).

      get time stamp field lv_timestamp.


      wa_int616_log-guid = mv_guid.
      wa_int616_log-update_date = sy-datum.
      wa_int616_log-update_time = sy-uzeit.
      wa_int616_log-text = ip_text.
      wa_int616_log-timestamp = lv_timestamp.

      insert zint616_log from wa_int616_log.

    endif.

  endmethod.

  method constructor.

    try.
        mv_guid = cl_system_uuid=>create_uuid_x16_static( ).

      catch cx_uuid_error.

    endtry.

  endmethod.

endclass.
