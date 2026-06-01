: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_corp_loan_bus_cont_attach_info_f
CreateDate: 20250627
FileName:   ${iel_data_path}/cmm_corp_loan_bus_cont_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.cont_name,chr(13),''),chr(10),'') as cont_name
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,margin_int_rat
,replace(replace(t1.gover_crdt_flg,chr(13),''),chr(10),'') as gover_crdt_flg
,replace(replace(t1.gover_crdt_supt_way_cd,chr(13),''),chr(10),'') as gover_crdt_supt_way_cd
,replace(replace(t1.gover_crdt_type_cd,chr(13),''),chr(10),'') as gover_crdt_type_cd
,replace(replace(t1.cdb_crdt_breed_cd,chr(13),''),chr(10),'') as cdb_crdt_breed_cd
,replace(replace(t1.loan_char_cd,chr(13),''),chr(10),'') as loan_char_cd
,replace(replace(t1.invest_char_cd,chr(13),''),chr(10),'') as invest_char_cd
,replace(replace(t1.margin_int_rat_type_cd,chr(13),''),chr(10),'') as margin_int_rat_type_cd
,replace(replace(t1.margin_int_accr_method_cd,chr(13),''),chr(10),'') as margin_int_accr_method_cd
,replace(replace(t1.m_l_claus_exist_flg,chr(13),''),chr(10),'') as m_l_claus_exist_flg
,replace(replace(t1.obank_open_flg,chr(13),''),chr(10),'') as obank_open_flg
,replace(replace(t1.three_old_tf_or_city_update_proj_flg,chr(13),''),chr(10),'') as three_old_tf_or_city_update_proj_flg
,cont_begin_dt
,cont_exp_dt
,start_work_dt
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.plan_lics_id,chr(13),''),chr(10),'') as plan_lics_id
,replace(replace(t1.arch_land_lics_id,chr(13),''),chr(10),'') as arch_land_lics_id
,replace(replace(t1.envir_im_ass_lics_id,chr(13),''),chr(10),'') as envir_im_ass_lics_id
,replace(replace(t1.cnstr_lics_id,chr(13),''),chr(10),'') as cnstr_lics_id
,replace(replace(t1.other_lics_id,chr(13),''),chr(10),'') as other_lics_id
,replace(replace(t1.ncds_num,chr(13),''),chr(10),'') as ncds_num
,replace(replace(t1.margin_tran_out_acct_num,chr(13),''),chr(10),'') as margin_tran_out_acct_num
,replace(replace(t1.bus_info_desc,chr(13),''),chr(10),'') as bus_info_desc
,replace(replace(t1.back_info_descb,chr(13),''),chr(10),'') as back_info_descb
,replace(replace(t1.cargo_name,chr(13),''),chr(10),'') as cargo_name
,cls_freq
,m_l_ratio
,proj_tot_invest
,capital
,replace(replace(t1.setup_proj_batch_file,chr(13),''),chr(10),'') as setup_proj_batch_file
,replace(replace(t1.other_lics,chr(13),''),chr(10),'') as other_lics
,replace(replace(t1.ncds_abbr,chr(13),''),chr(10),'') as ncds_abbr
,replace(replace(t1.margin_int_rat_level,chr(13),''),chr(10),'') as margin_int_rat_level
,replace(replace(t1.land_use_cert_id,chr(13),''),chr(10),'') as land_use_cert_id
,land_use_cert_dt
,replace(replace(t1.land_plan_lics_id,chr(13),''),chr(10),'') as land_plan_lics_id
,land_plan_lics_dt
,cnstr_lics_dt
,proj_plan_lics_dt
,replace(replace(t1.buyer_name,chr(13),''),chr(10),'') as buyer_name
,replace(replace(t1.seller_name,chr(13),''),chr(10),'') as seller_name
,replace(replace(t1.trade_tran_content,chr(13),''),chr(10),'') as trade_tran_content
,stat_use_open_bal
,replace(replace(t1.commer_inv_info_desc,chr(13),''),chr(10),'') as commer_inv_info_desc
,replace(replace(t1.commer_inv_curr_cd,chr(13),''),chr(10),'') as commer_inv_curr_cd
,commer_inv_amt
,replace(replace(t1.commer_inv_kind_cd,chr(13),''),chr(10),'') as commer_inv_kind_cd
,replace(replace(t1.acct_recvbl_tran_way_cd,chr(13),''),chr(10),'') as acct_recvbl_tran_way_cd
,cont_bal
,tenor_days
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,oper_start_dt
,replace(replace(t1.adv_man_indu_flg,chr(13),''),chr(10),'') as adv_man_indu_flg
,replace(replace(t1.spe_soph_unq_new_med_side_enter_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_med_side_enter_flg
,replace(replace(t1.spe_soph_unq_new_lte_gnt_corp_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_lte_gnt_corp_flg
,replace(replace(t1.cul_property_flg,chr(13),''),chr(10),'') as cul_property_flg
,replace(replace(t1.indu_corp_tech_rem_ugd_flg,chr(13),''),chr(10),'') as indu_corp_tech_rem_ugd_flg
,replace(replace(t1.strate_new_indus_type_cd,chr(13),''),chr(10),'') as strate_new_indus_type_cd
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg
,replace(replace(t1.sci_tech_corp_flg,chr(13),''),chr(10),'') as sci_tech_corp_flg
,replace(replace(t1.sci_tech_inovt_corp_flg,chr(13),''),chr(10),'') as sci_tech_inovt_corp_flg
,replace(replace(t1.provi_for_aged_property_flg,chr(13),''),chr(10),'') as provi_for_aged_property_flg
,replace(replace(t1.ppp_proj_flg,chr(13),''),chr(10),'') as ppp_proj_flg
,replace(replace(t1.new_distr_flg,chr(13),''),chr(10),'') as new_distr_flg
,replace(replace(t1.cashflow_cover_bbal_flg,chr(13),''),chr(10),'') as cashflow_cover_bbal_flg
,replace(replace(t1.seed_loan_flg,chr(13),''),chr(10),'') as seed_loan_flg
,replace(replace(t1.county_loan_flg,chr(13),''),chr(10),'') as county_loan_flg
,replace(replace(t1.tran_asset_name,chr(13),''),chr(10),'') as tran_asset_name
,replace(replace(t1.abs_name,chr(13),''),chr(10),'') as abs_name
,replace(replace(t1.ocup_open_lmt_risk_type_cd,chr(13),''),chr(10),'') as ocup_open_lmt_risk_type_cd
,replace(replace(t1.buss_tiket_recs_flg,chr(13),''),chr(10),'') as buss_tiket_recs_flg
,replace(replace(t1.discnter_margin_acct_flg,chr(13),''),chr(10),'') as discnter_margin_acct_flg

from ${icl_schema}.cmm_corp_loan_bus_cont_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_bus_cont_attach_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
