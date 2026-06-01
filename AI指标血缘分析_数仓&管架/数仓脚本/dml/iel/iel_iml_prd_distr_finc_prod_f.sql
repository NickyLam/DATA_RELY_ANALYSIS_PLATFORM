: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_distr_finc_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_distr_finc_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id 
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id 
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name 
,replace(replace(t1.prod_alias,chr(13),''),chr(10),'') as prod_alias 
,replace(replace(t1.prod_belong_cate_cd,chr(13),''),chr(10),'') as prod_belong_cate_cd 
,replace(replace(t1.bus_cate_cd,chr(13),''),chr(10),'') as bus_cate_cd 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd 
,replace(replace(t1.prod_sponsor_id,chr(13),''),chr(10),'') as prod_sponsor_id 
,replace(replace(t1.prod_trustee_cd,chr(13),''),chr(10),'') as prod_trustee_cd 
,replace(replace(t1.mger_cd,chr(13),''),chr(10),'') as mger_cd 
,replace(replace(t1.allow_divd_way_cd,chr(13),''),chr(10),'') as allow_divd_way_cd 
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd 
,replace(replace(t1.coll_term_acct_mode_cd,chr(13),''),chr(10),'') as coll_term_acct_mode_cd 
,replace(replace(t1.open_term_acct_mode_cd,chr(13),''),chr(10),'') as open_term_acct_mode_cd 
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd 
,replace(replace(t1.subscr_export_way_cd,chr(13),''),chr(10),'') as subscr_export_way_cd 
,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd 
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd 
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd 
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd 
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd 
,t1.prod_nv as prod_nv 
,t1.nv_dt as nv_dt 
,t1.nv_days as nv_days 
,t1.prod_fac_val as prod_fac_val 
,t1.issue_price as issue_price 
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id 
,t1.coll_start_dt as coll_start_dt 
,t1.coll_end_dt as coll_end_dt 
,t1.prod_found_dt as prod_found_dt 
,t1.prod_value_dt as prod_value_dt 
,t1.prod_end_dt as prod_end_dt 
,t1.int_exp_dt as int_exp_dt 
,t1.prft_exp_dt as prft_exp_dt 
,t1.coll_fail_dt as coll_fail_dt 
,t1.aft_coll_close_exp_dt as aft_coll_close_exp_dt 
,t1.actl_found_dt as actl_found_dt 
,t1.prod_lowt_coll_amt as prod_lowt_coll_amt 
,t1.prod_higt_coll_amt as prod_higt_coll_amt 
,t1.prod_lowt_coll_lot as prod_lowt_coll_lot 
,t1.prod_higt_coll_lot as prod_higt_coll_lot 
,t1.prod_actl_coll_amt as prod_actl_coll_amt 
,t1.curr_lot as curr_lot 
,replace(replace(t1.sell_rg_ctrl_flg,chr(13),''),chr(10),'') as sell_rg_ctrl_flg 
,replace(replace(t1.lmt_ctrl_flg,chr(13),''),chr(10),'') as lmt_ctrl_flg 
,replace(replace(t1.tepla_flg,chr(13),''),chr(10),'') as tepla_flg 
,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'') as ctrl_flg_comb 
,replace(replace(t1.bta_ctrl_flg_comb,chr(13),''),chr(10),'') as bta_ctrl_flg_comb 
,t1.cfm_ratio as cfm_ratio 
,replace(replace(t1.out_charge_flg,chr(13),''),chr(10),'') as out_charge_flg 
,t1.prod_curr_tot_lot as prod_curr_tot_lot 
,t1.prod_acm_nv as prod_acm_nv 
,t1.indv_min_buy_corp as indv_min_buy_corp 
,t1.indv_fir_lowt_invest_amt as indv_fir_lowt_invest_amt 
,t1.indv_supp_lowt_invest_amt as indv_supp_lowt_invest_amt 
,t1.indv_lowt_aip_amt as indv_lowt_aip_amt 
,t1.indv_lowt_hold_lot as indv_lowt_hold_lot 
,t1.indv_sig_max_buy_amt as indv_sig_max_buy_amt 
,t1.indv_single_amax_bamt as indv_single_amax_bamt 
,t1.org_min_buy_corp as org_min_buy_corp 
,t1.org_fir_lowt_invest_amt as org_fir_lowt_invest_amt 
,t1.org_supp_lowt_invest_amt as org_supp_lowt_invest_amt 
,t1.org_lowt_aip_amt as org_lowt_aip_amt 
,t1.org_lowt_hold_lot as org_lowt_hold_lot 
,t1.org_sig_max_buy_amt as org_sig_max_buy_amt 
,t1.org_single_amax_bamt as org_single_amax_bamt 
,t1.acm_corp_divd as acm_corp_divd 
,t1.clear_post_days as clear_post_days 
,t1.expe_yld_rat as expe_yld_rat 
,t1.ped_days as ped_days 
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_distr_finc_prod t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_distr_finc_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes