: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_octpninfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_octpninfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.cpntype,chr(13),''),chr(10),'') as cpntype
,replace(replace(t1.cpnpc,chr(13),''),chr(10),'') as cpnpc
,replace(replace(t1.cpnname,chr(13),''),chr(10),'') as cpnname
,replace(replace(t1.cpnaddr,chr(13),''),chr(10),'') as cpnaddr
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.empstatus,chr(13),''),chr(10),'') as empstatus
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.workstartdate,chr(13),''),chr(10),'') as workstartdate
,replace(replace(t1.techtitle,chr(13),''),chr(10),'') as techtitle
,replace(replace(t1.octpninfoupdate,chr(13),''),chr(10),'') as octpninfoupdate
,replace(replace(t1.cpndist,chr(13),''),chr(10),'') as cpndist
,replace(replace(t1.cpntel,chr(13),''),chr(10),'') as cpntel
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.title,chr(13),''),chr(10),'') as title
from ${iol_schema}.icms_credit_octpninfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_octpninfsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes