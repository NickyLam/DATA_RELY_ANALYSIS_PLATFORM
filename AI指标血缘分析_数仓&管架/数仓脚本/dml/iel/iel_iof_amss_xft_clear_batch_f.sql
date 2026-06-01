: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amss_xft_clear_batch_f
CreateDate: 20250508
FileName:   ${iel_data_path}/amss_xft_clear_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.xft_batch_no,chr(13),''),chr(10),'') as xft_batch_no
,replace(replace(t1.file_name,chr(13),''),chr(10),'') as file_name
,clear_time
,replace(replace(t1.merch_num,chr(13),''),chr(10),'') as merch_num
,replace(replace(t1.merch_name,chr(13),''),chr(10),'') as merch_name
,total_cnt
,txn_total_amt
,succ_cnt
,succ_amt
,fail_cnt
,fail_amt
,bth_status
,replace(replace(t1.bth_status_msg,chr(13),''),chr(10),'') as bth_status_msg
,replace(replace(t1.chn_bat_seq_num,chr(13),''),chr(10),'') as chn_bat_seq_num
,replace(replace(t1.return_query_serial_no,chr(13),''),chr(10),'') as return_query_serial_no
,replace(replace(t1.ledger_file_name,chr(13),''),chr(10),'') as ledger_file_name
,valid_flag
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,replace(replace(t1.update_emp,chr(13),''),chr(10),'') as update_emp
,update_time
,clear_type

from ${iol_schema}.amss_xft_clear_batch t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_xft_clear_batch.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
