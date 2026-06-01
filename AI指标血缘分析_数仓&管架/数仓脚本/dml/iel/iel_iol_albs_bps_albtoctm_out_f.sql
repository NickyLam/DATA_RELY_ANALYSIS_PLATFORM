: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_albs_bps_albtoctm_out_f
CreateDate: 20231030
FileName:   ${iel_data_path}/albs_bps_albtoctm_out.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.black_id,chr(13),''),chr(10),'') as black_id
,replace(replace(t1.source_program,chr(13),''),chr(10),'') as source_program
,replace(replace(t1.is_china_limit,chr(13),''),chr(10),'') as is_china_limit
,replace(replace(t1.bla_type,chr(13),''),chr(10),'') as bla_type
,replace(replace(t1.source_desc,chr(13),''),chr(10),'') as source_desc
,replace(replace(t1.blacklist_type,chr(13),''),chr(10),'') as blacklist_type
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.bla_identity,chr(13),''),chr(10),'') as bla_identity
,replace(replace(t1.bla_name,chr(13),''),chr(10),'') as bla_name
,replace(replace(t1.input_type,chr(13),''),chr(10),'') as input_type
,replace(replace(t1.active_date,chr(13),''),chr(10),'') as active_date
,replace(replace(t1.original_id,chr(13),''),chr(10),'') as original_id
,replace(replace(t1.bla_type_detail,chr(13),''),chr(10),'') as bla_type_detail
,replace(replace(t1.id,chr(13),''),chr(10),'') as id

from ${iol_schema}.albs_bps_albtoctm_out t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/albs_bps_albtoctm_out.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
