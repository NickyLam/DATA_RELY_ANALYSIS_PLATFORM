: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_wl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_wl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.prod_id
,t.lp_id
,t.loan_prod_id
,t.prod_cls_id
,t.cap_acct_id
,t.return_acct_id
,t.deflt_chn_id
,t.org_id
,t.prod_attr_cd
,t.user_group_id
,t.min_loan_tenor
,t.max_loan_tenor
,t.single_loan_lolmi_amt
,t.single_loan_uplmi_amt
,t.min_crdt_lmt
,t.max_crdt_lmt
,t.exec_uplmi_mon_int_rat
,t.exec_lolmi_mon_int_rat
,t.sp_check_ratio
,t.grace_days
,t.auto_apv_flg
,t.auto_distr_flg
,t.aval_status_flg
,t.sp_check_swi_flg
,t.loan_mode_cd
,t.tenor_type_cd
,t.int_rat_ped_cd
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.prd_wl t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_wl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes