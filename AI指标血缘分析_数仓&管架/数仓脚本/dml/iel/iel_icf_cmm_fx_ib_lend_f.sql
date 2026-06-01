: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_fx_ib_lend_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_fx_ib_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.portf_class_name,chr(13),''),chr(10),'') as portf_class_name
,replace(replace(t1.inv_port_status_cd,chr(13),''),chr(10),'') as inv_port_status_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'') as tran_aim_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'') as tran_mode_cd
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,replace(replace(t1.ib_lend_type_cd,chr(13),''),chr(10),'') as ib_lend_type_cd
,replace(replace(t1.clear_org_cd,chr(13),''),chr(10),'') as clear_org_cd
,input_dt
,tran_dt
,value_dt
,exp_dt
,tenor
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,int_rat_float_point
,replace(replace(t1.int_rat_tenor_cd,chr(13),''),chr(10),'') as int_rat_tenor_cd
,exec_int_rat
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,exp_amt
,usd_tran_amt
,acru_int
,currt_bal
,td_acru_int
,currt_acru_int
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,fir_pay_int_dt
,replace(replace(t1.pay_stub_proc_way_cd,chr(13),''),chr(10),'') as pay_stub_proc_way_cd
,replace(replace(t1.bag_status_cd,chr(13),''),chr(10),'') as bag_status_cd
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id
,replace(replace(t1.int_rat_adj_freq_cd,chr(13),''),chr(10),'') as int_rat_adj_freq_cd
,base_rat
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,bond_fac_val
,replace(replace(t1.bond_curr,chr(13),''),chr(10),'') as bond_curr
,inpwn_ratio
,replace(replace(t1.inpwn_way_cd,chr(13),''),chr(10),'') as inpwn_way_cd
,replace(replace(t1.ghb_clear_acct_id,chr(13),''),chr(10),'') as ghb_clear_acct_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.inpwn_amt,chr(13),''),chr(10),'') as inpwn_amt

from ${icl_schema}.cmm_fx_ib_lend t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_fx_ib_lend.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
