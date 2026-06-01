: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbankdepositstructure_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbankdepositstructure_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_compcode,chr(10),''),chr(13),'') as s_info_compcode
,replace(replace(report_period,chr(10),''),chr(13),'') as report_period
,replace(replace(statement_type,chr(10),''),chr(13),'') as statement_type
,replace(replace(crncy_code,chr(10),''),chr(13),'') as crncy_code
,replace(replace(crncy_type_code,chr(10),''),chr(13),'') as crncy_type_code
,replace(replace(loan_type_code,chr(10),''),chr(13),'') as loan_type_code
,replace(replace(deposit_item_code,chr(10),''),chr(13),'') as deposit_item_code
,replace(replace(ann_item,chr(10),''),chr(13),'') as ann_item
,replace(replace(total_deposit,chr(10),''),chr(13),'') as total_deposit
,replace(replace(ave_deposit,chr(10),''),chr(13),'') as ave_deposit
,replace(replace(interest_cost,chr(10),''),chr(13),'') as interest_cost
,replace(replace(average_yield,chr(10),''),chr(13),'') as average_yield
,replace(replace(memo,chr(10),''),chr(13),'') as memo
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_cbankdepositstructure
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbankdepositstructure_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes