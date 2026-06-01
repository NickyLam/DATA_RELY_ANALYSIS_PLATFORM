: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a01tbatdetail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a01tbatdetail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.batchdt
,t1.batchno
,t1.fntdt
,t1.fntseqno
,t1.trntype
,t1.prdcd
,t1.recordno
,t1.bgndt
,t1.enddt
,t1.trnmonth
,t1.payacctno
,t1.trnamt
,t1.amt1
,t1.amt2
,t1.amt3
,t1.amt4
,t1.paytype
,t1.memocd
,t1.dt1
,t1.prtmemocd
,t1.oppoacctno
,t1.payacctname
,t1.freezedt
,t1.freezeno
,t1.succamt
,t1.hostseqno
,t1.hostseqdt
,t1.rspcd
,t1.rspmsg
,t1.otherbankno
,t1.addword
,t1.orderid
,t1.upptranseqno
from ${idl_schema}.hdws_mpcs_a01tbatdetail t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a01tbatdetail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes