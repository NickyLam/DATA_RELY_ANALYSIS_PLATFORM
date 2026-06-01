: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_rms_cptys_udflist_f
CreateDate: 20240816
FileName:   ${iel_data_path}/ctms_tbs_v_rms_cptys_udflist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.entyid,chr(13),''),chr(10),'') as entyid
,replace(replace(t1.udf_code,chr(13),''),chr(10),'') as udf_code
,replace(replace(t1.udf_desc,chr(13),''),chr(10),'') as udf_desc
,replace(replace(t1.udf_type,chr(13),''),chr(10),'') as udf_type
,replace(replace(t1.udf_value,chr(13),''),chr(10),'') as udf_value
,replace(replace(t1.udf_valuedesc,chr(13),''),chr(10),'') as udf_valuedesc

from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_rms_cptys_udflist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
