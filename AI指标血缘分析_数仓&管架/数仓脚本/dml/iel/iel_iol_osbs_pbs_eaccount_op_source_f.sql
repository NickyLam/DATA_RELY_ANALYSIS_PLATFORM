: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_pbs_eaccount_op_source_f
CreateDate: 20240305
FileName:   ${iel_data_path}/osbs_pbs_eaccount_op_source.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.peos_accesstoken,chr(13),''),chr(10),'') as peos_accesstoken
,replace(replace(t1.peos_source,chr(13),''),chr(10),'') as peos_source
,replace(replace(t1.peos_extend_one,chr(13),''),chr(10),'') as peos_extend_one
,replace(replace(t1.peos_extend_two,chr(13),''),chr(10),'') as peos_extend_two
,replace(replace(t1.peos_extend_third,chr(13),''),chr(10),'') as peos_extend_third
,replace(replace(t1.peos_createtime,chr(13),''),chr(10),'') as peos_createtime

from ${iol_schema}.osbs_pbs_eaccount_op_source t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_eaccount_op_source.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
