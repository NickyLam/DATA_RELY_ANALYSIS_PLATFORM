: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_spsinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_spsinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.maristatus,chr(13),''),chr(10),'') as maristatus
    ,replace(replace(t.sponame,chr(13),''),chr(10),'') as sponame
    ,replace(replace(t.spoidtype,chr(13),''),chr(10),'') as spoidtype
    ,replace(replace(t.spoidnum,chr(13),''),chr(10),'') as spoidnum
    ,replace(replace(t.spotel,chr(13),''),chr(10),'') as spotel
    ,replace(replace(t.spscmpynm,chr(13),''),chr(10),'') as spscmpynm
    ,replace(replace(t.spsinfoupdate,chr(13),''),chr(10),'') as spsinfoupdate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_spsinfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_spsinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes