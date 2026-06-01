: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_cpm_t_data_client_property_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_cpm_t_data_client_property.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.origination_date,chr(13),''),chr(10),'') as origination_date
,replace(replace(t1.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.branch_name,chr(13),''),chr(10),'') as branch_name
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,t1.month_property as month_property
,t1.increase_month_property as increase_month_property
,t1.day_average_property as day_average_property
,t1.inc_day_ave_property as inc_day_ave_property
,t1.month_pro_total as month_pro_total
,t1.inc_month_pro_total as inc_month_pro_total
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
from ${idl_schema}.hdws_dul_d_cpm_t_data_client_property t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_cpm_t_data_client_property.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes