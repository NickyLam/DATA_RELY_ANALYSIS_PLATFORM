: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_elec_chn_precon_tran_plan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_elec_chn_precon_tran_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.timing_task_id,chr(13),''),chr(10),'') as timing_task_id
,replace(replace(t1.timing_task_type_cd,chr(13),''),chr(10),'') as timing_task_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.timing_task_fomult_dt as timing_task_fomult_dt
,replace(replace(t1.timing_kind_cd,chr(13),''),chr(10),'') as timing_kind_cd
,replace(replace(t1.timing_freq_kind_cd,chr(13),''),chr(10),'') as timing_freq_kind_cd
,replace(replace(t1.timing_rule_descb,chr(13),''),chr(10),'') as timing_rule_descb
,replace(replace(t1.timing_task_status_cd,chr(13),''),chr(10),'') as timing_task_status_cd
,t1.timing_task_start_dt as timing_task_start_dt
,t1.timing_task_end_dt as timing_task_end_dt
,t1.timing_task_cancel_dt as timing_task_cancel_dt
,replace(replace(t1.payer_bank_no,chr(13),''),chr(10),'') as payer_bank_no
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_open_bank_num,chr(13),''),chr(10),'') as cntpty_acct_open_bank_num
,replace(replace(t1.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,replace(replace(t1.cntpty_acct_prov_cd,chr(13),''),chr(10),'') as cntpty_acct_prov_cd
,replace(replace(t1.cntpty_acct_city_cd,chr(13),''),chr(10),'') as cntpty_acct_city_cd
,replace(replace(t1.cntpty_acct_org_id,chr(13),''),chr(10),'') as cntpty_acct_org_id
,replace(replace(t1.cntpty_acct_org_name,chr(13),''),chr(10),'') as cntpty_acct_org_name
,replace(replace(t1.cntpty_acct_clear_bk_num,chr(13),''),chr(10),'') as cntpty_acct_clear_bk_num
,replace(replace(t1.cntpty_mobile_no,chr(13),''),chr(10),'') as cntpty_mobile_no
,t1.plan_exec_cnt as plan_exec_cnt
,t1.execed_cnt as execed_cnt
,t1.sucs_cnt as sucs_cnt
,t1.sucs_amt as sucs_amt
,t1.fail_cnt as fail_cnt
,t1.fail_amt as fail_amt
,t1.not_exec_cnt as not_exec_cnt
,replace(replace(t1.plan_src_cd,chr(13),''),chr(10),'') as plan_src_cd
from ${icl_schema}.cmm_elec_chn_precon_tran_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_elec_chn_precon_tran_plan.f.${batch_date}.dat" \
        charset=utf8
        safe=yes