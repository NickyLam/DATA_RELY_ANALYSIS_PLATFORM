: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_liab_prod_comn_ctrl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_liab_prod_comn_ctrl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,replace(replace(t.acct_cls_attr_cd,chr(13),''),chr(10),'') as acct_cls_attr_cd
,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.ctrl_curr_cd,chr(13),''),chr(10),'') as ctrl_curr_cd
,replace(replace(t.stl_acct_flg,chr(13),''),chr(10),'') as stl_acct_flg
,t.init_amt as init_amt
,t.incremt_amt as incremt_amt
,t.acct_retnd_max_bal as acct_retnd_max_bal
,t.acct_retnd_min_bal as acct_retnd_min_bal
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_liab_prod_comn_ctrl_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_liab_prod_comn_ctrl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes