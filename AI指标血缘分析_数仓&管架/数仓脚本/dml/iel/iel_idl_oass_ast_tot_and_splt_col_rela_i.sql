: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_tot_and_splt_col_rela_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_tot_and_splt_col_rela.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.sup_chain_sys_merchd_id as sup_chain_sys_merchd_id
,t1.invtry_id as invtry_id
,t1.inpwn_id as inpwn_id
,t1.guar_contr_no as guar_contr_no
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.parent_asset_id as parent_asset_id
,t1.sub_asset_id as sub_asset_id

from ${idl_schema}.oass_ast_tot_and_splt_col_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_tot_and_splt_col_rela.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
