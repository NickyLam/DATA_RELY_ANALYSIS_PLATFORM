: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_creditlimsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_creditlimsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.contractcode,chr(13),''),chr(10),'') as contractcode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.creditlimtype,chr(13),''),chr(10),'') as creditlimtype
    ,replace(replace(t.limloopflg,chr(13),''),chr(10),'') as limloopflg
    ,t.creditlim as creditlim
    ,replace(replace(t.cy,chr(13),''),chr(10),'') as cy
    ,replace(replace(t.coneffdate,chr(13),''),chr(10),'') as coneffdate
    ,replace(replace(t.conexpdate,chr(13),''),chr(10),'') as conexpdate
    ,replace(replace(t.constatus,chr(13),''),chr(10),'') as constatus
    ,t.creditrest as creditrest
    ,replace(replace(t.creditrestcode,chr(13),''),chr(10),'') as creditrestcode
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_creditlimsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_creditlimsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes