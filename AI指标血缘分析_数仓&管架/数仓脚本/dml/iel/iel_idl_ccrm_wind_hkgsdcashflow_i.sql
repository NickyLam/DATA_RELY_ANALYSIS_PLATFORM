: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hkgsdcashflow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hkgsdcashflow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.begin_dt,chr(13),''),chr(10),'') as begin_dt
,replace(replace(t1.end_dt,chr(13),''),chr(10),'') as end_dt
,t1.report_type as report_type
,t1.statement_type as statement_type
,t1.is_calc as is_calc
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.net_cash_flows_oper_act as net_cash_flows_oper_act
,t1.net_profit_cs as net_profit_cs
,t1.plus_net_da as plus_net_da
,t1.op_cap_change as op_cap_change
,t1.oth_noncash_change as oth_noncash_change
,t1.net_cash_flows_inv_act as net_cash_flows_inv_act
,t1.cash_recp_fixasset_sell as cash_recp_fixasset_sell
,t1.less_cap_expense as less_cap_expense
,t1.less_inv_incr as less_inv_incr
,t1.inv_decr as inv_decr
,t1.net_oth_icf as net_oth_icf
,t1.net_cash_flows_fund_act as net_cash_flows_fund_act
,t1.debt_incr as debt_incr
,t1.less_debt_decr as less_debt_decr
,t1.cap_incr as cap_incr
,t1.plus_net_cap_decr as plus_net_cap_decr
,t1.tot_div_paid as tot_div_paid
,t1.net_oth_fcf as net_oth_fcf
,t1.e_change_effect as e_change_effect
,t1.oth_cf_adjust as oth_cf_adjust
,t1.net_incr_cash_cash_equ as net_incr_cash_cash_equ
,t1.cash_cash_equ_beg_period as cash_cash_equ_beg_period
,t1.cash_cash_equ_end_period as cash_cash_equ_end_period
,replace(replace(t1.s_meno,chr(13),''),chr(10),'') as s_meno
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_hkgsdcashflow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hkgsdcashflow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes