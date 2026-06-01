: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_icms_ba_cl_info_f
CreateDate: 20251126
FileName:   ${iel_data_path}/icms_ba_cl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.outclassifydate as outclassifydate
,t1.totalsumentpart as totalsumentpart
,t1.dlcdbz as dlcdbz
,t1.investtarget as investtarget
,t1.othercondition as othercondition
,t1.iscreditincrement as iscreditincrement
,t1.hxtymainratelevel as hxtymainratelevel
,t1.migtflag as migtflag
,t1.channelname as channelname
,t1.isbillapply as isbillapply
,t1.refbankname as refbankname
,t1.isgovernfinance as isgovernfinance
,t1.lngotimes as lngotimes
,t1.mainlevelorg as mainlevelorg
,t1.singlebizmostamount as singlebizmostamount
,t1.riskexposuresum as riskexposuresum
,t1.nominalsum as nominalsum
,t1.isestatefinance as isestatefinance
,t1.bizextendedterm as bizextendedterm
,t1.availableexposuresum as availableexposuresum
,t1.islikeloan as islikeloan
,t1.publishsum as publishsum
,t1.bizmostmortgagerate as bizmostmortgagerate
,t1.isfinancialcredit as isfinancialcredit
,t1.investway as investway
,t1.fundsource as fundsource
,t1.playtype as playtype
,t1.termtype as termtype
,t1.lineclass as lineclass
,t1.suremodel as suremodel
,t1.managename as managename
,t1.manageid as manageid
,t1.istrans as istrans
,t1.belonggroupapproveno as belonggroupapproveno
,t1.financialcreditowner as financialcreditowner
,t1.issmeandretail as issmeandretail
,t1.originalname as originalname
,t1.ispubliccredit as ispubliccredit
,t1.occupynominalsum as occupynominalsum
,t1.moneyindustryt as moneyindustryt
,t1.bizbailinitialrate as bizbailinitialrate
,t1.transcount as transcount
,t1.maxnominalamount as maxnominalamount
,t1.lowriskexposuresum as lowriskexposuresum
,t1.bizlowestfloatrate as bizlowestfloatrate
,t1.occupyexposuresum as occupyexposuresum
,t1.totalsumtypart as totalsumtypart
,t1.linecontrolmode as linecontrolmode
,t1.latestusedate as latestusedate
,t1.isgreenfinance as isgreenfinance
,t1.otherlimitownerid as otherlimitownerid
,t1.availablenominalsum as availablenominalsum
,t1.hostbankname as hostbankname
,t1.authvouchtype as authvouchtype
,t1.isquerycreditreport as isquerycreditreport
,t1.mainleveldate as mainleveldate
,t1.usewithoutcondition as usewithoutcondition
,t1.isbeltroadfinance as isbeltroadfinance
,t1.otherlimittype as otherlimittype
,t1.sqdkze as sqdkze
,t1.outclassifylevel as outclassifylevel
,t1.jxhjcontractno as jxhjcontractno
,t1.businesssumentpart as businesssumentpart
,t1.currencyrange as currencyrange
,t1.isconsumerfinance as isconsumerfinance
,t1.drtimes as drtimes
,t1.exposuresum as exposuresum
,t1.classifyresulteleven as classifyresulteleven
,t1.issuername as issuername
,t1.financialcreditserialno as financialcreditserialno
,t1.hxtyoperateorg as hxtyoperateorg
,t1.issme as issme
,t1.hostbankno as hostbankno
,t1.agentbankname as agentbankname
,t1.otherlimitno as otherlimitno
,t1.creditauthno as creditauthno
,t1.agentbankno as agentbankno
,t1.approvepubsum as approvepubsum
,t1.outclassifyorg as outclassifyorg
,t1.creditarea as creditarea
,t1.publicorg as publicorg
,t1.isyhcustomer as isyhcustomer
,t1.onlineamount as onlineamount
,t1.refbankno as refbankno
,t1.otherlimitflag as otherlimitflag
,t1.hxtyclassifylevel as hxtyclassifylevel
,t1.businesssumtypart as businesssumtypart
,t1.authostrdate as authostrdate
,t1.bizlongestterm as bizlongestterm
,t1.financialmodel as financialmodel
,t1.channelid as channelid
,t1.maxexposureamount as maxexposureamount
,t1.changetype as changetype
,t1.originalid as originalid
,t1.issuernameid as issuernameid
,t1.phaseopinion as phaseopinion
,t1.finishflag as finishflag
,t1.ispenetrate as ispenetrate
,t1.ifapprove as ifapprove
,t1.afterpayreq as afterpayreq
,t1.contractreq as contractreq
,t1.islikelowrisk as islikelowrisk
,t1.loanmanagereq as loanmanagereq
,t1.payreq as payreq
,t1.focuslendtype as focuslendtype
,t1.isinnovate as isinnovate
,t1.issupplychainfinance as issupplychainfinance
,t1.isprojectfinancing as isprojectfinancing
,t1.custraterisklevel as custraterisklevel
,t1.onlineapprovallimit as onlineapprovallimit
,t1.oastatus as oastatus
,t1.isjoinlimits as isjoinlimits
,t1.otherlimitamount as otherlimitamount
,t1.proborrowerattr as proborrowerattr
,t1.proborrowerincome as proborrowerincome
,t1.proborrowerdebt as proborrowerdebt
,t1.proassetscontrol as proassetscontrol
,t1.prorevenuecontrol as prorevenuecontrol
,t1.projfinancingtype as projfinancingtype
,t1.mercfinancingobject as mercfinancingobject
,t1.itemsfinancingtype as itemsfinancingtype
,t1.isonlineapprove as isonlineapprove
,t1.guaranteecompanyname as guaranteecompanyname
,t1.runentyearincome as runentyearincome
,t1.lastyearentyearincome as lastyearentyearincome
,t1.yearincomerate as yearincomerate
,t1.operationloanbalanceskr as operationloanbalanceskr
,t1.otherworkcaptial as otherworkcaptial
,t1.isrelatedcompany as isrelatedcompany
,t1.subjectbusiness as subjectbusiness
,t1.enterpriseamt as enterpriseamt
,t1.riskapproveamout as riskapproveamout
,t1.riskapprovestatus as riskapprovestatus
,t1.riskterm as riskterm
,t1.isbranchbusiness as isbranchbusiness
,t1.bondingcompanyinamt as bondingcompanyinamt
,t1.guarcompanyterm as guarcompanyterm
,t1.comptaxgrade as comptaxgrade
,t1.ishxdanbaoloan as ishxdanbaoloan

from ${idl_schema}.icms_ba_cl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_ba_cl_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
