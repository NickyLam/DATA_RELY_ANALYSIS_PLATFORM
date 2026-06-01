: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_estat_avg_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_estat_avg_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(batch_dt,chr(13),''),chr(10),'')
,replace(replace(estat_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(local_prov_cd,chr(13),''),chr(10),'')
,replace(replace(local_city_cd,chr(13),''),chr(10),'')
,replace(replace(local_rg_cd,chr(13),''),chr(10),'')
,replace(replace(estat_name,chr(13),''),chr(10),'')
,ext_estim_price
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_estat_avg_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_estat_avg_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
