: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_rltrepymtinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_rltrepymtinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.acctcode,chr(13),''),chr(10),'') as acctcode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rltrepymtnm,chr(13),''),chr(10),'') as rltrepymtnm
    ,replace(replace(t.infoidtype,chr(13),''),chr(10),'') as infoidtype
    ,replace(replace(t.arlpname,chr(13),''),chr(10),'') as arlpname
    ,replace(replace(t.arlpcerttype,chr(13),''),chr(10),'') as arlpcerttype
    ,replace(replace(t.arlpcertnum,chr(13),''),chr(10),'') as arlpcertnum
    ,replace(replace(t.arlptype,chr(13),''),chr(10),'') as arlptype
    ,t.arlpamt as arlpamt
    ,replace(replace(t.wartysign,chr(13),''),chr(10),'') as wartysign
    ,replace(replace(t.maxguarmcc,chr(13),''),chr(10),'') as maxguarmcc
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_rltrepymtinfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_rltrepymtinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes