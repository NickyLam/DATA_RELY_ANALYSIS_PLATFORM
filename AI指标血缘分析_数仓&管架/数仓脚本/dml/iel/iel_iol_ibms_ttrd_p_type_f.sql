: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_p_type_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_p_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_type_name,chr(13),''),chr(10),'') as p_type_name
,t1.is_auto_prft as is_auto_prft
,t1.is_allow_delay as is_allow_delay
,t1.amort_method as amort_method
,replace(replace(t1.amort_method_name,chr(13),''),chr(10),'') as amort_method_name
,t1.is_tprice as is_tprice
,t1.fv_type as fv_type
,t1.is_allow_withdraw as is_allow_withdraw
,t1.is_allow_accrue as is_allow_accrue
,t1.is_allow_receiveai as is_allow_receiveai
,t1.is_auto_overdue as is_auto_overdue
,replace(replace(t1.pending_account,chr(13),''),chr(10),'') as pending_account
,replace(replace(t1.pending_account_name,chr(13),''),chr(10),'') as pending_account_name

from ${iol_schema}.ibms_ttrd_p_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_p_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
