: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_cap_ib_lend_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_cap_ib_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.tran_acct_b_name,chr(13),''),chr(10),'') as tran_acct_b_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_cls_id,chr(13),''),chr(10),'') as cntpty_cls_id
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,t1.tran_dt as tran_dt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.tenor as tenor
,t1.exec_int_rat as exec_int_rat
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,t1.exp_amt as exp_amt
,t1.acru_int as acru_int
,t1.tran_fee as tran_fee
,t1.tran_tax as tran_tax
,t1.tran_comm as tran_comm
,t1.currt_bal as currt_bal
,t1.td_acru_int as td_acru_int
,t1.currt_acru_int as currt_acru_int
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.cfets_tran_flg,chr(13),''),chr(10),'') as cfets_tran_flg
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.tran_clear_acct_id,chr(13),''),chr(10),'') as tran_clear_acct_id
,replace(replace(t1.tran_clear_bank_no,chr(13),''),chr(10),'') as tran_clear_bank_no
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id
,replace(replace(t1.tran_breed_id,chr(13),''),chr(10),'') as tran_breed_id
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd
,replace(replace(t1.tran_clear_bank_name,chr(13),''),chr(10),'') as tran_clear_bank_name
from ${icl_schema}.cmm_cap_ib_lend t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_cap_ib_lend.f.${batch_date}.dat" \
        charset=utf8
        safe=yes