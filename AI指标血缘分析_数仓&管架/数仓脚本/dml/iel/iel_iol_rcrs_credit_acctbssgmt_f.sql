: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_acctbssgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_acctbssgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.accttype,chr(13),''),chr(10),'') as accttype
    ,replace(replace(t.acctcode,chr(13),''),chr(10),'') as acctcode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
from iol.rcrs_credit_acctbssgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_acctbssgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes