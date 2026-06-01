: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_tbps_cpr_login_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbps_cpr_login_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.clf_logno,chr(13),''),chr(10),'') as clf_logno
,replace(replace(t1.clf_userno,chr(13),''),chr(10),'') as clf_userno
,replace(replace(t1.clf_ecifno,chr(13),''),chr(10),'') as clf_ecifno
,replace(replace(t1.clf_state,chr(13),''),chr(10),'') as clf_state
,replace(replace(t1.clf_date,chr(13),''),chr(10),'') as clf_date
,replace(replace(t1.clf_time,chr(13),''),chr(10),'') as clf_time
,replace(replace(t1.clf_customerip,chr(13),''),chr(10),'') as clf_customerip
,replace(replace(t1.clf_channel,chr(13),''),chr(10),'') as clf_channel
,replace(replace(t1.clf_logintype,chr(13),''),chr(10),'') as clf_logintype
,replace(replace(t1.clf_returncode,chr(13),''),chr(10),'') as clf_returncode
,replace(replace(t1.clf_returnmsg,chr(13),''),chr(10),'') as clf_returnmsg
,replace(replace(t1.clf_ifp_sid,chr(13),''),chr(10),'') as clf_ifp_sid
,replace(replace(t1.clf_hostip,chr(13),''),chr(10),'') as clf_hostip
,replace(replace(t1.clf_wxcode,chr(13),''),chr(10),'') as clf_wxcode
,replace(replace(t1.clf_useragent,chr(13),''),chr(10),'') as clf_useragent
,replace(replace(t1.clf_token,chr(13),''),chr(10),'') as clf_token
,replace(replace(t1.clf_globalflow,chr(13),''),chr(10),'') as clf_globalflow
,replace(replace(t1.clf_clientmac,chr(13),''),chr(10),'') as clf_clientmac
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.tbps_cpr_login_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_login_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes