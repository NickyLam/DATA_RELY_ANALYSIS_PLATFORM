: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_appr_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_appr_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.serialno
,t1.status
,t1.jddate
,t1.fchkuser
,t1.fchksubdate
,t1.schkuser
,t1.subschkdate
,t1.schksubdate
,t1.fchkbckdate
,t1.fchkagsubdate
,t1.supdonedate
,t1.tshsession
,t1.subtype
,t1.distchkdate
,t1.distchkdays
,t1.totalchkdays
,t1.eff1
,t1.eff2
,t1.isontime
,t1.supfiledate
,t1.headchkuser
,t1.rightchkperson
,t1.conclusion
,t1.backreson
from ${idl_schema}.hdws_icss_t_appr_flow t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_appr_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes