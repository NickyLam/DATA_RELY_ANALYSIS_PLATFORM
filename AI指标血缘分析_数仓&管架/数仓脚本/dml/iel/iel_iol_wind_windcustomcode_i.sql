: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_windcustomcode_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_windcustomcode.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.s_info_asharecode,chr(13),''),chr(10),'') as s_info_asharecode
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.s_info_securitiestypes,chr(13),''),chr(10),'') as s_info_securitiestypes
,replace(replace(t.s_info_sectypename,chr(13),''),chr(10),'') as s_info_sectypename
,replace(replace(t.s_info_countryname,chr(13),''),chr(10),'') as s_info_countryname
,replace(replace(t.s_info_countrycode,chr(13),''),chr(10),'') as s_info_countrycode
,replace(replace(t.s_info_exchmarketname,chr(13),''),chr(10),'') as s_info_exchmarketname
,replace(replace(t.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket
,replace(replace(t.crncy_name,chr(13),''),chr(10),'') as crncy_name
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t.s_info_isincode,chr(13),''),chr(10),'') as s_info_isincode
,replace(replace(t.s_info_code,chr(13),''),chr(10),'') as s_info_code
,replace(replace(t.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t.exchmarket,chr(13),''),chr(10),'') as exchmarket
,t.security_status as security_status
,replace(replace(t.s_info_org_code,chr(13),''),chr(10),'') as s_info_org_code
,t.s_info_typecode as s_info_typecode
,t.s_info_min_price_chg_unit as s_info_min_price_chg_unit
,t.s_info_lot_size as s_info_lot_size
,replace(replace(t.s_info_ename,chr(13),''),chr(10),'') as s_info_ename
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_windcustomcode t
where start_dt =to_date('${batch_date}','yyyymmdd') ;
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_windcustomcode.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes