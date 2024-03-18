class zcl_qtb_rfc_interface definition
  public
  create public .

  public section.

    interfaces zif_qtb_rfc_interface .

    methods:

      constructor
        importing
          ip_direction type char1
          ip_type      type char1 optional.

  protected section.

    types: begin of  ty_execution_list,
             destination type char32,
             fm_name     type funcname,
             queue_name  type trfcqnam,
             commit      type abap_bool,
           end of ty_execution_list.

    constants:
      mc_outbound type char1 value 'O',
      mc_inbound  type char1 value 'I',
      mc_trfc     type char1 value 'T',
      mc_qrfc     type char1 value 'Q',
      mc_btrfc    type char2 value 'BT',
      mc_bqrfc    type char2 value 'BQ'.

    data:
      mt_execution_list type table of ty_execution_list,
      mt_runtime        type zqtb_rfc_tt_runtimes,
      mv_direction      type char1,
      mv_type           type char2,
      mv_start_run_time type integer.

  private section.



endclass.

class zcl_qtb_rfc_interface implementation.

  method constructor.

    case ip_direction.

      when mc_inbound or mc_outbound.

        mv_direction = ip_direction.

    endcase.


    case ip_type.

      when mc_qrfc or mc_trfc.

        mv_type = ip_type.

    endcase.



  endmethod.

  method zif_qtb_rfc_interface~add_fm_to_run_list.

    data wa_execution_list type ty_execution_list.

    wa_execution_list-destination = ip_destination.
    wa_execution_list-fm_name = ip_fm_name.
    wa_execution_list-queue_name = ip_queue_name.
    wa_execution_list-commit = ip_commit.

    append wa_execution_list to mt_execution_list.

  endmethod.

  method zif_qtb_rfc_interface~execute_and_commit.



  endmethod.

  method zif_qtb_rfc_interface~print_runtimes.

    data: lv_text_line             type string,
          lv_runtime_records_count type int4,
          lv_previous_runtime      type integer,
          lv_runtime_diff          type integer,
          lv_total_duration        type integer.



    lv_runtime_records_count =  lines( mt_runtime ).

    lv_text_line = |type: | && |{ mv_type }| && | | && |direction: | && |{ mv_direction }| && | | && |start: | && |{ mv_start_run_time }|.
    write lv_text_line.

    new-line.

    if ip_print_every_execution eq abap_true.

      loop at mt_runtime assigning field-symbol(<fs_runtime>).

        if ( sy-tabix > 1 ) and ( sy-tabix < lv_runtime_records_count ).
          "if ( sy-tabix < lv_runtime_records_count ).

          if  ( sy-tabix eq 2 ).

            lv_runtime_diff = <fs_runtime>-runtime - mv_start_run_time.

          else.

            lv_runtime_diff = <fs_runtime>-runtime - lv_previous_runtime.

          endif.

          lv_previous_runtime = <fs_runtime>-runtime.


          lv_text_line =
                   |{ sy-tabix - 1 }| && | | &&
                   |fm: | && |{ <fs_runtime>-fm_name }| && | | &&
                   |destination: | && |{ <fs_runtime>-destination }| && | | &&
                   |queue: | && |{ <fs_runtime>-queue_name }| && | | &&
                   |commit: | && |{ <fs_runtime>-commit }| && | | &&
                   |runtime: | && |{ <fs_runtime>-runtime }| && | | &&
                   |step runtime: | && |{ lv_runtime_diff }|.

          write lv_text_line.

          new-line.

        endif.
      endloop.

    endif.

    try.

        lv_total_duration = mt_runtime[ lv_runtime_records_count ]-runtime - mv_start_run_time.

        lv_text_line = |total duration: | && |{ lv_total_duration }|.

        write lv_text_line.

      catch cx_sy_itab_line_not_found.

    endtry.

  endmethod.

endclass.
