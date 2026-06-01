: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_business_apply_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_business_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.creditapplyid,chr(13),''),chr(10),'') as creditapplyid
,replace(replace(t1.partnercode,chr(13),''),chr(10),'') as partnercode
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,creditamount
,replace(replace(t1.maritalstatus,chr(13),''),chr(10),'') as maritalstatus
,replace(replace(t1.age,chr(13),''),chr(10),'') as age
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.identitype,chr(13),''),chr(10),'') as identitype
,replace(replace(t1.identino,chr(13),''),chr(10),'') as identino
,idcardexpiredate
,idcardvaliddate
,replace(replace(t1.idaddr,chr(13),''),chr(10),'') as idaddr
,replace(replace(t1.issuedagency,chr(13),''),chr(10),'') as issuedagency
,birthday
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.mobileno,chr(13),''),chr(10),'') as mobileno
,replace(replace(t1.userbankcardno,chr(13),''),chr(10),'') as userbankcardno
,replace(replace(t1.fstlnkmname,chr(13),''),chr(10),'') as fstlnkmname
,replace(replace(t1.fstlnkmtel,chr(13),''),chr(10),'') as fstlnkmtel
,replace(replace(t1.frslnkmrela,chr(13),''),chr(10),'') as frslnkmrela
,replace(replace(t1.livingaddress,chr(13),''),chr(10),'') as livingaddress
,replace(replace(t1.useroccupation,chr(13),''),chr(10),'') as useroccupation
,replace(replace(t1.userindustrycategory,chr(13),''),chr(10),'') as userindustrycategory
,replace(replace(t1.extend,chr(13),''),chr(10),'') as extend
,replace(replace(t1.auditstatus,chr(13),''),chr(10),'') as auditstatus
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.creditno,chr(13),''),chr(10),'') as creditno
,replace(replace(t1.ordertype,chr(13),''),chr(10),'') as ordertype
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.fixedbillday,chr(13),''),chr(10),'') as fixedbillday
,replace(replace(t1.fixedrepayday,chr(13),''),chr(10),'') as fixedrepayday
,loanterm
,settlerate
,replace(replace(t1.loanuse,chr(13),''),chr(10),'') as loanuse
,replace(replace(t1.debitaccountname,chr(13),''),chr(10),'') as debitaccountname
,replace(replace(t1.debitopenaccountbank,chr(13),''),chr(10),'') as debitopenaccountbank
,replace(replace(t1.debitaccountno,chr(13),''),chr(10),'') as debitaccountno
,replace(replace(t1.debitcnaps,chr(13),''),chr(10),'') as debitcnaps
,replace(replace(t1.insureid,chr(13),''),chr(10),'') as insureid
,replace(replace(t1.manualapproval,chr(13),''),chr(10),'') as manualapproval
,replace(replace(t1.finaldecisioncode,chr(13),''),chr(10),'') as finaldecisioncode
,finalapplyamount
,finalapplyterm
,finalapplyvaluation
,replace(replace(t1.risknote,chr(13),''),chr(10),'') as risknote
,replace(replace(t1.riskwarm,chr(13),''),chr(10),'') as riskwarm
,replace(replace(t1.educationlevel,chr(13),''),chr(10),'') as educationlevel
,monthlyincome
,providentfundbaseamt
,securitybaseamt
,replace(replace(t1.providentfundcompany,chr(13),''),chr(10),'') as providentfundcompany
,replace(replace(t1.companyaddr,chr(13),''),chr(10),'') as companyaddr
,recterm
,finishtime
,replace(replace(t1.userrating,chr(13),''),chr(10),'') as userrating

from ${iol_schema}.icms_lx_business_apply t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_business_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
