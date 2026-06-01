: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_organ_f
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_organ.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.organcodekey,chr(13),''),chr(10),'') as organcodekey
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode
,replace(replace(t1.zoneno,chr(13),''),chr(10),'') as zoneno
,replace(replace(t1.pbocfinancialcode,chr(13),''),chr(10),'') as pbocfinancialcode
,replace(replace(t1.financialcode,chr(13),''),chr(10),'') as financialcode
,replace(replace(t1.swiftcode,chr(13),''),chr(10),'') as swiftcode
,replace(replace(t1.bankcode,chr(13),''),chr(10),'') as bankcode
,replace(replace(t1.legal,chr(13),''),chr(10),'') as legal
,replace(replace(t1.businesslicense,chr(13),''),chr(10),'') as businesslicense
,replace(replace(t1.organizationcode,chr(13),''),chr(10),'') as organizationcode
,replace(replace(t1.taxid,chr(13),''),chr(10),'') as taxid
,replace(replace(t1.organcnfullname,chr(13),''),chr(10),'') as organcnfullname
,replace(replace(t1.organcnshortname,chr(13),''),chr(10),'') as organcnshortname
,replace(replace(t1.organenfullname,chr(13),''),chr(10),'') as organenfullname
,replace(replace(t1.organenshortname,chr(13),''),chr(10),'') as organenshortname
,replace(replace(t1.organstatecode,chr(13),''),chr(10),'') as organstatecode
,replace(replace(t1.organstatus,chr(13),''),chr(10),'') as organstatus
,replace(replace(t1.organfoundingdate,chr(13),''),chr(10),'') as organfoundingdate
,replace(replace(t1.organclosedate,chr(13),''),chr(10),'') as organclosedate
,replace(replace(t1.organtype,chr(13),''),chr(10),'') as organtype
,replace(replace(t1.isst,chr(13),''),chr(10),'') as isst
,replace(replace(t1.ishs,chr(13),''),chr(10),'') as ishs
,replace(replace(t1.isyy,chr(13),''),chr(10),'') as isyy
,replace(replace(t1.isxz,chr(13),''),chr(10),'') as isxz
,replace(replace(t1.iszw,chr(13),''),chr(10),'') as iszw
,replace(replace(t1.organlevel,chr(13),''),chr(10),'') as organlevel
,replace(replace(t1.leafnoteflag,chr(13),''),chr(10),'') as leafnoteflag
,replace(replace(t1.xzuporgancode,chr(13),''),chr(10),'') as xzuporgancode
,replace(replace(t1.zwuporgancode,chr(13),''),chr(10),'') as zwuporgancode
,replace(replace(t1.hsuporgancode,chr(13),''),chr(10),'') as hsuporgancode
,replace(replace(t1.seque,chr(13),''),chr(10),'') as seque
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.county,chr(13),''),chr(10),'') as county
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.url,chr(13),''),chr(10),'') as url
,replace(replace(t1.countrycode,chr(13),''),chr(10),'') as countrycode
,replace(replace(t1.areacode,chr(13),''),chr(10),'') as areacode
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.subphone,chr(13),''),chr(10),'') as subphone
,replace(replace(t1.servicephone,chr(13),''),chr(10),'') as servicephone
,replace(replace(t1.funorgan,chr(13),''),chr(10),'') as funorgan
,replace(replace(t1.fundep,chr(13),''),chr(10),'') as fundep
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno
,replace(replace(t1.financiallicnum,chr(13),''),chr(10),'') as financiallicnum
,replace(replace(t1.organsystem,chr(13),''),chr(10),'') as organsystem
,replace(replace(t1.cbrcfininsttid,chr(13),''),chr(10),'') as cbrcfininsttid
,replace(replace(t1.unionfinancialcode,chr(13),''),chr(10),'') as unionfinancialcode
,replace(replace(t1.workstarttm,chr(13),''),chr(10),'') as workstarttm
,replace(replace(t1.workendtm,chr(13),''),chr(10),'') as workendtm
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate
,replace(replace(t1.heademplyid,chr(13),''),chr(10),'') as heademplyid
,replace(replace(t1.isxnhs,chr(13),''),chr(10),'') as isxnhs
,replace(replace(t1.rhregcode,chr(13),''),chr(10),'') as rhregcode
,replace(replace(t1.blng_city_pbc,chr(13),''),chr(10),'') as blng_city_pbc
,replace(replace(t1.bankcodeperson,chr(13),''),chr(10),'') as bankcodeperson
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,replace(replace(t1.note3,chr(13),''),chr(10),'') as note3
,replace(replace(t1.note4,chr(13),''),chr(10),'') as note4
,replace(replace(t1.note5,chr(13),''),chr(10),'') as note5
,replace(replace(t1.note6,chr(13),''),chr(10),'') as note6
,replace(replace(t1.note7,chr(13),''),chr(10),'') as note7
,replace(replace(t1.note8,chr(13),''),chr(10),'') as note8
,replace(replace(t1.note9,chr(13),''),chr(10),'') as note9
,replace(replace(t1.note10,chr(13),''),chr(10),'') as note10
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.bbuporgancode,chr(13),''),chr(10),'') as bbuporgancode
from ${iol_schema}.uuss_uus_organ t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_organ.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes