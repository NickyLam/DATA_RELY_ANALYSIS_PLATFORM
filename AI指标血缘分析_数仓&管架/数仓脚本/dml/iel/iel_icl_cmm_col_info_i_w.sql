: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_col_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_col_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t.col_type_id,chr(13),''),chr(10),'') as col_type_id
,replace(replace(t.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t.col_mgmt_id,chr(13),''),chr(10),'') as col_mgmt_id
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.prop_ps_id,chr(13),''),chr(10),'') as prop_ps_id
,replace(replace(t.prop_ps_name,chr(13),''),chr(10),'') as prop_ps_name
,replace(replace(t.com_prot_flg,chr(13),''),chr(10),'') as com_prot_flg
,t.asset_obg_lot as asset_obg_lot
,replace(replace(t.guar_effect_way_cd,chr(13),''),chr(10),'') as guar_effect_way_cd
,replace(replace(t.trast_insure_flg,chr(13),''),chr(10),'') as trast_insure_flg
,replace(replace(t.rgst_trast_status_cd,chr(13),''),chr(10),'') as rgst_trast_status_cd
,replace(replace(t.insure_trast_status_cd,chr(13),''),chr(10),'') as insure_trast_status_cd
,replace(replace(t.insto_status_cd,chr(13),''),chr(10),'') as insto_status_cd
,replace(replace(t.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
,replace(replace(t.espec_status_cd,chr(13),''),chr(10),'') as espec_status_cd
,replace(replace(t.wt_md_cash_ability_cd,chr(13),''),chr(10),'') as wt_md_cash_ability_cd
,replace(replace(t.np_cash_ability_cd,chr(13),''),chr(10),'') as np_cash_ability_cd
,replace(replace(t.obank_guar_flg,chr(13),''),chr(10),'') as obank_guar_flg
,replace(replace(t.gcust_flg,chr(13),''),chr(10),'') as gcust_flg
,replace(replace(t.estim_curr_cd,chr(13),''),chr(10),'') as estim_curr_cd
,t.estim_val as estim_val
,replace(replace(t.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,t.estim_dt as estim_dt
,replace(replace(t.estim_ps_name,chr(13),''),chr(10),'') as estim_ps_name
,t.estim_exp_dt as estim_exp_dt
,t.col_val as col_val
,t.hxb_cfm_val as hxb_cfm_val
,t.mtged_val as mtged_val
,t.right_rgst_dt as right_rgst_dt
,t.estim_idtfy_dt as estim_idtfy_dt
,t.hxb_pa_cfm_val as hxb_pa_cfm_val
,replace(replace(t.save_hxb_flg,chr(13),''),chr(10),'') as save_hxb_flg
,t.setup_dt as setup_dt
,t.check_guar_dt as check_guar_dt
,replace(replace(t.ctfer_name_1,chr(13),''),chr(10),'') as ctfer_name_1
,replace(replace(t.ctfer_name_2,chr(13),''),chr(10),'') as ctfer_name_2
,replace(replace(t.modif_emply_id,chr(13),''),chr(10),'') as modif_emply_id
,replace(replace(t.main_col_flg,chr(13),''),chr(10),'') as main_col_flg
,replace(replace(t.belong_cust_id,chr(13),''),chr(10),'') as belong_cust_id
,replace(replace(t.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t.rgst_org_name,chr(13),''),chr(10),'') as rgst_org_name
,t.enty_coll_dt as enty_coll_dt
,t.pm_rat as pm_rat
,t.higt_mtg_rat as higt_mtg_rat
,replace(replace(t.col_estim_curr_cd,chr(13),''),chr(10),'') as col_estim_curr_cd
,t.col_estim_val as col_estim_val
,replace(replace(t.col_store_addr,chr(13),''),chr(10),'') as col_store_addr
,replace(replace(t.col_belong_type_cd,chr(13),''),chr(10),'') as col_belong_type_cd
,replace(replace(t.estim_org_name,chr(13),''),chr(10),'') as estim_org_name
,replace(replace(t.estim_org_orgnz_cd,chr(13),''),chr(10),'') as estim_org_orgnz_cd
,replace(replace(t.estim_org_rgst_org_name,chr(13),''),chr(10),'') as estim_org_rgst_org_name
,replace(replace(t.pledgor_name,chr(13),''),chr(10),'') as pledgor_name
,replace(replace(t.pledgor_cert_type_cd,chr(13),''),chr(10),'') as pledgor_cert_type_cd
,replace(replace(t.pledgor_cert_no,chr(13),''),chr(10),'') as pledgor_cert_no
,replace(replace(t.belong_cert_type,chr(13),''),chr(10),'') as belong_cert_type
,replace(replace(t.belong_cert_no,chr(13),''),chr(10),'') as belong_cert_no
,replace(replace(t.belong_rgst_org,chr(13),''),chr(10),'') as belong_rgst_org
,replace(replace(t.wat_rgst_num,chr(13),''),chr(10),'') as wat_rgst_num
,replace(replace(t.wat_name,chr(13),''),chr(10),'') as wat_name
,replace(replace(t.rent_flg,chr(13),''),chr(10),'') as rent_flg
,replace(replace(t.guara_tentry,chr(13),''),chr(10),'') as guara_tentry
,t.rent_begin_dt as rent_begin_dt
,t.rent_exp_dt as rent_exp_dt
,replace(replace(t.rent_situ_descb,chr(13),''),chr(10),'') as rent_situ_descb
,t.rgst_exp_dt as rgst_exp_dt
,replace(replace(t.rgst_tenor,chr(13),''),chr(10),'') as rgst_tenor
,replace(replace(t.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,replace(replace(t.insto_entry_org_id,chr(13),''),chr(10),'') as insto_entry_org_id
,t.insto_entry_val as insto_entry_val
,replace(replace(t.insto_entry_curr_cd,chr(13),''),chr(10),'') as insto_entry_curr_cd
,t.insto_dt as insto_dt
,t.exp_dt as exp_dt
,replace(replace(t.dep_rcpt_vouch_id,chr(13),''),chr(10),'') as dep_rcpt_vouch_id
,replace(replace(t.hxb_dep_rcpt_flg,chr(13),''),chr(10),'') as hxb_dep_rcpt_flg
,t.dep_rcpt_effect_dt as dep_rcpt_effect_dt
,t.dep_rcpt_exp_dt as dep_rcpt_exp_dt
,replace(replace(t.dep_rcpt_term,chr(13),''),chr(10),'') as dep_rcpt_term
,t.dep_rcpt_term_days as dep_rcpt_term_days
,t.dep_rcpt_int_rat as dep_rcpt_int_rat
,replace(replace(t.dep_rcpt_curr_cd,chr(13),''),chr(10),'') as dep_rcpt_curr_cd
,t.dep_rcpt_aval_amt as dep_rcpt_aval_amt
,t.dep_rcpt_acct_bal as dep_rcpt_acct_bal
,t.estate_mon_prop_fee as estate_mon_prop_fee
,t.estate_arch_area as estate_arch_area
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
from ${icl_schema}.cmm_col_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_col_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes