: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_zjbk_business_apply_f
CreateDate: 20251103
FileName:   ${iel_data_path}/icms_zjbk_business_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.lhdreqid,chr(13),''),chr(10),'') as lhdreqid
,replace(replace(t1.zdreqid,chr(13),''),chr(10),'') as zdreqid
,replace(replace(t1.accountid,chr(13),''),chr(10),'') as accountid
,replace(replace(t1.credittag,chr(13),''),chr(10),'') as credittag
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.idnumber,chr(13),''),chr(10),'') as idnumber
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.productmode,chr(13),''),chr(10),'') as productmode
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,birthday
,creditamount
,dailyrate
,annualrate
,replace(replace(t1.idcardaddress,chr(13),''),chr(10),'') as idcardaddress
,replace(replace(t1.idcardstartdate,chr(13),''),chr(10),'') as idcardstartdate
,replace(replace(t1.idcardenddate,chr(13),''),chr(10),'') as idcardenddate
,replace(replace(t1.idcardethnicity,chr(13),''),chr(10),'') as idcardethnicity
,replace(replace(t1.idcardauthority,chr(13),''),chr(10),'') as idcardauthority
,replace(replace(t1.careerindustry,chr(13),''),chr(10),'') as careerindustry
,replace(replace(t1.cardid,chr(13),''),chr(10),'') as cardid
,replace(replace(t1.bankname,chr(13),''),chr(10),'') as bankname
,replace(replace(t1.bankphone,chr(13),''),chr(10),'') as bankphone
,replace(replace(t1.enterprisename,chr(13),''),chr(10),'') as enterprisename
,replace(replace(t1.uniformsocialcreditcode,chr(13),''),chr(10),'') as uniformsocialcreditcode
,replace(replace(t1.businesslicense,chr(13),''),chr(10),'') as businesslicense
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.companyindustry,chr(13),''),chr(10),'') as companyindustry
,replace(replace(t1.ifexeshare,chr(13),''),chr(10),'') as ifexeshare
,replace(replace(t1.xwlabel,chr(13),''),chr(10),'') as xwlabel
,replace(replace(t1.riskstatus,chr(13),''),chr(10),'') as riskstatus
,replace(replace(t1.failreason,chr(13),''),chr(10),'') as failreason
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag
,replace(replace(t1.loanid,chr(13),''),chr(10),'') as loanid
,appliedamount
,availableamount
,loanamount
,bankamount
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.usage,chr(13),''),chr(10),'') as usage
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,orderdailyrate
,orderannualrate
,replace(replace(t1.capitalsetno,chr(13),''),chr(10),'') as capitalsetno
,riskcreditamount
,riskintrate
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,riskreqtime
,replace(replace(t1.creditchannel,chr(13),''),chr(10),'') as creditchannel
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.failcode,chr(13),''),chr(10),'') as failcode
,effectdate
,replace(replace(t1.intraindustrytype,chr(13),''),chr(10),'') as intraindustrytype
,replace(replace(t1.industrysource,chr(13),''),chr(10),'') as industrysource
,replace(replace(t1.totalassets,chr(13),''),chr(10),'') as totalassets
,replace(replace(t1.operatingrevenue,chr(13),''),chr(10),'') as operatingrevenue
,replace(replace(t1.colleguesnum,chr(13),''),chr(10),'') as colleguesnum
,replace(replace(t1.enterprisescale,chr(13),''),chr(10),'') as enterprisescale
,replace(replace(t1.locationinfo,chr(13),''),chr(10),'') as locationinfo
,replace(replace(t1.repayday,chr(13),''),chr(10),'') as repayday
,replace(replace(t1.reserveinfo,chr(13),''),chr(10),'') as reserveinfo
,replace(replace(t1.rdriskstatus,chr(13),''),chr(10),'') as rdriskstatus
,replace(replace(t1.rdfailcode,chr(13),''),chr(10),'') as rdfailcode
,replace(replace(t1.rdfailreason,chr(13),''),chr(10),'') as rdfailreason
,rdriskreqtime

from ${iol_schema}.icms_zjbk_business_apply t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_zjbk_business_apply.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
