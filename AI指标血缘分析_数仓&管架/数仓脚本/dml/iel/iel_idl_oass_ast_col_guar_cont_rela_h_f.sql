: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_guar_cont_rela_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ast_col_guar_cont_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.guar_cont_id as guar_cont_id
,t1.guar_type_cd as guar_type_cd
,t1.loan_stage_cd as loan_stage_cd
,t1.guar_amt as guar_amt
,t1.guar_curr_cd as guar_curr_cd
,t1.effect_status_cd as effect_status_cd
,t1.exp_status_cd as exp_status_cd
,t1.src_sys_cd as src_sys_cd
,t1.setup_dt as setup_dt
,t1.strip_line_cd as strip_line_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_guar_cont_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_guar_cont_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
