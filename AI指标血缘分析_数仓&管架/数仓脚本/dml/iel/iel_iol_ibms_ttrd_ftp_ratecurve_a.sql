: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_ftp_ratecurve_a
CreateDate: 20250701
FileName:   ${iel_data_path}/ibms_ttrd_ftp_ratecurve.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.value_date,chr(13),''),chr(10),'') as value_date
,replace(replace(t1.curve_no,chr(13),''),chr(10),'') as curve_no
,replace(replace(t1.curve_name,chr(13),''),chr(10),'') as curve_name
,rate_1d
,rate_7d
,rate_14d
,rate_21d
,rate_1m
,rate_3m
,rate_6m
,rate_9m
,rate_1y
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.effect_time,chr(13),''),chr(10),'') as effect_time
,update_user_id
,current_rate
,notrans_current_rate

from ${iol_schema}.ibms_ttrd_ftp_ratecurve t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_ftp_ratecurve.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
