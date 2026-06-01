: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_business_duebill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_business_duebill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.putoutserialno,chr(13),''),chr(10),'') as putoutserialno
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,t1.occurdate as occurdate
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.businesssum as businesssum
,t1.termmonth as termmonth
,t1.termday as termday
,t1.putoutdate as putoutdate
,t1.maturity as maturity
,t1.actualmaturity as actualmaturity
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,t1.baserate as baserate
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,t1.executerate as executerate
,t1.bailratio as bailratio
,t1.bailsum as bailsum
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,t1.balance as balance
,t1.normalbalance as normalbalance
,t1.overduebalance as overduebalance
,t1.dullbalance as dullbalance
,t1.badbalance as badbalance
,t1.extendtimes as extendtimes
,t1.innerinterestbalance as innerinterestbalance
,t1.outerinterestbalance as outerinterestbalance
,t1.capitalpenaltybalance as capitalpenaltybalance
,t1.interestpenaltybalance as interestpenaltybalance
,t1.overduedays as overduedays
,t1.owninterestdays as owninterestdays
,t1.ichangedate as ichangedate
,t1.graceperiod as graceperiod
,t1.reducereservesum as reducereservesum
,t1.predictlostsum as predictlostsum
,replace(replace(t1.finishtype,chr(13),''),chr(10),'') as finishtype
,t1.finishdate as finishdate
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk
,t1.badconfirmdate as badconfirmdate
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,t1.classifydate as classifydate
,replace(replace(t1.advanceflag,chr(13),''),chr(10),'') as advanceflag
,replace(replace(t1.businessstatus,chr(13),''),chr(10),'') as businessstatus
,replace(replace(t1.mforgid,chr(13),''),chr(10),'') as mforgid
,replace(replace(t1.relativeduebillno,chr(13),''),chr(10),'') as relativeduebillno
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.operatedate as operatedate
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,t1.inputdate as inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,t1.updatedate as updatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,t1.repaydate as repaydate
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount
,replace(replace(t1.overduedate,chr(13),''),chr(10),'') as overduedate
,replace(replace(t1.oweinterestdate,chr(13),''),chr(10),'') as oweinterestdate
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven
,t1.overduerate as overduerate
,replace(replace(t1.mainorgid,chr(13),''),chr(10),'') as mainorgid
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart
,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'') as vouchtype2
,replace(replace(t1.vouchtype3,chr(13),''),chr(10),'') as vouchtype3
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency
,t1.floatrange as floatrange
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname
,replace(replace(t1.loanaccountorgid,chr(13),''),chr(10),'') as loanaccountorgid
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype
,t1.overdueratefloatvalue as overdueratefloatvalue
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid
,replace(replace(t1.dzhxstatus,chr(13),''),chr(10),'') as dzhxstatus
,t1.classifyresultelevendate as classifyresultelevendate
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.zxzflag,chr(13),''),chr(10),'') as zxzflag
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.loanstatus,chr(13),''),chr(10),'') as loanstatus
,replace(replace(t1.assetflag,chr(13),''),chr(10),'') as assetflag
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
,replace(replace(t1.wrndate,chr(13),''),chr(10),'') as wrndate
,t1.repayamt as repayamt
,replace(replace(t1.prifirstduedate,chr(13),''),chr(10),'') as prifirstduedate
,replace(replace(t1.intfirstduedate,chr(13),''),chr(10),'') as intfirstduedate
,t1.compensateamt as compensateamt
,t1.yjintamt as yjintamt
,t1.csyjintamt as csyjintamt
,t1.ysintamt as ysintamt
,t1.csintamt as csintamt
,t1.yjodpamt as yjodpamt
,t1.csyjodpamt as csyjodpamt
,t1.ysodpamt as ysodpamt
,t1.csodpamt as csodpamt
,t1.odppostedctddr as odppostedctddr
,t1.odipostedctddr as odipostedctddr
,t1.yjodiamt as yjodiamt
,t1.wrnpriamt as wrnpriamt
,t1.wrnintamt as wrnintamt
,t1.wrnreceiptamt as wrnreceiptamt
,replace(replace(t1.intdate,chr(13),''),chr(10),'') as intdate
,t1.accountbalance as accountbalance
,t1.accountuserbalance as accountuserbalance
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,t1.insum as insum
,t1.interestinsum as interestinsum
,replace(replace(t1.exttradeno,chr(13),''),chr(10),'') as exttradeno
,t1.fyjbalamt as fyjbalamt
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid
,replace(replace(t1.migtbusinesstype,chr(13),''),chr(10),'') as migtbusinesstype
,t1.periods as periods
,t1.remain_periods as remain_periods
,replace(replace(t1.lastclassifyresultten,chr(13),''),chr(10),'') as lastclassifyresultten
,t1.lastclassifyresulttendate as lastclassifyresulttendate
,t1.classifyfivehchangedate as classifyfivehchangedate
,replace(replace(t1.tenclaind,chr(13),''),chr(10),'') as tenclaind
,replace(replace(t1.lastclassifyresult,chr(13),''),chr(10),'') as lastclassifyresult
,replace(replace(t1.lastclassifyresultdate,chr(13),''),chr(10),'') as lastclassifyresultdate
,replace(replace(t1.npltransflag,chr(13),''),chr(10),'') as npltransflag
,replace(replace(t1.reversalflag,chr(13),''),chr(10),'') as reversalflag
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp
from ${iol_schema}.icms_business_duebill t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_business_duebill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes