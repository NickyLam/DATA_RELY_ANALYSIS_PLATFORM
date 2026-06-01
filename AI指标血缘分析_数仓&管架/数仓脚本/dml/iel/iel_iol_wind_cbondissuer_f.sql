: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondissuer_f
CreateDate: 20230823
FileName:   ${iel_data_path}/wind_cbondissuer.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,used
,replace(replace(t1.s_info_compind_code1,chr(13),''),chr(10),'') as s_info_compind_code1
,replace(replace(t1.s_info_compind_name1,chr(13),''),chr(10),'') as s_info_compind_name1
,replace(replace(t1.s_info_compind_code2,chr(13),''),chr(10),'') as s_info_compind_code2
,replace(replace(t1.s_info_compind_name2,chr(13),''),chr(10),'') as s_info_compind_name2
,replace(replace(t1.s_info_compind_code3,chr(13),''),chr(10),'') as s_info_compind_code3
,replace(replace(t1.s_info_compind_name3,chr(13),''),chr(10),'') as s_info_compind_name3
,replace(replace(t1.s_info_compind_code4,chr(13),''),chr(10),'') as s_info_compind_code4
,replace(replace(t1.s_info_compind_name4,chr(13),''),chr(10),'') as s_info_compind_name4
,replace(replace(t1.s_info_compregaddress,chr(13),''),chr(10),'') as s_info_compregaddress
,replace(replace(t1.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype
,s_info_listcompornot
,replace(replace(t1.s_info_effective_dt,chr(13),''),chr(10),'') as s_info_effective_dt
,replace(replace(t1.s_info_invalid_dt,chr(13),''),chr(10),'') as s_info_invalid_dt
,replace(replace(t1.b_agency_guarantornature,chr(13),''),chr(10),'') as b_agency_guarantornature
,is_fin_inst

from ${iol_schema}.wind_cbondissuer t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondissuer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
