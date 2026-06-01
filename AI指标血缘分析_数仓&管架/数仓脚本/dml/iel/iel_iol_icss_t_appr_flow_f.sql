: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_appr_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_appr_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.jddate,chr(13),''),chr(10),'') as jddate
,replace(replace(t.fchkuser,chr(13),''),chr(10),'') as fchkuser
,replace(replace(t.fchksubdate,chr(13),''),chr(10),'') as fchksubdate
,replace(replace(t.schkuser,chr(13),''),chr(10),'') as schkuser
,replace(replace(t.subschkdate,chr(13),''),chr(10),'') as subschkdate
,replace(replace(t.schksubdate,chr(13),''),chr(10),'') as schksubdate
,replace(replace(t.fchkbckdate,chr(13),''),chr(10),'') as fchkbckdate
,replace(replace(t.fchkagsubdate,chr(13),''),chr(10),'') as fchkagsubdate
,replace(replace(t.supdonedate,chr(13),''),chr(10),'') as supdonedate
,replace(replace(t.tshsession,chr(13),''),chr(10),'') as tshsession
,replace(replace(t.subtype,chr(13),''),chr(10),'') as subtype
,replace(replace(t.distchkdate,chr(13),''),chr(10),'') as distchkdate
,t.distchkdays as distchkdays
,t.totalchkdays as totalchkdays
,t.eff1 as eff1
,t.eff2 as eff2
,replace(replace(t.isontime,chr(13),''),chr(10),'') as isontime
,t.supfiledate as supfiledate
,replace(replace(t.headchkuser,chr(13),''),chr(10),'') as headchkuser
,replace(replace(t.rightchkperson,chr(13),''),chr(10),'') as rightchkperson
,replace(replace(t.conclusion,chr(13),''),chr(10),'') as conclusion
,replace(replace(t.backreson,chr(13),''),chr(10),'') as backreson
from ${iol_schema}.icss_t_appr_flow t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_appr_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes