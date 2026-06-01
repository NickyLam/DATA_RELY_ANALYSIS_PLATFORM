: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpp_flgnamdef_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpp_flgnamdef.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ledge_cod
,t1.flag_field_name
,t1.value_dscp
,t1.flag_lost_value
,t1.mod_opr
,t1.mod_unit
,t1.mod_date
,t1.mod_time
,t1.time_sign
,t1.rec_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpp_flgnamdef t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpp_flgnamdef.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes