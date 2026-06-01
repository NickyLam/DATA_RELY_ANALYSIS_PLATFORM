: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_col_info_f
CreateDate: 20240429
FileName:   ${iel_data_path}/cmm_col_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.col_type_id,chr(13),''),chr(10),'') as col_type_id
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.col_mgmt_id,chr(13),''),chr(10),'') as col_mgmt_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.com_prot_flg,chr(13),''),chr(10),'') as com_prot_flg
,asset_obg_lot
,replace(replace(t1.guar_effect_way_cd,chr(13),''),chr(10),'') as guar_effect_way_cd
,replace(replace(t1.trast_insure_flg,chr(13),''),chr(10),'') as trast_insure_flg
,replace(replace(t1.rgst_trast_status_cd,chr(13),''),chr(10),'') as rgst_trast_status_cd
,replace(replace(t1.insure_trast_status_cd,chr(13),''),chr(10),'') as insure_trast_status_cd
,replace(replace(t1.insto_status_cd,chr(13),''),chr(10),'') as insto_status_cd
,replace(replace(t1.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
,replace(replace(t1.espec_status_cd,chr(13),''),chr(10),'') as espec_status_cd
,replace(replace(t1.wt_md_cash_ability_cd,chr(13),''),chr(10),'') as wt_md_cash_ability_cd
,replace(replace(t1.np_cash_ability_cd,chr(13),''),chr(10),'') as np_cash_ability_cd
,replace(replace(t1.obank_guar_flg,chr(13),''),chr(10),'') as obank_guar_flg
,replace(replace(t1.gcust_flg,chr(13),''),chr(10),'') as gcust_flg
,replace(replace(t1.estim_curr_cd,chr(13),''),chr(10),'') as estim_curr_cd
,estim_val
,replace(replace(t1.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,estim_dt
,hxb_cfm_val
,estim_idtfy_dt
,hxb_pa_cfm_val
,replace(replace(t1.save_hxb_flg,chr(13),''),chr(10),'') as save_hxb_flg
,setup_dt
,replace(replace(t1.modif_emply_id,chr(13),''),chr(10),'') as modif_emply_id
,replace(replace(t1.main_col_flg,chr(13),''),chr(10),'') as main_col_flg
,replace(replace(t1.belong_cust_id,chr(13),''),chr(10),'') as belong_cust_id
,replace(replace(t1.insto_entry_org_id,chr(13),''),chr(10),'') as insto_entry_org_id
,insto_entry_val
,replace(replace(t1.insto_entry_curr_cd,chr(13),''),chr(10),'') as insto_entry_curr_cd
,exp_dt
,replace(replace(t1.dep_rcpt_vouch_id,chr(13),''),chr(10),'') as dep_rcpt_vouch_id
,dep_rcpt_effect_dt
,dep_rcpt_exp_dt
,replace(replace(t1.dep_rcpt_term,chr(13),''),chr(10),'') as dep_rcpt_term
,dep_rcpt_term_days
,dep_rcpt_int_rat
,replace(replace(t1.dep_rcpt_curr_cd,chr(13),''),chr(10),'') as dep_rcpt_curr_cd
,dep_rcpt_aval_amt
,dep_rcpt_acct_bal
,estate_mon_prop_fee
,estate_arch_area
,replace(replace(t1.hxb_dep_rcpt_flg,chr(13),''),chr(10),'') as hxb_dep_rcpt_flg
,replace(replace(t1.prop_ps_id,chr(13),''),chr(10),'') as prop_ps_id
,replace(replace(t1.prop_ps_name,chr(13),''),chr(10),'') as prop_ps_name
,prior_comp_weight_qtty
,replace(replace(t1.estim_ps_name,chr(13),''),chr(10),'') as estim_ps_name
,estim_exp_dt
,col_val
,mtged_val
,right_rgst_dt
,check_guar_dt
,replace(replace(t1.ctfer_name_1,chr(13),''),chr(10),'') as ctfer_name_1
,replace(replace(t1.ctfer_name_2,chr(13),''),chr(10),'') as ctfer_name_2
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.rgst_org_name,chr(13),''),chr(10),'') as rgst_org_name
,enty_coll_dt
,pm_rat
,higt_mtg_rat
,replace(replace(t1.col_estim_curr_cd,chr(13),''),chr(10),'') as col_estim_curr_cd
,col_estim_val
,replace(replace(t1.col_store_addr,chr(13),''),chr(10),'') as col_store_addr
,replace(replace(t1.col_belong_type_cd,chr(13),''),chr(10),'') as col_belong_type_cd
,replace(replace(t1.estim_org_name,chr(13),''),chr(10),'') as estim_org_name
,replace(replace(t1.estim_org_orgnz_cd,chr(13),''),chr(10),'') as estim_org_orgnz_cd
,replace(replace(t1.estim_org_rgst_org_name,chr(13),''),chr(10),'') as estim_org_rgst_org_name
,replace(replace(t1.pledgor_name,chr(13),''),chr(10),'') as pledgor_name
,replace(replace(t1.pledgor_cert_type_cd,chr(13),''),chr(10),'') as pledgor_cert_type_cd
,replace(replace(t1.pledgor_cert_no,chr(13),''),chr(10),'') as pledgor_cert_no
,replace(replace(t1.belong_cert_type,chr(13),''),chr(10),'') as belong_cert_type
,replace(replace(t1.belong_cert_no,chr(13),''),chr(10),'') as belong_cert_no
,replace(replace(t1.belong_rgst_org,chr(13),''),chr(10),'') as belong_rgst_org
,replace(replace(t1.wat_rgst_num,chr(13),''),chr(10),'') as wat_rgst_num
,replace(replace(t1.wat_name,chr(13),''),chr(10),'') as wat_name
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg
,replace(replace(t1.guara_tentry,chr(13),''),chr(10),'') as guara_tentry
,rent_begin_dt
,rent_exp_dt
,replace(replace(t1.rent_situ_descb,chr(13),''),chr(10),'') as rent_situ_descb
,rgst_exp_dt
,replace(replace(t1.rgst_tenor,chr(13),''),chr(10),'') as rgst_tenor
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,insto_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.fst_flg,chr(13),''),chr(10),'') as fst_flg
,replace(replace(t1.pmo_flg,chr(13),''),chr(10),'') as pmo_flg
,replace(replace(t1.col_modif_flg,chr(13),''),chr(10),'') as col_modif_flg

from ${icl_schema}.cmm_col_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_col_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
