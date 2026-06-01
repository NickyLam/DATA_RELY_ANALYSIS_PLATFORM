: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_t99_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_t99_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.cd_id,chr(13),''),chr(10),'') as cd_id
,replace(replace(t1.cd_cn_name,chr(13),''),chr(10),'') as cd_cn_name
,replace(replace(t1.cd_en_name,chr(13),''),chr(10),'') as cd_en_name
,replace(replace(t1.cd_val,chr(13),''),chr(10),'') as cd_val
,replace(replace(t1.cd_desc,chr(13),''),chr(10),'') as cd_desc
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
from ${idl_schema}.hdws_iml_t99_code t1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_t99_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes