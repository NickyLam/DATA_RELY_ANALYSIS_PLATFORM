: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_irs_rate_history_f
CreateDate: 20240801
FileName:   ${iel_data_path}/icms_irs_rate_history.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.adjustlevel,chr(13),''),chr(10),'') as adjustlevel
,replace(replace(t1.applyid,chr(13),''),chr(10),'') as applyid
,balance
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.datasource,chr(13),''),chr(10),'') as datasource
,replace(replace(t1.finallevel,chr(13),''),chr(10),'') as finallevel
,replace(replace(t1.ifvalid,chr(13),''),chr(10),'') as ifvalid
,inputdate
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.modelcode,chr(13),''),chr(10),'') as modelcode
,replace(replace(t1.modelname,chr(13),''),chr(10),'') as modelname
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t1.originlevel,chr(13),''),chr(10),'') as originlevel
,replace(replace(t1.overthrowlevel,chr(13),''),chr(10),'') as overthrowlevel
,replace(replace(t1.pusherrorinfo,chr(13),''),chr(10),'') as pusherrorinfo
,replace(replace(t1.ratedate,chr(13),''),chr(10),'') as ratedate
,replace(replace(t1.ratedelayreason,chr(13),''),chr(10),'') as ratedelayreason
,replace(replace(t1.rateenddate,chr(13),''),chr(10),'') as rateenddate
,replace(replace(t1.ratereport,chr(13),''),chr(10),'') as ratereport
,replace(replace(t1.realenddate,chr(13),''),chr(10),'') as realenddate
,replace(replace(t1.reportdelete,chr(13),''),chr(10),'') as reportdelete
,replace(replace(t1.reportno,chr(13),''),chr(10),'') as reportno
,replace(replace(t1.reporttime,chr(13),''),chr(10),'') as reporttime
,replace(replace(t1.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.wyreason,chr(13),''),chr(10),'') as wyreason

from ${iol_schema}.icms_irs_rate_history t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_irs_rate_history.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
