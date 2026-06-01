: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_basic_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_basic_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.col_type_id as col_type_id
,t.col_mgmt_id as col_mgmt_id
,t.col_mgmt_org_id as col_mgmt_org_id
,t.setup_dt as setup_dt
,t.com_prot_flg as com_prot_flg
,t.asset_obg_lot as asset_obg_lot
,t.guar_effect_way_cd as guar_effect_way_cd
,t.trast_insure_flg as trast_insure_flg
,t.col_rgst_trast_status_cd as col_rgst_trast_status_cd
,t.col_insure_trast_status_cd as col_insure_trast_status_cd
,t.col_insto_status_cd as col_insto_status_cd
,t.col_rela_status_cd as col_rela_status_cd
,t.col_espec_status_cd as col_espec_status_cd
,t.wt_md_cash_ability_cd as wt_md_cash_ability_cd
,t.obank_guar_flg as obank_guar_flg
,t.gcust_flg as gcust_flg
,t.col_val as col_val
,t.curr_cd as curr_cd
,t.val_estim_dt as val_estim_dt
,t.data_src_cd as data_src_cd
,t.col_info_check_status_cd as col_info_check_status_cd
,t.col_modif_apv_status_cd as col_modif_apv_status_cd
,t.np_cash_ability_cd as np_cash_ability_cd
,t.get_key_info_flg as get_key_info_flg
,t.modifbl_flg as modifbl_flg
,t.col_name as col_name
,t.pledge_ctrl_f_adj_coef_cd as pledge_ctrl_f_adj_coef_cd
,t.modif_emply_id as modif_emply_id
,t.save_hxb_flg as save_hxb_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_basic_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_basic_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes