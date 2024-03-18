class zcl_alert_data_spta_pack_mgr definition
  public
  final
  create public .

  public section.

    types tt_alerts_list type table of e2ea_guid.


    methods:
      constructor,

      get_alerts_list
        exporting
          et_result type tt_alerts_list,

      get_alerts_count
        returning
          value(rp_result) type integer.

  protected section.
  private section.

    data:
        mt_alerts_list type tt_alerts_list.

endclass.

class zcl_alert_data_spta_pack_mgr implementation.

  method constructor.

    select algroup_id into table mt_alerts_list from e2ea_alertgroup.

  endmethod.

  method get_alerts_list.

    et_result = mt_alerts_list.

  endmethod.

  method get_alerts_count.

    rp_result = lines( mt_alerts_list ).

  endmethod.

endclass.
