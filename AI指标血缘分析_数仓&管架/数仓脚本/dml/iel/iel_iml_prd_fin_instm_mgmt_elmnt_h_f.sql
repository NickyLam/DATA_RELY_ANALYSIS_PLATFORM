: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fin_instm_mgmt_elmnt_h_f
CreateDate: 20240422
FileName:   ${iel_data_path}/prd_fin_instm_mgmt_elmnt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,cont_int_rat
,replace(replace(t1.spent_corp_name,chr(13),''),chr(10),'') as spent_corp_name
,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'') as indus_categy_cd
,replace(replace(t1.thol_flg,chr(13),''),chr(10),'') as thol_flg
,replace(replace(t1.gover_fin_plat_flg,chr(13),''),chr(10),'') as gover_fin_plat_flg
,replace(replace(t1.ind_fund_flg,chr(13),''),chr(10),'') as ind_fund_flg
,replace(replace(t1.ext_rating_cd,chr(13),''),chr(10),'') as ext_rating_cd
,replace(replace(t1.intnal_rating_cd,chr(13),''),chr(10),'') as intnal_rating_cd
,intnal_rating_exp_dt
,replace(replace(t1.spent_corp_prov_cd,chr(13),''),chr(10),'') as spent_corp_prov_cd
,replace(replace(t1.spent_corp_city_cd,chr(13),''),chr(10),'') as spent_corp_city_cd
,replace(replace(t1.dir_makti_debt_eqty_flg,chr(13),''),chr(10),'') as dir_makti_debt_eqty_flg
,replace(replace(t1.uder_asset_type_cd,chr(13),''),chr(10),'') as uder_asset_type_cd
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd
,replace(replace(t1.entr_loan_flg,chr(13),''),chr(10),'') as entr_loan_flg
,spv_vector_cnt
,replace(replace(t1.reply_num,chr(13),''),chr(10),'') as reply_num
,prod_tot_amt
,reply_amt
,risk_wt
,replace(replace(t1.multi_finer_flg,chr(13),''),chr(10),'') as multi_finer_flg
,replace(replace(t1.actl_finer_cust_id,chr(13),''),chr(10),'') as actl_finer_cust_id
,replace(replace(t1.actl_finer_cust_char_name,chr(13),''),chr(10),'') as actl_finer_cust_char_name
,replace(replace(t1.actl_finer_belong_group_name,chr(13),''),chr(10),'') as actl_finer_belong_group_name
,replace(replace(t1.crdt_proj_flg,chr(13),''),chr(10),'') as crdt_proj_flg
,replace(replace(t1.invest_prod_type_cd,chr(13),''),chr(10),'') as invest_prod_type_cd
,replace(replace(t1.dir_indus_subclass_cd,chr(13),''),chr(10),'') as dir_indus_subclass_cd
,replace(replace(t1.asset_supt_secu_flg,chr(13),''),chr(10),'') as asset_supt_secu_flg
,replace(replace(t1.noth_rating_abs_flg,chr(13),''),chr(10),'') as noth_rating_abs_flg
,replace(replace(t1.asset_secution_prod_flg,chr(13),''),chr(10),'') as asset_secution_prod_flg
,replace(replace(t1.abs_prod_flg,chr(13),''),chr(10),'') as abs_prod_flg
,dir_ind_fund_amt
,dir_makti_debt_eqty_amt
,dir_indus_pam_amt
,dir_attach_org_pam_amt
,replace(replace(t1.coll_way_cd,chr(13),''),chr(10),'') as coll_way_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.non_uder_asset_cls_cd,chr(13),''),chr(10),'') as non_uder_asset_cls_cd
,replace(replace(t1.non_uder_asset_sub_cls_cd,chr(13),''),chr(10),'') as non_uder_asset_sub_cls_cd
,replace(replace(t1.g31_prod_cls_cd,chr(13),''),chr(10),'') as g31_prod_cls_cd

from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fin_instm_mgmt_elmnt_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
