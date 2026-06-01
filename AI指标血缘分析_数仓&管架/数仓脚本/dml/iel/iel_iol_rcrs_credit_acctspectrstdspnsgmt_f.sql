: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_acctspectrstdspnsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_acctspectrstdspnsgmt.f.${batch_date}.dat
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
    ,replace(replace(t.cagoftrdnm,chr(13),''),chr(10),'') as cagoftrdnm
    ,replace(replace(t.chantrantype,chr(13),''),chr(10),'') as chantrantype
    ,replace(replace(t.trandate,chr(13),''),chr(10),'') as trandate
    ,replace(replace(t.tranamt,chr(13),''),chr(10),'') as tranamt
    ,replace(replace(t.duetranmon,chr(13),''),chr(10),'') as duetranmon
    ,replace(replace(t.detinfo,chr(13),''),chr(10),'') as detinfo
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_acctspectrstdspnsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_acctspectrstdspnsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes