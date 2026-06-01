: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_agent_consmt_prod_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_agent_consmt_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.prod_fname,chr(13),''),chr(10),'') as prod_fname
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.consmt_bus_type_cd,chr(13),''),chr(10),'') as consmt_bus_type_cd
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.trustee_id,chr(13),''),chr(10),'') as trustee_id
,replace(replace(t1.mger_id,chr(13),''),chr(10),'') as mger_id
,replace(replace(t1.fund_mgr,chr(13),''),chr(10),'') as fund_mgr
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.coll_start_dt as coll_start_dt
,t1.coll_end_dt as coll_end_dt
,t1.found_dt as found_dt
,t1.end_dt as end_dt
,t1.value_dt as value_dt
,t1.int_closing_dt as int_closing_dt
,t1.prft_exp_dt as prft_exp_dt
,t1.actl_found_dt as actl_found_dt
,replace(replace(t1.sp_acct_id,chr(13),''),chr(10),'') as sp_acct_id
,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id
,replace(replace(t1.comm_fee_assign_acct_id,chr(13),''),chr(10),'') as comm_fee_assign_acct_id
,replace(replace(t1.mgmt_fee_assign_acct_id,chr(13),''),chr(10),'') as mgmt_fee_assign_acct_id
,replace(replace(t1.allow_chn_group_id,chr(13),''),chr(10),'') as allow_chn_group_id
,replace(replace(t1.allow_cust_group_id,chr(13),''),chr(10),'') as allow_cust_group_id
,replace(replace(t1.sell_rg_ctrl_flg,chr(13),''),chr(10),'') as sell_rg_ctrl_flg
,replace(replace(t1.lmt_ctrl_flg,chr(13),''),chr(10),'') as lmt_ctrl_flg
,replace(replace(t1.allow_divd_way_cd,chr(13),''),chr(10),'') as allow_divd_way_cd
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd
,replace(replace(t1.charge_type_cd,chr(13),''),chr(10),'') as charge_type_cd
,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'') as prod_attr_cd
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t1.estim_level_cd,chr(13),''),chr(10),'') as estim_level_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.tran_flg_cd,chr(13),''),chr(10),'') as tran_flg_cd
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t1.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t1.prft_curr_cd,chr(13),''),chr(10),'') as prft_curr_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.ctrl_flg_info,chr(13),''),chr(10),'') as ctrl_flg_info
,replace(replace(t1.bta_ctrl_flg_info,chr(13),''),chr(10),'') as bta_ctrl_flg_info
,t1.issue_price as issue_price
,t1.expe_yld_rat as expe_yld_rat
,t1.lowt_coll_amt as lowt_coll_amt
,t1.higt_coll_amt as higt_coll_amt
,t1.lowt_coll_lot as lowt_coll_lot
,t1.higt_coll_lot as higt_coll_lot
,t1.actl_coll_amt as actl_coll_amt
,t1.curr_coll_size as curr_coll_size
,t1.indv_fir_lowt_invest_amt as indv_fir_lowt_invest_amt
,t1.ped_days as ped_days
,t1.nv_days as nv_days
,t1.curr_tot_lot as curr_tot_lot
,t1.curr_acm_nv as curr_acm_nv
,t1.nv as nv
,t1.nv_dt as nv_dt
,t1.fac_val as fac_val
,replace(replace(t1.insure_prod_proj_type_cd,chr(13),''),chr(10),'') as insure_prod_proj_type_cd
,replace(replace(t1.dir_insure_cd,chr(13),''),chr(10),'') as dir_insure_cd
,t1.insure_return_days as insure_return_days
,t1.redem_cap_avl_days as redem_cap_avl_days
,replace(replace(t1.trustee_name,chr(13),''),chr(10),'') as trustee_name
,replace(replace(t1.mger_name,chr(13),''),chr(10),'') as mger_name
,replace(replace(t1.prod_tepla_comnt,chr(13),''),chr(10),'') as prod_tepla_comnt
,replace(replace(t1.ped_open_flg,chr(13),''),chr(10),'') as ped_open_flg
,replace(replace(t1.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd
,t1.acvmnt_base as acvmnt_base
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id
,replace(replace(t1.prod_sclass_cd,chr(13),''),chr(10),'') as prod_sclass_cd
,t1.next_open_start_dt as next_open_start_dt
,t1.next_open_end_dt as next_open_end_dt
,replace(replace(t1.supt_buy_way_cd,chr(13),''),chr(10),'') as supt_buy_way_cd
,t1.sale_fee_rat as sale_fee_rat
,t1.diff_price_fee_rat as diff_price_fee_rat
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
from ${icl_schema}.cmm_agent_consmt_prod_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_agent_consmt_prod_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes