: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hkcompanyinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hkcompanyinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t1.comp_sname,chr(13),''),chr(10),'') as comp_sname
,replace(replace(t1.comp_name_eng,chr(13),''),chr(10),'') as comp_name_eng
,replace(replace(t1.founddate,chr(13),''),chr(10),'') as founddate
,replace(replace(t1.legalrepresentative,chr(13),''),chr(10),'') as legalrepresentative
,t1.regcapital as regcapital
,replace(replace(t1.briefing,chr(13),''),chr(10),'') as briefing
,replace(replace(t1.businessscope,chr(13),''),chr(10),'') as businessscope
,replace(replace(t1.businessscope_eng,chr(13),''),chr(10),'') as businessscope_eng
,t1.totalemployees as totalemployees
,replace(replace(t1.discloserid,chr(13),''),chr(10),'') as discloserid
,replace(replace(t1.crny_code,chr(13),''),chr(10),'') as crny_code
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.office,chr(13),''),chr(10),'') as office
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.website,chr(13),''),chr(10),'') as website
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_hkcompanyinfo t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hkcompanyinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes