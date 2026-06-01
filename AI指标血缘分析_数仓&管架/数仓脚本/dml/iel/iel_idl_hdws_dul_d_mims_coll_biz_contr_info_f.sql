: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_biz_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_biz_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.assoc_appl_id,chr(13),''),chr(10),'') as assoc_appl_id
,replace(replace(t1.crdt_contr_id,chr(13),''),chr(10),'') as crdt_contr_id
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.crdt_biz_breed_cd,chr(13),''),chr(10),'') as crdt_biz_breed_cd
,replace(replace(t1.loan_dir_indu_cd,chr(13),''),chr(10),'') as loan_dir_indu_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.ctr_amt as ctr_amt
,t1.loan_total_bal as loan_total_bal
,t1.ctr_eff_dt as ctr_eff_dt
,t1.ctr_expire_dt as ctr_expire_dt
,replace(replace(t1.loan_contr_guar_mode_cd,chr(13),''),chr(10),'') as loan_contr_guar_mode_cd
,t1.ctr_sign_dt as ctr_sign_dt
,t1.dd_loan_amt as dd_loan_amt
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,t1.int_off_bs_bal as int_off_bs_bal
,t1.int_on_bs_bal as int_on_bs_bal
,replace(replace(t1.ref_lmt_contr_flg,chr(13),''),chr(10),'') as ref_lmt_contr_flg
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.crdt_flow_typ_cd,chr(13),''),chr(10),'') as crdt_flow_typ_cd
,replace(replace(t1.ctr_txt_name,chr(13),''),chr(10),'') as ctr_txt_name
,t1.contr_due_dt as contr_due_dt
from ${idl_schema}.hdws_dul_d_mims_coll_biz_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_biz_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes