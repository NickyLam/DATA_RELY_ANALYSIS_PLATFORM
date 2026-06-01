: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_log_info_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ast_col_log_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.log_kind_cd,chr(13),''),chr(10),'') as log_kind_cd
,replace(replace(t1.issue_cty_cd,chr(13),''),chr(10),'') as issue_cty_cd
,replace(replace(t1.open_org_name,chr(13),''),chr(10),'') as open_org_name
,replace(replace(t1.open_org_type_cd,chr(13),''),chr(10),'') as open_org_type_cd
,replace(replace(t1.open_org_rgst_cd,chr(13),''),chr(10),'') as open_org_rgst_cd
,replace(replace(t1.stage_guar_flg,chr(13),''),chr(10),'') as stage_guar_flg
,replace(replace(t1.irevbl_flg,chr(13),''),chr(10),'') as irevbl_flg
,log_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.log_open_org_ext_rating_rest_cd,chr(13),''),chr(10),'') as log_open_org_ext_rating_rest_cd
,log_open_org_ext_rating_dt
,replace(replace(t1.log_open_org_intnal_rating_rest_cd,chr(13),''),chr(10),'') as log_open_org_intnal_rating_rest_cd
,log_open_org_intnal_rating_dt
,replace(replace(t1.log_open_org_rgst_ext_rating_rest_cd,chr(13),''),chr(10),'') as log_open_org_rgst_ext_rating_rest_cd

from ${iml_schema}.ast_col_log_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_log_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
