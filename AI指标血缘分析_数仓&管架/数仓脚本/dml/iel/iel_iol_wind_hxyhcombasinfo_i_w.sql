: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhcombasinfo_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhcombasinfo_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(comp_id,chr(10),''),chr(13),'') as comp_id
,replace(replace(comp_name,chr(10),''),chr(13),'') as comp_name
,replace(replace(comp_sname,chr(10),''),chr(13),'') as comp_sname
,replace(replace(province,chr(10),''),chr(13),'') as province
,replace(replace(city,chr(10),''),chr(13),'') as city
,replace(replace(address,chr(10),''),chr(13),'') as address
,replace(replace(office,chr(10),''),chr(13),'') as office
,replace(replace(register_number,chr(10),''),chr(13),'') as register_number
,replace(replace(regcapital,chr(10),''),chr(13),'') as regcapital
,replace(replace(currencycode,chr(10),''),chr(13),'') as currencycode
,replace(replace(chairman,chr(10),''),chr(13),'') as chairman
,replace(replace(founddate,chr(10),''),chr(13),'') as founddate
,replace(replace(enddate,chr(10),''),chr(13),'') as enddate
,replace(replace(s_info_totalemployees,chr(10),''),chr(13),'') as s_info_totalemployees
,replace(replace(business_scope,chr(10),''),chr(13),'') as business_scope
,replace(replace(s_info_org_code,chr(10),''),chr(13),'') as s_info_org_code
,replace(replace(wind_ind_code,chr(10),''),chr(13),'') as wind_ind_code
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.wind_hxyhcombasinfo
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhcombasinfo_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes