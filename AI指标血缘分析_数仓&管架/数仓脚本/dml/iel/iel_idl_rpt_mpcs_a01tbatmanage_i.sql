: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a01tbatmanage_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a01tbatmanage.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t1.batchtype,chr(13),''),chr(10),'') as batchtype
,replace(replace(t1.batchdt,chr(13),''),chr(10),'') as batchdt
,replace(replace(t1.batchno,chr(13),''),chr(10),'') as batchno
,replace(replace(t1.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t1.fntseqno,chr(13),''),chr(10),'') as fntseqno
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t1.payacctname,chr(13),''),chr(10),'') as payacctname
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.totalnum,chr(13),''),chr(10),'') as totalnum
,replace(replace(t1.succnum,chr(13),''),chr(10),'') as succnum
,replace(replace(t1.failnum,chr(13),''),chr(10),'') as failnum
,replace(replace(t1.totalamt,chr(13),''),chr(10),'') as totalamt
,replace(replace(t1.succamt,chr(13),''),chr(10),'') as succamt
,replace(replace(t1.failamt,chr(13),''),chr(10),'') as failamt
,replace(replace(t1.trndtts,chr(13),''),chr(10),'') as trndtts
,replace(replace(t1.tmpflag,chr(13),''),chr(10),'') as tmpflag
,replace(replace(t1.tmpacctno,chr(13),''),chr(10),'') as tmpacctno
,replace(replace(t1.tmpacctname,chr(13),''),chr(10),'') as tmpacctname
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.stat,chr(13),''),chr(10),'') as stat
,replace(replace(t1.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t1.crossflag,chr(13),''),chr(10),'') as crossflag
,replace(replace(t1.otherflag,chr(13),''),chr(10),'') as otherflag
,replace(replace(t1.inneracno,chr(13),''),chr(10),'') as inneracno
,replace(replace(t1.inneracna,chr(13),''),chr(10),'') as inneracna
,replace(replace(t1.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t1.hostseqdt,chr(13),''),chr(10),'') as hostseqdt
,replace(replace(t1.brcno,chr(13),''),chr(10),'') as brcno
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
 from iol.mpcs_a01tbatmanage T1
where fntdt='${batch_date}' and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a01tbatmanage.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes