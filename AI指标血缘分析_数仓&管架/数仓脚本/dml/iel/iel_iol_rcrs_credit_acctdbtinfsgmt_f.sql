: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit_acctdbtinfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit_acctdbtinfsgmt.f.${batch_date}.dat
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
    ,replace(replace(t.acctstatus,chr(13),''),chr(10),'') as acctstatus
    ,t.acctbal as acctbal
    ,replace(replace(t.fivecate,chr(13),''),chr(10),'') as fivecate
    ,replace(replace(t.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
    ,replace(replace(t.remrepprd,chr(13),''),chr(10),'') as remrepprd
    ,replace(replace(t.rpystatus,chr(13),''),chr(10),'') as rpystatus
    ,replace(replace(t.overdprd,chr(13),''),chr(10),'') as overdprd
    ,t.totoverd as totoverd
    ,t.latrpyamt as latrpyamt
    ,replace(replace(t.latrpydate,chr(13),''),chr(10),'') as latrpydate
    ,replace(replace(t.closedate,chr(13),''),chr(10),'') as closedate
    ,replace(replace(t.extra_info,chr(13),''),chr(10),'') as extra_info
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit_acctdbtinfsgmt    t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit_acctdbtinfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes