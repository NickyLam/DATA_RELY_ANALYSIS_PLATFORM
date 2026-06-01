: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpp_flgnamdef_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpp_flgnamdef.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.flag_field_name,chr(13),''),chr(10),'') as flag_field_name
,replace(replace(t.value_dscp,chr(13),''),chr(10),'') as value_dscp
,replace(replace(t.flag_lost_value,chr(13),''),chr(10),'') as flag_lost_value
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,t.mod_time as mod_time
,t.time_sign as time_sign
,replace(replace(t.rec_sts,chr(13),''),chr(10),'') as rec_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpp_flgnamdef t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpp_flgnamdef.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes