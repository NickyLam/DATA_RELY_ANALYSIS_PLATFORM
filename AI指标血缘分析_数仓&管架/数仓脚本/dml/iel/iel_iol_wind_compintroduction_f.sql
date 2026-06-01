: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_compintroduction_f
CreateDate: 20240807
FileName:   ${iel_data_path}/wind_compintroduction.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.comp_name,chr(13),''),chr(10),'') as comp_name
,replace(replace(t1.comp_sname,chr(13),''),chr(10),'') as comp_sname
,replace(replace(t1.comp_name_eng,chr(13),''),chr(10),'') as comp_name_eng
,replace(replace(t1.comp_snameeng,chr(13),''),chr(10),'') as comp_snameeng
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.office,chr(13),''),chr(10),'') as office
,replace(replace(t1.zipcode,chr(13),''),chr(10),'') as zipcode
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.website,chr(13),''),chr(10),'') as website
,replace(replace(t1.registernumber,chr(13),''),chr(10),'') as registernumber
,replace(replace(t1.chairman,chr(13),''),chr(10),'') as chairman
,replace(replace(t1.president,chr(13),''),chr(10),'') as president
,replace(replace(t1.discloser,chr(13),''),chr(10),'') as discloser
,regcapital
,replace(replace(t1.currencycode,chr(13),''),chr(10),'') as currencycode
,replace(replace(t1.founddate,chr(13),''),chr(10),'') as founddate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.briefing,chr(13),''),chr(10),'') as briefing
,replace(replace(t1.comp_type,chr(13),''),chr(10),'') as comp_type
,replace(replace(t1.comp_property,chr(13),''),chr(10),'') as comp_property
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.businessscope,chr(13),''),chr(10),'') as businessscope
,replace(replace(t1.company_type,chr(13),''),chr(10),'') as company_type
,s_info_totalemployees
,replace(replace(t1.main_business,chr(13),''),chr(10),'') as main_business
,opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
,is_listed
,replace(replace(t1.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype

from ${iol_schema}.wind_compintroduction t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_compintroduction.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
