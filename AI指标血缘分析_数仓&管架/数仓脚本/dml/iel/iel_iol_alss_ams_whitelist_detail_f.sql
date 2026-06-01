: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_ams_whitelist_detail_f
CreateDate: 20240417
FileName:   ${iel_data_path}/alss_ams_whitelist_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bla_det_id,chr(13),''),chr(10),'') as bla_det_id
,replace(replace(t1.black_id,chr(13),''),chr(10),'') as black_id
,replace(replace(t1.bla_name,chr(13),''),chr(10),'') as bla_name
,replace(replace(t1.bla_cust_type,chr(13),''),chr(10),'') as bla_cust_type
,replace(replace(t1.bla_value,chr(13),''),chr(10),'') as bla_value
,replace(replace(t1.eff_date,chr(13),''),chr(10),'') as eff_date
,replace(replace(t1.exp_date,chr(13),''),chr(10),'') as exp_date
,replace(replace(t1.bla_desc,chr(13),''),chr(10),'') as bla_desc
,replace(replace(t1.bla_status,chr(13),''),chr(10),'') as bla_status
,replace(replace(t1.add_user,chr(13),''),chr(10),'') as add_user
,replace(replace(t1.add_date,chr(13),''),chr(10),'') as add_date
,replace(replace(t1.del_user,chr(13),''),chr(10),'') as del_user
,replace(replace(t1.del_date,chr(13),''),chr(10),'') as del_date
,replace(replace(t1.exp_user,chr(13),''),chr(10),'') as exp_user
,replace(replace(t1.exp_time,chr(13),''),chr(10),'') as exp_time
,replace(replace(t1.last_update_user,chr(13),''),chr(10),'') as last_update_user
,replace(replace(t1.last_update_date,chr(13),''),chr(10),'') as last_update_date
,replace(replace(t1.cust_manage,chr(13),''),chr(10),'') as cust_manage
,replace(replace(t1.list_dimension,chr(13),''),chr(10),'') as list_dimension

from ${iol_schema}.alss_ams_whitelist_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_ams_whitelist_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
