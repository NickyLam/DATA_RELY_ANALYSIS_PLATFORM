: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_creditlimsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_creditlimsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.coneffdate,chr(13),''),chr(10),'') as coneffdate
,replace(replace(t1.constatus,chr(13),''),chr(10),'') as constatus
,replace(replace(t1.creditrestcode,chr(13),''),chr(10),'') as creditrestcode
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,t1.creditlim as creditlim
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.conexpdate,chr(13),''),chr(10),'') as conexpdate
,t1.creditrest as creditrest
,replace(replace(t1.contractcode,chr(13),''),chr(10),'') as contractcode
,replace(replace(t1.limloopflg,chr(13),''),chr(10),'') as limloopflg
,replace(replace(t1.creditlimtype,chr(13),''),chr(10),'') as creditlimtype
,replace(replace(t1.cy,chr(13),''),chr(10),'') as cy
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
from ${iol_schema}.icms_credit_creditlimsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_creditlimsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes