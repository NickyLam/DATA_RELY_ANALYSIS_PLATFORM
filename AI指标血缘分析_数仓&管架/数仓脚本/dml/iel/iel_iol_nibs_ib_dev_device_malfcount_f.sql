: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_dev_device_malfcount_f
CreateDate: 20230323
FileName:   ${iel_data_path}/nibs_ib_dev_device_malfcount.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.devicenum,chr(13),''),chr(10),'') as devicenum
,maindate
,replace(replace(t1.typefalg,chr(13),''),chr(10),'') as typefalg
,replace(replace(t1.branchnum,chr(13),''),chr(10),'') as branchnum
,replace(replace(t1.opensalf,chr(13),''),chr(10),'') as opensalf
,replace(replace(t1.malfsalf,chr(13),''),chr(10),'') as malfsalf

from ${iol_schema}.nibs_ib_dev_device_malfcount t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_dev_device_malfcount.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
