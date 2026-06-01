: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a01tbatmanage_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a01tbatmanage.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t.batchtype,chr(13),''),chr(10),'') as batchtype
,replace(replace(t.batchdt,chr(13),''),chr(10),'') as batchdt
,replace(replace(t.batchno,chr(13),''),chr(10),'') as batchno
,replace(replace(t.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t.fntseqno,chr(13),''),chr(10),'') as fntseqno
,replace(replace(t.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t.payacctname,chr(13),''),chr(10),'') as payacctname
,replace(replace(t.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t.totalnum,chr(13),''),chr(10),'') as totalnum
,replace(replace(t.succnum,chr(13),''),chr(10),'') as succnum
,replace(replace(t.failnum,chr(13),''),chr(10),'') as failnum
,replace(replace(t.totalamt,chr(13),''),chr(10),'') as totalamt
,replace(replace(t.succamt,chr(13),''),chr(10),'') as succamt
,replace(replace(t.failamt,chr(13),''),chr(10),'') as failamt
,replace(replace(t.trndtts,chr(13),''),chr(10),'') as trndtts
,replace(replace(t.tmpflag,chr(13),''),chr(10),'') as tmpflag
,replace(replace(t.tmpacctno,chr(13),''),chr(10),'') as tmpacctno
,replace(replace(t.tmpacctname,chr(13),''),chr(10),'') as tmpacctname
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t.stat,chr(13),''),chr(10),'') as stat
,replace(replace(t.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t.crossflag,chr(13),''),chr(10),'') as crossflag
,replace(replace(t.otherflag,chr(13),''),chr(10),'') as otherflag
,replace(replace(t.inneracno,chr(13),''),chr(10),'') as inneracno
,replace(replace(t.inneracna,chr(13),''),chr(10),'') as inneracna
,replace(replace(t.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t.hostseqdt,chr(13),''),chr(10),'') as hostseqdt
,replace(replace(t.brcno,chr(13),''),chr(10),'') as brcno
,replace(replace(t.tlrno,chr(13),''),chr(10),'') as tlrno
from ${iol_schema}.MPCS_A01TBATMANAGE t 
where FNTDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a01tbatmanage.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes