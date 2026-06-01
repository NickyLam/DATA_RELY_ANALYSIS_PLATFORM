: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_breach_result_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_breach_result_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(taskno,chr(10),''),chr(13),'') as taskno
,replace(replace(processtype,chr(10),''),chr(13),'') as processtype
,replace(replace(breachflag,chr(10),''),chr(13),'') as breachflag
,replace(replace(breachdate,chr(10),''),chr(13),'') as breachdate
,replace(replace(breachoverturndate,chr(10),''),chr(13),'') as breachoverturndate
,replace(replace(breachrelivedate,chr(10),''),chr(13),'') as breachrelivedate
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(iscanrelive,chr(10),''),chr(13),'') as iscanrelive
,replace(replace(risklevel,chr(10),''),chr(13),'') as risklevel
,replace(replace(begindate,chr(10),''),chr(13),'') as begindate
,replace(replace(enddate,chr(10),''),chr(13),'') as enddate
,replace(replace(rateflag,chr(10),''),chr(13),'') as rateflag
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_breach_result 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_breach_result_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes