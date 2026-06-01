: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_basic_info_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_type_id,chr(13),''),chr(10),'') as col_type_id
,replace(replace(t1.col_mgmt_id,chr(13),''),chr(10),'') as col_mgmt_id
,replace(replace(t1.col_mgmt_org_id,chr(13),''),chr(10),'') as col_mgmt_org_id
,setup_dt
,replace(replace(t1.com_prot_flg,chr(13),''),chr(10),'') as com_prot_flg
,asset_obg_lot
,replace(replace(t1.guar_effect_way_cd,chr(13),''),chr(10),'') as guar_effect_way_cd
,replace(replace(t1.trast_insure_flg,chr(13),''),chr(10),'') as trast_insure_flg
,replace(replace(t1.col_rgst_trast_status_cd,chr(13),''),chr(10),'') as col_rgst_trast_status_cd
,replace(replace(t1.col_insure_trast_status_cd,chr(13),''),chr(10),'') as col_insure_trast_status_cd
,replace(replace(t1.col_insto_status_cd,chr(13),''),chr(10),'') as col_insto_status_cd
,replace(replace(t1.col_rela_status_cd,chr(13),''),chr(10),'') as col_rela_status_cd
,replace(replace(t1.col_espec_status_cd,chr(13),''),chr(10),'') as col_espec_status_cd
,replace(replace(t1.wt_md_cash_ability_cd,chr(13),''),chr(10),'') as wt_md_cash_ability_cd
,replace(replace(t1.obank_guar_flg,chr(13),''),chr(10),'') as obank_guar_flg
,replace(replace(t1.gcust_flg,chr(13),''),chr(10),'') as gcust_flg
,col_val
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,val_estim_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.col_info_check_status_cd,chr(13),''),chr(10),'') as col_info_check_status_cd
,replace(replace(t1.col_modif_apv_status_cd,chr(13),''),chr(10),'') as col_modif_apv_status_cd
,replace(replace(t1.np_cash_ability_cd,chr(13),''),chr(10),'') as np_cash_ability_cd
,replace(replace(t1.get_key_info_flg,chr(13),''),chr(10),'') as get_key_info_flg
,replace(replace(t1.modifbl_flg,chr(13),''),chr(10),'') as modifbl_flg
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t1.pledge_ctrl_f_adj_coef_cd,chr(13),''),chr(10),'') as pledge_ctrl_f_adj_coef_cd
,replace(replace(t1.modif_emply_id,chr(13),''),chr(10),'') as modif_emply_id
,replace(replace(t1.save_hxb_flg,chr(13),''),chr(10),'') as save_hxb_flg
,final_modif_dt
,prior_comp_weight_qtty
,replace(replace(t1.fst_flg,chr(13),''),chr(10),'') as fst_flg
,replace(replace(t1.col_rgst_b_type_cd,chr(13),''),chr(10),'') as col_rgst_b_type_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_basic_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
