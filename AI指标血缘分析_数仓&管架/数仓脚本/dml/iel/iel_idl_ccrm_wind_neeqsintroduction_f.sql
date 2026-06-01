: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_neeqsintroduction_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_neeqsintroduction.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t1.s_info_compnameeng,chr(13),''),chr(10),'') as s_info_compnameeng
,replace(replace(t1.s_info_country,chr(13),''),chr(10),'') as s_info_country
,replace(replace(t1.s_info_province,chr(13),''),chr(10),'') as s_info_province
,replace(replace(t1.s_info_city,chr(13),''),chr(10),'') as s_info_city
,replace(replace(t1.s_info_chairman,chr(13),''),chr(10),'') as s_info_chairman
,replace(replace(t1.s_info_president,chr(13),''),chr(10),'') as s_info_president
,replace(replace(t1.s_info_bdsecretary,chr(13),''),chr(10),'') as s_info_bdsecretary
,t1.s_info_regcapital as s_info_regcapital
,replace(replace(t1.s_info_founddate,chr(13),''),chr(10),'') as s_info_founddate
,replace(replace(t1.s_info_website,chr(13),''),chr(10),'') as s_info_website
,replace(replace(t1.s_info_email,chr(13),''),chr(10),'') as s_info_email
,replace(replace(t1.s_info_office,chr(13),''),chr(10),'') as s_info_office
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,t1.s_info_totalemployees as s_info_totalemployees
,replace(replace(t1.s_info_businessscope,chr(13),''),chr(10),'') as s_info_businessscope
,replace(replace(t1.s_info_main_business,chr(13),''),chr(10),'') as s_info_main_business
,replace(replace(t1.s_info_chineseintroduction,chr(13),''),chr(10),'') as s_info_chineseintroduction
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_neeqsintroduction t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_neeqsintroduction.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes