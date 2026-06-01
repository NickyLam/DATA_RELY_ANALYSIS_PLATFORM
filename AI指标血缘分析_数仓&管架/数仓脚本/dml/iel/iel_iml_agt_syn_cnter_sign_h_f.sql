: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_syn_cnter_sign_h_f
CreateDate: 20250901
FileName:   ${iel_data_path}/agt_syn_cnter_sign_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
,replace(replace(t.sign_agt_cd,chr(13),''),chr(10),'') as sign_agt_cd
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,t.sign_dt as sign_dt
,replace(replace(t.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,t.rels_dt as rels_dt
,replace(replace(t.rels_org_id,chr(13),''),chr(10),'') as rels_org_id
,replace(replace(t.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t.rels_flow_num,chr(13),''),chr(10),'') as rels_flow_num
,replace(replace(t.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
,t.old_sign_dt as old_sign_dt
,replace(replace(t.chn_id,chr(13),''),chr(10),'') as chn_id
from iml.agt_syn_cnter_sign_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_syn_cnter_sign_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes