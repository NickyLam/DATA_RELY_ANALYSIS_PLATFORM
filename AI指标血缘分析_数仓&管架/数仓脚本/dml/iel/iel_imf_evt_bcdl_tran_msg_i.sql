: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bcdl_tran_msg_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bcdl_tran_msg.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.corp_work_dt as corp_work_dt
,replace(replace(t1.corp_flow_num,chr(13),''),chr(10),'') as corp_flow_num
,replace(replace(t1.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,t1.sorc_sys_tran_timestamp as sorc_sys_tran_timestamp
from ${iml_schema}.evt_bcdl_tran_msg t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bcdl_tran_msg.i.${batch_date}.dat" \
        charset=utf8
        safe=yes