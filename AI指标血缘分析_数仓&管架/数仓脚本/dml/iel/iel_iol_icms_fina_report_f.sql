: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_fina_report_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_fina_report.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.reportno,chr(13),''),chr(10),'') as reportno
,replace(replace(t1.reportflag,chr(13),''),chr(10),'') as reportflag
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.hxtyzlsource,chr(13),''),chr(10),'') as hxtyzlsource
,replace(replace(t1.accountingmonth,chr(13),''),chr(10),'') as accountingmonth
,replace(replace(t1.auditingagency,chr(13),''),chr(10),'') as auditingagency
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.accordingflag,chr(13),''),chr(10),'') as accordingflag
,replace(replace(t1.reportstatus,chr(13),''),chr(10),'') as reportstatus
,replace(replace(t1.auditopinion,chr(13),''),chr(10),'') as auditopinion
,replace(replace(t1.warningresult,chr(13),''),chr(10),'') as warningresult
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.islock,chr(13),''),chr(10),'') as islock
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.auditflag,chr(13),''),chr(10),'') as auditflag
,t1.updatedate as updatedate
,replace(replace(t1.reporttypeno,chr(13),''),chr(10),'') as reporttypeno
,replace(replace(t1.reportscope,chr(13),''),chr(10),'') as reportscope
,replace(replace(t1.monetaryunit,chr(13),''),chr(10),'') as monetaryunit
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.reportperiod,chr(13),''),chr(10),'') as reportperiod
,t1.auditdate as auditdate
,t1.inputdate as inputdate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.reportopinion,chr(13),''),chr(10),'') as reportopinion
,replace(replace(t1.deleteflag,chr(13),''),chr(10),'') as deleteflag
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
from ${iol_schema}.icms_fina_report t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_fina_report.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes