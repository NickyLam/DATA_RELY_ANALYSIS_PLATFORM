: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_acctbsinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_acctbsinfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.loanform,chr(13),''),chr(10),'') as loanform
,replace(replace(t1.busilines,chr(13),''),chr(10),'') as busilines
,t1.loanamt as loanamt
,replace(replace(t1.guarmode,chr(13),''),chr(10),'') as guarmode
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.assettrandflag,chr(13),''),chr(10),'') as assettrandflag
,replace(replace(t1.loanconcode,chr(13),''),chr(10),'') as loanconcode
,replace(replace(t1.duedate,chr(13),''),chr(10),'') as duedate
,replace(replace(t1.firsthouloanflag,chr(13),''),chr(10),'') as firsthouloanflag
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.creditid,chr(13),''),chr(10),'') as creditid
,replace(replace(t1.busidtllines,chr(13),''),chr(10),'') as busidtllines
,replace(replace(t1.applybusidist,chr(13),''),chr(10),'') as applybusidist
,t1.acctcredline as acctcredline
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.othrepyguarway,chr(13),''),chr(10),'') as othrepyguarway
,replace(replace(t1.repaymode,chr(13),''),chr(10),'') as repaymode
,replace(replace(t1.repayfreqcy,chr(13),''),chr(10),'') as repayfreqcy
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.repayprd,chr(13),''),chr(10),'') as repayprd
,replace(replace(t1.fundsou,chr(13),''),chr(10),'') as fundsou
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
from ${iol_schema}.icms_credit_acctbsinfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_acctbsinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes