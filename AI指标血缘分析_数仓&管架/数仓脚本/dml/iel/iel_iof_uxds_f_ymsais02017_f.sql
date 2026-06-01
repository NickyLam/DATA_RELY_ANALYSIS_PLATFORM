: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_uxds_f_ymsais02017_f
CreateDate: 20250318
FileName:   ${iel_data_path}/uxds_f_ymsais02017.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.gendate,chr(13),''),chr(10),'') as gendate
,replace(replace(t1.serialnumber,chr(13),''),chr(10),'') as serialnumber
,replace(replace(t1.sequenceid,chr(13),''),chr(10),'') as sequenceid
,replace(replace(t1.channeltype,chr(13),''),chr(10),'') as channeltype
,replace(replace(t1.mobstatusresult_itemdata,chr(13),''),chr(10),'') as mobstatusresult_itemdata
,replace(replace(t1.mobstatusresult_itemcode,chr(13),''),chr(10),'') as mobstatusresult_itemcode
,replace(replace(t1.mobstatusresult_iteminfo,chr(13),''),chr(10),'') as mobstatusresult_iteminfo
,replace(replace(t1.genmonth,chr(13),''),chr(10),'') as genmonth

from ${iol_schema}.uxds_f_ymsais02017 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_f_ymsais02017.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
