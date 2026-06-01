: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_dict_mult_lang_f
CreateDate: 20230423
FileName:   ${iel_data_path}/ibms_ttrd_dict_mult_lang.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dict_type,chr(13),''),chr(10),'') as dict_type
,replace(replace(t1.dict_sub_type,chr(13),''),chr(10),'') as dict_sub_type
,replace(replace(t1.dict_key,chr(13),''),chr(10),'') as dict_key
,replace(replace(t1.dict_lang,chr(13),''),chr(10),'') as dict_lang
,replace(replace(t1.dict_value,chr(13),''),chr(10),'') as dict_value
,dict_key_order
,replace(replace(t1.loadflag,chr(13),''),chr(10),'') as loadflag
,replace(replace(t1.isdefault,chr(13),''),chr(10),'') as isdefault
,replace(replace(t1.dict_description,chr(13),''),chr(10),'') as dict_description
,replace(replace(t1.front_flag,chr(13),''),chr(10),'') as front_flag
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ibms_ttrd_dict_mult_lang t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_dict_mult_lang.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
