: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_business_putout_f
CreateDate: 20251201
FileName:   ${iel_data_path}/icms_business_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,executerate
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate
,gainamount
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,replace(replace(t1.pdgpaymethod,chr(13),''),chr(10),'') as pdgpaymethod
,repaydate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.loanaccountnosub,chr(13),''),chr(10),'') as loanaccountnosub
,baserate
,replace(replace(t1.policyid,chr(13),''),chr(10),'') as policyid
,occurdate
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.subjectno,chr(13),''),chr(10),'') as subjectno
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency
,putoutdate
,updatedate
,segterm
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype
,replace(replace(t1.exchangetime,chr(13),''),chr(10),'') as exchangetime
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag
,overdueratefloatvalue
,pdgsum
,replace(replace(t1.jxhjduebillno,chr(13),''),chr(10),'') as jxhjduebillno
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,replace(replace(t1.pdgaccountno,chr(13),''),chr(10),'') as pdgaccountno
,replace(replace(t1.zftransserialno,chr(13),''),chr(10),'') as zftransserialno
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.interestrepaycycle,chr(13),''),chr(10),'') as interestrepaycycle
,replace(replace(t1.exchangestate,chr(13),''),chr(10),'') as exchangestate
,bpspreads
,fixedrate
,floatrange
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk
,replace(replace(t1.lendingorgid,chr(13),''),chr(10),'') as lendingorgid
,commissionpaysum
,replace(replace(t1.clno,chr(13),''),chr(10),'') as clno
,segrptamount
,bailratio
,replace(replace(t1.transserialno,chr(13),''),chr(10),'') as transserialno
,replace(replace(t1.payfrequencyunit,chr(13),''),chr(10),'') as payfrequencyunit
,payfrequency
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,overduerate
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,termmonth
,maturity
,gaincyc
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,contractsum
,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'') as bailtransaccount
,operatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno
,bailsum
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.secondpayaccount,chr(13),''),chr(10),'') as secondpayaccount
,replace(replace(t1.bailsubaccount,chr(13),''),chr(10),'') as bailsubaccount
,replace(replace(t1.putoutcontrol,chr(13),''),chr(10),'') as putoutcontrol
,termday
,businesssum
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,inputdate
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname
,replace(replace(t1.loanaccountbankname,chr(13),''),chr(10),'') as loanaccountbankname
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.pdgamorfg,chr(13),''),chr(10),'') as pdgamorfg
,replace(replace(t1.loanaccountorgid,chr(13),''),chr(10),'') as loanaccountorgid
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept
,replace(replace(t1.policyversionid,chr(13),''),chr(10),'') as policyversionid
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount
,replace(replace(t1.loanusetype,chr(13),''),chr(10),'') as loanusetype
,replace(replace(t1.loanaccountname,chr(13),''),chr(10),'') as loanaccountname
,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
,pdgpaypercent
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp
,replace(replace(t1.cashconcenaccount,chr(13),''),chr(10),'') as cashconcenaccount
,replace(replace(t1.ecodepartmentcode,chr(13),''),chr(10),'') as ecodepartmentcode
,replace(replace(t1.entscale,chr(13),''),chr(10),'') as entscale
,replace(replace(t1.isfirstloans,chr(13),''),chr(10),'') as isfirstloans
,replace(replace(t1.ispensionindustry,chr(13),''),chr(10),'') as ispensionindustry
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid
,replace(replace(t1.migtbusinesstype,chr(13),''),chr(10),'') as migtbusinesstype
,replace(replace(t1.hangseqno,chr(13),''),chr(10),'') as hangseqno
,replace(replace(t1.relacontractno,chr(13),''),chr(10),'') as relacontractno
,replace(replace(t1.nextsettlementdate,chr(13),''),chr(10),'') as nextsettlementdate
,replace(replace(t1.lprrefertype,chr(13),''),chr(10),'') as lprrefertype
,replace(replace(t1.othcustomername,chr(13),''),chr(10),'') as othcustomername
,replace(replace(t1.othcustomerid,chr(13),''),chr(10),'') as othcustomerid
,replace(replace(t1.subproductname,chr(13),''),chr(10),'') as subproductname

from ${iol_schema}.icms_business_putout t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_business_putout.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
