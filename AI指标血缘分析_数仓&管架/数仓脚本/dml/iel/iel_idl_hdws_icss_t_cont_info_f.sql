: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.relativeserialno
,t1.serialno
,t1.contractst
,t1.counterid
,t1.countername
,t1.artificialno
,t1.businesstype
,t1.fundsource
,t1.investway
,t1.financierid
,t1.financier
,t1.tradingassets
,t1.businesscurrency
,t1.businesssum
,t1.contractbal
,t1.contractavlsum
,t1.putoutdate
,t1.maturity
,t1.corpuspaymethod
,t1.vouchtype
,t1.creditincrementtype
,t1.direction
,t1.lcno
,t1.lcenddate
,t1.lcopenorgid
,t1.lcopenorgname
,t1.billtype
,t1.billkind
,t1.billno
,t1.billsum
,t1.billacptdate
,t1.billmaturity
,t1.billwriter
,t1.acceptcustomerid
,t1.acceptbankname
,t1.iswhzt
,t1.depositno
,t1.depositname
,t1.issueprice
,t1.businessrate
,t1.issueamount
,t1.issuesum
,t1.bondno
,t1.bondname
,t1.investkind
,t1.canseparate
,t1.canbacktosale
,t1.salebackbegindate
,t1.salebackenddate
,t1.businessmarkettype
,t1.businessmarket
,t1.begindate
,t1.paymentdate
,t1.outerevaluate1
,t1.outerevaluate2
,t1.outerevaluate3
,t1.couponrate
,t1.transactionprice
,t1.transactionrate
,t1.transactoinamount
,t1.transactiondate
,t1.backtosaletype
,t1.financialtype
,t1.financialclassify
,t1.absabnname
,t1.derassettype
,t1.derassetsubtype
,t1.derassetcurrency
,t1.derassetnotionprin
,t1.derassetbailratio
,t1.derassetenddate
,t1.isgovfinance
,t1.isconsumefinance
,t1.toindustryfund
,t1.operateuser
,t1.operateorg
from ${idl_schema}.hdws_icss_t_cont_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes