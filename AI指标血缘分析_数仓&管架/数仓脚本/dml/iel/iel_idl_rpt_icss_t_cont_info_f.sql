: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.contractst,chr(13),''),chr(10),'') as contractst
,replace(replace(t1.counterid,chr(13),''),chr(10),'') as counterid
,replace(replace(t1.countername,chr(13),''),chr(10),'') as countername
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource
,replace(replace(t1.investway,chr(13),''),chr(10),'') as investway
,replace(replace(t1.financierid,chr(13),''),chr(10),'') as financierid
,replace(replace(t1.financier,chr(13),''),chr(10),'') as financier
,replace(replace(t1.tradingassets,chr(13),''),chr(10),'') as tradingassets
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,t1.businesssum as businesssum
,t1.contractbal as contractbal
,t1.contractavlsum as contractavlsum
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.maturity,chr(13),''),chr(10),'') as maturity
,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.creditincrementtype,chr(13),''),chr(10),'') as creditincrementtype
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.lcno,chr(13),''),chr(10),'') as lcno
,replace(replace(t1.lcenddate,chr(13),''),chr(10),'') as lcenddate
,replace(replace(t1.lcopenorgid,chr(13),''),chr(10),'') as lcopenorgid
,replace(replace(t1.lcopenorgname,chr(13),''),chr(10),'') as lcopenorgname
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.billkind,chr(13),''),chr(10),'') as billkind
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno
,t1.billsum as billsum
,replace(replace(t1.billacptdate,chr(13),''),chr(10),'') as billacptdate
,replace(replace(t1.billmaturity,chr(13),''),chr(10),'') as billmaturity
,replace(replace(t1.billwriter,chr(13),''),chr(10),'') as billwriter
,replace(replace(t1.acceptcustomerid,chr(13),''),chr(10),'') as acceptcustomerid
,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'') as acceptbankname
,replace(replace(t1.iswhzt,chr(13),''),chr(10),'') as iswhzt
,replace(replace(t1.depositno,chr(13),''),chr(10),'') as depositno
,replace(replace(t1.depositname,chr(13),''),chr(10),'') as depositname
,t1.issueprice as issueprice
,t1.businessrate as businessrate
,t1.issueamount as issueamount
,t1.issuesum as issuesum
,replace(replace(t1.bondno,chr(13),''),chr(10),'') as bondno
,replace(replace(t1.bondname,chr(13),''),chr(10),'') as bondname
,replace(replace(t1.investkind,chr(13),''),chr(10),'') as investkind
,replace(replace(t1.canseparate,chr(13),''),chr(10),'') as canseparate
,replace(replace(t1.canbacktosale,chr(13),''),chr(10),'') as canbacktosale
,replace(replace(t1.salebackbegindate,chr(13),''),chr(10),'') as salebackbegindate
,replace(replace(t1.salebackenddate,chr(13),''),chr(10),'') as salebackenddate
,replace(replace(t1.businessmarkettype,chr(13),''),chr(10),'') as businessmarkettype
,replace(replace(t1.businessmarket,chr(13),''),chr(10),'') as businessmarket
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.paymentdate,chr(13),''),chr(10),'') as paymentdate
,replace(replace(t1.outerevaluate1,chr(13),''),chr(10),'') as outerevaluate1
,replace(replace(t1.outerevaluate2,chr(13),''),chr(10),'') as outerevaluate2
,replace(replace(t1.outerevaluate3,chr(13),''),chr(10),'') as outerevaluate3
,t1.couponrate as couponrate
,t1.transactionprice as transactionprice
,t1.transactionrate as transactionrate
,replace(replace(t1.transactoinamount,chr(13),''),chr(10),'') as transactoinamount
,replace(replace(t1.transactiondate,chr(13),''),chr(10),'') as transactiondate
,replace(replace(t1.backtosaletype,chr(13),''),chr(10),'') as backtosaletype
,replace(replace(t1.financialtype,chr(13),''),chr(10),'') as financialtype
,replace(replace(t1.financialclassify,chr(13),''),chr(10),'') as financialclassify
,replace(replace(t1.absabnname,chr(13),''),chr(10),'') as absabnname
,replace(replace(t1.derassettype,chr(13),''),chr(10),'') as derassettype
,replace(replace(t1.derassetsubtype,chr(13),''),chr(10),'') as derassetsubtype
,replace(replace(t1.derassetcurrency,chr(13),''),chr(10),'') as derassetcurrency
,t1.derassetnotionprin as derassetnotionprin
,t1.derassetbailratio as derassetbailratio
,replace(replace(t1.derassetenddate,chr(13),''),chr(10),'') as derassetenddate
,replace(replace(t1.isgovfinance,chr(13),''),chr(10),'') as isgovfinance
,replace(replace(t1.isconsumefinance,chr(13),''),chr(10),'') as isconsumefinance
,replace(replace(t1.toindustryfund,chr(13),''),chr(10),'') as toindustryfund
,replace(replace(t1.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t1.operateorg,chr(13),''),chr(10),'') as operateorg
 from iol.icss_t_cont_info T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes