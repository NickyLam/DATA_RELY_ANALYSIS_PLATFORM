: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_organ_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_organ_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(organcodekey,chr(10),''),chr(13),'') as organcodekey
,replace(replace(organcode,chr(10),''),chr(13),'') as organcode
,replace(replace(zoneno,chr(10),''),chr(13),'') as zoneno
,replace(replace(pbocfinancialcode,chr(10),''),chr(13),'') as pbocfinancialcode
,replace(replace(financialcode,chr(10),''),chr(13),'') as financialcode
,replace(replace(swiftcode,chr(10),''),chr(13),'') as swiftcode
,replace(replace(bankcode,chr(10),''),chr(13),'') as bankcode
,replace(replace(legal,chr(10),''),chr(13),'') as legal
,replace(replace(businesslicense,chr(10),''),chr(13),'') as businesslicense
,replace(replace(organizationcode,chr(10),''),chr(13),'') as organizationcode
,replace(replace(taxid,chr(10),''),chr(13),'') as taxid
,replace(replace(organcnfullname,chr(10),''),chr(13),'') as organcnfullname
,replace(replace(organcnshortname,chr(10),''),chr(13),'') as organcnshortname
,replace(replace(organenfullname,chr(10),''),chr(13),'') as organenfullname
,replace(replace(organenshortname,chr(10),''),chr(13),'') as organenshortname
,replace(replace(organstatecode,chr(10),''),chr(13),'') as organstatecode
,replace(replace(organstatus,chr(10),''),chr(13),'') as organstatus
,replace(replace(organfoundingdate,chr(10),''),chr(13),'') as organfoundingdate
,replace(replace(organclosedate,chr(10),''),chr(13),'') as organclosedate
,replace(replace(organtype,chr(10),''),chr(13),'') as organtype
,replace(replace(isst,chr(10),''),chr(13),'') as isst
,replace(replace(ishs,chr(10),''),chr(13),'') as ishs
,replace(replace(isyy,chr(10),''),chr(13),'') as isyy
,replace(replace(isxz,chr(10),''),chr(13),'') as isxz
,replace(replace(iszw,chr(10),''),chr(13),'') as iszw
,replace(replace(organlevel,chr(10),''),chr(13),'') as organlevel
,replace(replace(leafnoteflag,chr(10),''),chr(13),'') as leafnoteflag
,replace(replace(xzuporgancode,chr(10),''),chr(13),'') as xzuporgancode
,replace(replace(zwuporgancode,chr(10),''),chr(13),'') as zwuporgancode
,replace(replace(hsuporgancode,chr(10),''),chr(13),'') as hsuporgancode
,replace(replace(seque,chr(10),''),chr(13),'') as seque
,replace(replace(postcode,chr(10),''),chr(13),'') as postcode
,replace(replace(country,chr(10),''),chr(13),'') as country
,replace(replace(province,chr(10),''),chr(13),'') as province
,replace(replace(city,chr(10),''),chr(13),'') as city
,replace(replace(county,chr(10),''),chr(13),'') as county
,replace(replace(address,chr(10),''),chr(13),'') as address
,replace(replace(email,chr(10),''),chr(13),'') as email
,replace(replace(url,chr(10),''),chr(13),'') as url
,replace(replace(countrycode,chr(10),''),chr(13),'') as countrycode
,replace(replace(areacode,chr(10),''),chr(13),'') as areacode
,replace(replace(phone,chr(10),''),chr(13),'') as phone
,replace(replace(subphone,chr(10),''),chr(13),'') as subphone
,replace(replace(servicephone,chr(10),''),chr(13),'') as servicephone
,replace(replace(funorgan,chr(10),''),chr(13),'') as funorgan
,replace(replace(fundep,chr(10),''),chr(13),'') as fundep
,replace(replace(orderno,chr(10),''),chr(13),'') as orderno
,replace(replace(financiallicnum,chr(10),''),chr(13),'') as financiallicnum
,replace(replace(organsystem,chr(10),''),chr(13),'') as organsystem
,replace(replace(cbrcfininsttid,chr(10),''),chr(13),'') as cbrcfininsttid
,replace(replace(unionfinancialcode,chr(10),''),chr(13),'') as unionfinancialcode
,replace(replace(workstarttm,chr(10),''),chr(13),'') as workstarttm
,replace(replace(workendtm,chr(10),''),chr(13),'') as workendtm
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(heademplyid,chr(10),''),chr(13),'') as heademplyid
,replace(replace(isxnhs,chr(10),''),chr(13),'') as isxnhs
,replace(replace(rhregcode,chr(10),''),chr(13),'') as rhregcode
,replace(replace(blng_city_pbc,chr(10),''),chr(13),'') as blng_city_pbc
,replace(replace(bankcodeperson,chr(10),''),chr(13),'') as bankcodeperson
,replace(replace(note1,chr(10),''),chr(13),'') as note1
,replace(replace(note2,chr(10),''),chr(13),'') as note2
,replace(replace(note3,chr(10),''),chr(13),'') as note3
,replace(replace(note4,chr(10),''),chr(13),'') as note4
,replace(replace(note5,chr(10),''),chr(13),'') as note5
,replace(replace(note6,chr(10),''),chr(13),'') as note6
,replace(replace(note7,chr(10),''),chr(13),'') as note7
,replace(replace(note8,chr(10),''),chr(13),'') as note8
,replace(replace(note9,chr(10),''),chr(13),'') as note9
,replace(replace(note10,chr(10),''),chr(13),'') as note10
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_uus_organ
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_organ_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes