: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_val_info_h_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_val_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,estim_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,exch_rat
,ext_estim_exp_dt
,replace(replace(t1.ext_estim_org_id,chr(13),''),chr(10),'') as ext_estim_org_id
,replace(replace(t1.ext_estim_method_cd,chr(13),''),chr(10),'') as ext_estim_method_cd
,ext_pre_estim_val
,ext_formal_estim_dt
,ext_estim_val
,intnal_estim_val
,appl_estim_cfm_val
,replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id
,hxb_cfm_val
,estim_idtfy_dt
,ext_pa_estim_val
,intnal_pa_estim_val
,hxb_pa_cfm_val
,replace(replace(t1.pa_flow_id,chr(13),''),chr(10),'') as pa_flow_id
,replace(replace(t1.evltion_status_cd,chr(13),''),chr(10),'') as evltion_status_cd
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg
,insto_col_val
,replace(replace(t1.insto_org_id,chr(13),''),chr(10),'') as insto_org_id
,entry_col_val
,replace(replace(t1.ext_pre_estim_flg,chr(13),''),chr(10),'') as ext_pre_estim_flg

from ${iml_schema}.ast_col_val_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_val_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
