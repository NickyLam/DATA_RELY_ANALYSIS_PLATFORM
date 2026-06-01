: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_bssgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_bssgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.infsurccode,chr(13),''),chr(10),'') as infsurccode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
    ,replace(replace(t.cimoc,chr(13),''),chr(10),'') as cimoc
    ,replace(replace(t.customertype,chr(13),''),chr(10),'') as customertype
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_bssgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_bssgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes