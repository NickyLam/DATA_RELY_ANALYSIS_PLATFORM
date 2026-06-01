: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hxyhcombasinfo_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hxyhcombasinfo.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.comp_name,chr(13),''),chr(10),'') as comp_name
,replace(replace(t1.comp_sname,chr(13),''),chr(10),'') as comp_sname
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.office,chr(13),''),chr(10),'') as office
,replace(replace(t1.register_number,chr(13),''),chr(10),'') as register_number
,t1.regcapital as regcapital
,replace(replace(t1.currencycode,chr(13),''),chr(10),'') as currencycode
,replace(replace(t1.chairman,chr(13),''),chr(10),'') as chairman
,replace(replace(t1.founddate,chr(13),''),chr(10),'') as founddate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,t1.s_info_totalemployees as s_info_totalemployees
,replace(replace(t1.business_scope,chr(13),''),chr(10),'') as business_scope
,replace(replace(t1.s_info_org_code,chr(13),''),chr(10),'') as s_info_org_code
,replace(replace(t1.wind_ind_code,chr(13),''),chr(10),'') as wind_ind_code
from ${iol_schema}.wind_hxyhcombasinfo t1
where start_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hxyhcombasinfo.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes