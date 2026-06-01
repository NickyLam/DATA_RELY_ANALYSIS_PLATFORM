: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_estat_avg_info_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_ast_estat_avg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.local_rg_cd as local_rg_cd
,t1.estat_name as estat_name
,t1.ext_estim_price as ext_estim_price
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.batch_dt as batch_dt
,t1.estat_id as estat_id

from ${idl_schema}.oass_ast_estat_avg_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_estat_avg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
