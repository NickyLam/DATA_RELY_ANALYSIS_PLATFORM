: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_fcsinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_fcsinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.fcsinfoupdate,chr(13),''),chr(10),'') as fcsinfoupdate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
    ,replace(replace(t.dob,chr(13),''),chr(10),'') as dob
    ,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
    ,replace(replace(t.houseadd,chr(13),''),chr(10),'') as houseadd
    ,replace(replace(t.hhdist,chr(13),''),chr(10),'') as hhdist
    ,replace(replace(t.cellphone,chr(13),''),chr(10),'') as cellphone
    ,replace(replace(t.email,chr(13),''),chr(10),'') as email
from iol.rcrs_credit_fcsinfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_fcsinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes