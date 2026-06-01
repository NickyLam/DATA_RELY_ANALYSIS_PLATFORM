: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_loan_prod_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_loan_prod_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.prod_name as prod_name
,t1.bus_breed_cd as bus_breed_cd
,t1.super_prod_id as super_prod_id
,t1.leaf_node_flg as leaf_node_flg
,t1.mgmt_dept_id as mgmt_dept_id
,t1.bus_dept_id as bus_dept_id
,t1.exlus_prod_flg as exlus_prod_flg
,t1.off_bs_flg as off_bs_flg
,t1.allow_pkg_flg as allow_pkg_flg
,t1.lmt_prod_flg as lmt_prod_flg
,t1.loan_mon_tenor as loan_mon_tenor
,t1.lmt_ocup_way_cd as lmt_ocup_way_cd
,t1.lmt_rela_agt_flg as lmt_rela_agt_flg
,t1.ocup_lmt_flg as ocup_lmt_flg
,t1.lmt_ocup_comnt as lmt_ocup_comnt
,t1.public_lmt_flg as public_lmt_flg
,t1.lmt_uniq_flg as lmt_uniq_flg
,t1.uniq_fit_range_cd as uniq_fit_range_cd
,t1.fit_role_descb as fit_role_descb
,t1.lmt_fit_prod_descb as lmt_fit_prod_descb
,t1.circl_idf_flg as circl_idf_flg
,t1.aval_curr_cd as aval_curr_cd
,t1.prod_status_cd as prod_status_cd
,t1.prod_descb as prod_descb
,t1.prod_effect_dt as prod_effect_dt
,t1.prod_invalid_dt as prod_invalid_dt
,t1.prod_belong_gen_cd as prod_belong_gen_cd
,t1.base_claus_model_id as base_claus_model_id
,t1.rela_claus_model_id as rela_claus_model_id
,t1.noth_risk_bus_flg as noth_risk_bus_flg
,t1.all_open_bus_flg as all_open_bus_flg
,t1.allow_multi_out_acct_flg as allow_multi_out_acct_flg
,t1.allow_adv_repay_flg as allow_adv_repay_flg
,t1.prod_type_cd as prod_type_cd
,t1.allow_multi_distr_flg as allow_multi_distr_flg
,t1.proc_cap_usage_check_flg as proc_cap_usage_check_flg
,t1.lmt_ctrl_stage_cd as lmt_ctrl_stage_cd
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.crdt_prod_cate_cd as crdt_prod_cate_cd
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.prod_id as prod_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_loan_prod_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_loan_prod_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
