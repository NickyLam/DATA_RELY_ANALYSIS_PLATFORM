: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hxyhcashflow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hxyhcashflow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.iflisted_data,chr(13),''),chr(10),'') as iflisted_data
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.net_cash_flows_oper_act as net_cash_flows_oper_act
,t1.net_cash_flows_inv_act as net_cash_flows_inv_act
,t1.net_cash_flows_fnc_act as net_cash_flows_fnc_act
from ${iol_schema}.wind_hxyhcashflow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hxyhcashflow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes