: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_agent_consmt_prod_info_a
CreateDate: 20220110
FileName:   ${iel_data_path}/cmm_agent_consmt_prod_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.prod_fname,chr(13),''),chr(10),'') as prod_fname
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.consmt_bus_type_cd,chr(13),''),chr(10),'') as consmt_bus_type_cd
,replace(replace(t.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t.trustee_id,chr(13),''),chr(10),'') as trustee_id
,replace(replace(t.mger_id,chr(13),''),chr(10),'') as mger_id
,replace(replace(t.fund_mgr,chr(13),''),chr(10),'') as fund_mgr
,replace(replace(t.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,t.coll_start_dt as coll_start_dt
,t.coll_end_dt as coll_end_dt
,t.found_dt as found_dt
,t.end_dt as end_dt
,t.value_dt as value_dt
,t.int_closing_dt as int_closing_dt
,t.prft_exp_dt as prft_exp_dt
,t.actl_found_dt as actl_found_dt
,replace(replace(t.sp_acct_id,chr(13),''),chr(10),'') as sp_acct_id
,replace(replace(t.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id
,replace(replace(t.comm_fee_assign_acct_id,chr(13),''),chr(10),'') as comm_fee_assign_acct_id
,replace(replace(t.mgmt_fee_assign_acct_id,chr(13),''),chr(10),'') as mgmt_fee_assign_acct_id
,replace(replace(t.allow_chn_group_id,chr(13),''),chr(10),'') as allow_chn_group_id
,replace(replace(t.allow_cust_group_id,chr(13),''),chr(10),'') as allow_cust_group_id
,replace(replace(t.sell_rg_ctrl_flg,chr(13),''),chr(10),'') as sell_rg_ctrl_flg
,replace(replace(t.lmt_ctrl_flg,chr(13),''),chr(10),'') as lmt_ctrl_flg
,replace(replace(t.allow_divd_way_cd,chr(13),''),chr(10),'') as allow_divd_way_cd
,replace(replace(t.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd
,replace(replace(t.charge_type_cd,chr(13),''),chr(10),'') as charge_type_cd
,replace(replace(t.prod_attr_cd,chr(13),''),chr(10),'') as prod_attr_cd
,replace(replace(t.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t.estim_level_cd,chr(13),''),chr(10),'') as estim_level_cd
,replace(replace(t.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t.tran_flg_cd,chr(13),''),chr(10),'') as tran_flg_cd
,replace(replace(t.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t.prft_curr_cd,chr(13),''),chr(10),'') as prft_curr_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.ctrl_flg_info,chr(13),''),chr(10),'') as ctrl_flg_info
,replace(replace(t.bta_ctrl_flg_info,chr(13),''),chr(10),'') as bta_ctrl_flg_info
,t.issue_price as issue_price
,t.expe_yld_rat as expe_yld_rat
,t.lowt_coll_amt as lowt_coll_amt
,t.higt_coll_amt as higt_coll_amt
,t.lowt_coll_lot as lowt_coll_lot
,t.higt_coll_lot as higt_coll_lot
,t.actl_coll_amt as actl_coll_amt
,t.curr_coll_size as curr_coll_size
,t.indv_fir_lowt_invest_amt as indv_fir_lowt_invest_amt
,t.ped_days as ped_days
,t.nv_days as nv_days
,t.curr_tot_lot as curr_tot_lot
,t.curr_acm_nv as curr_acm_nv
,t.nv as nv
,t.nv_dt as nv_dt
,t.fac_val as fac_val
,replace(replace(t.insure_prod_proj_type_cd,chr(13),''),chr(10),'') as insure_prod_proj_type_cd
,replace(replace(t.dir_insure_cd,chr(13),''),chr(10),'') as dir_insure_cd
,t.insure_return_days as insure_return_days
,t.redem_cap_avl_days as redem_cap_avl_days
,replace(replace(t.trustee_name,chr(13),''),chr(10),'') as trustee_name
,replace(replace(t.mger_name,chr(13),''),chr(10),'') as mger_name
,replace(replace(t.prod_tepla_comnt,chr(13),''),chr(10),'') as prod_tepla_comnt
,replace(replace(t.ped_open_flg,chr(13),''),chr(10),'') as ped_open_flg
,replace(replace(t.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd
,replace(replace(t.acvmnt_base,chr(13),''),chr(10),'') as acvmnt_base
from icl.cmm_agent_consmt_prod_info t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_agent_consmt_prod_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes