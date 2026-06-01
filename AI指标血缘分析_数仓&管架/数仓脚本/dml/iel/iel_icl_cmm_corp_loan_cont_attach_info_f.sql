: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_cont_attach_info_f
CreateDate: 20221105
FileName:   ${iel_data_path}/cmm_corp_loan_cont_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.cont_name,chr(13),''),chr(10),'') as cont_name
    ,replace(replace(t.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
    ,t.margin_int_rat as margin_int_rat
    ,replace(replace(t.gover_crdt_supt_way_cd,chr(13),''),chr(10),'') as gover_crdt_supt_way_cd
    ,replace(replace(t.gover_crdt_type_cd,chr(13),''),chr(10),'') as gover_crdt_type_cd
    ,replace(replace(t.cdb_crdt_breed_cd,chr(13),''),chr(10),'') as cdb_crdt_breed_cd
    ,replace(replace(t.loan_char_cd,chr(13),''),chr(10),'') as loan_char_cd
    ,replace(replace(t.invest_char_cd,chr(13),''),chr(10),'') as invest_char_cd
    ,replace(replace(t.margin_int_rat_type_cd,chr(13),''),chr(10),'') as margin_int_rat_type_cd
    ,replace(replace(t.margin_int_accr_method_cd,chr(13),''),chr(10),'') as margin_int_accr_method_cd
    ,replace(replace(t.m_l_claus_exist_flg,chr(13),''),chr(10),'') as m_l_claus_exist_flg
    ,replace(replace(t.obank_open_flg,chr(13),''),chr(10),'') as obank_open_flg
    ,replace(replace(t.three_old_tf_or_city_update_proj_flg,chr(13),''),chr(10),'') as three_old_tf_or_city_update_proj_flg
    ,replace(replace(t.overs_loan_flg,chr(13),''),chr(10),'') as overs_loan_flg
    ,t.cont_begin_dt as cont_begin_dt
    ,t.cont_exp_dt as cont_exp_dt
    ,t.start_work_dt as start_work_dt
    ,replace(replace(t.batch_no,chr(13),''),chr(10),'') as batch_no
    ,replace(replace(t.plan_lics_id,chr(13),''),chr(10),'') as plan_lics_id
    ,replace(replace(t.arch_land_lics_id,chr(13),''),chr(10),'') as arch_land_lics_id
    ,replace(replace(t.envir_im_ass_lics_id,chr(13),''),chr(10),'') as envir_im_ass_lics_id
    ,replace(replace(t.cnstr_lics_id,chr(13),''),chr(10),'') as cnstr_lics_id
    ,replace(replace(t.other_lics_id,chr(13),''),chr(10),'') as other_lics_id
    ,replace(replace(t.ncds_num,chr(13),''),chr(10),'') as ncds_num
    ,replace(replace(t.margin_tran_out_acct_num,chr(13),''),chr(10),'') as margin_tran_out_acct_num
    ,replace(replace(t.bus_info_desc,chr(13),''),chr(10),'') as bus_info_desc
    ,replace(replace(t.back_info_descb,chr(13),''),chr(10),'') as back_info_descb
    ,replace(replace(t.cargo_name,chr(13),''),chr(10),'') as cargo_name
    ,t.cls_freq as cls_freq
    ,t.m_l_ratio as m_l_ratio
    ,replace(replace(t.proj_name,chr(13),''),chr(10),'') as proj_name
    ,t.proj_tot_invest as proj_tot_invest
    ,t.capital as capital
    ,replace(replace(t.setup_proj_batch_file,chr(13),''),chr(10),'') as setup_proj_batch_file
    ,replace(replace(t.other_lics,chr(13),''),chr(10),'') as other_lics
    ,replace(replace(t.ncds_abbr,chr(13),''),chr(10),'') as ncds_abbr
    ,replace(replace(t.margin_int_rat_level,chr(13),''),chr(10),'') as margin_int_rat_level
    ,replace(replace(t.land_use_cert_id,chr(13),''),chr(10),'') as land_use_cert_id
    ,t.land_use_cert_dt as land_use_cert_dt
    ,replace(replace(t.land_plan_lics_id,chr(13),''),chr(10),'') as land_plan_lics_id
    ,t.land_plan_lics_dt as land_plan_lics_dt
    ,t.cnstr_lics_dt as cnstr_lics_dt
    ,t.proj_plan_lics_dt as proj_plan_lics_dt
    ,replace(replace(t.buyer_name,chr(13),''),chr(10),'') as buyer_name
    ,replace(replace(t.seller_name,chr(13),''),chr(10),'') as seller_name
    ,replace(replace(t.trade_tran_content,chr(13),''),chr(10),'') as trade_tran_content
    ,t.stat_use_open_bal as stat_use_open_bal
    ,replace(replace(t.commer_inv_info_desc,chr(13),''),chr(10),'') as commer_inv_info_desc
    ,replace(replace(t.commer_inv_curr_cd,chr(13),''),chr(10),'') as commer_inv_curr_cd
    ,t.commer_inv_amt as commer_inv_amt
    ,replace(replace(t.commer_inv_kind_cd,chr(13),''),chr(10),'') as commer_inv_kind_cd
    ,replace(replace(t.era_pay_bank_cust_id,chr(13),''),chr(10),'') as era_pay_bank_cust_id
    ,replace(replace(t.adv_man_indu_flg,chr(13),''),chr(10),'') as adv_man_indu_flg
    ,replace(replace(t.spe_soph_unq_new_med_side_enter_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_med_side_enter_flg
    ,replace(replace(t.spe_soph_unq_new_lte_gnt_corp_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_lte_gnt_corp_flg
    ,replace(replace(t.cul_property_flg,chr(13),''),chr(10),'') as cul_property_flg
    ,replace(replace(t.indu_corp_tech_rem_ugd_flg,chr(13),''),chr(10),'') as indu_corp_tech_rem_ugd_flg
    ,replace(replace(t.strate_new_indus_flg,chr(13),''),chr(10),'') as strate_new_indus_flg
    ,replace(replace(t.strate_new_indus_type_cd,chr(13),''),chr(10),'') as strate_new_indus_type_cd
    ,replace(replace(t.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg
    ,replace(replace(t.sci_tech_corp_flg,chr(13),''),chr(10),'') as sci_tech_corp_flg
    ,replace(replace(t.sci_tech_inovt_corp_flg,chr(13),''),chr(10),'') as sci_tech_inovt_corp_flg
    ,replace(replace(t.proj_fin_flg,chr(13),''),chr(10),'') as proj_fin_flg
from icl.cmm_corp_loan_cont_attach_info t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_cont_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes