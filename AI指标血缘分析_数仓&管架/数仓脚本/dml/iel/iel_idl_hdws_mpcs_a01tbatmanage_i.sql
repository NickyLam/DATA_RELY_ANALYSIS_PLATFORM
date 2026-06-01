: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a01tbatmanage_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a01tbatmanage.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.chnlid
,t1.batchtype
,t1.batchdt
,t1.batchno
,t1.fntdt
,t1.fntseqno
,t1.filename
,t1.custno
,t1.payacctno
,t1.payacctname
,t1.ccy
,t1.totalnum
,t1.succnum
,t1.failnum
,t1.totalamt
,t1.succamt
,t1.failamt
,t1.trndtts
,t1.tmpflag
,t1.tmpacctno
,t1.tmpacctname
,t1.memo
,t1.stat
,t1.reserve
,t1.crossflag
,t1.otherflag
,t1.inneracno
,t1.inneracna
,t1.rspcd
,t1.dataid
,t1.hostseqno
,t1.hostseqdt
,t1.brcno
,t1.tlrno
from ${idl_schema}.hdws_mpcs_a01tbatmanage t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a01tbatmanage.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes