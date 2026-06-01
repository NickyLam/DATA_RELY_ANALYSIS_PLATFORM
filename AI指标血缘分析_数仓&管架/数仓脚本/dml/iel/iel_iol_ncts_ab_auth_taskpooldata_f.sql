: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_auth_taskpooldata_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_auth_taskpooldata.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.authdate,chr(13),''),chr(10),'') as authdate 
,replace(replace(t1.authserno,chr(13),''),chr(10),'') as authserno 
,replace(replace(t1.authorgno,chr(13),''),chr(10),'') as authorgno 
,replace(replace(t1.taskpoolid,chr(13),''),chr(10),'') as taskpoolid 
,replace(replace(t1.authlevel,chr(13),''),chr(10),'') as authlevel 
,replace(replace(t1.entrytime,chr(13),''),chr(10),'') as entrytime 
,replace(replace(t1.outtime,chr(13),''),chr(10),'') as outtime 
,t1.waittime as waittime 
,replace(replace(t1.status,chr(13),''),chr(10),'') as status 
,replace(replace(t1.authtellerno,chr(13),''),chr(10),'') as authtellerno 
,t1.weight as weight 
,replace(replace(t1.aboid,chr(13),''),chr(10),'') as aboid 
,replace(replace(t1.tradeid,chr(13),''),chr(10),'') as tradeid 
,replace(replace(t1.tradeserno,chr(13),''),chr(10),'') as tradeserno 
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag 
,replace(replace(t1.queuenum,chr(13),''),chr(10),'') as queuenum 
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode 
,t1.cartorder as cartorder 
,replace(replace(t1.makeupsn,chr(13),''),chr(10),'') as makeupsn 
,t1.times as times 
,replace(replace(t1.replenish_status,chr(13),''),chr(10),'') as replenish_status 
,replace(replace(t1.bj_tellerno,chr(13),''),chr(10),'') as bj_tellerno 
,replace(replace(t1.fqbj_tellerno,chr(13),''),chr(10),'') as fqbj_tellerno 
,replace(replace(t1.bj_authtellerno,chr(13),''),chr(10),'') as bj_authtellerno 
,replace(replace(t1.fqbj_date,chr(13),''),chr(10),'') as fqbj_date 
,replace(replace(t1.fqbj_time,chr(13),''),chr(10),'') as fqbj_time 
,replace(replace(t1.bj_authdate,chr(13),''),chr(10),'') as bj_authdate 
,replace(replace(t1.bj_authtime,chr(13),''),chr(10),'') as bj_authtime 
,replace(replace(t1.bj_successtime,chr(13),''),chr(10),'') as bj_successtime 
,replace(replace(t1.bj_lastoptdate,chr(13),''),chr(10),'') as bj_lastoptdate 
,replace(replace(t1.replenishflag,chr(13),''),chr(10),'') as replenishflag 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.ncts_ab_auth_taskpooldata t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_auth_taskpooldata.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes