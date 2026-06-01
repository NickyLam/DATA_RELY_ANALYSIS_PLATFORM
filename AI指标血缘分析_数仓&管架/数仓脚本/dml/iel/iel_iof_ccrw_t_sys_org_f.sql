: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccrw_t_sys_org_f
CreateDate: 20240903
FileName:   ${iel_data_path}/ccrw_t_sys_org.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.org_abbr,chr(13),''),chr(10),'') as org_abbr
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id
,replace(replace(t1.brch_name,chr(13),''),chr(10),'') as brch_name
,replace(replace(t1.parent_org_id,chr(13),''),chr(10),'') as parent_org_id
,org_level
,replace(replace(t1.org_level_code,chr(13),''),chr(10),'') as org_level_code
,sort_no
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,ver
,replace(replace(t1.org_type,chr(13),''),chr(10),'') as org_type
,replace(replace(t1.short_name,chr(13),''),chr(10),'') as short_name
,replace(replace(t1.is_law_org,chr(13),''),chr(10),'') as is_law_org
,replace(replace(t1.law_org_id,chr(13),''),chr(10),'') as law_org_id
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.org_lng,chr(13),''),chr(10),'') as org_lng
,replace(replace(t1.org_lat,chr(13),''),chr(10),'') as org_lat
,replace(replace(t1.is_show,chr(13),''),chr(10),'') as is_show
,replace(replace(t1.is_statis,chr(13),''),chr(10),'') as is_statis
,replace(replace(t1.ccr_org,chr(13),''),chr(10),'') as ccr_org
,replace(replace(t1.org_status,chr(13),''),chr(10),'') as org_status
,replace(replace(t1.is_protection,chr(13),''),chr(10),'') as is_protection
,protection_time_start
,protection_time_end

from ${iol_schema}.ccrw_t_sys_org t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrw_t_sys_org.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
