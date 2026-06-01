: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_guar_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_guar_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t1.col_type_cd,chr(13),''),chr(10),'') as col_type_cd
,replace(replace(t1.guar_guar_form_cd,chr(13),''),chr(10),'') as guar_guar_form_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_status_cd,chr(13),''),chr(10),'') as guar_status_cd
,guar_amt
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,guar_corp_margin_amt
,replace(replace(t1.stage_guar_flg,chr(13),''),chr(10),'') as stage_guar_flg
,replace(replace(t1.estim_org_name,chr(13),''),chr(10),'') as estim_org_name
,estim_val
,evltion_dt
,replace(replace(t1.rel_esat_cert_id,chr(13),''),chr(10),'') as rel_esat_cert_id
,rel_esat_arch_area
,replace(replace(t1.mtg_addr,chr(13),''),chr(10),'') as mtg_addr
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.log_type_cd,chr(13),''),chr(10),'') as log_type_cd
,log_amt
,replace(replace(t1.log_curr_cd,chr(13),''),chr(10),'') as log_curr_cd
,replace(replace(t1.log_issue_cty_cd,chr(13),''),chr(10),'') as log_issue_cty_cd
,replace(replace(t1.open_org_name,chr(13),''),chr(10),'') as open_org_name
,replace(replace(t1.open_org_type_cd,chr(13),''),chr(10),'') as open_org_type_cd
,replace(replace(t1.irevbl_flg,chr(13),''),chr(10),'') as irevbl_flg
,replace(replace(t1.finc_turn_margin_col_id,chr(13),''),chr(10),'') as finc_turn_margin_col_id
,replace(replace(t1.guartor_type_cd,chr(13),''),chr(10),'') as guartor_type_cd
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd
,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no
,replace(replace(t1.guartor_guar_indep_cd,chr(13),''),chr(10),'') as guartor_guar_indep_cd
,replace(replace(t1.guartor_rgst_cty_cd,chr(13),''),chr(10),'') as guartor_rgst_cty_cd
,replace(replace(t1.guartor_rgst_ext_rating_cd,chr(13),''),chr(10),'') as guartor_rgst_ext_rating_cd
,guartor_ext_rating_dt
,replace(replace(t1.guartor_ext_rating_cd,chr(13),''),chr(10),'') as guartor_ext_rating_cd
,guartor_intnal_rating_dt
,replace(replace(t1.guartor_intnal_rating_cd,chr(13),''),chr(10),'') as guartor_intnal_rating_cd
,replace(replace(t1.guartor_ownsp_type_cd,chr(13),''),chr(10),'') as guartor_ownsp_type_cd
,guartor_net_asset
,replace(replace(t1.net_asset_curr_cd,chr(13),''),chr(10),'') as net_asset_curr_cd
,replace(replace(t1.guar_insure_policy_num,chr(13),''),chr(10),'') as guar_insure_policy_num
,replace(replace(t1.guar_aim_cd,chr(13),''),chr(10),'') as guar_aim_cd
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,rgst_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,last_update_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id

from ${iml_schema}.ast_col_guar_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_guar_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
