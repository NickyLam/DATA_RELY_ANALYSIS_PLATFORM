: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibss_wx_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibss_wx_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.userseq as userseq
    ,replace(replace(t.tousername,chr(13),''),chr(10),'') as tousername
    ,replace(replace(t.openid,chr(13),''),chr(10),'') as openid
    ,replace(replace(t.cifno,chr(13),''),chr(10),'') as cifno
    ,replace(replace(t.userstate,chr(13),''),chr(10),'') as userstate
    ,t.binddate as binddate
    ,t.unbinddate as unbinddate
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idno,chr(13),''),chr(10),'') as idno
    ,replace(replace(t.ciflevel,chr(13),''),chr(10),'') as ciflevel
    ,t.cifseq as cifseq
    ,replace(replace(t.password,chr(13),''),chr(10),'') as password
    ,replace(replace(t.userpausestate,chr(13),''),chr(10),'') as userpausestate
    ,t.pausedate as pausedate
    ,t.pauseenddate as pauseenddate
    ,replace(replace(t.userfreezestate,chr(13),''),chr(10),'') as userfreezestate
    ,replace(replace(t.pwdstate,chr(13),''),chr(10),'') as pwdstate
    ,t.pwdlockdate as pwdlockdate
    ,t.pwdfailcount as pwdfailcount
    ,replace(replace(t.finstate,chr(13),''),chr(10),'') as finstate
    ,t.findate as findate
    ,replace(replace(t.prdcode,chr(13),''),chr(10),'') as prdcode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibss_wx_user t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibss_wx_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes