: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_icms_business_approve_f
CreateDate: 20250822
FileName:   ${iel_data_path}/icms_business_approve.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.baserialno as baserialno
,t1.originflag as originflag
,t1.relativeserialno as relativeserialno
,t1.parentserialno as parentserialno
,t1.sourceserialno as sourceserialno
,t1.customerid as customerid
,t1.customername as customername
,t1.applytype as applytype
,t1.flowtype as flowtype
,t1.businessflag as businessflag
,t1.occurtype as occurtype
,t1.occurdate as occurdate
,t1.currency as currency
,t1.businesssum as businesssum
,t1.baseproduct as baseproduct
,t1.productid as productid
,t1.policyid as policyid
,t1.policyversionid as policyversionid
,t1.productclassify as productclassify
,t1.termmonth as termmonth
,t1.termday as termday
,t1.startdate as startdate
,t1.maturity as maturity
,t1.isremotebusiness as isremotebusiness
,t1.iscycle as iscycle
,t1.risktype as risktype
,t1.islowrisk as islowrisk
,t1.creditinvest as creditinvest
,t1.nationalindustrytype as nationalindustrytype
,t1.intraindustrytype as intraindustrytype
,t1.purpose as purpose
,t1.ratemodel as ratemodel
,t1.fixedrate as fixedrate
,t1.baseratetype as baseratetype
,t1.baserate as baserate
,t1.ratefloattype as ratefloattype
,t1.rateadjusttype as rateadjusttype
,t1.floatrange as floatrange
,t1.executerate as executerate
,t1.vouchtype as vouchtype
,t1.haveadditionalvouch as haveadditionalvouch
,t1.othervouchtype as othervouchtype
,t1.additioncommand as additioncommand
,t1.repaytype as repaytype
,t1.repaycycle as repaycycle
,t1.repaydate as repaydate
,t1.reservesum as reservesum
,t1.oldcontractno as oldcontractno
,t1.clno as clno
,t1.contractflag as contractflag
,t1.approvestatus as approvestatus
,t1.approvetype as approvetype
,t1.finalapproveopinion as finalapproveopinion
,t1.remark as remark
,t1.completeflag as completeflag
,t1.operateuserid as operateuserid
,t1.operateorgid as operateorgid
,t1.operatedate as operatedate
,t1.inputuserid as inputuserid
,t1.inputorgid as inputorgid
,t1.inputdate as inputdate
,t1.updateuserid as updateuserid
,t1.updateorgid as updateorgid
,t1.updatedate as updatedate
,t1.belongdept as belongdept
,t1.corporgid as corporgid
,t1.payfrequencyunit as payfrequencyunit
,t1.payfrequency as payfrequency
,t1.renewtermdate as renewtermdate
,t1.renewtotalsum as renewtotalsum
,t1.renewexecuteyearrate as renewexecuteyearrate
,t1.loanusetype as loanusetype
,t1.vouchtype2 as vouchtype2
,t1.vouchtype3 as vouchtype3
,t1.organizetype as organizetype
,t1.totalsum as totalsum
,t1.vouchtypeinner as vouchtypeinner
,t1.pigeonholedate as pigeonholedate
,t1.classifyresulteleven as classifyresulteleven
,t1.reinforceflag as reinforceflag
,t1.status as status
,t1.classifyresult as classifyresult
,t1.classifydate as classifydate
,t1.bailaccount as bailaccount
,t1.bailtransaccount as bailtransaccount
,t1.bailcurrency as bailcurrency
,t1.bailratio as bailratio
,t1.bailsum as bailsum
,t1.rateadjustfrequency as rateadjustfrequency
,t1.overduerate as overduerate
,t1.overdueratefloattype as overdueratefloattype
,t1.overdueratefloatvalue as overdueratefloatvalue
,t1.settlementaccountname as settlementaccountname
,t1.loanaccountno as loanaccountno
,t1.settlementaccount as settlementaccount
,t1.migtflag as migtflag
,t1.migtcustomerid as migtcustomerid
,t1.migtbusinesstype as migtbusinesstype
,t1.migtoldvalue as migtoldvalue
,t1.checkyearstatus as checkyearstatus
,t1.vouchflag as vouchflag
,t1.ratefloatratioorbp as ratefloatratioorbp
,t1.effectdate as effectdate
,t1.serialnocn as serialnocn
,t1.ispensionindustry as ispensionindustry
,t1.isyeartocheck as isyeartocheck
,t1.sqcheckyeardate as sqcheckyeardate
,t1.bqcheckyeardate as bqcheckyeardate
,t1.templeteno as templeteno
,t1.templeteurl as templeteurl
,t1.whethertorestructuretheloan as whethertorestructuretheloan
,t1.subproductname as subproductname
from ${idl_schema}.icms_business_approve t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_business_approve.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
