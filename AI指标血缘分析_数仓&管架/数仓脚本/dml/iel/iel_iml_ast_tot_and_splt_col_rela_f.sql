: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_tot_and_splt_col_rela_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_tot_and_splt_col_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(parent_asset_id,chr(13),''),chr(10),'')
,replace(replace(sub_asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sup_chain_sys_merchd_id,chr(13),''),chr(10),'')
,replace(replace(invtry_id,chr(13),''),chr(10),'')
,replace(replace(inpwn_id,chr(13),''),chr(10),'')
,replace(replace(guar_contr_no,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_tot_and_splt_col_rela t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_tot_and_splt_col_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
