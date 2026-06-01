: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_cust_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t.custst,chr(13),''),chr(10),'') as custst
,replace(replace(t.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t.isdlfr,chr(13),''),chr(10),'') as isdlfr
,replace(replace(t.isstrategycustomer,chr(13),''),chr(10),'') as isstrategycustomer
,replace(replace(t.chargedepartment,chr(13),''),chr(10),'') as chargedepartment
,replace(replace(t.societyinstitutioncode,chr(13),''),chr(10),'') as societyinstitutioncode
,replace(replace(t.swift_bic,chr(13),''),chr(10),'') as swift_bic
,replace(replace(t.banklicense,chr(13),''),chr(10),'') as banklicense
,replace(replace(t.corpid,chr(13),''),chr(10),'') as corpid
,replace(replace(t.otherlicense,chr(13),''),chr(10),'') as otherlicense
,replace(replace(t.fictitiousperson,chr(13),''),chr(10),'') as fictitiousperson
,replace(replace(t.legalperson,chr(13),''),chr(10),'') as legalperson
,replace(replace(t.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t.setupdate,chr(13),''),chr(10),'') as setupdate
,t.registercapital as registercapital
,replace(replace(t.countrycode,chr(13),''),chr(10),'') as countrycode
,replace(replace(t.registeradd,chr(13),''),chr(10),'') as registeradd
,replace(replace(t.orgtype,chr(13),''),chr(10),'') as orgtype
,replace(replace(t.scope,chr(13),''),chr(10),'') as scope
,replace(replace(t.customerownership,chr(13),''),chr(10),'') as customerownership
,replace(replace(t.listingcorpornot,chr(13),''),chr(10),'') as listingcorpornot
,replace(replace(t.privateent,chr(13),''),chr(10),'') as privateent
,replace(replace(t.belongjtcustomerid,chr(13),''),chr(10),'') as belongjtcustomerid
,replace(replace(t.belongjtcustomer,chr(13),''),chr(10),'') as belongjtcustomer
,replace(replace(t.isrelatedparty,chr(13),''),chr(10),'') as isrelatedparty
,replace(replace(t.locality,chr(13),''),chr(10),'') as locality
,replace(replace(t.raterisklevel1,chr(13),''),chr(10),'') as raterisklevel1
,replace(replace(t.ratedate,chr(13),''),chr(10),'') as ratedate
,replace(replace(t.rateorg,chr(13),''),chr(10),'') as rateorg
,replace(replace(t.raterisklevel2,chr(13),''),chr(10),'') as raterisklevel2
,replace(replace(t.innerrisklevel,chr(13),''),chr(10),'') as innerrisklevel
,replace(replace(t.rateenddate,chr(13),''),chr(10),'') as rateenddate
,replace(replace(t.ghuser,chr(13),''),chr(10),'') as ghuser
,replace(replace(t.ghorg,chr(13),''),chr(10),'') as ghorg
from ${iol_schema}.icss_t_cust_info t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes