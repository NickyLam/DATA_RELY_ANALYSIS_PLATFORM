: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ctms_tbs_security_extra_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ctms_tbs_security_extra_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.security_code,chr(13),''),chr(10),'') as security_code
,replace(replace(t1.extra_type,chr(13),''),chr(10),'') as extra_type
,replace(replace(t1.extra_code,chr(13),''),chr(10),'') as extra_code
,t1.customer_number as customer_number
,t1.modify_user as modify_user
,t1.modify_date as modify_date
 from iol.ctms_tbs_security_extra_code T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ctms_tbs_security_extra_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes