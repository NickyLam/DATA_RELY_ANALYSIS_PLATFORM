: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_loan_prod_info_h_f
CreateDate: 20240813
FileName:   ${iel_data_path}/prd_loan_prod_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.bus_breed_cd,chr(13),''),chr(10),'') as bus_breed_cd
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id
,replace(replace(t1.leaf_node_flg,chr(13),''),chr(10),'') as leaf_node_flg
,replace(replace(t1.mgmt_dept_id,chr(13),''),chr(10),'') as mgmt_dept_id
,replace(replace(t1.bus_dept_id,chr(13),''),chr(10),'') as bus_dept_id
,replace(replace(t1.exlus_prod_flg,chr(13),''),chr(10),'') as exlus_prod_flg
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg
,replace(replace(t1.allow_pkg_flg,chr(13),''),chr(10),'') as allow_pkg_flg
,replace(replace(t1.lmt_prod_flg,chr(13),''),chr(10),'') as lmt_prod_flg
,loan_mon_tenor
,replace(replace(t1.lmt_ocup_way_cd,chr(13),''),chr(10),'') as lmt_ocup_way_cd
,replace(replace(t1.lmt_rela_agt_flg,chr(13),''),chr(10),'') as lmt_rela_agt_flg
,replace(replace(t1.ocup_lmt_flg,chr(13),''),chr(10),'') as ocup_lmt_flg
,replace(replace(t1.lmt_ocup_comnt,chr(13),''),chr(10),'') as lmt_ocup_comnt
,replace(replace(t1.public_lmt_flg,chr(13),''),chr(10),'') as public_lmt_flg
,replace(replace(t1.lmt_uniq_flg,chr(13),''),chr(10),'') as lmt_uniq_flg
,replace(replace(t1.uniq_fit_range_cd,chr(13),''),chr(10),'') as uniq_fit_range_cd
,replace(replace(t1.fit_role_descb,chr(13),''),chr(10),'') as fit_role_descb
,replace(replace(t1.lmt_fit_prod_descb,chr(13),''),chr(10),'') as lmt_fit_prod_descb
,replace(replace(t1.circl_idf_flg,chr(13),''),chr(10),'') as circl_idf_flg
,replace(replace(t1.aval_curr_cd,chr(13),''),chr(10),'') as aval_curr_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.prod_descb,chr(13),''),chr(10),'') as prod_descb
,prod_effect_dt
,prod_invalid_dt
,replace(replace(t1.prod_belong_gen_cd,chr(13),''),chr(10),'') as prod_belong_gen_cd
,replace(replace(t1.base_claus_model_id,chr(13),''),chr(10),'') as base_claus_model_id
,replace(replace(t1.rela_claus_model_id,chr(13),''),chr(10),'') as rela_claus_model_id
,replace(replace(t1.noth_risk_bus_flg,chr(13),''),chr(10),'') as noth_risk_bus_flg
,replace(replace(t1.all_open_bus_flg,chr(13),''),chr(10),'') as all_open_bus_flg
,replace(replace(t1.allow_multi_out_acct_flg,chr(13),''),chr(10),'') as allow_multi_out_acct_flg
,replace(replace(t1.allow_adv_repay_flg,chr(13),''),chr(10),'') as allow_adv_repay_flg
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.allow_multi_distr_flg,chr(13),''),chr(10),'') as allow_multi_distr_flg
,replace(replace(t1.proc_cap_usage_check_flg,chr(13),''),chr(10),'') as proc_cap_usage_check_flg
,replace(replace(t1.lmt_ctrl_stage_cd,chr(13),''),chr(10),'') as lmt_ctrl_stage_cd
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.crdt_prod_cate_cd,chr(13),''),chr(10),'') as crdt_prod_cate_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.group_ctrl_flg,chr(13),''),chr(10),'') as group_ctrl_flg
,replace(replace(t1.prtcpt_single_cust_crdt_lmt_calc_flg,chr(13),''),chr(10),'') as prtcpt_single_cust_crdt_lmt_calc_flg

from ${iml_schema}.prd_loan_prod_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_loan_prod_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
