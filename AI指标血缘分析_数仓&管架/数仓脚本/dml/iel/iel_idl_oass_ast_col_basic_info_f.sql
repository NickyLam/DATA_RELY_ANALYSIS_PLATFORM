: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_basic_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.col_type_id as col_type_id
,t1.col_mgmt_id as col_mgmt_id
,t1.col_mgmt_org_id as col_mgmt_org_id
,t1.setup_dt as setup_dt
,t1.com_prot_flg as com_prot_flg
,t1.asset_obg_lot as asset_obg_lot
,t1.guar_effect_way_cd as guar_effect_way_cd
,t1.trast_insure_flg as trast_insure_flg
,t1.col_rgst_trast_status_cd as col_rgst_trast_status_cd
,t1.col_insure_trast_status_cd as col_insure_trast_status_cd
,t1.col_insto_status_cd as col_insto_status_cd
,t1.col_rela_status_cd as col_rela_status_cd
,t1.col_espec_status_cd as col_espec_status_cd
,t1.wt_md_cash_ability_cd as wt_md_cash_ability_cd
,t1.obank_guar_flg as obank_guar_flg
,t1.gcust_flg as gcust_flg
,t1.col_val as col_val
,t1.curr_cd as curr_cd
,t1.val_estim_dt as val_estim_dt
,t1.data_src_cd as data_src_cd
,t1.col_info_check_status_cd as col_info_check_status_cd
,t1.col_modif_apv_status_cd as col_modif_apv_status_cd
,t1.np_cash_ability_cd as np_cash_ability_cd
,t1.get_key_info_flg as get_key_info_flg
,t1.modifbl_flg as modifbl_flg
,t1.col_name as col_name
,t1.pledge_ctrl_f_adj_coef_cd as pledge_ctrl_f_adj_coef_cd
,t1.modif_emply_id as modif_emply_id
,t1.save_hxb_flg as save_hxb_flg
,t1.final_modif_dt as final_modif_dt
,t1.prior_comp_weight_qtty as prior_comp_weight_qtty
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
