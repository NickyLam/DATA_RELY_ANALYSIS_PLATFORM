: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpp_flgnamdef_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpp_flgnamdef.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.flag_field_name,chr(13),''),chr(10),'') as flag_field_name
,replace(replace(t1.value_dscp,chr(13),''),chr(10),'') as value_dscp
,replace(replace(t1.flag_lost_value,chr(13),''),chr(10),'') as flag_lost_value
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,replace(replace(t1.rec_sts,chr(13),''),chr(10),'') as rec_sts
 from iol.dpss_dpp_flgnamdef T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpp_flgnamdef.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes