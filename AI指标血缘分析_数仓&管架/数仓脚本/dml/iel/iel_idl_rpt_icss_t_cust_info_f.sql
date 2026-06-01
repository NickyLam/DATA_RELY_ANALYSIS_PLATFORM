: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_cust_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.custst,chr(13),''),chr(10),'') as custst
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.isdlfr,chr(13),''),chr(10),'') as isdlfr
,replace(replace(t1.isstrategycustomer,chr(13),''),chr(10),'') as isstrategycustomer
,replace(replace(t1.chargedepartment,chr(13),''),chr(10),'') as chargedepartment
,replace(replace(t1.societyinstitutioncode,chr(13),''),chr(10),'') as societyinstitutioncode
,replace(replace(t1.swift_bic,chr(13),''),chr(10),'') as swift_bic
,replace(replace(t1.banklicense,chr(13),''),chr(10),'') as banklicense
,replace(replace(t1.corpid,chr(13),''),chr(10),'') as corpid
,replace(replace(t1.otherlicense,chr(13),''),chr(10),'') as otherlicense
,replace(replace(t1.fictitiousperson,chr(13),''),chr(10),'') as fictitiousperson
,replace(replace(t1.legalperson,chr(13),''),chr(10),'') as legalperson
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.setupdate,chr(13),''),chr(10),'') as setupdate
,t1.registercapital as registercapital
,replace(replace(t1.countrycode,chr(13),''),chr(10),'') as countrycode
,replace(replace(t1.registeradd,chr(13),''),chr(10),'') as registeradd
,replace(replace(t1.orgtype,chr(13),''),chr(10),'') as orgtype
,replace(replace(t1.scope,chr(13),''),chr(10),'') as scope
,replace(replace(t1.customerownership,chr(13),''),chr(10),'') as customerownership
,replace(replace(t1.listingcorpornot,chr(13),''),chr(10),'') as listingcorpornot
,replace(replace(t1.privateent,chr(13),''),chr(10),'') as privateent
,replace(replace(t1.belongjtcustomerid,chr(13),''),chr(10),'') as belongjtcustomerid
,replace(replace(t1.belongjtcustomer,chr(13),''),chr(10),'') as belongjtcustomer
,replace(replace(t1.isrelatedparty,chr(13),''),chr(10),'') as isrelatedparty
,replace(replace(t1.locality,chr(13),''),chr(10),'') as locality
,replace(replace(t1.raterisklevel1,chr(13),''),chr(10),'') as raterisklevel1
,replace(replace(t1.ratedate,chr(13),''),chr(10),'') as ratedate
,replace(replace(t1.rateorg,chr(13),''),chr(10),'') as rateorg
,replace(replace(t1.raterisklevel2,chr(13),''),chr(10),'') as raterisklevel2
,replace(replace(t1.innerrisklevel,chr(13),''),chr(10),'') as innerrisklevel
,replace(replace(t1.rateenddate,chr(13),''),chr(10),'') as rateenddate
,replace(replace(t1.ghuser,chr(13),''),chr(10),'') as ghuser
,replace(replace(t1.ghorg,chr(13),''),chr(10),'') as ghorg
 from iol.icss_t_cust_info T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes