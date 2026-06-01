: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_finc_prod_basic_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_finc_prod_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id
,replace(replace(t1.sell_prod_id,chr(13),''),chr(10),'') as sell_prod_id
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr
,replace(replace(t1.prod_fname,chr(13),''),chr(10),'') as prod_fname
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id
,replace(replace(t1.prod_tepla_comnt,chr(13),''),chr(10),'') as prod_tepla_comnt
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd
,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'') as tran_caln_cd
,replace(replace(t1.coll_way_cd,chr(13),''),chr(10),'') as coll_way_cd
,replace(replace(t1.oper_mode_cd,chr(13),''),chr(10),'') as oper_mode_cd
,replace(replace(t1.entr_way_cd,chr(13),''),chr(10),'') as entr_way_cd
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id
,replace(replace(t1.trustee_id,chr(13),''),chr(10),'') as trustee_id
,replace(replace(t1.sell_org_id,chr(13),''),chr(10),'') as sell_org_id
,replace(replace(t1.sell_dept_id,chr(13),''),chr(10),'') as sell_dept_id
,coll_start_dt
,coll_end_dt
,prod_found_dt
,value_dt
,exp_dt
,actl_value_dt
,actl_exp_dt
,liqd_dt
,tenor
,replace(replace(t1.tenor_kind_cd,chr(13),''),chr(10),'') as tenor_kind_cd
,invest_ped_days
,prod_ped_days
,replace(replace(t1.subtn_flg,chr(13),''),chr(10),'') as subtn_flg
,replace(replace(t1.subtn_claus_descb,chr(13),''),chr(10),'') as subtn_claus_descb
,purch_cfm_tenor
,redem_cfm_tenor
,replace(replace(t1.inv_port_id,chr(13),''),chr(10),'') as inv_port_id
,replace(replace(t1.prod_rgst_code,chr(13),''),chr(10),'') as prod_rgst_code
,replace(replace(t1.cash_mgmt_flg,chr(13),''),chr(10),'') as cash_mgmt_flg
,replace(replace(t1.ped_prod_flg,chr(13),''),chr(10),'') as ped_prod_flg
,replace(replace(t1.open_flg,chr(13),''),chr(10),'') as open_flg
,replace(replace(t1.consmted_flg,chr(13),''),chr(10),'') as consmted_flg
,replace(replace(t1.redembl_flg,chr(13),''),chr(10),'') as redembl_flg
,replace(replace(t1.layered_flg,chr(13),''),chr(10),'') as layered_flg
,replace(replace(t1.layered_type_cd,chr(13),''),chr(10),'') as layered_type_cd
,replace(replace(t1.invest_char_cd,chr(13),''),chr(10),'') as invest_char_cd
,replace(replace(t1.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t1.sell_chn_cd_comb,chr(13),''),chr(10),'') as sell_chn_cd_comb
,replace(replace(t1.sell_rg_cd_comb,chr(13),''),chr(10),'') as sell_rg_cd_comb
,replace(replace(t1.sell_cust_type_cd_comb,chr(13),''),chr(10),'') as sell_cust_type_cd_comb
,replace(replace(t1.prod_mgr_id,chr(13),''),chr(10),'') as prod_mgr_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.pric_subj_id,chr(13),''),chr(10),'') as pric_subj_id
,replace(replace(t1.prft_adj_subj_id,chr(13),''),chr(10),'') as prft_adj_subj_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,curr_pric_bal
,currt_acru_prft
,expe_yld_rat
,sevn_aual_yld
,td_cust_yld_rat
,prod_fee_f_unit_nv
,prod_fee_post_corp_nv
,prod_acm_corp_nv
,prod_currt_nv
,replace(replace(t1.supt_buy_way_cd,chr(13),''),chr(10),'') as supt_buy_way_cd
,replace(replace(t1.indv_allow_buy_flg,chr(13),''),chr(10),'') as indv_allow_buy_flg
,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'') as ctrl_flg_comb
,prod_fee_bf_ten_thous_prft
,prod_fee_post_ten_thous_prft
,replace(replace(t1.prod_sclass_cd,chr(13),''),chr(10),'') as prod_sclass_cd
,sale_fee_rat
,diff_price_fee_rat
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id

from ${icl_schema}.cmm_finc_prod_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_finc_prod_basic_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
