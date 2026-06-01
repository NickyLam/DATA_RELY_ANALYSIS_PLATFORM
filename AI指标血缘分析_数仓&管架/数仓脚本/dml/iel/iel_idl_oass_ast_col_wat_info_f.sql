: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_wat_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_wat_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.wat_id as wat_id
,t1.wat_num as wat_num
,t1.wat_name as wat_name
,t1.wat_type_cd as wat_type_cd
,t1.licen_issue_autho_name as licen_issue_autho_name
,t1.issue_dt as issue_dt
,t1.valid_closing_dt as valid_closing_dt
,t1.rgst_dt as rgst_dt
,t1.rgst_emply_id as rgst_emply_id
,t1.insto_flow_id as insto_flow_id
,t1.acss_cont_id as acss_cont_id
,t1.pri_contr_id as pri_contr_id
,t1.insto_id as insto_id
,t1.insto_dt as insto_dt
,t1.ex_flow_id as ex_flow_id
,t1.ex_dt as ex_dt
,t1.latest_debit_flow_id as latest_debit_flow_id
,t1.latest_debit_dt as latest_debit_dt
,t1.rn_flow_id as rn_flow_id
,t1.rn_dt as rn_dt
,t1.rn_cnt as rn_cnt
,t1.latest_rtn_dt as latest_rtn_dt
,t1.wat_status_cd as wat_status_cd
,t1.uniq_wat_flg as uniq_wat_flg
,t1.flow_status_cd as flow_status_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_wat_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_wat_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
