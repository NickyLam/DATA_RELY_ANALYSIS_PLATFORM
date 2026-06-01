: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_loan_f
CreateDate: 20250317
FileName:   ${iel_data_path}/icms_wyd_loan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.operorg,chr(13),''),chr(10),'') as operorg
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.fullname,chr(13),''),chr(10),'') as fullname
,replace(replace(t1.termdate,chr(13),''),chr(10),'') as termdate
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.maturity,chr(13),''),chr(10),'') as maturity
,tremmonth
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,businesssum
,balance
,businessrate
,overduefine
,replace(replace(t1.startinterestdate,chr(13),''),chr(10),'') as startinterestdate
,replace(replace(t1.payday,chr(13),''),chr(10),'') as payday
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.loanstatus,chr(13),''),chr(10),'') as loanstatus
,replace(replace(t1.absstatus,chr(13),''),chr(10),'') as absstatus
,replace(replace(t1.projectid,chr(13),''),chr(10),'') as projectid
,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod
,replace(replace(t1.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t1.payacctnoname,chr(13),''),chr(10),'') as payacctnoname
,replace(replace(t1.payacctbankno,chr(13),''),chr(10),'') as payacctbankno
,replace(replace(t1.payacctbank,chr(13),''),chr(10),'') as payacctbank
,replace(replace(t1.inacctno,chr(13),''),chr(10),'') as inacctno
,replace(replace(t1.inacctnoname,chr(13),''),chr(10),'') as inacctnoname
,replace(replace(t1.inacctbankno,chr(13),''),chr(10),'') as inacctbankno
,replace(replace(t1.inacctbank,chr(13),''),chr(10),'') as inacctbank
,replace(replace(t1.bondacctno,chr(13),''),chr(10),'') as bondacctno
,replace(replace(t1.typeofcust,chr(13),''),chr(10),'') as typeofcust
,replace(replace(t1.termflag,chr(13),''),chr(10),'') as termflag
,lprbaserate
,replace(replace(t1.loanchangfrequency,chr(13),''),chr(10),'') as loanchangfrequency
,replace(replace(t1.loanusage,chr(13),''),chr(10),'') as loanusage
,replace(replace(t1.withdrawsettleid,chr(13),''),chr(10),'') as withdrawsettleid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.ipcode,chr(13),''),chr(10),'') as ipcode
,replace(replace(t1.interestcalculatetype,chr(13),''),chr(10),'') as interestcalculatetype
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,replace(replace(t1.repricetermunit,chr(13),''),chr(10),'') as repricetermunit
,replace(replace(t1.repricetermfrequency,chr(13),''),chr(10),'') as repricetermfrequency
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,ratefloatvalue
,replace(replace(t1.isriskcreditwhite,chr(13),''),chr(10),'') as isriskcreditwhite
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart
,accrueinterday
,ysintamt
,rcvaaccrpnlt
,ysodpamt
,replace(replace(t1.category,chr(13),''),chr(10),'') as category
,fksdbusinesssum
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid
,replace(replace(t1.taxflag,chr(13),''),chr(10),'') as taxflag
,replace(replace(t1.loanusagedesc,chr(13),''),chr(10),'') as loanusagedesc
,overduedays
,replace(replace(t1.paidoutdate,chr(13),''),chr(10),'') as paidoutdate

from ${iol_schema}.icms_wyd_loan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_loan.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
