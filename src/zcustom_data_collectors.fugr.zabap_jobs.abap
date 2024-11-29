FUNCTION ZABAP_JOBS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SELOPT_PARA) TYPE  /SDF/E2E_SELECTION_PARA_T
*"  EXPORTING
*"     VALUE(RESULT) TYPE  /SDF/E2E_RESULT_TT
*"     VALUE(RETURN_STATUS) TYPE  /SDF/E2E_EFWKE_RETURN_STATUS_T
*"----------------------------------------------------------------------
  constants: c_total     type string value 'TOTAL', c_today type string value 'TODAY', c_yesterday type string value 'YESTERDAY'.

  types: begin of lty_dump_stat,
           client type symandt,
           uname  type syuname,
           datum  type datum,
           entry  type i,
         end of lty_dump_stat.
  data:
    lt_selopt_para    like selopt_para,
    ls_parameter      type /sdf/e2e_para,
    ls_result         type /sdf/e2e_result,
    lt_sel_opt_client type /sdf/e2e_selop_tt,
    lt_sel_opt_user   type /sdf/e2e_selop_tt,
    lt_sel_opt_date   type /sdf/e2e_selop_tt,
    ls_return_status  like line of return_status,
    ls_dump_stat      type lty_dump_stat, lt_dump_stat type table of lty_dump_stat,
    lt_snap           type table of snap, ls_snap type snap,
    lv_total_user, lv_total_client,
    lv_date           type d, lv_date_string type string,
    lv_where          type string.

  field-symbols:
    <ls_selopt_para>         type /sdf/e2e_selection_para,
    <ls_selection_parameter> type /sdf/e2e_selection_params,
    <ls_sel_opt>             type /sdf/ranges,
    <ls_snap>                like line of lt_snap.


  loop at selopt_para assigning <ls_selopt_para>.

    " Loop over all CALL_ID
    " Retrieve parameter values from the metric configuration

    loop at <ls_selopt_para>-selection_parameter assigning <ls_selection_parameter>.

      case <ls_selection_parameter>-param.
        when 'CLIENT'.
          clear lv_total_client.
          lt_sel_opt_client = <ls_selection_parameter>-t_ranges.
          read table lt_sel_opt_client assigning <ls_sel_opt> index 1.
          if sy-subrc eq 0 and <ls_sel_opt>-sign ='I' and <ls_sel_opt>-option = 'EQ' and
          <ls_sel_opt>-low = c_total.
            lv_total_client = 'X'.
            clear lt_sel_opt_client.
            "Select all clients
          endif.
        when 'USER'.
          clear lv_total_user.
          lt_sel_opt_user = <ls_selection_parameter>-t_ranges.
          read table lt_sel_opt_user assigning <ls_sel_opt> index 1.
          if sy-subrc eq 0 and <ls_sel_opt>-sign ='I' and <ls_sel_opt>-option = 'EQ' and
          <ls_sel_opt>-low = c_total.
            lv_total_user = 'X'.
            clear lt_sel_opt_user. "Select all users
          endif.
        when 'DATE'.
          "Required field, can only be TODAY or YESTERDAY
          clear lv_date.
          lt_sel_opt_date = <ls_selection_parameter>-t_ranges.
          read table lt_sel_opt_date assigning <ls_sel_opt> index 1.
          if sy-subrc eq 0.
            if <ls_sel_opt>-low eq c_today.
              lv_date = sy-datum.
            elseif <ls_sel_opt>-low eq c_yesterday.
              lv_date = sy-datum - 1.
            endif.
          endif.

          if lv_date is initial.
            " Set error to export parameter RETURN_STATUS
            ls_return_status-call_id = <ls_selopt_para>-call_id.
            ls_return_status-status = 10.
            ls_return_status-msgtext = 'Incorrect date value: enter TODAY or YESTERDAY'. "#EC NOTEXT
            append ls_return_status to return_status.
            exit.
          endif.

        when others.

      endcase.

    endloop.

    " If parameter error ==> jomp to next CALL ID

    check lv_date is not initial.

    " Select data from table SNAP to read number of ABAP Dumps

    select * from snap into table lt_snap where mandt in lt_sel_opt_client and uname in lt_sel_opt_user and datum eq lv_date and seqno = '000'.

    " Collect result data for this CALL ID

    clear: lt_dump_stat.

    loop at lt_snap assigning <ls_snap>.

      if lv_total_client = 'X'.
        ls_dump_stat-client = c_total.
      else.
        ls_dump_stat-client = <ls_snap>-mandt.
      endif.

      if lv_total_user = 'X'.
        ls_dump_stat-uname = c_total.
      else.
        ls_dump_stat-uname = <ls_snap>-uname.
      endif.

      ls_dump_stat-datum = <ls_snap>-datum.
      ls_dump_stat-entry = 1.

      collect ls_dump_stat into lt_dump_stat.

    endloop.

" Build result table
    clear ls_result.
    ls_result-call_id = <ls_selopt_para>-call_id.

    loop at lt_dump_stat into ls_dump_stat.

      clear: ls_parameter, ls_result-result.

      ls_parameter-param = 'CLIENT'.
      ls_parameter-value = ls_dump_stat-client.

      append ls_parameter to ls_result-result-t_parameter.

      ls_parameter-param = 'USER'.
      ls_parameter-value = ls_dump_stat-uname.

      append ls_parameter to ls_result-result-t_parameter.

      ls_parameter-param = 'DATE'.
      ls_parameter-value = ls_dump_stat-datum.

      append ls_parameter to ls_result-result-t_parameter.

      ls_result-result-count = 1.
      ls_result-result-average = ls_result-result-sum = ls_result-result-min = ls_result-result-max = ls_dump_stat-entry.

      append ls_result to result.

    endloop.

  endloop. "End of loop over call_id

endfunction.
