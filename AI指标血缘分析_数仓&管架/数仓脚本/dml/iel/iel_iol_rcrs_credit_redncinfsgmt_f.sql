: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_redncinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_redncinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.resistatus,chr(13),''),chr(10),'') as resistatus
    ,replace(replace(t.resiaddr,chr(13),''),chr(10),'') as resiaddr
    ,replace(replace(t.resipc,chr(13),''),chr(10),'') as resipc
    ,replace(replace(t.residist,chr(13),''),chr(10),'') as residist
    ,replace(replace(t.hometel,chr(13),''),chr(10),'') as hometel
    ,replace(replace(t.resiinfoupdate,chr(13),''),chr(10),'') as resiinfoupdate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_redncinfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_redncinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes