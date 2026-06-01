: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareeodderivativeindicator_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareeodderivativeindicator.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.trade_dt,chr(13),''),chr(10),'') as trade_dt
    ,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
    ,t.s_val_mv as s_val_mv
    ,t.s_dq_mv as s_dq_mv
    ,t.s_pq_high_52w_ as s_pq_high_52w_
    ,t.s_pq_low_52w_ as s_pq_low_52w_
    ,t.s_val_pe as s_val_pe
    ,t.s_val_pb_new as s_val_pb_new
    ,t.s_val_pe_ttm as s_val_pe_ttm
    ,t.s_val_pcf_ocf as s_val_pcf_ocf
    ,t.s_val_pcf_ocfttm as s_val_pcf_ocfttm
    ,t.s_val_pcf_ncf as s_val_pcf_ncf
    ,t.s_val_pcf_ncfttm as s_val_pcf_ncfttm
    ,t.s_val_ps as s_val_ps
    ,t.s_val_ps_ttm as s_val_ps_ttm
    ,t.s_dq_turn as s_dq_turn
    ,t.s_dq_freeturnover as s_dq_freeturnover
    ,t.tot_shr_today as tot_shr_today
    ,t.float_a_shr_today as float_a_shr_today
    ,t.s_dq_close_today as s_dq_close_today
    ,t.s_price_div_dps as s_price_div_dps
    ,t.s_pq_adjhigh_52w as s_pq_adjhigh_52w
    ,t.s_pq_adjlow_52w as s_pq_adjlow_52w
    ,t.free_shares_today as free_shares_today
    ,t.net_profit_parent_comp_ttm as net_profit_parent_comp_ttm
    ,t.net_profit_parent_comp_lyr as net_profit_parent_comp_lyr
    ,t.net_assets_today as net_assets_today
    ,t.net_cash_flows_oper_act_ttm as net_cash_flows_oper_act_ttm
    ,t.net_cash_flows_oper_act_lyr as net_cash_flows_oper_act_lyr
    ,t.oper_rev_ttm as oper_rev_ttm
    ,t.oper_rev_lyr as oper_rev_lyr
    ,t.net_incr_cash_cash_equ_ttm as net_incr_cash_cash_equ_ttm
    ,t.net_incr_cash_cash_equ_lyr as net_incr_cash_cash_equ_lyr
    ,t.up_down_limit_status as up_down_limit_status
    ,t.lowest_highest_status as lowest_highest_status
from iol.wind_ashareeodderivativeindicator t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareeodderivativeindicator.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes