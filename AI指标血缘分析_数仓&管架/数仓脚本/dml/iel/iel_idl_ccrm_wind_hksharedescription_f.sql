: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hksharedescription_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hksharedescription.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.s_info_code,chr(13),''),chr(10),'') as s_info_code
,replace(replace(t1.s_info_isincode,chr(13),''),chr(10),'') as s_info_isincode
,replace(replace(t1.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t1.s_info_name_eng,chr(13),''),chr(10),'') as s_info_name_eng
,replace(replace(t1.s_info_fullname,chr(13),''),chr(10),'') as s_info_fullname
,replace(replace(t1.s_info_fullname_eng,chr(13),''),chr(10),'') as s_info_fullname_eng
,t1.securityclass as securityclass
,t1.securitysubclass as securitysubclass
,replace(replace(t1.securitytype,chr(13),''),chr(10),'') as securitytype
,replace(replace(t1.s_info_countrycode,chr(13),''),chr(10),'') as s_info_countrycode
,replace(replace(t1.s_info_exchange_eng,chr(13),''),chr(10),'') as s_info_exchange_eng
,replace(replace(t1.s_info_exchange,chr(13),''),chr(10),'') as s_info_exchange
,replace(replace(t1.s_info_listboard,chr(13),''),chr(10),'') as s_info_listboard
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,t1.s_info_status as s_info_status
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.s_info_par as s_info_par
,t1.min_prc_chg_unit as min_prc_chg_unit
,t1.s_info_unitperlot as s_info_unitperlot
,replace(replace(t1.s_info_listdate,chr(13),''),chr(10),'') as s_info_listdate
,replace(replace(t1.s_info_delistdate,chr(13),''),chr(10),'') as s_info_delistdate
,t1.s_info_listprice as s_info_listprice
,t1.is_hksc as is_hksc
,t1.istemporarysymbol as istemporarysymbol
,t1.is_h as is_h
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_hksharedescription t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hksharedescription.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes