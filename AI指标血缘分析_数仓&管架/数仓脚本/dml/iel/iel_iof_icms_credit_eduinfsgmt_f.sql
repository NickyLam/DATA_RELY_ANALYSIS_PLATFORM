: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_eduinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_eduinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acadegree,chr(13),''),chr(10),'') as acadegree
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.edulevel,chr(13),''),chr(10),'') as edulevel
,replace(replace(t1.eduinfoupdate,chr(13),''),chr(10),'') as eduinfoupdate
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
from ${iol_schema}.icms_credit_eduinfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_eduinfsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes