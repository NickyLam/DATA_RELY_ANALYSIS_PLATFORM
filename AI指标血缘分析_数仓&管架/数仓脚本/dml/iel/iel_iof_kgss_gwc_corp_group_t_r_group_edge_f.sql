: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_kgss_gwc_corp_group_t_r_group_edge_f
CreateDate: 20260126
FileName:   ${iel_data_path}/kgss_gwc_corp_group_t_r_group_edge.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_key,chr(13),''),chr(10),'') as object_key
,replace(replace(t1.group_name,chr(13),''),chr(10),'') as group_name
,replace(replace(t1.from_key,chr(13),''),chr(10),'') as from_key
,replace(replace(t1.src_name,chr(13),''),chr(10),'') as src_name
,replace(replace(t1.src_credit_no,chr(13),''),chr(10),'') as src_credit_no
,replace(replace(t1.to_key,chr(13),''),chr(10),'') as to_key
,replace(replace(t1.dst_name,chr(13),''),chr(10),'') as dst_name
,replace(replace(t1.dst_credit_no,chr(13),''),chr(10),'') as dst_credit_no
,replace(replace(t1.label,chr(13),''),chr(10),'') as label
,replace(replace(t1.label_temp,chr(13),''),chr(10),'') as label_temp
,replace(replace(t1.group_name_remark,chr(13),''),chr(10),'') as group_name_remark
,replace(replace(t1.distinct_flag,chr(13),''),chr(10),'') as distinct_flag
,replace(replace(t1.priority_level,chr(13),''),chr(10),'') as priority_level

from ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/kgss_gwc_corp_group_t_r_group_edge.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
