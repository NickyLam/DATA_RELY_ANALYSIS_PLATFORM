: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_seal_acct_mgmt_jnl_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_seal_acct_mgmt_jnl_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,t1.oper_dt as oper_dt
,t1.oper_tm as oper_tm
,replace(replace(t1.brac_id,chr(13),''),chr(10),'') as brac_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.opered_acct_id,chr(13),''),chr(10),'') as opered_acct_id
,replace(replace(t1.opered_acct_name,chr(13),''),chr(10),'') as opered_acct_name
from ${iml_schema}.evt_seal_acct_mgmt_jnl_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_seal_acct_mgmt_jnl_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes