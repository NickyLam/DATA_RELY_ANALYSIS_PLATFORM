: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_business_apply_f
CreateDate: 20251126
FileName:   ${iel_data_path}/icms_business_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.originflag,chr(13),''),chr(10),'') as originflag
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.parentserialno,chr(13),''),chr(10),'') as parentserialno
,replace(replace(t1.sourceserialno,chr(13),''),chr(10),'') as sourceserialno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,occurdate
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,businesssum
,replace(replace(t1.baseproduct,chr(13),''),chr(10),'') as baseproduct
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.policyid,chr(13),''),chr(10),'') as policyid
,replace(replace(t1.policyversionid,chr(13),''),chr(10),'') as policyversionid
,replace(replace(t1.productclassify,chr(13),''),chr(10),'') as productclassify
,termmonth
,termday
,startdate
,maturity
,replace(replace(t1.isremotebusiness,chr(13),''),chr(10),'') as isremotebusiness
,replace(replace(t1.iscycle,chr(13),''),chr(10),'') as iscycle
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk
,replace(replace(t1.creditinvest,chr(13),''),chr(10),'') as creditinvest
,replace(replace(t1.nationalindustrytype,chr(13),''),chr(10),'') as nationalindustrytype
,replace(replace(t1.intraindustrytype,chr(13),''),chr(10),'') as intraindustrytype
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel
,fixedrate
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,baserate
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,floatrange
,executerate
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.haveadditionalvouch,chr(13),''),chr(10),'') as haveadditionalvouch
,replace(replace(t1.othervouchtype,chr(13),''),chr(10),'') as othervouchtype
,replace(replace(t1.additioncommand,chr(13),''),chr(10),'') as additioncommand
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,repaydate
,reservesum
,replace(replace(t1.oldcontractno,chr(13),''),chr(10),'') as oldcontractno
,replace(replace(t1.clno,chr(13),''),chr(10),'') as clno
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.approvetype,chr(13),''),chr(10),'') as approvetype
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.programno,chr(13),''),chr(10),'') as programno
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,operatedate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.payfrequencyunit,chr(13),''),chr(10),'') as payfrequencyunit
,payfrequency
,renewtermdate
,renewtotalsum
,renewexecuteyearrate
,replace(replace(t1.loanusetype,chr(13),''),chr(10),'') as loanusetype
,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'') as vouchtype2
,replace(replace(t1.vouchtype3,chr(13),''),chr(10),'') as vouchtype3
,replace(replace(t1.organizetype,chr(13),''),chr(10),'') as organizetype
,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate
,replace(replace(t1.hascreateapprove,chr(13),''),chr(10),'') as hascreateapprove
,replace(replace(t1.vouchtypeinner,chr(13),''),chr(10),'') as vouchtypeinner
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency
,totalsum
,replace(replace(t1.trueorfalse,chr(13),''),chr(10),'') as trueorfalse
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency
,bailsum
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,classifydate
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno
,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'') as bailtransaccount
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.loanaccountname,chr(13),''),chr(10),'') as loanaccountname
,replace(replace(t1.loanaccountbankno,chr(13),''),chr(10),'') as loanaccountbankno
,overduerate
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype
,overdueratefloatvalue
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,bailratio
,replace(replace(t1.adjusttype,chr(13),''),chr(10),'') as adjusttype
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
,replace(replace(t1.templeteno,chr(13),''),chr(10),'') as templeteno
,replace(replace(t1.templeteurl,chr(13),''),chr(10),'') as templeteurl
,replace(replace(t1.vouchflag,chr(13),''),chr(10),'') as vouchflag
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp

from ${iol_schema}.icms_business_apply t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_business_apply.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
