: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_bill_redcst_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_bill_redcst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.bill_prod_id,chr(13),''),chr(10),'') as bill_prod_id
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
,t1.draw_dt as draw_dt
,t1.exp_dt as exp_dt
,t1.actl_exp_dt as actl_exp_dt
,t1.appl_dt as appl_dt
,t1.stl_dt as stl_dt
,t1.repo_dt as repo_dt
,t1.bag_dt as bag_dt
,t1.bag_tm as bag_tm
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.fac_val_amt as fac_val_amt
,t1.stl_amt as stl_amt
,t1.repo_amt as repo_amt
,t1.int_amt as int_amt
,t1.discnt_int_rat as discnt_int_rat
,t1.currt_bal as currt_bal
,t1.int_adj_bal as int_adj_bal
,t1.td_acru_int as td_acru_int
,t1.currt_acru_int as currt_acru_int
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_cate_cd,chr(13),''),chr(10),'') as cntpty_cate_cd
,replace(replace(t1.cntpty_type_cd,chr(13),''),chr(10),'') as cntpty_type_cd
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.discount_bill_flg,chr(13),''),chr(10),'') as discount_bill_flg
,replace(replace(t1.remote_bill_flg,chr(13),''),chr(10),'') as remote_bill_flg
,replace(replace(t1.acrd_policy_flg,chr(13),''),chr(10),'') as acrd_policy_flg
,replace(replace(t1.refuse_flg,chr(13),''),chr(10),'') as refuse_flg
,t1.hold_days as hold_days
,t1.defer_days as defer_days
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.lmt_status_cd,chr(13),''),chr(10),'') as lmt_status_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.recver_org_id,chr(13),''),chr(10),'') as recver_org_id
,replace(replace(t1.recver_trust_acct_num,chr(13),''),chr(10),'') as recver_trust_acct_num
,replace(replace(t1.recver_trust_acct_name,chr(13),''),chr(10),'') as recver_trust_acct_name
,replace(replace(t1.recver_bank_no,chr(13),''),chr(10),'') as recver_bank_no
,replace(replace(t1.recver_bank_name,chr(13),''),chr(10),'') as recver_bank_name
,replace(replace(t1.payer_org_id,chr(13),''),chr(10),'') as payer_org_id
,replace(replace(t1.payer_trust_acct_num,chr(13),''),chr(10),'') as payer_trust_acct_num
,replace(replace(t1.payer_trust_acct_name,chr(13),''),chr(10),'') as payer_trust_acct_name
,replace(replace(t1.payer_bank_no,chr(13),''),chr(10),'') as payer_bank_no
,replace(replace(t1.payer_bank_name,chr(13),''),chr(10),'') as payer_bank_name
,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,t1.bus_dt as bus_dt
,replace(replace(t1.batch_no_code,chr(13),''),chr(10),'') as batch_no_code
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
from ${icl_schema}.cmm_bill_redcst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_redcst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes