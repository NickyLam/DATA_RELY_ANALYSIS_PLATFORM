: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_wat_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_wat_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.wat_id as wat_id
,t.wat_num as wat_num
,t.wat_name as wat_name
,t.wat_type_cd as wat_type_cd
,t.licen_issue_autho_name as licen_issue_autho_name
,t.issue_dt as issue_dt
,t.valid_closing_dt as valid_closing_dt
,t.rgst_dt as rgst_dt
,t.rgst_emply_id as rgst_emply_id
,t.insto_flow_id as insto_flow_id
,t.acss_cont_id as acss_cont_id
,t.pri_contr_id as pri_contr_id
,t.insto_id as insto_id
,t.insto_dt as insto_dt
,t.ex_flow_id as ex_flow_id
,t.ex_dt as ex_dt
,t.latest_debit_flow_id as latest_debit_flow_id
,t.latest_debit_dt as latest_debit_dt
,t.rn_flow_id as rn_flow_id
,t.rn_dt as rn_dt
,t.rn_cnt as rn_cnt
,t.latest_rtn_dt as latest_rtn_dt
,t.wat_status_cd as wat_status_cd
,t.uniq_wat_flg as uniq_wat_flg
,t.flow_status_cd as flow_status_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_wat_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_wat_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes