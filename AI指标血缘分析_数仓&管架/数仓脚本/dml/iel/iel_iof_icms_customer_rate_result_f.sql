: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_customer_rate_result_f
CreateDate: 20250210
FileName:   ${iel_data_path}/icms_customer_rate_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,rateenddate
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.raterisklevel,chr(13),''),chr(10),'') as raterisklevel
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.ratelimitlevel,chr(13),''),chr(10),'') as ratelimitlevel
,replace(replace(t1.ismerge,chr(13),''),chr(10),'') as ismerge
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.fromflag,chr(13),''),chr(10),'') as fromflag
,inputtime
,ratelimitamt
,replace(replace(t1.repperiod,chr(13),''),chr(10),'') as repperiod
,ratebegindate
,replace(replace(t1.repno,chr(13),''),chr(10),'') as repno
,replace(replace(t1.processtype,chr(13),''),chr(10),'') as processtype
,updatetime
,replace(replace(t1.isreport,chr(13),''),chr(10),'') as isreport
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.taskno,chr(13),''),chr(10),'') as taskno

from ${iol_schema}.icms_customer_rate_result t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_customer_rate_result.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
