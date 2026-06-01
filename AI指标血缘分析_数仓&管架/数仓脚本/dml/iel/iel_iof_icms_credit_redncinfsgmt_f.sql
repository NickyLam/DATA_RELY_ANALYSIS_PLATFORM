: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_redncinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_redncinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.hometel,chr(13),''),chr(10),'') as hometel
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.resiinfoupdate,chr(13),''),chr(10),'') as resiinfoupdate
,replace(replace(t1.resistatus,chr(13),''),chr(10),'') as resistatus
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.resipc,chr(13),''),chr(10),'') as resipc
,replace(replace(t1.resiaddr,chr(13),''),chr(10),'') as resiaddr
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.residist,chr(13),''),chr(10),'') as residist
from ${iol_schema}.icms_credit_redncinfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_redncinfsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes