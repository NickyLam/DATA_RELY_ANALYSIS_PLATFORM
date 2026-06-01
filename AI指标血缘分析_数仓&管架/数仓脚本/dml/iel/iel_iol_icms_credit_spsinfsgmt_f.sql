: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_spsinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_spsinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.spsinfoupdate,chr(13),''),chr(10),'') as spsinfoupdate
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.spotel,chr(13),''),chr(10),'') as spotel
,replace(replace(t1.spoidtype,chr(13),''),chr(10),'') as spoidtype
,replace(replace(t1.spscmpynm,chr(13),''),chr(10),'') as spscmpynm
,replace(replace(t1.spoidnum,chr(13),''),chr(10),'') as spoidnum
,replace(replace(t1.maristatus,chr(13),''),chr(10),'') as maristatus
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.sponame,chr(13),''),chr(10),'') as sponame
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
from ${iol_schema}.icms_credit_spsinfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_spsinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes