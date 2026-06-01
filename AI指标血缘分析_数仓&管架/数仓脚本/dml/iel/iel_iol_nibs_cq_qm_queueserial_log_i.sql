: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_cq_qm_queueserial_log_i
CreateDate: 20251128
FileName:   ${iel_data_path}/nibs_cq_qm_queueserial_log.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.deviceno,chr(13),''),chr(10),'') as deviceno
,replace(replace(t1.queuegetserno,chr(13),''),chr(10),'') as queuegetserno
,replace(replace(t1.queuegetchannel,chr(13),''),chr(10),'') as queuegetchannel
,queuegettime
,replace(replace(t1.queuetppreletter,chr(13),''),chr(10),'') as queuetppreletter
,replace(replace(t1.queuetpprenum,chr(13),''),chr(10),'') as queuetpprenum
,replace(replace(t1.queueno,chr(13),''),chr(10),'') as queueno
,replace(replace(t1.queuetpchkcode,chr(13),''),chr(10),'') as queuetpchkcode
,replace(replace(t1.queuetpstatus,chr(13),''),chr(10),'') as queuetpstatus
,replace(replace(t1.bsid,chr(13),''),chr(10),'') as bsid
,replace(replace(t1.queuetpid,chr(13),''),chr(10),'') as queuetpid
,replace(replace(t1.custgrd,chr(13),''),chr(10),'') as custgrd
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idcode,chr(13),''),chr(10),'') as idcode
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.telno,chr(13),''),chr(10),'') as telno
,replace(replace(t1.cardno,chr(13),''),chr(10),'') as cardno
,replace(replace(t1.reserveflag,chr(13),''),chr(10),'') as reserveflag
,replace(replace(t1.reserveid,chr(13),''),chr(10),'') as reserveid
,replace(replace(t1.isbill,chr(13),''),chr(10),'') as isbill
,waittime
,transfertime
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno
,sleeptime
,replace(replace(t1.assdqueueno,chr(13),''),chr(10),'') as assdqueueno
,replace(replace(t1.queuecallseq,chr(13),''),chr(10),'') as queuecallseq
,queuecalltime
,replace(replace(t1.winno,chr(13),''),chr(10),'') as winno
,replace(replace(t1.queuecalltp,chr(13),''),chr(10),'') as queuecalltp
,transfernum
,startservtime
,finishservtime
,servetime
,replace(replace(t1.queuecalltlrno,chr(13),''),chr(10),'') as queuecalltlrno
,replace(replace(t1.custphoto,chr(13),''),chr(10),'') as custphoto
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
,replace(replace(t1.wddeviceno,chr(13),''),chr(10),'') as wddeviceno
,replace(replace(t1.queueadjtime,chr(13),''),chr(10),'') as queueadjtime
,replace(replace(t1.usernum,chr(13),''),chr(10),'') as usernum
,replace(replace(t1.holidayfalg,chr(13),''),chr(10),'') as holidayfalg
,replace(replace(t1.custserialnum,chr(13),''),chr(10),'') as custserialnum
,replace(replace(t1.minwaitnum,chr(13),''),chr(10),'') as minwaitnum
,replace(replace(t1.handlewinno,chr(13),''),chr(10),'') as handlewinno
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,replace(replace(t1.noticeflag,chr(13),''),chr(10),'') as noticeflag
,replace(replace(t1.bsname,chr(13),''),chr(10),'') as bsname

from ${iol_schema}.nibs_cq_qm_queueserial_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_cq_qm_queueserial_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
