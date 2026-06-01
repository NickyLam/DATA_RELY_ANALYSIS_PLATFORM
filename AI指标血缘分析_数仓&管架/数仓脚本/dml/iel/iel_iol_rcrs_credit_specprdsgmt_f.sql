: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_specprdsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_specprdsgmt.f.${batch_date}.dat
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
    ,t.specline as specline
    ,replace(replace(t.specefctdate,chr(13),''),chr(10),'') as specefctdate
    ,replace(replace(t.specenddate,chr(13),''),chr(10),'') as specenddate
    ,t.usedinstamt as usedinstamt
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_specprdsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_specprdsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes