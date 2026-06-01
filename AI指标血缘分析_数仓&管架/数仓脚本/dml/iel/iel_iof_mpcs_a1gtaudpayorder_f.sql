: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1gtaudpayorder_f
CreateDate: 20231030
FileName:   ${iel_data_path}/mpcs_a1gtaudpayorder.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trxcode,chr(13),''),chr(10),'') as trxcode
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.finaid,chr(13),''),chr(10),'') as finaid
,replace(replace(t1.finano,chr(13),''),chr(10),'') as finano
,replace(replace(t1.operator,chr(13),''),chr(10),'') as operator
,replace(replace(t1.bankid,chr(13),''),chr(10),'') as bankid
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno
,replace(replace(t1.bgorgcode,chr(13),''),chr(10),'') as bgorgcode
,replace(replace(t1.bgdeptcode,chr(13),''),chr(10),'') as bgdeptcode
,replace(replace(t1.procdate,chr(13),''),chr(10),'') as procdate
,replace(replace(t1.captorgion,chr(13),''),chr(10),'') as captorgion
,replace(replace(t1.fiscal,chr(13),''),chr(10),'') as fiscal
,replace(replace(t1.fisperd,chr(13),''),chr(10),'') as fisperd
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,replace(replace(t1.bgacccode,chr(13),''),chr(10),'') as bgacccode
,replace(replace(t1.projectcode,chr(13),''),chr(10),'') as projectcode
,replace(replace(t1.typeofpay,chr(13),''),chr(10),'') as typeofpay
,replace(replace(t1.outlaycode,chr(13),''),chr(10),'') as outlaycode
,replace(replace(t1.payusage,chr(13),''),chr(10),'') as payusage
,replace(replace(t1.recebankaccount,chr(13),''),chr(10),'') as recebankaccount
,replace(replace(t1.recename,chr(13),''),chr(10),'') as recename
,replace(replace(t1.recebanknodename,chr(13),''),chr(10),'') as recebanknodename
,replace(replace(t1.paybankaccount,chr(13),''),chr(10),'') as paybankaccount
,replace(replace(t1.payname,chr(13),''),chr(10),'') as payname
,replace(replace(t1.paybanknodename,chr(13),''),chr(10),'') as paybanknodename
,replace(replace(t1.rationsum,chr(13),''),chr(10),'') as rationsum
,replace(replace(t1.paysum,chr(13),''),chr(10),'') as paysum
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t1.wayofpay,chr(13),''),chr(10),'') as wayofpay
,replace(replace(t1.billsno,chr(13),''),chr(10),'') as billsno
,replace(replace(t1.banktrxcode,chr(13),''),chr(10),'') as banktrxcode
,replace(replace(t1.paydatetime,chr(13),''),chr(10),'') as paydatetime
,replace(replace(t1.bankpaystatus,chr(13),''),chr(10),'') as bankpaystatus
,replace(replace(t1.finatrxcode,chr(13),''),chr(10),'') as finatrxcode
,replace(replace(t1.updt,chr(13),''),chr(10),'') as updt
,replace(replace(t1.brcno,chr(13),''),chr(10),'') as brcno
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.bgdeptname,chr(13),''),chr(10),'') as bgdeptname
,replace(replace(t1.projectname,chr(13),''),chr(10),'') as projectname
,replace(replace(t1.bgorgname,chr(13),''),chr(10),'') as bgorgname
,replace(replace(t1.bgaccname,chr(13),''),chr(10),'') as bgaccname
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.banksequ,chr(13),''),chr(10),'') as banksequ
,replace(replace(t1.outlayname,chr(13),''),chr(10),'') as outlayname
,replace(replace(t1.recebanknode,chr(13),''),chr(10),'') as recebanknode
,replace(replace(t1.bankflg,chr(13),''),chr(10),'') as bankflg
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.cnapstransq,chr(13),''),chr(10),'') as cnapstransq
,replace(replace(t1.operationtypecode,chr(13),''),chr(10),'') as operationtypecode
,replace(replace(t1.yztype,chr(13),''),chr(10),'') as yztype
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno

from ${iol_schema}.mpcs_a1gtaudpayorder t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1gtaudpayorder.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
