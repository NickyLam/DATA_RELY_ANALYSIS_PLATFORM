: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_tps_broker_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_tps_broker_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.broker_cd,chr(13),''),chr(10),'') as broker_cd
,replace(replace(t1.broker_name,chr(13),''),chr(10),'') as broker_name
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_tps_broker_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tps_broker_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
