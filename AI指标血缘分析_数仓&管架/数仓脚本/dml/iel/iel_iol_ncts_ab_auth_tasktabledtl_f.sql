: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_auth_tasktabledtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_auth_tasktabledtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.txdate as txdate 
,replace(replace(t1.txtime,chr(13),''),chr(10),'') as txtime 
,replace(replace(t1.tradeserno,chr(13),''),chr(10),'') as tradeserno 
,replace(replace(t1.authserno,chr(13),''),chr(10),'') as authserno 
,replace(replace(t1.crtdate,chr(13),''),chr(10),'') as crtdate 
,replace(replace(t1.txorgno,chr(13),''),chr(10),'') as txorgno 
,replace(replace(t1.txtellerno,chr(13),''),chr(10),'') as txtellerno 
,replace(replace(t1.authorgno,chr(13),''),chr(10),'') as authorgno 
,replace(replace(t1.authtellerno,chr(13),''),chr(10),'') as authtellerno 
,replace(replace(t1.auditorgno,chr(13),''),chr(10),'') as auditorgno 
,replace(replace(t1.audittellerno,chr(13),''),chr(10),'') as audittellerno 
,replace(replace(t1.authstatus,chr(13),''),chr(10),'') as authstatus 
,replace(replace(t1.authtasknote,chr(13),''),chr(10),'') as authtasknote 
,replace(replace(t1.authrefusenote,chr(13),''),chr(10),'') as authrefusenote 
,replace(replace(t1.crttime,chr(13),''),chr(10),'') as crttime 
,t1.weight as weight 
,replace(replace(t1.authmodel,chr(13),''),chr(10),'') as authmodel 
,replace(replace(t1.isauthflag,chr(13),''),chr(10),'') as isauthflag 
,replace(replace(t1.txcode,chr(13),''),chr(10),'') as txcode 
,replace(replace(t1.reasoncode,chr(13),''),chr(10),'') as reasoncode 
,replace(replace(t1.barcode,chr(13),''),chr(10),'') as barcode 
,replace(replace(t1.authlevel,chr(13),''),chr(10),'') as authlevel 
,replace(replace(t1.tradestatus,chr(13),''),chr(10),'') as tradestatus 
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode 
,replace(replace(t1.authreturnnote,chr(13),''),chr(10),'') as authreturnnote 
,replace(replace(t1.authcancelnote,chr(13),''),chr(10),'') as authcancelnote 
,replace(replace(t1.returntype,chr(13),''),chr(10),'') as returntype 
,replace(replace(t1.overtime,chr(13),''),chr(10),'') as overtime 
,t1.cartorder as cartorder 
,replace(replace(t1.makeupsn,chr(13),''),chr(10),'') as makeupsn 
,t1.times as times 
,replace(replace(t1.authnote_replenish,chr(13),''),chr(10),'') as authnote_replenish 
,replace(replace(t1.replenish_status,chr(13),''),chr(10),'') as replenish_status 
,replace(replace(t1.auth_replenish_type,chr(13),''),chr(10),'') as auth_replenish_type 
,replace(replace(t1.auth_replenish_note,chr(13),''),chr(10),'') as auth_replenish_note 
,replace(replace(t1.bj_tellerno,chr(13),''),chr(10),'') as bj_tellerno 
,replace(replace(t1.fqbj_tellerno,chr(13),''),chr(10),'') as fqbj_tellerno 
,replace(replace(t1.sh_tellerno,chr(13),''),chr(10),'') as sh_tellerno 
,replace(replace(t1.bj_authtellerno,chr(13),''),chr(10),'') as bj_authtellerno 
,replace(replace(t1.replenish_note,chr(13),''),chr(10),'') as replenish_note 
,replace(replace(t1.replenishflag,chr(13),''),chr(10),'') as replenishflag 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.ncts_ab_auth_tasktabledtl t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_auth_tasktabledtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes