: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a01tbatdetail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a01tbatdetail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.batchdt,chr(13),''),chr(10),'') as batchdt
,replace(replace(t1.batchno,chr(13),''),chr(10),'') as batchno
,replace(replace(t1.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t1.fntseqno,chr(13),''),chr(10),'') as fntseqno
,replace(replace(t1.trntype,chr(13),''),chr(10),'') as trntype
,replace(replace(t1.prdcd,chr(13),''),chr(10),'') as prdcd
,replace(replace(t1.recordno,chr(13),''),chr(10),'') as recordno
,replace(replace(t1.bgndt,chr(13),''),chr(10),'') as bgndt
,replace(replace(t1.enddt,chr(13),''),chr(10),'') as enddt
,replace(replace(t1.trnmonth,chr(13),''),chr(10),'') as trnmonth
,replace(replace(t1.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t1.trnamt,chr(13),''),chr(10),'') as trnamt
,replace(replace(t1.amt1,chr(13),''),chr(10),'') as amt1
,replace(replace(t1.amt2,chr(13),''),chr(10),'') as amt2
,replace(replace(t1.amt3,chr(13),''),chr(10),'') as amt3
,replace(replace(t1.amt4,chr(13),''),chr(10),'') as amt4
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,replace(replace(t1.memocd,chr(13),''),chr(10),'') as memocd
,replace(replace(t1.dt1,chr(13),''),chr(10),'') as dt1
,replace(replace(t1.prtmemocd,chr(13),''),chr(10),'') as prtmemocd
,replace(replace(t1.oppoacctno,chr(13),''),chr(10),'') as oppoacctno
,replace(replace(t1.payacctname,chr(13),''),chr(10),'') as payacctname
,replace(replace(t1.freezedt,chr(13),''),chr(10),'') as freezedt
,replace(replace(t1.freezeno,chr(13),''),chr(10),'') as freezeno
,replace(replace(t1.succamt,chr(13),''),chr(10),'') as succamt
,replace(replace(t1.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t1.hostseqdt,chr(13),''),chr(10),'') as hostseqdt
,replace(replace(t1.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t1.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t1.otherbankno,chr(13),''),chr(10),'') as otherbankno
,replace(replace(t1.addword,chr(13),''),chr(10),'') as addword
,replace(replace(t1.orderid,chr(13),''),chr(10),'') as orderid
,replace(replace(t1.upptranseqno,chr(13),''),chr(10),'') as upptranseqno
 from iol.mpcs_a01tbatdetail T1
where fntdt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a01tbatdetail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes