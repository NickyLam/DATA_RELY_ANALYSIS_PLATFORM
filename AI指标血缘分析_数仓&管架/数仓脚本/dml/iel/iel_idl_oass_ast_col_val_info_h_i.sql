: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_val_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_val_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.estim_way_cd as estim_way_cd
,t1.estim_dt as estim_dt
,t1.curr_cd as curr_cd
,t1.exch_rat as exch_rat
,t1.ext_estim_exp_dt as ext_estim_exp_dt
,t1.ext_estim_org_id as ext_estim_org_id
,t1.ext_estim_method_cd as ext_estim_method_cd
,t1.ext_pre_estim_val as ext_pre_estim_val
,t1.ext_formal_estim_dt as ext_formal_estim_dt
,t1.ext_estim_val as ext_estim_val
,t1.intnal_estim_val as intnal_estim_val
,t1.appl_estim_cfm_val as appl_estim_cfm_val
,t1.flow_id as flow_id
,t1.hxb_cfm_val as hxb_cfm_val
,t1.estim_idtfy_dt as estim_idtfy_dt
,t1.ext_pa_estim_val as ext_pa_estim_val
,t1.intnal_pa_estim_val as intnal_pa_estim_val
,t1.hxb_pa_cfm_val as hxb_pa_cfm_val
,t1.pa_flow_id as pa_flow_id
,t1.evltion_status_cd as evltion_status_cd
,t1.froz_flg as froz_flg
,t1.insto_col_val as insto_col_val
,t1.insto_org_id as insto_org_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.ext_pre_estim_flg as ext_pre_estim_flg
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_val_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_val_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
