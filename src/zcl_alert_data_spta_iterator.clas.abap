class zcl_alert_data_spta_iterator definition
  public
  final
  create public .

  public section.

    types: begin of  ty_alert_data,

             context_id      type ac_guid,
             alerttype_id    type ac_guid,
             start_timestamp type e2ea_timestamp,
             end_timestamp   type e2ea_timestamp,
             al_count        type num6,
             tech_scenario   type ac_technical_scenario,
             name            type ac_name,

           end of ty_alert_data.

    types tt_alert_data type table of ty_alert_data.

    methods:
      constructor
        importing ip_algroup_id type e2ea_guid,

      get_results
        exporting es_results type ty_alert_data.

  protected section.
  private section.

    data:
         ms_e2ea_alertgroup type e2ea_alertgroup.


endclass.


class zcl_alert_data_spta_iterator implementation.

  method get_results.

    data wa_alert_data type ty_alert_data.

    if ms_e2ea_alertgroup is initial.
      return.
    endif.

    wa_alert_data-alerttype_id = ms_e2ea_alertgroup-alerttype_id.
    wa_alert_data-al_count = ms_e2ea_alertgroup-al_count.
    wa_alert_data-context_id = ms_e2ea_alertgroup-context_id.
    wa_alert_data-end_timestamp = ms_e2ea_alertgroup-end_timestamp.
    wa_alert_data-start_timestamp = ms_e2ea_alertgroup-start_timestamp.

    select single name tech_scenario into ( wa_alert_data-name, wa_alert_data-tech_scenario )
        from acalertdir
        where alert_type_id = ms_e2ea_alertgroup-alerttype_id
        and ac_variant = 'A'.

    es_results = wa_alert_data.

    " append wa_alert_data to et_results.

  endmethod.

  method constructor.

    select single context_id alerttype_id start_timestamp end_timestamp al_count from e2ea_alertgroup
      into corresponding fields of ms_e2ea_alertgroup
      where algroup_id eq ip_algroup_id.

  endmethod.

endclass.
