: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_bat_repayment_f
CreateDate: 20250620
FileName:   ${iel_data_path}/icms_bat_repayment.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.duebillno as duebillno
,t1.transdate as transdate
,t1.customerid as customerid
,t1.customername as customername
,t1.certtype as certtype
,t1.certid as certid
,t1.currency as currency
,t1.schedulepayment as schedulepayment
,t1.actualpayment as actualpayment
,t1.payaccountno as payaccountno
,t1.payserialno as payserialno
,t1.paymenttype as paymenttype
,t1.status as status
,t1.relaobjecttype as relaobjecttype
,t1.relaobjectno as relaobjectno
,t1.batserialno as batserialno
,t1.transserialno as transserialno
,t1.grouptype as grouptype
,t1.remark as remark
,t1.inputuserid as inputuserid
,t1.inputorgid as inputorgid
,t1.inputdate as inputdate
,t1.updateuserid as updateuserid
,t1.updateorgid as updateorgid
,t1.updatedate as updatedate
,t1.completeflag as completeflag
,t1.priamt as priamt
,t1.intamt as intamt
,t1.odpamt as odpamt
,t1.odiamt as odiamt
,t1.remamt as remamt
,t1.stageno as stageno
,t1.reasoncode as reasoncode
,t1.receipttype as receipttype
,t1.migtflag as migtflag
,t1.reversal as reversal
,t1.receiptno as receiptno
,t1.channel as channel
,t1.srcinitsysid as srcinitsysid

from ${idl_schema}.icms_bat_repayment t1
where etl_dt = to_date('${batch_date}','yyyymmdd') - 1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_bat_repayment.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
