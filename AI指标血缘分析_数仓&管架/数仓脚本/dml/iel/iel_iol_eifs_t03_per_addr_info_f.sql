: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t03_per_addr_info_f
CreateDate: 20240328
FileName:   ${iel_data_path}/eifs_t03_per_addr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.addr_id,chr(13),''),chr(10),'') as addr_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.phys_addr_type_cd,chr(13),''),chr(10),'') as phys_addr_type_cd
,replace(replace(t1.phys_addr_cty_zone_cd,chr(13),''),chr(10),'') as phys_addr_cty_zone_cd
,replace(replace(t1.prov_cd,chr(13),''),chr(10),'') as prov_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.county_cd,chr(13),''),chr(10),'') as county_cd
,replace(replace(t1.street,chr(13),''),chr(10),'') as street
,replace(replace(t1.addr_detail,chr(13),''),chr(10),'') as addr_detail
,replace(replace(t1.post_code,chr(13),''),chr(10),'') as post_code
,replace(replace(t1.prefereed_flag,chr(13),''),chr(10),'') as prefereed_flag
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,init_created_ts
,created_ts
,updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,last_updated_ts
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num

from ${iol_schema}.eifs_t03_per_addr_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t03_per_addr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
