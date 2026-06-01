: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_windcustomcode_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_windcustomcode.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.s_info_asharecode,chr(13),''),chr(10),'') as s_info_asharecode
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.s_info_securitiestypes,chr(13),''),chr(10),'') as s_info_securitiestypes
,replace(replace(t1.s_info_sectypename,chr(13),''),chr(10),'') as s_info_sectypename
,replace(replace(t1.s_info_countryname,chr(13),''),chr(10),'') as s_info_countryname
,replace(replace(t1.s_info_countrycode,chr(13),''),chr(10),'') as s_info_countrycode
,replace(replace(t1.s_info_exchmarketname,chr(13),''),chr(10),'') as s_info_exchmarketname
,replace(replace(t1.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket
,replace(replace(t1.crncy_name,chr(13),''),chr(10),'') as crncy_name
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t1.s_info_isincode,chr(13),''),chr(10),'') as s_info_isincode
,replace(replace(t1.s_info_code,chr(13),''),chr(10),'') as s_info_code
,replace(replace(t1.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t1.exchmarket,chr(13),''),chr(10),'') as exchmarket
,t1.security_status as security_status
,replace(replace(t1.s_info_org_code,chr(13),''),chr(10),'') as s_info_org_code
,t1.s_info_typecode as s_info_typecode
,t1.s_info_min_price_chg_unit as s_info_min_price_chg_unit
,t1.s_info_lot_size as s_info_lot_size
,replace(replace(t1.s_info_ename,chr(13),''),chr(10),'') as s_info_ename
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_windcustomcode t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_windcustomcode.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes