: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_bssgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_bssgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.infsurccode,chr(13),''),chr(10),'') as infsurccode
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.cimoc,chr(13),''),chr(10),'') as cimoc
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.idnum,chr(13),''),chr(10),'') as idnum
,replace(replace(t1.infrectype,chr(13),''),chr(10),'') as infrectype
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
from ${iol_schema}.icms_credit_bssgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_bssgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes