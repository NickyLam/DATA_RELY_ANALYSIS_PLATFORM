: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amls_t1h_model_fomula_f
CreateDate: 20241112
FileName:   ${iel_data_path}/amls_t1h_model_fomula.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fomula_id,chr(13),''),chr(10),'') as fomula_id
,replace(replace(t1.model_id,chr(13),''),chr(10),'') as model_id
,replace(replace(t1.fomula_name,chr(13),''),chr(10),'') as fomula_name
,replace(replace(t1.level_id,chr(13),''),chr(10),'') as level_id
,replace(replace(t1.fomula_des,chr(13),''),chr(10),'') as fomula_des
,replace(replace(t1.fomula_freq,chr(13),''),chr(10),'') as fomula_freq
,replace(replace(t1.fomula_explain,chr(13),''),chr(10),'') as fomula_explain
,exec_seq
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.create_tm,chr(13),''),chr(10),'') as create_tm
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.modify_tm,chr(13),''),chr(10),'') as modify_tm
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,who_first

from ${iol_schema}.amls_t1h_model_fomula t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1h_model_fomula.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
