: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_rate_result_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_rate_result_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(taskno,chr(10),''),chr(13),'') as taskno
,replace(replace(processtype,chr(10),''),chr(13),'') as processtype
,replace(replace(raterisklevel,chr(10),''),chr(13),'') as raterisklevel
,replace(replace(ratebegindate,chr(10),''),chr(13),'') as ratebegindate
,replace(replace(rateenddate,chr(10),''),chr(13),'') as rateenddate
,replace(replace(ratelimitlevel,chr(10),''),chr(13),'') as ratelimitlevel
,replace(replace(ratelimitamt,chr(10),''),chr(13),'') as ratelimitamt
,replace(replace(repno,chr(10),''),chr(13),'') as repno
,replace(replace(ismerge,chr(10),''),chr(13),'') as ismerge
,replace(replace(repperiod,chr(10),''),chr(13),'') as repperiod
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(fromflag,chr(10),''),chr(13),'') as fromflag
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_rate_result 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_rate_result_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes