: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mpcs_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mpcs_agt_ln_ac_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.assoc_loan_contr_id,chr(13),''),chr(10),'') as assoc_loan_contr_id
,t1.issue_amt as issue_amt
,replace(replace(t1.pled_store_loc,chr(13),''),chr(10),'') as pled_store_loc
,replace(replace(t1.loan_issue_dt,chr(13),''),chr(10),'') as loan_issue_dt
,replace(replace(t1.operate,chr(13),''),chr(10),'') as operate
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
from ${idl_schema}.hdws_dul_d_mpcs_agt_ln_ac_base_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mpcs_agt_ln_ac_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes