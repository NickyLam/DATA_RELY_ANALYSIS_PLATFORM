: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_lg_ctr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_lg_ctr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.lg_typ_cd,chr(13),''),chr(10),'') as lg_typ_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.lg_bal as lg_bal
,replace(replace(t1.adv_dbill_id,chr(13),''),chr(10),'') as adv_dbill_id
,replace(replace(t1.benef_name,chr(13),''),chr(10),'') as benef_name
,replace(replace(t1.benef_acct_num,chr(13),''),chr(10),'') as benef_acct_num
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,t1.margin_amt as margin_amt
,t1.marg_ratio as marg_ratio
,t1.start_dt as start_dt
,t1.due_dt as due_dt
,replace(replace(t1.lg_status,chr(13),''),chr(10),'') as lg_status
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.crdt_agt_id,chr(13),''),chr(10),'') as crdt_agt_id
from ${idl_schema}.hdws_dul_d_ccrm_agt_lg_ctr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_lg_ctr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes