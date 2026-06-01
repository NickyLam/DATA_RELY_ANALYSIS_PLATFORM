: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mpcs_a51ubelecashtranlog_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mpcs_a51ubelecashtranlog.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.filedate,chr(13),''),chr(10),'') as filedate
,replace(replace(t1.gatetype,chr(13),''),chr(10),'') as gatetype
,replace(replace(t1.fwdinstid,chr(13),''),chr(10),'') as fwdinstid
,replace(replace(t1.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t1.acqinstid,chr(13),''),chr(10),'') as acqinstid
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.settlmtdate,chr(13),''),chr(10),'') as settlmtdate
,replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t1.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t1.cardsq,chr(13),''),chr(10),'') as cardsq
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,t1.tranam as tranam
,replace(replace(t1.provstatus,chr(13),''),chr(10),'') as provstatus
,replace(replace(t1.merctp,chr(13),''),chr(10),'') as merctp
,replace(replace(t1.termid,chr(13),''),chr(10),'') as termid
,replace(replace(t1.mercid,chr(13),''),chr(10),'') as mercid
,replace(replace(t1.mercad,chr(13),''),chr(10),'') as mercad
,replace(replace(t1.trcert,chr(13),''),chr(10),'') as trcert
,replace(replace(t1.trauam,chr(13),''),chr(10),'') as trauam
,replace(replace(t1.trotam,chr(13),''),chr(10),'') as trotam
,replace(replace(t1.trcoun,chr(13),''),chr(10),'') as trcoun
,replace(replace(t1.trcrcy,chr(13),''),chr(10),'') as trcrcy
,replace(replace(t1.trdate,chr(13),''),chr(10),'') as trdate
,replace(replace(t1.trtype,chr(13),''),chr(10),'') as trtype
,replace(replace(t1.trrand,chr(13),''),chr(10),'') as trrand
,replace(replace(t1.trapip,chr(13),''),chr(10),'') as trapip
,replace(replace(t1.traptc,chr(13),''),chr(10),'') as traptc
,replace(replace(t1.trresp,chr(13),''),chr(10),'') as trresp
,replace(replace(t1.idprest,chr(13),''),chr(10),'') as idprest
,replace(replace(t1.isdata,chr(13),''),chr(10),'') as isdata
,replace(replace(t1.oldtrantp,chr(13),''),chr(10),'') as oldtrantp
,replace(replace(t1.oldsystrace,chr(13),''),chr(10),'') as oldsystrace
,replace(replace(t1.oldsettlmtdate,chr(13),''),chr(10),'') as oldsettlmtdate
,replace(replace(t1.oldtranstime,chr(13),''),chr(10),'') as oldtranstime
,t1.feeamt as feeamt
,replace(replace(t1.cardholdrate,chr(13),''),chr(10),'') as cardholdrate
,t1.cardholdamt as cardholdamt
,replace(replace(t1.cardholdcy,chr(13),''),chr(10),'') as cardholdcy
,t1.settlmtamt as settlmtamt
,replace(replace(t1.settlmtcy,chr(13),''),chr(10),'') as settlmtcy
,t1.ratefeeamt as ratefeeamt
,replace(replace(t1.openbrn,chr(13),''),chr(10),'') as openbrn
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.qsstatus,chr(13),''),chr(10),'') as qsstatus
,replace(replace(t1.opstatus,chr(13),''),chr(10),'') as opstatus
,replace(replace(t1.retrflg,chr(13),''),chr(10),'') as retrflg
,replace(replace(t1.magacct,chr(13),''),chr(10),'') as magacct
,t1.tranexamt as tranexamt
,t1.covamt as covamt
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,'' as data_date
from ${iol_schema}.mpcs_a51ubelecashtranlog t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and 
 trandate>=to_char(to_date('${batch_date}','yyyymmdd')-8,'yyyymmdd') and trandate<='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mpcs_a51ubelecashtranlog.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes