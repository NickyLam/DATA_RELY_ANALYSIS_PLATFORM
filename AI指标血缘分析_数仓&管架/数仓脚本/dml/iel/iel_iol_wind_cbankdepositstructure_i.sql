: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbankdepositstructure_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbankdepositstructure.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,crncy_type_code
,loan_type_code
,deposit_item_code
,replace(replace(t1.ann_item,chr(13),''),chr(10),'') as ann_item
,total_deposit
,ave_deposit
,interest_cost
,average_yield
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo

from ${iol_schema}.wind_cbankdepositstructure t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbankdepositstructure.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
