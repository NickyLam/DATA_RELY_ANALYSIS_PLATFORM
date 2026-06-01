: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_fsrecord_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_fsrecord.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
    ,replace(replace(t.recordno,chr(13),''),chr(10),'') as recordno
    ,replace(replace(t.reportdate,chr(13),''),chr(10),'') as reportdate
    ,replace(replace(t.reportscope,chr(13),''),chr(10),'') as reportscope
    ,replace(replace(t.reportperiod,chr(13),''),chr(10),'') as reportperiod
    ,replace(replace(t.reportcurrency,chr(13),''),chr(10),'') as reportcurrency
    ,replace(replace(t.reportunit,chr(13),''),chr(10),'') as reportunit
    ,replace(replace(t.reportstatus,chr(13),''),chr(10),'') as reportstatus
    ,replace(replace(t.reportflag,chr(13),''),chr(10),'') as reportflag
    ,replace(replace(t.reportopinion,chr(13),''),chr(10),'') as reportopinion
    ,replace(replace(t.auditflag,chr(13),''),chr(10),'') as auditflag
    ,replace(replace(t.auditoffice,chr(13),''),chr(10),'') as auditoffice
    ,replace(replace(t.auditopinion,chr(13),''),chr(10),'') as auditopinion
    ,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.modelclass,chr(13),''),chr(10),'') as modelclass
    ,replace(replace(t.accordingflag,chr(13),''),chr(10),'') as accordingflag
    ,replace(replace(t.islock,chr(13),''),chr(10),'') as islock
    ,replace(replace(t.hxtyzlsource,chr(13),''),chr(10),'') as hxtyzlsource
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_customer_fsrecord t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_fsrecord.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes