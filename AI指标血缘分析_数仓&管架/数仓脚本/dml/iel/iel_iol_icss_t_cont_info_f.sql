: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.contractst,chr(13),''),chr(10),'') as contractst
,replace(replace(t.counterid,chr(13),''),chr(10),'') as counterid
,replace(replace(t.countername,chr(13),''),chr(10),'') as countername
,replace(replace(t.artificialno,chr(13),''),chr(10),'') as artificialno
,replace(replace(t.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t.fundsource,chr(13),''),chr(10),'') as fundsource
,replace(replace(t.investway,chr(13),''),chr(10),'') as investway
,replace(replace(t.financierid,chr(13),''),chr(10),'') as financierid
,replace(replace(t.financier,chr(13),''),chr(10),'') as financier
,replace(replace(t.tradingassets,chr(13),''),chr(10),'') as tradingassets
,replace(replace(t.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,t.businesssum as businesssum
,t.contractbal as contractbal
,t.contractavlsum as contractavlsum
,replace(replace(t.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t.maturity,chr(13),''),chr(10),'') as maturity
,replace(replace(t.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod
,replace(replace(t.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t.creditincrementtype,chr(13),''),chr(10),'') as creditincrementtype
,replace(replace(t.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t.lcno,chr(13),''),chr(10),'') as lcno
,replace(replace(t.lcenddate,chr(13),''),chr(10),'') as lcenddate
,replace(replace(t.lcopenorgid,chr(13),''),chr(10),'') as lcopenorgid
,replace(replace(t.lcopenorgname,chr(13),''),chr(10),'') as lcopenorgname
,replace(replace(t.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t.billkind,chr(13),''),chr(10),'') as billkind
,replace(replace(t.billno,chr(13),''),chr(10),'') as billno
,t.billsum as billsum
,replace(replace(t.billacptdate,chr(13),''),chr(10),'') as billacptdate
,replace(replace(t.billmaturity,chr(13),''),chr(10),'') as billmaturity
,replace(replace(t.billwriter,chr(13),''),chr(10),'') as billwriter
,replace(replace(t.acceptcustomerid,chr(13),''),chr(10),'') as acceptcustomerid
,replace(replace(t.acceptbankname,chr(13),''),chr(10),'') as acceptbankname
,replace(replace(t.iswhzt,chr(13),''),chr(10),'') as iswhzt
,replace(replace(t.depositno,chr(13),''),chr(10),'') as depositno
,replace(replace(t.depositname,chr(13),''),chr(10),'') as depositname
,t.issueprice as issueprice
,t.businessrate as businessrate
,t.issueamount as issueamount
,t.issuesum as issuesum
,replace(replace(t.bondno,chr(13),''),chr(10),'') as bondno
,replace(replace(t.bondname,chr(13),''),chr(10),'') as bondname
,replace(replace(t.investkind,chr(13),''),chr(10),'') as investkind
,replace(replace(t.canseparate,chr(13),''),chr(10),'') as canseparate
,replace(replace(t.canbacktosale,chr(13),''),chr(10),'') as canbacktosale
,replace(replace(t.salebackbegindate,chr(13),''),chr(10),'') as salebackbegindate
,replace(replace(t.salebackenddate,chr(13),''),chr(10),'') as salebackenddate
,replace(replace(t.businessmarkettype,chr(13),''),chr(10),'') as businessmarkettype
,replace(replace(t.businessmarket,chr(13),''),chr(10),'') as businessmarket
,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t.paymentdate,chr(13),''),chr(10),'') as paymentdate
,replace(replace(t.outerevaluate1,chr(13),''),chr(10),'') as outerevaluate1
,replace(replace(t.outerevaluate2,chr(13),''),chr(10),'') as outerevaluate2
,replace(replace(t.outerevaluate3,chr(13),''),chr(10),'') as outerevaluate3
,t.couponrate as couponrate
,t.transactionprice as transactionprice
,t.transactionrate as transactionrate
,replace(replace(t.transactoinamount,chr(13),''),chr(10),'') as transactoinamount
,replace(replace(t.transactiondate,chr(13),''),chr(10),'') as transactiondate
,replace(replace(t.backtosaletype,chr(13),''),chr(10),'') as backtosaletype
,replace(replace(t.financialtype,chr(13),''),chr(10),'') as financialtype
,replace(replace(t.financialclassify,chr(13),''),chr(10),'') as financialclassify
,replace(replace(t.absabnname,chr(13),''),chr(10),'') as absabnname
,replace(replace(t.derassettype,chr(13),''),chr(10),'') as derassettype
,replace(replace(t.derassetsubtype,chr(13),''),chr(10),'') as derassetsubtype
,replace(replace(t.derassetcurrency,chr(13),''),chr(10),'') as derassetcurrency
,t.derassetnotionprin as derassetnotionprin
,t.derassetbailratio as derassetbailratio
,replace(replace(t.derassetenddate,chr(13),''),chr(10),'') as derassetenddate
,replace(replace(t.isgovfinance,chr(13),''),chr(10),'') as isgovfinance
,replace(replace(t.isconsumefinance,chr(13),''),chr(10),'') as isconsumefinance
,replace(replace(t.toindustryfund,chr(13),''),chr(10),'') as toindustryfund
,replace(replace(t.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t.operateorg,chr(13),''),chr(10),'') as operateorg
from ${iol_schema}.icss_t_cont_info t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes