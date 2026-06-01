: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_uxds_f_yzgais02002_request_f
CreateDate: 20250318
FileName:   ${iel_data_path}/uxds_f_yzgais02002_request.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.gendate,chr(13),''),chr(10),'') as gendate
,replace(replace(t1.serialnumber,chr(13),''),chr(10),'') as serialnumber
,replace(replace(t1.sequenceid,chr(13),''),chr(10),'') as sequenceid
,replace(replace(t1.srv_scen_cd,chr(13),''),chr(10),'') as srv_scen_cd
,replace(replace(t1.src_init_sys_id,chr(13),''),chr(10),'') as src_init_sys_id
,replace(replace(t1.srv_cllpty_sys_id,chr(13),''),chr(10),'') as srv_cllpty_sys_id
,replace(replace(t1.srv_cllpty_trx_seq,chr(13),''),chr(10),'') as srv_cllpty_trx_seq
,replace(replace(t1.srv_cllpty_trx_dt,chr(13),''),chr(10),'') as srv_cllpty_trx_dt
,replace(replace(t1.srv_cllpty_txn_tm,chr(13),''),chr(10),'') as srv_cllpty_txn_tm
,replace(replace(t1.srv_tgt_sys_id,chr(13),''),chr(10),'') as srv_tgt_sys_id
,replace(replace(t1.txn_org_cd,chr(13),''),chr(10),'') as txn_org_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.deponame,chr(13),''),chr(10),'') as deponame
,replace(replace(t1.uniscid,chr(13),''),chr(10),'') as uniscid
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.legalname,chr(13),''),chr(10),'') as legalname
,replace(replace(t1.legalldtype,chr(13),''),chr(10),'') as legalldtype
,replace(replace(t1.legalldno,chr(13),''),chr(10),'') as legalldno
,replace(replace(t1.legalcontel,chr(13),''),chr(10),'') as legalcontel
,replace(replace(t1.handlpernameother,chr(13),''),chr(10),'') as handlpernameother
,replace(replace(t1.handlidtypeother,chr(13),''),chr(10),'') as handlidtypeother
,replace(replace(t1.andlidnoother,chr(13),''),chr(10),'') as andlidnoother
,replace(replace(t1.handlcontelother,chr(13),''),chr(10),'') as handlcontelother
,replace(replace(t1.genmonth,chr(13),''),chr(10),'') as genmonth
,replace(replace(t1.msgid,chr(13),''),chr(10),'') as msgid

from ${iol_schema}.uxds_f_yzgais02002_request t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_f_yzgais02002_request.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
