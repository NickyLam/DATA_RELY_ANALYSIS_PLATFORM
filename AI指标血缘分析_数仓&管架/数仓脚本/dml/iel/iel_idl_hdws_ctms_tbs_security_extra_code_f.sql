: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_security_extra_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_security_extra_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.security_code
,t1.extra_type
,t1.extra_code
,t1.customer_number
,t1.modify_user
,t1.modify_date
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ctms_tbs_security_extra_code t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_security_extra_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes