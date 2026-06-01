: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a51ubelecashtranlog_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a51ubelecashtranlog.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.filedate,chr(13),''),chr(10),'') as filedate
,replace(replace(t.gatetype,chr(13),''),chr(10),'') as gatetype
,replace(replace(t.fwdinstid,chr(13),''),chr(10),'') as fwdinstid
,replace(replace(t.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t.acqinstid,chr(13),''),chr(10),'') as acqinstid
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.settlmtdate,chr(13),''),chr(10),'') as settlmtdate
,replace(replace(t.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t.cardsq,chr(13),''),chr(10),'') as cardsq
,replace(replace(t.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.tranam as tranam
,replace(replace(t.provstatus,chr(13),''),chr(10),'') as provstatus
,replace(replace(t.merctp,chr(13),''),chr(10),'') as merctp
,replace(replace(t.termid,chr(13),''),chr(10),'') as termid
,replace(replace(t.mercid,chr(13),''),chr(10),'') as mercid
,replace(replace(t.mercad,chr(13),''),chr(10),'') as mercad
,replace(replace(t.trcert,chr(13),''),chr(10),'') as trcert
,replace(replace(t.trauam,chr(13),''),chr(10),'') as trauam
,replace(replace(t.trotam,chr(13),''),chr(10),'') as trotam
,replace(replace(t.trcoun,chr(13),''),chr(10),'') as trcoun
,replace(replace(t.trcrcy,chr(13),''),chr(10),'') as trcrcy
,replace(replace(t.trdate,chr(13),''),chr(10),'') as trdate
,replace(replace(t.trtype,chr(13),''),chr(10),'') as trtype
,replace(replace(t.trrand,chr(13),''),chr(10),'') as trrand
,replace(replace(t.trapip,chr(13),''),chr(10),'') as trapip
,replace(replace(t.traptc,chr(13),''),chr(10),'') as traptc
,replace(replace(t.trresp,chr(13),''),chr(10),'') as trresp
,replace(replace(t.idprest,chr(13),''),chr(10),'') as idprest
,replace(replace(t.isdata,chr(13),''),chr(10),'') as isdata
,replace(replace(t.oldtrantp,chr(13),''),chr(10),'') as oldtrantp
,replace(replace(t.oldsystrace,chr(13),''),chr(10),'') as oldsystrace
,replace(replace(t.oldsettlmtdate,chr(13),''),chr(10),'') as oldsettlmtdate
,replace(replace(t.oldtranstime,chr(13),''),chr(10),'') as oldtranstime
,t.feeamt as feeamt
,replace(replace(t.cardholdrate,chr(13),''),chr(10),'') as cardholdrate
,t.cardholdamt as cardholdamt
,replace(replace(t.cardholdcy,chr(13),''),chr(10),'') as cardholdcy
,t.settlmtamt as settlmtamt
,replace(replace(t.settlmtcy,chr(13),''),chr(10),'') as settlmtcy
,t.ratefeeamt as ratefeeamt
,replace(replace(t.openbrn,chr(13),''),chr(10),'') as openbrn
,replace(replace(t.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t.qsstatus,chr(13),''),chr(10),'') as qsstatus
,replace(replace(t.opstatus,chr(13),''),chr(10),'') as opstatus
,replace(replace(t.retrflg,chr(13),''),chr(10),'') as retrflg
,replace(replace(t.magacct,chr(13),''),chr(10),'') as magacct
,t.tranexamt as tranexamt
,t.covamt as covamt
,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
from ${iol_schema}.mpcs_a51ubelecashtranlog t
where t.trandate >= to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'),'yyyymmdd')
and t.trandate <= to_char(to_date('${batch_date}','yyyymmdd'),'yyyymmdd') and t.etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a51ubelecashtranlog.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes