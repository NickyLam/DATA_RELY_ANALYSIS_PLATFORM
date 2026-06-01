: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_acct_payoff_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_acct_payoff_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.acct_sub_acct_id,chr(13),''),chr(10),'') as acct_sub_acct_id
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.payoff_way_cd,chr(13),''),chr(10),'') as payoff_way_cd
,replace(replace(t.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
from ${iml_schema}.evt_corp_acct_payoff_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_acct_payoff_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes