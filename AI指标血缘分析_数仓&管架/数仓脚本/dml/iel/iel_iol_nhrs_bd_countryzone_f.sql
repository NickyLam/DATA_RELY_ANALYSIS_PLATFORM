: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_bd_countryzone_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_bd_countryzone.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.bbanrule,chr(13),''),chr(10),'') as bbanrule
    ,replace(replace(t.code,chr(13),''),chr(10),'') as code
    ,replace(replace(t.codeth,chr(13),''),chr(10),'') as codeth
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,t.dr as dr
    ,t.ibanlength as ibanlength
    ,replace(replace(t.ibanrule,chr(13),''),chr(10),'') as ibanrule
    ,replace(replace(t.iseucountry,chr(13),''),chr(10),'') as iseucountry
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.name2,chr(13),''),chr(10),'') as name2
    ,replace(replace(t.name3,chr(13),''),chr(10),'') as name3
    ,replace(replace(t.name4,chr(13),''),chr(10),'') as name4
    ,replace(replace(t.name5,chr(13),''),chr(10),'') as name5
    ,replace(replace(t.name6,chr(13),''),chr(10),'') as name6
    ,replace(replace(t.phonecode,chr(13),''),chr(10),'') as phonecode
    ,replace(replace(t.pk_country,chr(13),''),chr(10),'') as pk_country
    ,replace(replace(t.pk_currtype,chr(13),''),chr(10),'') as pk_currtype
    ,replace(replace(t.pk_format,chr(13),''),chr(10),'') as pk_format
    ,replace(replace(t.pk_lang,chr(13),''),chr(10),'') as pk_lang
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_timezone,chr(13),''),chr(10),'') as pk_timezone
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.wholename,chr(13),''),chr(10),'') as wholename
    ,replace(replace(t.wholename2,chr(13),''),chr(10),'') as wholename2
    ,replace(replace(t.wholename3,chr(13),''),chr(10),'') as wholename3
    ,replace(replace(t.wholename4,chr(13),''),chr(10),'') as wholename4
    ,replace(replace(t.wholename5,chr(13),''),chr(10),'') as wholename5
    ,replace(replace(t.wholename6,chr(13),''),chr(10),'') as wholename6
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_bd_countryzone t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_bd_countryzone.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes