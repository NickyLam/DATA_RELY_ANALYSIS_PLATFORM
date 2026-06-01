: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_dbill_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_dbill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.assoc_loan_contr_id,chr(13),''),chr(10),'') as assoc_loan_contr_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,t1.loan_issue_dt as loan_issue_dt
,t1.due_dt as due_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.loan_biz_breed_cd,chr(13),''),chr(10),'') as loan_biz_breed_cd
,replace(replace(t1.crdt_rat_resu_cd,chr(13),''),chr(10),'') as crdt_rat_resu_cd
,t1.issue_amt as issue_amt
,t1.loan_total_bal as loan_total_bal
,t1.int_on_bs_bal as int_on_bs_bal
,t1.int_off_bs_bal as int_off_bs_bal
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_mims_coll_dbill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_dbill_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes