: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_uuss_uus_organ_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_uuss_uus_organ.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.zoneno as zoneno
,t1.pbocfinancialcode as pbocfinancialcode
,t1.financialcode as financialcode
,t1.swiftcode as swiftcode
,t1.bankcode as bankcode
,t1.legal as legal
,t1.businesslicense as businesslicense
,t1.organizationcode as organizationcode
,t1.taxid as taxid
,t1.organcnfullname as organcnfullname
,t1.organcnshortname as organcnshortname
,t1.organenfullname as organenfullname
,t1.organenshortname as organenshortname
,t1.organstatecode as organstatecode
,t1.organstatus as organstatus
,t1.organfoundingdate as organfoundingdate
,t1.organclosedate as organclosedate
,t1.organtype as organtype
,t1.isst as isst
,t1.ishs as ishs
,t1.isyy as isyy
,t1.isxz as isxz
,t1.iszw as iszw
,t1.organlevel as organlevel
,t1.leafnoteflag as leafnoteflag
,t1.xzuporgancode as xzuporgancode
,t1.zwuporgancode as zwuporgancode
,t1.hsuporgancode as hsuporgancode
,t1.seque as seque
,t1.postcode as postcode
,t1.country as country
,t1.province as province
,t1.city as city
,t1.county as county
,t1.address as address
,t1.email as email
,t1.url as url
,t1.countrycode as countrycode
,t1.areacode as areacode
,t1.phone as phone
,t1.subphone as subphone
,t1.servicephone as servicephone
,t1.funorgan as funorgan
,t1.fundep as fundep
,t1.orderno as orderno
,t1.financiallicnum as financiallicnum
,t1.organsystem as organsystem
,t1.cbrcfininsttid as cbrcfininsttid
,t1.unionfinancialcode as unionfinancialcode
,t1.workstarttm as workstarttm
,t1.workendtm as workendtm
,t1.updatedate as updatedate
,t1.heademplyid as heademplyid
,t1.isxnhs as isxnhs
,t1.rhregcode as rhregcode
,t1.blng_city_pbc as blng_city_pbc
,t1.bankcodeperson as bankcodeperson
,t1.note1 as note1
,t1.note2 as note2
,t1.note3 as note3
,t1.note4 as note4
,t1.note5 as note5
,t1.note6 as note6
,t1.note7 as note7
,t1.note8 as note8
,t1.note9 as note9
,t1.note10 as note10
,t1.bbuporgancode as bbuporgancode
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.organcodekey as organcodekey
,t1.organcode as organcode

from ${idl_schema}.oass_uuss_uus_organ t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_uuss_uus_organ.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
