: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_fsrecord_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_fsrecord_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(recordno,chr(10),''),chr(13),'') as recordno
,replace(replace(reportdate,chr(10),''),chr(13),'') as reportdate
,replace(replace(reportscope,chr(10),''),chr(13),'') as reportscope
,replace(replace(reportperiod,chr(10),''),chr(13),'') as reportperiod
,replace(replace(reportcurrency,chr(10),''),chr(13),'') as reportcurrency
,replace(replace(reportunit,chr(10),''),chr(13),'') as reportunit
,replace(replace(reportstatus,chr(10),''),chr(13),'') as reportstatus
,replace(replace(reportflag,chr(10),''),chr(13),'') as reportflag
,replace(replace(reportopinion,chr(10),''),chr(13),'') as reportopinion
,replace(replace(auditflag,chr(10),''),chr(13),'') as auditflag
,replace(replace(auditoffice,chr(10),''),chr(13),'') as auditoffice
,replace(replace(auditopinion,chr(10),''),chr(13),'') as auditopinion
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(modelclass,chr(10),''),chr(13),'') as modelclass
,replace(replace(accordingflag,chr(10),''),chr(13),'') as accordingflag
,replace(replace(islock,chr(10),''),chr(13),'') as islock
,replace(replace(hxtyzlsource,chr(10),''),chr(13),'') as hxtyzlsource
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_customer_fsrecord 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_fsrecord_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes