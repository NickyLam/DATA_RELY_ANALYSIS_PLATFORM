: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_insure_info_h_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_insure_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.insure_rec_id,chr(13),''),chr(10),'') as insure_rec_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.insu_comp_id,chr(13),''),chr(10),'') as insu_comp_id
,replace(replace(t1.insu_comp_name,chr(13),''),chr(10),'') as insu_comp_name
,replace(replace(t1.policy_num,chr(13),''),chr(10),'') as policy_num
,guar_amt
,insure_begin_dt
,insure_exp_dt
,replace(replace(t1.fst_ctfer_name,chr(13),''),chr(10),'') as fst_ctfer_name
,replace(replace(t1.secd_ctfer_name,chr(13),''),chr(10),'') as secd_ctfer_name
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,latest_update_dt

from ${iml_schema}.ast_col_insure_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_insure_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
