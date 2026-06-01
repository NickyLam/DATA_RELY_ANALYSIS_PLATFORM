: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_uxds_f_yzgais02001_f
CreateDate: 20250318
FileName:   ${iel_data_path}/uxds_f_yzgais02001.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.gendate,chr(13),''),chr(10),'') as gendate
,replace(replace(t1.serialnumber,chr(13),''),chr(10),'') as serialnumber
,replace(replace(t1.sequenceid,chr(13),''),chr(10),'') as sequenceid
,replace(replace(t1.policellegalaccpersonlist,chr(13),''),chr(10),'') as policellegalaccpersonlist
,replace(replace(t1.individualabnormalcaselist,chr(13),''),chr(10),'') as individualabnormalcaselist
,replace(replace(t1.bankshareabnormalacccluelist,chr(13),''),chr(10),'') as bankshareabnormalacccluelist
,replace(replace(t1.itemcode,chr(13),''),chr(10),'') as itemcode
,replace(replace(t1.iteminfo,chr(13),''),chr(10),'') as iteminfo
,replace(replace(t1.genmonth,chr(13),''),chr(10),'') as genmonth

from ${iol_schema}.uxds_f_yzgais02001 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_f_yzgais02001.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
