: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_fina_sheet_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_fina_sheet.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sheetno,chr(13),''),chr(10),'') as sheetno
,replace(replace(t1.reportscope,chr(13),''),chr(10),'') as reportscope
,replace(replace(t1.reportperiod,chr(13),''),chr(10),'') as reportperiod
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.calculateerrorinfo,chr(13),''),chr(10),'') as calculateerrorinfo
,replace(replace(t1.reportname,chr(13),''),chr(10),'') as reportname
,replace(replace(t1.sheettype,chr(13),''),chr(10),'') as sheettype
,replace(replace(t1.accountingmonth,chr(13),''),chr(10),'') as accountingmonth
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.reportno,chr(13),''),chr(10),'') as reportno
,t1.updatedate as updatedate
,t1.inputdate as inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.reporttypeno,chr(13),''),chr(10),'') as reporttypeno
,replace(replace(t1.deleteflag,chr(13),''),chr(10),'') as deleteflag
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
from ${iol_schema}.icms_fina_sheet t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_fina_sheet.f.${batch_date}.dat" \
        charset=utf8
        safe=yes