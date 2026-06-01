: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_octpninfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_octpninfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.empstatus,chr(13),''),chr(10),'') as empstatus
    ,replace(replace(t.cpnname,chr(13),''),chr(10),'') as cpnname
    ,replace(replace(t.cpntype,chr(13),''),chr(10),'') as cpntype
    ,replace(replace(t.industry,chr(13),''),chr(10),'') as industry
    ,replace(replace(t.cpnaddr,chr(13),''),chr(10),'') as cpnaddr
    ,replace(replace(t.cpnpc,chr(13),''),chr(10),'') as cpnpc
    ,replace(replace(t.cpndist,chr(13),''),chr(10),'') as cpndist
    ,replace(replace(t.cpntel,chr(13),''),chr(10),'') as cpntel
    ,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
    ,replace(replace(t.title,chr(13),''),chr(10),'') as title
    ,replace(replace(t.techtitle,chr(13),''),chr(10),'') as techtitle
    ,replace(replace(t.workstartdate,chr(13),''),chr(10),'') as workstartdate
    ,replace(replace(t.octpninfoupdate,chr(13),''),chr(10),'') as octpninfoupdate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_octpninfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_octpninfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes