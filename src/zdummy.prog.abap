*&---------------------------------------------------------------------*
*& Report  zdummy
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zdummy.


data  lv_job_count type btcjobcnt .

if sy-batch = ' ' .
  call function 'JOB_OPEN'
    exporting
      jobname  = 'ZALERT_DATA_SPTA1'
    importing
      jobcount = lv_job_count.

  submit ZALERT_DATA_SPTA
  via job 'ZALERT_DATA_SPTA1' number lv_job_count
  user 'KUZNETSOVAND'
  and return .

  call function 'JOB_CLOSE'
    exporting
      jobcount  = lv_job_count
      jobname   = 'ZALERT_DATA_SPTA1'
      sdlstrtdt = sy-datum
      sdlstrttm = sy-uzeit.

elseif sy-batch = 'X' .
*  place the program logic here ...
endif .
