: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_antifraud_gung_cust_result_info_f
CreateDate: 20250305
FileName:   ${iel_data_path}/alss_antifraud_gung_cust_result_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.map_number,chr(13),''),chr(10),'') as map_number
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.early_warning_date,chr(13),''),chr(10),'') as early_warning_date
,replace(replace(t1.cust_risk_status,chr(13),''),chr(10),'') as cust_risk_status
,replace(replace(t1.deal_description,chr(13),''),chr(10),'') as deal_description
,replace(replace(t1.deal_result_text,chr(13),''),chr(10),'') as deal_result_text
,replace(replace(t1.deal_user_name,chr(13),''),chr(10),'') as deal_user_name
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.deal_result,chr(13),''),chr(10),'') as deal_result

from ${iol_schema}.alss_antifraud_gung_cust_result_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_antifraud_gung_cust_result_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
