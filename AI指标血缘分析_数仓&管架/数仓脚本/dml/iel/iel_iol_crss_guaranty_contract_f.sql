: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_guaranty_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_guaranty_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.contracttype,chr(13),''),chr(10),'') as contracttype
,replace(replace(t.guarantytype,chr(13),''),chr(10),'') as guarantytype
,replace(replace(t.contractstatus,chr(13),''),chr(10),'') as contractstatus
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.guarantorid,chr(13),''),chr(10),'') as guarantorid
,replace(replace(t.guarantorname,chr(13),''),chr(10),'') as guarantorname
,replace(replace(t.creditorgid,chr(13),''),chr(10),'') as creditorgid
,replace(replace(t.creditorgname,chr(13),''),chr(10),'') as creditorgname
,replace(replace(t.guarantycurrency,chr(13),''),chr(10),'') as guarantycurrency
,t.guarantyvalue as guarantyvalue
,replace(replace(t.guarantyinfo,chr(13),''),chr(10),'') as guarantyinfo
,replace(replace(t.otherdescribe,chr(13),''),chr(10),'') as otherdescribe
,replace(replace(t.checkguaranty,chr(13),''),chr(10),'') as checkguaranty
,replace(replace(t.reception,chr(13),''),chr(10),'') as reception
,replace(replace(t.receptionduty,chr(13),''),chr(10),'') as receptionduty
,replace(replace(t.guaranryopinion,chr(13),''),chr(10),'') as guaranryopinion
,replace(replace(t.checkguarantyman1,chr(13),''),chr(10),'') as checkguarantyman1
,replace(replace(t.checkguarantyman2,chr(13),''),chr(10),'') as checkguarantyman2
,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t.othername,chr(13),''),chr(10),'') as othername
,replace(replace(t.loancardno,chr(13),''),chr(10),'') as loancardno
,replace(replace(t.guaranteeform,chr(13),''),chr(10),'') as guaranteeform
,replace(replace(t.commondate,chr(13),''),chr(10),'') as commondate
,t.bailratio as bailratio
,replace(replace(t.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t.econtracttype,chr(13),''),chr(10),'') as econtracttype
,replace(replace(t.ectempsaveflag,chr(13),''),chr(10),'') as ectempsaveflag
,replace(replace(t.textcontractno,chr(13),''),chr(10),'') as textcontractno
,replace(replace(t.shortorg,chr(13),''),chr(10),'') as shortorg
,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
,replace(replace(t.partyaaddress,chr(13),''),chr(10),'') as partyaaddress
,replace(replace(t.partyaphone,chr(13),''),chr(10),'') as partyaphone
,replace(replace(t.partyafax,chr(13),''),chr(10),'') as partyafax
,replace(replace(t.partyaprincipal,chr(13),''),chr(10),'') as partyaprincipal
,replace(replace(t.partyaduty,chr(13),''),chr(10),'') as partyaduty
,replace(replace(t.partybname,chr(13),''),chr(10),'') as partybname
,replace(replace(t.partybcerttype,chr(13),''),chr(10),'') as partybcerttype
,replace(replace(t.partybcertid,chr(13),''),chr(10),'') as partybcertid
,replace(replace(t.partybaddress,chr(13),''),chr(10),'') as partybaddress
,replace(replace(t.partybphone,chr(13),''),chr(10),'') as partybphone
,replace(replace(t.partybfax,chr(13),''),chr(10),'') as partybfax
,replace(replace(t.partyblegalperson,chr(13),''),chr(10),'') as partyblegalperson
,replace(replace(t.partybpostcode,chr(13),''),chr(10),'') as partybpostcode
,replace(replace(t.partybduty,chr(13),''),chr(10),'') as partybduty
,replace(replace(t.textmaincontractno,chr(13),''),chr(10),'') as textmaincontractno
,replace(replace(t.guarantyrange,chr(13),''),chr(10),'') as guarantyrange
,replace(replace(t.otherguarantyrange,chr(13),''),chr(10),'') as otherguarantyrange
,replace(replace(t.guarantyperiod,chr(13),''),chr(10),'') as guarantyperiod
,replace(replace(t.otherguarantyperiod1,chr(13),''),chr(10),'') as otherguarantyperiod1
,replace(replace(t.otherguarantyperiod2,chr(13),''),chr(10),'') as otherguarantyperiod2
,replace(replace(t.notarizationflag,chr(13),''),chr(10),'') as notarizationflag
,replace(replace(t.otherpromise,chr(13),''),chr(10),'') as otherpromise
,replace(replace(t.otherparties,chr(13),''),chr(10),'') as otherparties
,replace(replace(t.maincontractname,chr(13),''),chr(10),'') as maincontractname
,replace(replace(t.maincontractcurrency,chr(13),''),chr(10),'') as maincontractcurrency
,t.maincontractsum as maincontractsum
,replace(replace(t.compensatetype,chr(13),''),chr(10),'') as compensatetype
,replace(replace(t.transfercreditrange,chr(13),''),chr(10),'') as transfercreditrange
,replace(replace(t.begintime,chr(13),''),chr(10),'') as begintime
,replace(replace(t.endtime,chr(13),''),chr(10),'') as endtime
,replace(replace(t.financeitem7,chr(13),''),chr(10),'') as financeitem7
,replace(replace(t.financeitem6,chr(13),''),chr(10),'') as financeitem6
,replace(replace(t.guarantytype2,chr(13),''),chr(10),'') as guarantytype2
,replace(replace(t.printflag,chr(13),''),chr(10),'') as printflag
,replace(replace(t.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate
,replace(replace(t.quoteguarantyquota,chr(13),''),chr(10),'') as quoteguarantyquota
,replace(replace(t.quoteguarantyquotano,chr(13),''),chr(10),'') as quoteguarantyquotano
,replace(replace(t.totalcopies,chr(13),''),chr(10),'') as totalcopies
,replace(replace(t.partyacopies,chr(13),''),chr(10),'') as partyacopies
,replace(replace(t.contractword,chr(13),''),chr(10),'') as contractword
,replace(replace(t.contractno1,chr(13),''),chr(10),'') as contractno1
,replace(replace(t.contractname,chr(13),''),chr(10),'') as contractname
,replace(replace(t.currency1,chr(13),''),chr(10),'') as currency1
,t.contractsum1 as contractsum1
,replace(replace(t.contractword2,chr(13),''),chr(10),'') as contractword2
,replace(replace(t.contractno2,chr(13),''),chr(10),'') as contractno2
,replace(replace(t.contractname2,chr(13),''),chr(10),'') as contractname2
,replace(replace(t.currency2,chr(13),''),chr(10),'') as currency2
,t.contractsum2 as contractsum2
,replace(replace(t.currency3,chr(13),''),chr(10),'') as currency3
,t.contractsum3 as contractsum3
,replace(replace(t.currency4,chr(13),''),chr(10),'') as currency4
,t.contractsum4 as contractsum4
,replace(replace(t.firstcreditparty,chr(13),''),chr(10),'') as firstcreditparty
,replace(replace(t.firstcreditcurrency,chr(13),''),chr(10),'') as firstcreditcurrency
,t.firstcreditsum as firstcreditsum
,replace(replace(t.secondcreditparty,chr(13),''),chr(10),'') as secondcreditparty
,replace(replace(t.secondcreditcurrency,chr(13),''),chr(10),'') as secondcreditcurrency
,t.secondcreditsum as secondcreditsum
,replace(replace(t.thirdcreditparty,chr(13),''),chr(10),'') as thirdcreditparty
,replace(replace(t.thirdcreditcurrency,chr(13),''),chr(10),'') as thirdcreditcurrency
,t.thirdcreditsum as thirdcreditsum
,replace(replace(t.preserialno,chr(13),''),chr(10),'') as preserialno
,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t.ypguarantorid,chr(13),''),chr(10),'') as ypguarantorid
,replace(replace(t.registationcode,chr(13),''),chr(10),'') as registationcode
,replace(replace(t.residentflag,chr(13),''),chr(10),'') as residentflag
,replace(replace(t.iscustody,chr(13),''),chr(10),'') as iscustody
,replace(replace(t.obligeeid,chr(13),''),chr(10),'') as obligeeid
,replace(replace(t.obligeename,chr(13),''),chr(10),'') as obligeename
,replace(replace(t.issaveowner,chr(13),''),chr(10),'') as issaveowner
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_guaranty_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_guaranty_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes