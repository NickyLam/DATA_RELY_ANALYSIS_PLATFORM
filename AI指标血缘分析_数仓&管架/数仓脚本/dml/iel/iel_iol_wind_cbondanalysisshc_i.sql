: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondanalysisshc_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbondanalysisshc.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.trade_dt,chr(13),''),chr(10),'') as trade_dt
,b_anal_matu_cnbd
,b_anal_dirty_cnbd
,b_anal_accrint_cnbd
,b_anal_net_cnbd
,b_anal_yield_cnbd
,b_anal_modidura_cnbd
,b_anal_cnvxty_cnbd
,b_anal_vobp_cnbd
,b_anal_sprdura_cnbd
,b_anal_sprcnxt_cnbd
,b_anal_price
,b_anal_netprice
,b_anal_yield
,b_anal_modifiedduration
,b_anal_convexity
,b_anal_bpvalue
,b_anal_sduration
,b_anal_scnvxty
,b_anal_interestduration_cnbd
,b_anal_interestcnvxty_cnbd
,b_anal_interestduration
,b_anal_interestcnvxty
,b_anal_price_cnbd
,b_anal_bpyield
,b_anal_surpluscapital
,replace(replace(t1.b_anal_exchange,chr(13),''),chr(10),'') as b_anal_exchange
,replace(replace(t1.b_anal_credibility,chr(13),''),chr(10),'') as b_anal_credibility

from ${iol_schema}.wind_cbondanalysisshc t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondanalysisshc.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
