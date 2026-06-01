: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hkgsdcashflow_i
CreateDate: 20240430
FileName:   ${iel_data_path}/wind_hkgsdcashflow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.begin_dt,chr(13),''),chr(10),'') as begin_dt
,replace(replace(t1.end_dt,chr(13),''),chr(10),'') as end_dt
,report_type
,statement_type
,is_calc
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,net_cash_flows_oper_act
,net_profit_cs
,plus_net_da
,op_cap_change
,oth_noncash_change
,net_cash_flows_inv_act
,cash_recp_fixasset_sell
,less_cap_expense
,less_inv_incr
,inv_decr
,net_oth_icf
,net_cash_flows_fund_act
,debt_incr
,less_debt_decr
,cap_incr
,plus_net_cap_decr
,tot_div_paid
,net_oth_fcf
,e_change_effect
,oth_cf_adjust
,net_incr_cash_cash_equ
,cash_cash_equ_beg_period
,cash_cash_equ_end_period
,replace(replace(t1.s_meno,chr(13),''),chr(10),'') as s_meno

from ${iol_schema}.wind_hkgsdcashflow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hkgsdcashflow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
