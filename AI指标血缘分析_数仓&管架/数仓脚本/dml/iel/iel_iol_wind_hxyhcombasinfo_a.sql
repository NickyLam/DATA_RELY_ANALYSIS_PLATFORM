: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhcombasinfo_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhcombasinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t.comp_name,chr(13),''),chr(10),'') as comp_name
,replace(replace(t.comp_sname,chr(13),''),chr(10),'') as comp_sname
,replace(replace(t.province,chr(13),''),chr(10),'') as province
,replace(replace(t.city,chr(13),''),chr(10),'') as city
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.office,chr(13),''),chr(10),'') as office
,replace(replace(t.register_number,chr(13),''),chr(10),'') as register_number
,t.regcapital as regcapital
,replace(replace(t.currencycode,chr(13),''),chr(10),'') as currencycode
,replace(replace(t.chairman,chr(13),''),chr(10),'') as chairman
,replace(replace(t.founddate,chr(13),''),chr(10),'') as founddate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
,t.s_info_totalemployees as s_info_totalemployees
,replace(replace(t.business_scope,chr(13),''),chr(10),'') as business_scope
,replace(replace(t.s_info_org_code,chr(13),''),chr(10),'') as s_info_org_code
,replace(replace(t.wind_ind_code,chr(13),''),chr(10),'') as wind_ind_code
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_hxyhcombasinfo t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhcombasinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes