: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_acctmthlyblginfsgmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit_acctmthlyblginfsgmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.pridacctbal as pridacctbal
,t1.usedamt as usedamt
,replace(replace(t1.overdprd,chr(13),''),chr(10),'') as overdprd
,t1.notisubal as notisubal
,replace(replace(t1.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
,t1.ovedrawbaove180 as ovedrawbaove180
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,t1.acctbal as acctbal
,t1.oved91_180princ as oved91_180princ
,t1.latrpyamt as latrpyamt
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,t1.currpyamt as currpyamt
,t1.totoverd as totoverd
,t1.oved61_90princ as oved61_90princ
,replace(replace(t1.settdate,chr(13),''),chr(10),'') as settdate
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,t1.oved31_60princ as oved31_60princ
,replace(replace(t1.latrpydate,chr(13),''),chr(10),'') as latrpydate
,replace(replace(t1.top_deptcode,chr(13),''),chr(10),'') as top_deptcode
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.month,chr(13),''),chr(10),'') as month
,replace(replace(t1.acctstatus,chr(13),''),chr(10),'') as acctstatus
,t1.actrpyamt as actrpyamt
,replace(replace(t1.rpyprct,chr(13),''),chr(10),'') as rpyprct
,replace(replace(t1.closedate,chr(13),''),chr(10),'') as closedate
,replace(replace(t1.extra_info,chr(13),''),chr(10),'') as extra_info
,t1.ovedprinc180 as ovedprinc180
,replace(replace(t1.fivecate,chr(13),''),chr(10),'') as fivecate
,replace(replace(t1.remrepprd,chr(13),''),chr(10),'') as remrepprd
,replace(replace(t1.rpystatus,chr(13),''),chr(10),'') as rpystatus
,t1.overdprinc as overdprinc
from ${iol_schema}.icms_credit_acctmthlyblginfsgmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_acctmthlyblginfsgmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes