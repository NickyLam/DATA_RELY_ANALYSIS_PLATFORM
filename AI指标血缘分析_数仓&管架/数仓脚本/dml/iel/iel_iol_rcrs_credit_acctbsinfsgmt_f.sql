: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_acctbsinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_acctbsinfsgmt.f.${batch_date}.dat
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
    ,replace(replace(t.busilines,chr(13),''),chr(10),'') as busilines
    ,replace(replace(t.busidtllines,chr(13),''),chr(10),'') as busidtllines
    ,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
    ,replace(replace(t.ccy,chr(13),''),chr(10),'') as ccy
    ,t.acctcredline as acctcredline
    ,t.loanamt as loanamt
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,replace(replace(t.duedate,chr(13),''),chr(10),'') as duedate
    ,replace(replace(t.repaymode,chr(13),''),chr(10),'') as repaymode
    ,replace(replace(t.repayfreqcy,chr(13),''),chr(10),'') as repayfreqcy
    ,replace(replace(t.repayprd,chr(13),''),chr(10),'') as repayprd
    ,replace(replace(t.applybusidist,chr(13),''),chr(10),'') as applybusidist
    ,replace(replace(t.guarmode,chr(13),''),chr(10),'') as guarmode
    ,replace(replace(t.othrepyguarway,chr(13),''),chr(10),'') as othrepyguarway
    ,replace(replace(t.assettrandflag,chr(13),''),chr(10),'') as assettrandflag
    ,replace(replace(t.fundsou,chr(13),''),chr(10),'') as fundsou
    ,replace(replace(t.loanform,chr(13),''),chr(10),'') as loanform
    ,replace(replace(t.creditid,chr(13),''),chr(10),'') as creditid
    ,replace(replace(t.loanconcode,chr(13),''),chr(10),'') as loanconcode
    ,replace(replace(t.firsthouloanflag,chr(13),''),chr(10),'') as firsthouloanflag
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_acctbsinfsgmt  t  
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_acctbsinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes