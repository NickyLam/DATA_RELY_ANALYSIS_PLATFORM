: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_financialincomedetails_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_financialincomedetails.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type 
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code 
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name 
,t1.item_amount as item_amount 
,t1.classification_number as classification_number 
,replace(replace(t1.publish_value,chr(13),''),chr(10),'') as publish_value 
,replace(replace(t1.publish_counitdimension,chr(13),''),chr(10),'') as publish_counitdimension 
,t1.is_listing_data as is_listing_data 
,replace(replace(t1.acc_sta_code,chr(13),''),chr(10),'') as acc_sta_code 
from ${iol_schema}.wind_financialincomedetails t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_financialincomedetails.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes