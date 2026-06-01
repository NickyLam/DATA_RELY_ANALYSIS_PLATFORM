: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_cust_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.mfcustomerid
,t1.customername
,t1.custst
,t1.customertype
,t1.isdlfr
,t1.isstrategycustomer
,t1.chargedepartment
,t1.societyinstitutioncode
,t1.swift_bic
,t1.banklicense
,t1.corpid
,t1.otherlicense
,t1.fictitiousperson
,t1.legalperson
,t1.industrytype
,t1.setupdate
,t1.registercapital
,t1.countrycode
,t1.registeradd
,t1.orgtype
,t1.scope
,t1.customerownership
,t1.listingcorpornot
,t1.privateent
,t1.belongjtcustomerid
,t1.belongjtcustomer
,t1.isrelatedparty
,t1.locality
,t1.raterisklevel1
,t1.ratedate
,t1.rateorg
,t1.raterisklevel2
,t1.innerrisklevel
,t1.rateenddate
,t1.ghuser
,t1.ghorg
from ${idl_schema}.hdws_icss_t_cust_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes