: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_kgss_gwc_corp_group_t_level_control_f
CreateDate: 20240808
FileName:   ${iel_data_path}/kgss_gwc_corp_group_t_level_control.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.\"_from\",chr(13),''),chr(10),'') as \"_from\"
,replace(replace(t1.\"_to\",chr(13),''),chr(10),'') as \"_to\"
,replace(replace(t1.depth,chr(13),''),chr(10),'') as depth
,replace(replace(t1.dst_name,chr(13),''),chr(10),'') as dst_name
,replace(replace(t1.ratio,chr(13),''),chr(10),'') as ratio
,replace(replace(t1.src_name,chr(13),''),chr(10),'') as src_name
,stock_indeg

from ${iol_schema}.kgss_gwc_corp_group_t_level_control t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/kgss_gwc_corp_group_t_level_control.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
