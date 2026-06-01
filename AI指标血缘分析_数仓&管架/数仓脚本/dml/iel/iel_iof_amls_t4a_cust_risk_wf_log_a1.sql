: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amls_t4a_cust_risk_wf_log_a1
CreateDate: 20250113
FileName:   ${iel_data_path}/amls_t4a_cust_risk_wf_log.i.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt
,replace(replace(t1.rslt_id,chr(13),''),chr(10),'') as rslt_id
,t1.stat_dt as stat_dt
,replace(replace(t1.wf_seq,chr(13),''),chr(10),'') as wf_seq
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.curr_lvl,chr(13),''),chr(10),'') as curr_lvl
,replace(replace(t1.curr_node_id,chr(13),''),chr(10),'') as curr_node_id
,replace(replace(t1.curr_sts,chr(13),''),chr(10),'') as curr_sts
,replace(replace(t1.curr_post_id,chr(13),''),chr(10),'') as curr_post_id
,replace(replace(t1.curr_org_id,chr(13),''),chr(10),'') as curr_org_id
,replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t1.next_lvl,chr(13),''),chr(10),'') as next_lvl
,replace(replace(t1.next_node_id,chr(13),''),chr(10),'') as next_node_id
,replace(replace(t1.next_sts,chr(13),''),chr(10),'') as next_sts
,replace(replace(t1.next_post_id,chr(13),''),chr(10),'') as next_post_id
,replace(replace(t1.next_org_id,chr(13),''),chr(10),'') as next_org_id
,replace(replace(t1.opr_tm,chr(13),''),chr(10),'') as opr_tm
,replace(replace(t1.opr_user,chr(13),''),chr(10),'') as opr_user
,replace(replace(t1.advice,chr(13),''),chr(10),'') as advice
,replace(replace(t1.opr_id,chr(13),''),chr(10),'') as opr_id
from ${iol_schema}.amls_t4a_cust_risk_wf_log t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t4a_cust_risk_wf_log.i.${batch_date}.dat" \
        charset=utf8
        safe=yes