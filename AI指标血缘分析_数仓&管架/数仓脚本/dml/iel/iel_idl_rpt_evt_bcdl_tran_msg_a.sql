: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_bcdl_tran_msg_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_bcdl_tran_msg.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,t.corp_work_dt as corp_work_dt
    ,replace(replace(t.corp_flow_num,chr(13),''),chr(10),'') as corp_flow_num
    ,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
    ,replace(replace(t.acct_num,chr(13),''),chr(10),'') as acct_num
    ,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
    ,t.sorc_sys_tran_timestamp as sorc_sys_tran_timestamp
from iml.evt_bcdl_tran_msg t
  where to_char(t.corp_work_dt,'yyyymmdd') in ('20200910','20200303','20191109','20191108','20191009','20191008') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_bcdl_tran_msg.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes