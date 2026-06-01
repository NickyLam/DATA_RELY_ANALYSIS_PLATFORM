: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_bill_discount_info_f
CreateDate: 20251111
FileName:   ${iel_data_path}/cmm_bill_discount_info.f.${batch_date}.dat
IF_mark:    f
Logs:
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
,draw_dt
,exp_dt
,actl_exp_dt
,appl_dt
,bus_dt
,stl_dt
,repo_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,stl_amt
,repo_amt
,int_amt
,repo_int_amt
,discnt_int_rat
,currt_bal
,int_adj_bal
,td_acru_int
,currt_acru_int
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_cate_cd,chr(13),''),chr(10),'') as cntpty_cate_cd
,replace(replace(t1.cntpty_type_cd,chr(13),''),chr(10),'') as cntpty_type_cd
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
,replace(replace(t1.quot_way_cd,chr(13),''),chr(10),'') as quot_way_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,hold_days
,defer_days
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.lmt_status_cd,chr(13),''),chr(10),'') as lmt_status_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t1.exp_repo_agt_id,chr(13),''),chr(10),'') as exp_repo_agt_id
,replace(replace(t1.bill_cont_id,chr(13),''),chr(10),'') as bill_cont_id
,actl_repo_dt
,redem_int_rat
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.bf_cntpty_flg,chr(13),''),chr(10),'') as bf_cntpty_flg
,replace(replace(t1.bf_cntpty_name,chr(13),''),chr(10),'') as bf_cntpty_name
,replace(replace(t1.bf_cntpty_type_cd,chr(13),''),chr(10),'') as bf_cntpty_type_cd
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,discnt_dt
,replace(replace(t1.discnt_ps_unify_soci_crdt_cd_cert,chr(13),''),chr(10),'') as discnt_ps_unify_soci_crdt_cd_cert
,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'') as cntpty_org_id
,replace(replace(t1.discnt_ps_name,chr(13),''),chr(10),'') as discnt_ps_name
,replace(replace(t1.spd_pl_subj_id,chr(13),''),chr(10),'') as spd_pl_subj_id
,spd_pl
,replace(replace(t1.src_tran_dir_cd,chr(13),''),chr(10),'') as src_tran_dir_cd
,replace(replace(t1.fir_buy_src_cd,chr(13),''),chr(10),'') as fir_buy_src_cd
,replace(replace(t1.fir_cntpty_cust_id,chr(13),''),chr(10),'') as fir_cntpty_cust_id
,replace(replace(t1.fir_cntpty_name,chr(13),''),chr(10),'') as fir_cntpty_name
,replace(replace(t1.fir_cntpty_ibank_no,chr(13),''),chr(10),'') as fir_cntpty_ibank_no
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id

from ${icl_schema}.cmm_bill_discount_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_discount_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
