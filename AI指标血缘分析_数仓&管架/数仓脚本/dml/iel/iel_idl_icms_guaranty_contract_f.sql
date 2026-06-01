: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_guaranty_contract_f
CreateDate: 20221208
FileName:   ${iel_data_path}/icms_guaranty_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.checkguarantydate as checkguarantydate
,t1.checkguarantymana as checkguarantymana
,t1.checkguarantymanb as checkguarantymanb
,t1.certtype as certtype
,t1.certid as certid
,t1.loancardno as loancardno
,t1.guaranteeform as guaranteeform
,t1.inputorgid as inputorgid
,t1.inputuserid as inputuserid
,t1.inputdate as inputdate
,t1.updateorgid as updateorgid
,t1.updateuserid as updateuserid
,t1.updatedate as updatedate
,t1.remark as remark
,t1.corporgid as corporgid
,t1.authostrdate as authostrdate
,t1.istranguaranty as istranguaranty
,t1.isquerycreditreport as isquerycreditreport
,t1.creditauthno as creditauthno
,t1.industrytype as industrytype
,t1.enterprisescope as enterprisescope
,t1.ecodepartmentcode as ecodepartmentcode
,t1.newregioncode as newregioncode
,t1.issaveowner as issaveowner
,t1.obligeename as obligeename
,t1.obligeeid as obligeeid
,t1.iscustody as iscustody
,t1.residentflag as residentflag
,t1.registationcode as registationcode
,t1.guarantyorsum as guarantyorsum
,t1.ypguarantorid as ypguarantorid
,t1.guarantyfax as guarantyfax
,t1.guarantyphone as guarantyphone
,t1.guarantyaddress as guarantyaddress
,t1.isinuse as isinuse
,t1.preserialno as preserialno
,t1.creditaggreement as creditaggreement
,t1.thirdcreditsum as thirdcreditsum
,t1.thirdcreditcurrency as thirdcreditcurrency
,t1.thirdcreditparty as thirdcreditparty
,t1.secondcreditsum as secondcreditsum
,t1.secondcreditcurrency as secondcreditcurrency
,t1.secondcreditparty as secondcreditparty
,t1.firstcreditsum as firstcreditsum
,t1.firstcreditcurrency as firstcreditcurrency
,t1.firstcreditparty as firstcreditparty
,t1.contractsum4 as contractsum4
,t1.currency4 as currency4
,t1.contractsum3 as contractsum3
,t1.currency3 as currency3
,t1.contractsum2 as contractsum2
,t1.currency2 as currency2
,t1.contractname2 as contractname2
,t1.contractno2 as contractno2
,t1.contractword2 as contractword2
,t1.contractsum1 as contractsum1
,t1.currency1 as currency1
,t1.contractname as contractname
,t1.contractno1 as contractno1
,t1.contractword as contractword
,t1.partyacopies as partyacopies
,t1.totalcopies as totalcopies
,t1.quoteguarantyquotano as quoteguarantyquotano
,t1.quoteguarantyquota as quoteguarantyquota
,t1.pigeonholedate as pigeonholedate
,t1.printflag as printflag
,t1.guarantytype2 as guarantytype2
,t1.financeitem6 as financeitem6
,t1.financeitem7 as financeitem7
,t1.endtime as endtime
,t1.begintime as begintime
,t1.transfercreditrange as transfercreditrange
,t1.compensatetype as compensatetype
,t1.maincontractsum as maincontractsum
,t1.maincontractcurrency as maincontractcurrency
,t1.maincontractname as maincontractname
,t1.otherparties as otherparties
,t1.otherpromise as otherpromise
,t1.notarizationflag as notarizationflag
,t1.otherguarantyperiod2 as otherguarantyperiod2
,t1.otherguarantyperiod1 as otherguarantyperiod1
,t1.guarantyperiod as guarantyperiod
,t1.otherguarantyrange as otherguarantyrange
,t1.guarantyrange as guarantyrange
,t1.textmaincontractno as textmaincontractno
,t1.partybduty as partybduty
,t1.partybpostcode as partybpostcode
,t1.partyblegalperson as partyblegalperson
,t1.partybfax as partybfax
,t1.partybphone as partybphone
,t1.partybaddress as partybaddress
,t1.partybcertid as partybcertid
,t1.partybcerttype as partybcerttype
,t1.partybname as partybname
,t1.partyaduty as partyaduty
,t1.partyaprincipal as partyaprincipal
,t1.partyafax as partyafax
,t1.partyaphone as partyaphone
,t1.partyaaddress as partyaaddress
,t1.orgname as orgname
,t1.shortorg as shortorg
,t1.textcontractno as textcontractno
,t1.ectempsaveflag as ectempsaveflag
,t1.econtracttype as econtracttype
,t1.vouchtype as vouchtype
,t1.bailratio as bailratio
,t1.commondate as commondate
,t1.othername as othername
,t1.checkguarantyman2 as checkguarantyman2
,t1.receptionduty as receptionduty
,t1.reception as reception
,t1.creditorgname as creditorgname
,t1.creditorgid as creditorgid
,t1.customerownership as customerownership
,t1.channelflag as channelflag
,t1.guarterm as guarterm
,t1.usesum as usesum
,t1.guarbalance as guarbalance
,t1.guarantyno as guarantyno
,t1.guarantytype as guarantytype
,t1.guarantystyle as guarantystyle
,t1.guarantystatus as guarantystatus
,t1.signdate as signdate
,t1.begindate as begindate
,t1.enddate as enddate
,t1.customerid as customerid
,t1.guarantorid as guarantorid
,t1.guarantorname as guarantorname
,t1.guarantycurrency as guarantycurrency
,t1.guarantyvalue as guarantyvalue
,t1.guarantyinfo as guarantyinfo
,t1.otherdescsribe as otherdescsribe
,t1.guarantyopinion as guarantyopinion
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.migtflag as migtflag
,t1.guartorcate as guartorcate

from ${idl_schema}.icms_guaranty_contract t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_guaranty_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
