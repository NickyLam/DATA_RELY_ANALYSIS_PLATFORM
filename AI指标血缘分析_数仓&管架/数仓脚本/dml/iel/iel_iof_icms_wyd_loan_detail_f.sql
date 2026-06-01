: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_loan_detail_f
CreateDate: 20250320
FileName:   ${iel_data_path}/icms_wyd_loan_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.ietmcd,chr(13),''),chr(10),'') as ietmcd
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.loantype,chr(13),''),chr(10),'') as loantype
,replace(replace(t1.agrrelflg,chr(13),''),chr(10),'') as agrrelflg
,replace(replace(t1.subsidizedflg,chr(13),''),chr(10),'') as subsidizedflg
,replace(replace(t1.agrrelprop,chr(13),''),chr(10),'') as agrrelprop
,replace(replace(t1.agrspttype,chr(13),''),chr(10),'') as agrspttype
,replace(replace(t1.realestatetype,chr(13),''),chr(10),'') as realestatetype
,replace(replace(t1.laidoffloantype,chr(13),''),chr(10),'') as laidoffloantype
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.custidtype,chr(13),''),chr(10),'') as custidtype
,replace(replace(t1.custidno,chr(13),''),chr(10),'') as custidno
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.loanpurpose,chr(13),''),chr(10),'') as loanpurpose
,replace(replace(t1.cardstate,chr(13),''),chr(10),'') as cardstate
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.schmaturitydate,chr(13),''),chr(10),'') as schmaturitydate
,graceperiod
,rate
,baserate
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,amount
,balance
,replace(replace(t1.paymentfeq,chr(13),''),chr(10),'') as paymentfeq
,replace(replace(t1.payway,chr(13),''),chr(10),'') as payway
,replace(replace(t1.repricingdate,chr(13),''),chr(10),'') as repricingdate
,replace(replace(t1.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t1.overduetype,chr(13),''),chr(10),'') as overduetype
,overduedays
,replace(replace(t1.intrtyp,chr(13),''),chr(10),'') as intrtyp
,interest
,replace(replace(t1.prinoddate,chr(13),''),chr(10),'') as prinoddate
,prinodamt
,replace(replace(t1.intoddate,chr(13),''),chr(10),'') as intoddate
,intodamt
,subsidizedint
,actsubsidizedint
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource
,replace(replace(t1.extensionflg,chr(13),''),chr(10),'') as extensionflg
,extensionamt
,replace(replace(t1.extensionstart,chr(13),''),chr(10),'') as extensionstart
,replace(replace(t1.extensionmaturity,chr(13),''),chr(10),'') as extensionmaturity
,replace(replace(t1.recomflg,chr(13),''),chr(10),'') as recomflg
,replace(replace(t1.recomdate,chr(13),''),chr(10),'') as recomdate
,bondamt
,capitalfund
,housenum
,tenementfee
,replace(replace(t1.personaddloanflg,chr(13),''),chr(10),'') as personaddloanflg
,replace(replace(t1.managementflag,chr(13),''),chr(10),'') as managementflag
,replace(replace(t1.smelttype,chr(13),''),chr(10),'') as smelttype
,replace(replace(t1.strategytype,chr(13),''),chr(10),'') as strategytype
,replace(replace(t1.upgradeflg,chr(13),''),chr(10),'') as upgradeflg
,generalreserve
,specialprep
,prespe
,reserve
,replace(replace(t1.housebuycount,chr(13),''),chr(10),'') as housebuycount
,replace(replace(t1.usedlocat,chr(13),''),chr(10),'') as usedlocat
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,replace(replace(t1.guartype,chr(13),''),chr(10),'') as guartype
,originalmaturitym
,originalmaturityd
,remainingmaturitym
,remainingmaturityd
,replace(replace(t1.beginloangrade,chr(13),''),chr(10),'') as beginloangrade
,poverdueamt
,replace(replace(t1.agecd,chr(13),''),chr(10),'') as agecd
,replace(replace(t1.pcanceldate,chr(13),''),chr(10),'') as pcanceldate
,pinitterm
,repricingmaturitym
,repricingmaturityd
,replace(replace(t1.culturesign,chr(13),''),chr(10),'') as culturesign
,replace(replace(t1.activatedate,chr(13),''),chr(10),'') as activatedate
,replace(replace(t1.pmtduedate,chr(13),''),chr(10),'') as pmtduedate
,replace(replace(t1.bankgroupid,chr(13),''),chr(10),'') as bankgroupid
,replace(replace(t1.terminatedate,chr(13),''),chr(10),'') as terminatedate
,replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.insurancepaymentflag,chr(13),''),chr(10),'') as insurancepaymentflag
,replace(replace(t1.insurancepaymentdate,chr(13),''),chr(10),'') as insurancepaymentdate
,insurancepaymentprin
,insurancepaymentfee
,replace(replace(t1.terminatereasoncd,chr(13),''),chr(10),'') as terminatereasoncd
,replace(replace(t1.assetplanno,chr(13),''),chr(10),'') as assetplanno
,replace(replace(t1.assettransferorg,chr(13),''),chr(10),'') as assettransferorg
,assettransferamt
,replace(replace(t1.assettransferflag,chr(13),''),chr(10),'') as assettransferflag
,replace(replace(t1.assettransferdate,chr(13),''),chr(10),'') as assettransferdate
,interestpaidamt
,replace(replace(t1.interestallpaiddate,chr(13),''),chr(10),'') as interestallpaiddate
,replace(replace(t1.eventflag,chr(13),''),chr(10),'') as eventflag
,replace(replace(t1.eventdate,chr(13),''),chr(10),'') as eventdate
,replace(replace(t1.loantypestage,chr(13),''),chr(10),'') as loantypestage
,replace(replace(t1.productstcode,chr(13),''),chr(10),'') as productstcode
,pcurrterm
,replace(replace(t1.bondccy,chr(13),''),chr(10),'') as bondccy
,replace(replace(t1.typeofcust,chr(13),''),chr(10),'') as typeofcust
,replace(replace(t1.paidoutdate,chr(13),''),chr(10),'') as paidoutdate
,replace(replace(t1.wtodate,chr(13),''),chr(10),'') as wtodate
,replace(replace(t1.cardno,chr(13),''),chr(10),'') as cardno
,replace(replace(t1.limitreportno,chr(13),''),chr(10),'') as limitreportno
,replace(replace(t1.bgrepodate,chr(13),''),chr(10),'') as bgrepodate
,replace(replace(t1.loanprocessflag,chr(13),''),chr(10),'') as loanprocessflag
,replace(replace(t1.claimeddate,chr(13),''),chr(10),'') as claimeddate
,replace(replace(t1.relativeddloanno,chr(13),''),chr(10),'') as relativeddloanno
,monthrate
,replace(replace(t1.packetdate,chr(13),''),chr(10),'') as packetdate
,packetbalance
,replace(replace(t1.coreenterprisename,chr(13),''),chr(10),'') as coreenterprisename
,replace(replace(t1.coreprojectid,chr(13),''),chr(10),'') as coreprojectid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven
,inreceivebalance

from ${iol_schema}.icms_wyd_loan_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_loan_detail.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
