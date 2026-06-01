: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_acctspectrstdspnsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_acctspectrstdspnsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.cagoftrdnm,chr(13),''),chr(10),'') as cagoftrdnm
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.detinfo,chr(13),''),chr(10),'') as detinfo
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.chantrantype,chr(13),''),chr(10),'') as chantrantype
,replace(replace(t1.tranamt,chr(13),''),chr(10),'') as tranamt
,replace(replace(t1.duetranmon,chr(13),''),chr(10),'') as duetranmon
from ${iol_schema}.icms_credit_acctspectrstdspnsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_acctspectrstdspnsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes