: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a01tbatdetail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a01tbatdetail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.batchdt,chr(13),''),chr(10),'') as batchdt
,replace(replace(t.batchno,chr(13),''),chr(10),'') as batchno
,replace(replace(t.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t.fntseqno,chr(13),''),chr(10),'') as fntseqno
,replace(replace(t.trntype,chr(13),''),chr(10),'') as trntype
,replace(replace(t.prdcd,chr(13),''),chr(10),'') as prdcd
,replace(replace(t.recordno,chr(13),''),chr(10),'') as recordno
,replace(replace(t.bgndt,chr(13),''),chr(10),'') as bgndt
,replace(replace(t.enddt,chr(13),''),chr(10),'') as enddt
,replace(replace(t.trnmonth,chr(13),''),chr(10),'') as trnmonth
,replace(replace(t.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t.trnamt,chr(13),''),chr(10),'') as trnamt
,replace(replace(t.amt1,chr(13),''),chr(10),'') as amt1
,replace(replace(t.amt2,chr(13),''),chr(10),'') as amt2
,replace(replace(t.amt3,chr(13),''),chr(10),'') as amt3
,replace(replace(t.amt4,chr(13),''),chr(10),'') as amt4
,replace(replace(t.paytype,chr(13),''),chr(10),'') as paytype
,replace(replace(t.memocd,chr(13),''),chr(10),'') as memocd
,replace(replace(t.dt1,chr(13),''),chr(10),'') as dt1
,replace(replace(t.prtmemocd,chr(13),''),chr(10),'') as prtmemocd
,replace(replace(t.oppoacctno,chr(13),''),chr(10),'') as oppoacctno
,replace(replace(t.payacctname,chr(13),''),chr(10),'') as payacctname
,replace(replace(t.freezedt,chr(13),''),chr(10),'') as freezedt
,replace(replace(t.freezeno,chr(13),''),chr(10),'') as freezeno
,replace(replace(t.succamt,chr(13),''),chr(10),'') as succamt
,replace(replace(t.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t.hostseqdt,chr(13),''),chr(10),'') as hostseqdt
,replace(replace(t.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t.otherbankno,chr(13),''),chr(10),'') as otherbankno
,replace(replace(t.addword,chr(13),''),chr(10),'') as addword
,replace(replace(t.orderid,chr(13),''),chr(10),'') as orderid
,replace(replace(t.upptranseqno,chr(13),''),chr(10),'') as upptranseqno
from ${iol_schema}.MPCS_A01TBATDETAIL t 
where t.FNTDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a01tbatdetail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes