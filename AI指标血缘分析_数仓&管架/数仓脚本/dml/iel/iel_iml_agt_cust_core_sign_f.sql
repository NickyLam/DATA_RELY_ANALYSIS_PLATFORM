: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cust_core_sign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_core_sign.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.sign_agt_type_cd,chr(13),''),chr(10),'') as sign_agt_type_cd
,replace(replace(t.sign_main_type_cd,chr(13),''),chr(10),'') as sign_main_type_cd
,replace(replace(t.sign_main_id,chr(13),''),chr(10),'') as sign_main_id
,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,t.sign_dt as sign_dt
,replace(replace(t.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,t.rels_dt as rels_dt
,replace(replace(t.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t.rels_flow_num,chr(13),''),chr(10),'') as rels_flow_num
,t.agt_amt as agt_amt
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,t.auto_redt_cnt as auto_redt_cnt
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_cust_core_sign t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_core_sign.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes