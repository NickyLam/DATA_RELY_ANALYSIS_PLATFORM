: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_bcdl_tran_msg_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_bcdl_tran_msg.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,cust_id
,corp_work_dt
,corp_flow_num
,sign_id
,acct_num
,tran_cd
,sorc_sys_tran_timestamp from idl.rpt_evt_bcdl_tran_msg where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_bcdl_tran_msg.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes