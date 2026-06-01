: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhincome_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhincome_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(comp_id,chr(10),''),chr(13),'') as comp_id
,replace(replace(ann_dt,chr(10),''),chr(13),'') as ann_dt
,replace(replace(report_period,chr(10),''),chr(13),'') as report_period
,replace(replace(statement_type,chr(10),''),chr(13),'') as statement_type
,replace(replace(iflisted_data,chr(10),''),chr(13),'') as iflisted_data
,replace(replace(crncy_code,chr(10),''),chr(13),'') as crncy_code
,replace(replace(tot_oper_rev,chr(10),''),chr(13),'') as tot_oper_rev
,replace(replace(less_oper_cost,chr(10),''),chr(13),'') as less_oper_cost
,replace(replace(oper_profit,chr(10),''),chr(13),'') as oper_profit
,replace(replace(net_profit_incl_min_int_inc,chr(10),''),chr(13),'') as net_profit_incl_min_int_inc
,replace(replace(net_profit_excl_min_int_inc,chr(10),''),chr(13),'') as net_profit_excl_min_int_inc
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_hxyhincome where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhincome_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes