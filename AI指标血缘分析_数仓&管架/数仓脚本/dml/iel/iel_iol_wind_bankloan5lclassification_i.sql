: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_bankloan5lclassification_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_bankloan5lclassification.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.loan_type,chr(13),''),chr(10),'') as loan_type
,total_amount
,loans_excl_discount
,discount
,pastdueitems
,othercreditasset
,proportion_of_ta
,llimit_of_llr_accrualratio
,ulimit_of_llr_accrualratio
,proportion_of_sll
,migration_rate

from ${iol_schema}.wind_bankloan5lclassification t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_bankloan5lclassification.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
