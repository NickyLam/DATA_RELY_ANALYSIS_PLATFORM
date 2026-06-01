: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_osbs_oss_ope_lot_num_f
CreateDate: 20230630
FileName:   ${iel_data_path}/osbs_oss_ope_lot_num.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.ecif_no,chr(13),''),chr(10),'') as ecif_no
,replace(replace(t1.act_no,chr(13),''),chr(10),'') as act_no
,replace(replace(t1.tas_no,chr(13),''),chr(10),'') as tas_no
,replace(replace(t1.pro_no,chr(13),''),chr(10),'') as pro_no
,replace(replace(t1.safe_no,chr(13),''),chr(10),'') as safe_no
,replace(replace(t1.lot_num,chr(13),''),chr(10),'') as lot_num
,replace(replace(t1.get_time,chr(13),''),chr(10),'') as get_time
,replace(replace(t1.get_channel,chr(13),''),chr(10),'') as get_channel
,replace(replace(t1.is_use,chr(13),''),chr(10),'') as is_use
,replace(replace(t1.oss_efetimestart,chr(13),''),chr(10),'') as oss_efetimestart
,replace(replace(t1.oss_efetimeend,chr(13),''),chr(10),'') as oss_efetimeend
,replace(replace(t1.oss_createtime,chr(13),''),chr(10),'') as oss_createtime
,replace(replace(t1.oss_updatetime,chr(13),''),chr(10),'') as oss_updatetime

from ${iol_schema}.osbs_oss_ope_lot_num t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_oss_ope_lot_num.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
