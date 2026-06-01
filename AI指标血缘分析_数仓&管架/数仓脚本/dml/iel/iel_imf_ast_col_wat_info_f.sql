: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_wat_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_wat_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.wat_id,chr(13),''),chr(10),'') as wat_id
,replace(replace(t1.wat_num,chr(13),''),chr(10),'') as wat_num
,replace(replace(t1.wat_name,chr(13),''),chr(10),'') as wat_name
,replace(replace(t1.wat_type_cd,chr(13),''),chr(10),'') as wat_type_cd
,replace(replace(t1.licen_issue_autho_name,chr(13),''),chr(10),'') as licen_issue_autho_name
,issue_dt
,valid_closing_dt
,rgst_dt
,replace(replace(t1.rgst_emply_id,chr(13),''),chr(10),'') as rgst_emply_id
,replace(replace(t1.insto_flow_id,chr(13),''),chr(10),'') as insto_flow_id
,replace(replace(t1.acss_cont_id,chr(13),''),chr(10),'') as acss_cont_id
,replace(replace(t1.pri_contr_id,chr(13),''),chr(10),'') as pri_contr_id
,replace(replace(t1.insto_id,chr(13),''),chr(10),'') as insto_id
,insto_dt
,replace(replace(t1.ex_flow_id,chr(13),''),chr(10),'') as ex_flow_id
,ex_dt
,replace(replace(t1.latest_debit_flow_id,chr(13),''),chr(10),'') as latest_debit_flow_id
,latest_debit_dt
,replace(replace(t1.rn_flow_id,chr(13),''),chr(10),'') as rn_flow_id
,rn_dt
,rn_cnt
,latest_rtn_dt
,replace(replace(t1.wat_status_cd,chr(13),''),chr(10),'') as wat_status_cd
,replace(replace(t1.uniq_wat_flg,chr(13),''),chr(10),'') as uniq_wat_flg
,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'') as flow_status_cd
,create_dt
,update_dt
,rgst_start_dt
,rgst_end_dt

from ${iml_schema}.ast_col_wat_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_wat_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
