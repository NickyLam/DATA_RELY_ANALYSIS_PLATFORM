: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_ams_blacklist_category_f
CreateDate: 20231101
FileName:   ${iel_data_path}/alss_ams_blacklist_category.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.black_id,chr(13),''),chr(10),'') as black_id
,replace(replace(t1.black_type,chr(13),''),chr(10),'') as black_type
,replace(replace(t1.black_nane,chr(13),''),chr(10),'') as black_nane
,replace(replace(t1.black_source,chr(13),''),chr(10),'') as black_source
,replace(replace(t1.black_desc,chr(13),''),chr(10),'') as black_desc
,replace(replace(t1.control_measure_desc,chr(13),''),chr(10),'') as control_measure_desc
,replace(replace(t1.supervise_file,chr(13),''),chr(10),'') as supervise_file
,replace(replace(t1.effective_region,chr(13),''),chr(10),'') as effective_region
,replace(replace(t1.data_permisions,chr(13),''),chr(10),'') as data_permisions
,replace(replace(t1.effective_date,chr(13),''),chr(10),'') as effective_date
,replace(replace(t1.black_status,chr(13),''),chr(10),'') as black_status
,replace(replace(t1.add_user,chr(13),''),chr(10),'') as add_user
,replace(replace(t1.add_date,chr(13),''),chr(10),'') as add_date
,replace(replace(t1.del_user,chr(13),''),chr(10),'') as del_user
,replace(replace(t1.del_date,chr(13),''),chr(10),'') as del_date
,replace(replace(t1.exp_user,chr(13),''),chr(10),'') as exp_user
,replace(replace(t1.exp_time,chr(13),''),chr(10),'') as exp_time
,replace(replace(t1.last_update_user,chr(13),''),chr(10),'') as last_update_user
,replace(replace(t1.last_update_date,chr(13),''),chr(10),'') as last_update_date

from ${iol_schema}.alss_ams_blacklist_category t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_ams_blacklist_category.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
