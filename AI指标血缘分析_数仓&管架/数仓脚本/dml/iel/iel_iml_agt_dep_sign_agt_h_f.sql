: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_sign_agt_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_sign_agt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.sign_agt_type_cd,chr(13),''),chr(10),'') as sign_agt_type_cd
,replace(replace(t1.agt_layered_flg,chr(13),''),chr(10),'') as agt_layered_flg
,replace(replace(t1.agt_key_type_cd,chr(13),''),chr(10),'') as agt_key_type_cd
,replace(replace(t1.agt_key,chr(13),''),chr(10),'') as agt_key
,t1.agt_amt as agt_amt
,replace(replace(t1.sign_main_prod_id,chr(13),''),chr(10),'') as sign_main_prod_id
,replace(replace(t1.sign_chn_id,chr(13),''),chr(10),'') as sign_chn_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,t1.agt_sign_dt as agt_sign_dt
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,t1.valid_dt as valid_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.sign_agt_status_cd,chr(13),''),chr(10),'') as sign_agt_status_cd
,replace(replace(t1.allow_clos_acct_flg,chr(13),''),chr(10),'') as allow_clos_acct_flg
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_abbr,chr(13),''),chr(10),'') as cust_abbr
,replace(replace(t1.sign_cntpty_acct_id,chr(13),''),chr(10),'') as sign_cntpty_acct_id
,replace(replace(t1.rels_org_id,chr(13),''),chr(10),'') as rels_org_id
,replace(replace(t1.rels_chn_id,chr(13),''),chr(10),'') as rels_chn_id
,t1.rels_dt as rels_dt
,replace(replace(t1.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,t1.tran_sign_dt as tran_sign_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_dep_sign_agt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_sign_agt_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes