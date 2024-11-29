*&---------------------------------------------------------------------*
*& Report  zlukoil_sm3_line_exists
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zlukoil_sm3_line_exists.

data: lt_track_imp          type standard table of /tmwflow/track_n,
      wa_track_imp          type /tmwflow/track_n,
      et_released           type /tmwflow/track_t,
      wa_released           type /tmwflow/track_s,
      lv_imported_count     type int4,
      lv_not_imported_count type int4,
      lv_runtime_start      type integer,
      lv_runtime_end        type integer,
      lv_tests_count        type int4.


data lt_track_imp_with_key type table of /tmwflow/track_n with non-unique sorted key sort_key components obj_name.


field-symbols <fs_track>         type /tmwflow/track_s.

data(lo_random) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                              min  = 1
                                              max = 500 ).

do 1000 times.

  wa_track_imp-sys_name = | A | && |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) } |.
  wa_track_imp-sys_type = "XYZ".
  wa_track_imp-sys_client = |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) }| &&  |{ lo_random->get_next( ) } |.
  wa_track_imp-obj_name = | A | && |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) } | && |XY| && |{ lo_random->get_next( ) }|.
  wa_track_imp-a_date = sy-datum + lo_random->get_next( ).
  wa_track_imp-a_time = sy-uzeit + lo_random->get_next( ).

  append wa_track_imp to lt_track_imp.

enddo.


do 500 times.

  wa_released-sys_name = | A | && |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) } |.
  wa_released-sys_client = |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) }| &&  |{ lo_random->get_next( ) } |.
  wa_released-obj_name = | A | && |{ lo_random->get_next( ) }| && |{ lo_random->get_next( ) } | && |XY| && |{ lo_random->get_next( ) }|.

  append wa_released to et_released.

enddo.

"cl_demo_output=>display( lt_track_imp ).
"cl_demo_output=>display( et_released ).

lv_tests_count = 1000.


get run time field lv_runtime_start.

lv_imported_count = 0.
lv_not_imported_count = 0.

do lv_tests_count times.

  loop at et_released assigning <fs_track>.


    read table lt_track_imp transporting no fields
      with key obj_name = <fs_track>-obj_name.
    if sy-subrc = 0. "Imported
      lv_imported_count = lv_imported_count + 1.
    else.
      lv_not_imported_count = lv_not_imported_count + 1.
    endif.

  endloop.

enddo.

get run time field lv_runtime_end.

new-line.
new-line.

write: |non-optimized test executions = | && |{ lv_tests_count }|.

new-line.

write: | lt_track_imp lines  = | && |{ lines( lt_track_imp ) }|.

new-line.

write: |non-optimized total processing time = | && |{ lv_runtime_end - lv_runtime_start }|.

new-line.

write: |non-optimized average processing time = | && |{ ( lv_runtime_end - lv_runtime_start ) / lv_tests_count }|.


get run time field lv_runtime_start.

lv_imported_count = 0.
lv_not_imported_count = 0.

do lv_tests_count times.

  loop at et_released assigning <fs_track>.


    if line_exists( lt_track_imp[ obj_name = <fs_track>-obj_name ] ).
      lv_imported_count = lv_imported_count + 1.
    else.
      lv_not_imported_count = lv_not_imported_count + 1.
    endif.


  endloop.

enddo.

get run time field lv_runtime_end.

new-line.
new-line.

write: |optimized with line_exists test executions = | && |{ lv_tests_count }|.

new-line.

write: |optimized with line_exists total processing time = | && |{ lv_runtime_end - lv_runtime_start }|.

new-line.

write: |optimized with line_exists average processing time = | && |{ ( lv_runtime_end - lv_runtime_start ) / lv_tests_count }|.



get run time field lv_runtime_start.

lv_imported_count = 0.
lv_not_imported_count = 0.


append lines of lt_track_imp to lt_track_imp_with_key.


do lv_tests_count times.

  loop at et_released assigning <fs_track>.

    read table lt_track_imp_with_key transporting no fields
         with table key sort_key  components obj_name = <fs_track>-obj_name.

    if sy-subrc = 0. "Imported
      lv_imported_count = lv_imported_count + 1.
    else.
      lv_not_imported_count = lv_not_imported_count + 1.
    endif.


  endloop.

enddo.

get run time field lv_runtime_end.

new-line.
new-line.

write: |optimized with secondary key test executions = | && |{ lv_tests_count }|.

new-line.

write: | lt_track_imp_with_key  = | && |{ lines( lt_track_imp_with_key ) }|.

new-line.

write: |optimized with secondary key total processing time = | && |{ lv_runtime_end - lv_runtime_start }|.

new-line.

write: |optimized with secondary key average processing time = | && |{ ( lv_runtime_end - lv_runtime_start ) / lv_tests_count }|.
