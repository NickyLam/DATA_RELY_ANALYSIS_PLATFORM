: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_cust_sign_prod_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_cust_sign_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t1.sign_org_name,chr(13),''),chr(10),'') as sign_org_name
,replace(replace(t1.sign_prod_type_cd,chr(13),''),chr(10),'') as sign_prod_type_cd
,replace(replace(t1.sign_prod_status_cd,chr(13),''),chr(10),'') as sign_prod_status_cd
,t1.sign_dt as sign_dt
,t1.rels_dt as rels_dt
,replace(replace(t1.rels_org_id,chr(13),''),chr(10),'') as rels_org_id
,replace(replace(t1.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t1.rels_org_name,chr(13),''),chr(10),'') as rels_org_name
,replace(replace(t1.sign_mobile_no,chr(13),''),chr(10),'') as sign_mobile_no
,replace(replace(t1.sign_chn_id,chr(13),''),chr(10),'') as sign_chn_id
from ${icl_schema}.cmm_cust_sign_prod_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_cust_sign_prod_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes