: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhcashflow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhcashflow_w.i.${batch_date}.dat
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
,replace(replace(net_cash_flows_oper_act,chr(10),''),chr(13),'') as net_cash_flows_oper_act
,replace(replace(net_cash_flows_inv_act,chr(10),''),chr(13),'') as net_cash_flows_inv_act
,replace(replace(net_cash_flows_fnc_act,chr(10),''),chr(13),'') as net_cash_flows_fnc_act
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_hxyhcashflow where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhcashflow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes