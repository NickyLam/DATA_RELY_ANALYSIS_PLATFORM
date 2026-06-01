: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_credit_ctrctcertrelsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_ctrctcertrelsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.contractcode,chr(13),''),chr(10),'') as contractcode
,replace(replace(t1.certrelidnum,chr(13),''),chr(10),'') as certrelidnum
,replace(replace(t1.certrelidtype,chr(13),''),chr(10),'') as certrelidtype
,replace(replace(t1.brernm,chr(13),''),chr(10),'') as brernm
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.certrelname,chr(13),''),chr(10),'') as certrelname
,replace(replace(t1.brertype,chr(13),''),chr(10),'') as brertype
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
from ${iol_schema}.icms_credit_ctrctcertrelsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_ctrctcertrelsgmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes