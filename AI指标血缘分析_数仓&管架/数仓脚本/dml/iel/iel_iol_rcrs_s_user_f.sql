: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_s_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_s_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.actorno,chr(13),''),chr(10),'') as actorno
    ,replace(replace(t.actorname,chr(13),''),chr(10),'') as actorname
    ,replace(replace(t.nickname,chr(13),''),chr(10),'') as nickname
    ,replace(replace(t.state,chr(13),''),chr(10),'') as state
    ,replace(replace(t.password,chr(13),''),chr(10),'') as password
    ,replace(replace(t.startdate,chr(13),''),chr(10),'') as startdate
    ,replace(replace(t.passwvalda,chr(13),''),chr(10),'') as passwvalda
    ,replace(replace(t.firedate,chr(13),''),chr(10),'') as firedate
    ,replace(replace(t.birthday,chr(13),''),chr(10),'') as birthday
    ,replace(replace(t.telnum,chr(13),''),chr(10),'') as telnum
    ,replace(replace(t.idcardno,chr(13),''),chr(10),'') as idcardno
    ,replace(replace(t.allowopersys,chr(13),''),chr(10),'') as allowopersys
    ,replace(replace(t.lastlogdat,chr(13),''),chr(10),'') as lastlogdat
    ,replace(replace(t.creater,chr(13),''),chr(10),'') as creater
    ,replace(replace(t.creattime,chr(13),''),chr(10),'') as creattime
    ,replace(replace(t.usermail,chr(13),''),chr(10),'') as usermail
    ,t.wrongpinnum as wrongpinnum
    ,replace(replace(t.isadmin,chr(13),''),chr(10),'') as isadmin
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.ipmask,chr(13),''),chr(10),'') as ipmask
    ,t.orderno as orderno
    ,replace(replace(t.question,chr(13),''),chr(10),'') as question
    ,replace(replace(t.answer,chr(13),''),chr(10),'') as answer
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.degree,chr(13),''),chr(10),'') as degree
    ,replace(replace(t.prft,chr(13),''),chr(10),'') as prft
    ,replace(replace(t.qulf,chr(13),''),chr(10),'') as qulf
    ,replace(replace(t.curr_stat,chr(13),''),chr(10),'') as curr_stat
    ,replace(replace(t.is_conf_mem,chr(13),''),chr(10),'') as is_conf_mem
    ,replace(replace(t.is_risk_mem,chr(13),''),chr(10),'') as is_risk_mem
    ,replace(replace(t.actor_duty,chr(13),''),chr(10),'') as actor_duty
    ,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
    ,replace(replace(t.login_type,chr(13),''),chr(10),'') as login_type
    ,replace(replace(t.session_id,chr(13),''),chr(10),'') as session_id
    ,replace(replace(t.if_msg,chr(13),''),chr(10),'') as if_msg
    ,replace(replace(t.oid,chr(13),''),chr(10),'') as oid
    ,replace(replace(t.enname,chr(13),''),chr(10),'') as enname
    ,replace(replace(t.parentactorno,chr(13),''),chr(10),'') as parentactorno
    ,replace(replace(t.perm_qry,chr(13),''),chr(10),'') as perm_qry
    ,replace(replace(t.perm_upt,chr(13),''),chr(10),'') as perm_upt
    ,replace(replace(t.last_upd_date,chr(13),''),chr(10),'') as last_upd_date
    ,replace(replace(t.showifr,chr(13),''),chr(10),'') as showifr
    ,replace(replace(t.fina_br_id,chr(13),''),chr(10),'') as fina_br_id
    ,replace(replace(t.employeeid,chr(13),''),chr(10),'') as employeeid
    ,replace(replace(t.domainid,chr(13),''),chr(10),'') as domainid
    ,replace(replace(t.tellerno,chr(13),''),chr(10),'') as tellerno
    ,replace(replace(t.status,chr(13),''),chr(10),'') as status
    ,replace(replace(t.upt_manager,chr(13),''),chr(10),'') as upt_manager
    ,replace(replace(t.wfi_if_msg,chr(13),''),chr(10),'') as wfi_if_msg
    ,replace(replace(t.login_ip,chr(13),''),chr(10),'') as login_ip
    ,replace(replace(t.is_single_sign,chr(13),''),chr(10),'') as is_single_sign
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_s_user t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_s_user.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes