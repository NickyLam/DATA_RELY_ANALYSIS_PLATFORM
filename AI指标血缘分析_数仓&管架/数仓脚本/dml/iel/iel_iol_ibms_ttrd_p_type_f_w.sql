: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_p_type_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_p_type_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(id,chr(10),''),chr(13),'') as id
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(p_type_name,chr(10),''),chr(13),'') as p_type_name
,replace(replace(is_auto_prft,chr(10),''),chr(13),'') as is_auto_prft
,replace(replace(is_allow_delay,chr(10),''),chr(13),'') as is_allow_delay
,replace(replace(amort_method,chr(10),''),chr(13),'') as amort_method
,replace(replace(amort_method_name,chr(10),''),chr(13),'') as amort_method_name
,replace(replace(is_tprice,chr(10),''),chr(13),'') as is_tprice
,replace(replace(fv_type,chr(10),''),chr(13),'') as fv_type
,replace(replace(is_allow_withdraw,chr(10),''),chr(13),'') as is_allow_withdraw
,replace(replace(is_allow_accrue,chr(10),''),chr(13),'') as is_allow_accrue
,replace(replace(is_allow_receiveai,chr(10),''),chr(13),'') as is_allow_receiveai
,replace(replace(is_auto_overdue,chr(10),''),chr(13),'') as is_auto_overdue
,replace(replace(pending_account,chr(10),''),chr(13),'') as pending_account
,replace(replace(pending_account_name,chr(10),''),chr(13),'') as pending_account_name
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_p_type
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_p_type_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes