: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_loan_contract_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_loan_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.limitno,chr(13),''),chr(10),'') as limitno
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.custidtype,chr(13),''),chr(10),'') as custidtype
,replace(replace(t1.custidno,chr(13),''),chr(10),'') as custidno
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,replace(replace(t1.loanflg,chr(13),''),chr(10),'') as loanflg
,replace(replace(t1.subloanflg,chr(13),''),chr(10),'') as subloanflg
,contractamt
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.enterpriseemail,chr(13),''),chr(10),'') as enterpriseemail
,replace(replace(t1.legalemail,chr(13),''),chr(10),'') as legalemail
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.contractstatus,chr(13),''),chr(10),'') as contractstatus
,replace(replace(t1.credittype,chr(13),''),chr(10),'') as credittype
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype

from ${iol_schema}.icms_wyd_loan_contract t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_loan_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
