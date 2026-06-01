: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_dubil_assign_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ast_dubil_assign_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.dubil_id as dubil_id
,t1.loan_assign_bal as loan_assign_bal
,t1.dubil_bal as dubil_bal
,t1.splt_col_latest_val as splt_col_latest_val
,t1.splt_col_insto_val as splt_col_insto_val
,t1.in_out_tab_flg as in_out_tab_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_dubil_assign_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_dubil_assign_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
