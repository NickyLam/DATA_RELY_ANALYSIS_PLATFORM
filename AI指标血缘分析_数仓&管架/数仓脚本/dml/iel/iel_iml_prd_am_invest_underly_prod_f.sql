: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_invest_underly_prod_f
CreateDate: 20240606
FileName:   ${iel_data_path}/prd_am_invest_underly_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr
,replace(replace(t1.prod_fname,chr(13),''),chr(10),'') as prod_fname
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd
,replace(replace(t1.coupon_breed_cd,chr(13),''),chr(10),'') as coupon_breed_cd
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id
,issue_price
,issue_size
,replace(replace(t1.issue_curr_cd,chr(13),''),chr(10),'') as issue_curr_cd
,replace(replace(t1.overs_flg,chr(13),''),chr(10),'') as overs_flg
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'') as tran_caln_cd
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id
,replace(replace(t1.trustee_id,chr(13),''),chr(10),'') as trustee_id
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.mger_id,chr(13),''),chr(10),'') as mger_id
,replace(replace(t1.finer_id,chr(13),''),chr(10),'') as finer_id
,issue_dt
,value_dt
,exp_dt
,prod_tenor
,actl_exp_dt
,replace(replace(t1.subtn_flg,chr(13),''),chr(10),'') as subtn_flg
,replace(replace(t1.subtn_claus,chr(13),''),chr(10),'') as subtn_claus
,replace(replace(t1.contn_weight_flg,chr(13),''),chr(10),'') as contn_weight_flg
,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg
,replace(replace(t1.rgst_trust_org_cd,chr(13),''),chr(10),'') as rgst_trust_org_cd
,replace(replace(t1.fin_inst_issue_flg,chr(13),''),chr(10),'') as fin_inst_issue_flg
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,purch_cfm_tenor
,redem_cfm_tenor
,replace(replace(t1.sub_debt_flg,chr(13),''),chr(10),'') as sub_debt_flg
,replace(replace(t1.invest_char_type_cd,chr(13),''),chr(10),'') as invest_char_type_cd
,fac_val
,replace(replace(t1.city_bond_flg,chr(13),''),chr(10),'') as city_bond_flg
,replace(replace(t1.city_bond_lev_cd,chr(13),''),chr(10),'') as city_bond_lev_cd
,init_create_tm
,init_update_tm
,replace(replace(t1.asset_src_cd,chr(13),''),chr(10),'') as asset_src_cd
,replace(replace(t1.distr_brch_id,chr(13),''),chr(10),'') as distr_brch_id
,replace(replace(t1.clear_ped_cd,chr(13),''),chr(10),'') as clear_ped_cd
,replace(replace(t1.proj_dir_indus_categy_cd,chr(13),''),chr(10),'') as proj_dir_indus_categy_cd
,replace(replace(t1.proj_dir_indus_gen_cd,chr(13),''),chr(10),'') as proj_dir_indus_gen_cd
,replace(replace(t1.actl_crdt_main_id,chr(13),''),chr(10),'') as actl_crdt_main_id
,replace(replace(t1.ped_days,chr(13),''),chr(10),'') as ped_days
,replace(replace(t1.am_plan_type_cd,chr(13),''),chr(10),'') as am_plan_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,create_dt
,update_dt

from ${iml_schema}.prd_am_invest_underly_prod t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_invest_underly_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
