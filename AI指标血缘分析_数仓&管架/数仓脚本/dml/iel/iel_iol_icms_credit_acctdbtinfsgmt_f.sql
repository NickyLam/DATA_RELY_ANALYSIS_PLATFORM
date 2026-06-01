: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_acctdbtinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_acctdbtinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acctstatus,chr(13),''),chr(10),'') as acctstatus
,replace(replace(t1.remrepprd,chr(13),''),chr(10),'') as remrepprd
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.fivecate,chr(13),''),chr(10),'') as fivecate
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.rpystatus,chr(13),''),chr(10),'') as rpystatus
,replace(replace(t1.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
,t1.totoverd as totoverd
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.overdprd,chr(13),''),chr(10),'') as overdprd
,replace(replace(t1.latrpydate,chr(13),''),chr(10),'') as latrpydate
,replace(replace(t1.extra_info,chr(13),''),chr(10),'') as extra_info
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,t1.latrpyamt as latrpyamt
,t1.acctbal as acctbal
,replace(replace(t1.closedate,chr(13),''),chr(10),'') as closedate
from ${iol_schema}.icms_credit_acctdbtinfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_acctdbtinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes