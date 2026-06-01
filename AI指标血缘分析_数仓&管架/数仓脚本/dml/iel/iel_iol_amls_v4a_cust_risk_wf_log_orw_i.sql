: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_v4a_cust_risk_wf_log_orw_i
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_v4a_cust_risk_wf_log_orw.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.opr_dt as opr_dt
,replace(replace(t1.opr_tm,chr(13),''),chr(10),'') as opr_tm
,replace(replace(t1.organkey,chr(13),''),chr(10),'') as organkey
,replace(replace(t1.opr_user,chr(13),''),chr(10),'') as opr_user
,replace(replace(t1.realname,chr(13),''),chr(10),'') as realname
,replace(replace(t1.curr_node_id,chr(13),''),chr(10),'') as curr_node_id
,replace(replace(t1.node_name,chr(13),''),chr(10),'') as node_name
,replace(replace(t1.wf_seq,chr(13),''),chr(10),'') as wf_seq
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.eft_flag,chr(13),''),chr(10),'') as eft_flag
,replace(replace(t1.serv_flag,chr(13),''),chr(10),'') as serv_flag
,replace(replace(t1.acct_flag,chr(13),''),chr(10),'') as acct_flag
,replace(replace(t1.ca_flag,chr(13),''),chr(10),'') as ca_flag
,replace(replace(t1.bd_flag,chr(13),''),chr(10),'') as bd_flag
from ${iol_schema}.amls_v4a_cust_risk_wf_log_orw t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_v4a_cust_risk_wf_log_orw.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes