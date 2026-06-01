: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1xdztransjour_sxf_a
CreateDate: 20260407
FileName:   ${iel_data_path}/mpcs_a1xdztransjour_sxf.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.keyid,chr(13),''),chr(10),'') as keyid
,replace(replace(t1.accptrid,chr(13),''),chr(10),'') as accptrid
,replace(replace(t1.orderid,chr(13),''),chr(10),'') as orderid
,replace(replace(t1.payno,chr(13),''),chr(10),'') as payno
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.productno,chr(13),''),chr(10),'') as productno
,replace(replace(t1.paycategory,chr(13),''),chr(10),'') as paycategory
,replace(replace(t1.paychannel,chr(13),''),chr(10),'') as paychannel
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.paycurrency,chr(13),''),chr(10),'') as paycurrency
,replace(replace(t1.payamount,chr(13),''),chr(10),'') as payamount
,replace(replace(t1.payfee,chr(13),''),chr(10),'') as payfee
,replace(replace(t1.payfeerate,chr(13),''),chr(10),'') as payfeerate
,replace(replace(t1.discountamount,chr(13),''),chr(10),'') as discountamount
,replace(replace(t1.refundamount,chr(13),''),chr(10),'') as refundamount
,replace(replace(t1.refundfee,chr(13),''),chr(10),'') as refundfee
,replace(replace(t1.szltflag,chr(13),''),chr(10),'') as szltflag
,replace(replace(t1.szltrecfeeamt,chr(13),''),chr(10),'') as szltrecfeeamt
,replace(replace(t1.cappingfee,chr(13),''),chr(10),'') as cappingfee
,replace(replace(t1.oriorderid,chr(13),''),chr(10),'') as oriorderid
,replace(replace(t1.oripayno,chr(13),''),chr(10),'') as oripayno
,replace(replace(t1.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t1.drtype,chr(13),''),chr(10),'') as drtype
,replace(replace(t1.oversea,chr(13),''),chr(10),'') as oversea
,replace(replace(t1.cardorg,chr(13),''),chr(10),'') as cardorg
,replace(replace(t1.sncode,chr(13),''),chr(10),'') as sncode
,replace(replace(t1.storeno,chr(13),''),chr(10),'') as storeno
,replace(replace(t1.auth3ds,chr(13),''),chr(10),'') as auth3ds
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.remakr1,chr(13),''),chr(10),'') as remakr1
,replace(replace(t1.remakr2,chr(13),''),chr(10),'') as remakr2
,replace(replace(t1.remakr3,chr(13),''),chr(10),'') as remakr3
,replace(replace(t1.remakr4,chr(13),''),chr(10),'') as remakr4
,replace(replace(t1.remakr5,chr(13),''),chr(10),'') as remakr5

from ${iol_schema}.mpcs_a1xdztransjour_sxf t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1xdztransjour_sxf.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
