: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_appr_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_appr_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.jddate,chr(13),''),chr(10),'') as jddate
,replace(replace(t1.fchkuser,chr(13),''),chr(10),'') as fchkuser
,replace(replace(t1.fchksubdate,chr(13),''),chr(10),'') as fchksubdate
,replace(replace(t1.schkuser,chr(13),''),chr(10),'') as schkuser
,replace(replace(t1.subschkdate,chr(13),''),chr(10),'') as subschkdate
,replace(replace(t1.schksubdate,chr(13),''),chr(10),'') as schksubdate
,replace(replace(t1.fchkbckdate,chr(13),''),chr(10),'') as fchkbckdate
,replace(replace(t1.fchkagsubdate,chr(13),''),chr(10),'') as fchkagsubdate
,replace(replace(t1.supdonedate,chr(13),''),chr(10),'') as supdonedate
,replace(replace(t1.tshsession,chr(13),''),chr(10),'') as tshsession
,replace(replace(t1.subtype,chr(13),''),chr(10),'') as subtype
,replace(replace(t1.distchkdate,chr(13),''),chr(10),'') as distchkdate
,t1.distchkdays as distchkdays
,t1.totalchkdays as totalchkdays
,t1.eff1 as eff1
,t1.eff2 as eff2
,replace(replace(t1.isontime,chr(13),''),chr(10),'') as isontime
,t1.supfiledate as supfiledate
,replace(replace(t1.headchkuser,chr(13),''),chr(10),'') as headchkuser
,replace(replace(t1.rightchkperson,chr(13),''),chr(10),'') as rightchkperson
,replace(replace(t1.conclusion,chr(13),''),chr(10),'') as conclusion
,replace(replace(t1.backreson,chr(13),''),chr(10),'') as backreson
 from iol.icss_t_appr_flow T1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_appr_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes