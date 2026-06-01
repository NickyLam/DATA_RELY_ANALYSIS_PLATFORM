: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_bankloan5lclassification_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_bankloan5lclassification_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_compcode,chr(10),''),chr(13),'') as s_info_compcode
,replace(replace(report_period,chr(10),''),chr(13),'') as report_period
,replace(replace(loan_type,chr(10),''),chr(13),'') as loan_type
,replace(replace(total_amount,chr(10),''),chr(13),'') as total_amount
,replace(replace(loans_excl_discount,chr(10),''),chr(13),'') as loans_excl_discount
,replace(replace(discount,chr(10),''),chr(13),'') as discount
,replace(replace(pastdueitems,chr(10),''),chr(13),'') as pastdueitems
,replace(replace(othercreditasset,chr(10),''),chr(13),'') as othercreditasset
,replace(replace(proportion_of_ta,chr(10),''),chr(13),'') as proportion_of_ta
,replace(replace(llimit_of_llr_accrualratio,chr(10),''),chr(13),'') as llimit_of_llr_accrualratio
,replace(replace(ulimit_of_llr_accrualratio,chr(10),''),chr(13),'') as ulimit_of_llr_accrualratio
,replace(replace(proportion_of_sll,chr(10),''),chr(13),'') as proportion_of_sll
,replace(replace(migration_rate,chr(10),''),chr(13),'') as migration_rate
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_bankloan5lclassification
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_bankloan5lclassification_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes