: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_resv_lc_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ast_col_resv_lc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.resv_lc_id,chr(13),''),chr(10),'') as resv_lc_id
,replace(replace(t1.issue_cty_rg_cd,chr(13),''),chr(10),'') as issue_cty_rg_cd
,replace(replace(t1.issue_org_name,chr(13),''),chr(10),'') as issue_org_name
,replace(replace(t1.issue_org_type_cd,chr(13),''),chr(10),'') as issue_org_type_cd
,replace(replace(t1.issue_org_ext_rating_rest_cd,chr(13),''),chr(10),'') as issue_org_ext_rating_rest_cd
,issue_org_ext_rating_dt
,replace(replace(t1.issue_org_intnal_rating_rest_cd,chr(13),''),chr(10),'') as issue_org_intnal_rating_rest_cd
,issue_org_intnal_rating_dt
,replace(replace(t1.issue_org_rgst_cty_rg_cd,chr(13),''),chr(10),'') as issue_org_rgst_cty_rg_cd
,replace(replace(t1.issue_org_rgst_ext_rating_rest_cd,chr(13),''),chr(10),'') as issue_org_rgst_ext_rating_rest_cd
,amt
,replace(replace(t1.irevbl_flg,chr(13),''),chr(10),'') as irevbl_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd

from ${iml_schema}.ast_col_resv_lc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_resv_lc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
