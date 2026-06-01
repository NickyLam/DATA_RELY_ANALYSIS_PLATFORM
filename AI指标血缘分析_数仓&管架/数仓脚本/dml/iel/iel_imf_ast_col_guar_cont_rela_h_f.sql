: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_guar_cont_rela_h_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_guar_cont_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.loan_stage_cd,chr(13),''),chr(10),'') as loan_stage_cd
,guar_amt
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,pm_rat
,replace(replace(t1.effect_status_cd,chr(13),''),chr(10),'') as effect_status_cd
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,setup_dt
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd

from ${iml_schema}.ast_col_guar_cont_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_guar_cont_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
