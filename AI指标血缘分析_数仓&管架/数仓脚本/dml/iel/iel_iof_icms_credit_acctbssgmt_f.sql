: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_acctbssgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_acctbssgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
,replace(replace(t1.idnum,chr(13),''),chr(10),'') as idnum
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.infrectype,chr(13),''),chr(10),'') as infrectype
,replace(replace(t1.createtime,chr(13),''),chr(10),'') as createtime
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.topdeptcode,chr(13),''),chr(10),'') as topdeptcode
,replace(replace(t1.extrainfo,chr(13),''),chr(10),'') as extrainfo
from ${iol_schema}.icms_credit_acctbssgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_acctbssgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes