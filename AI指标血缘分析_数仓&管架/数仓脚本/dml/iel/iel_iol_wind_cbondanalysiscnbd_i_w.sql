: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondanalysiscnbd_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondanalysiscnbd_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_windcode,chr(10),''),chr(13),'') as s_info_windcode
,replace(replace(trade_dt,chr(10),''),chr(13),'') as trade_dt
,replace(replace(b_anal_matu_cnbd,chr(10),''),chr(13),'') as b_anal_matu_cnbd
,replace(replace(b_anal_dirty_cnbd,chr(10),''),chr(13),'') as b_anal_dirty_cnbd
,replace(replace(b_anal_accrint_cnbd,chr(10),''),chr(13),'') as b_anal_accrint_cnbd
,replace(replace(b_anal_net_cnbd,chr(10),''),chr(13),'') as b_anal_net_cnbd
,replace(replace(b_anal_yield_cnbd,chr(10),''),chr(13),'') as b_anal_yield_cnbd
,replace(replace(b_anal_modidura_cnbd,chr(10),''),chr(13),'') as b_anal_modidura_cnbd
,replace(replace(b_anal_cnvxty_cnbd,chr(10),''),chr(13),'') as b_anal_cnvxty_cnbd
,replace(replace(b_anal_vobp_cnbd,chr(10),''),chr(13),'') as b_anal_vobp_cnbd
,replace(replace(b_anal_sprdura_cnbd,chr(10),''),chr(13),'') as b_anal_sprdura_cnbd
,replace(replace(b_anal_sprcnxt_cnbd,chr(10),''),chr(13),'') as b_anal_sprcnxt_cnbd
,replace(replace(b_anal_accrintclose_cnbd,chr(10),''),chr(13),'') as b_anal_accrintclose_cnbd
,replace(replace(b_anal_price,chr(10),''),chr(13),'') as b_anal_price
,replace(replace(b_anal_netprice,chr(10),''),chr(13),'') as b_anal_netprice
,replace(replace(b_anal_yield,chr(10),''),chr(13),'') as b_anal_yield
,replace(replace(b_anal_modifiedduration,chr(10),''),chr(13),'') as b_anal_modifiedduration
,replace(replace(b_anal_convexity,chr(10),''),chr(13),'') as b_anal_convexity
,replace(replace(b_anal_bpvalue,chr(10),''),chr(13),'') as b_anal_bpvalue
,replace(replace(b_anal_sduration,chr(10),''),chr(13),'') as b_anal_sduration
,replace(replace(b_anal_scnvxty,chr(10),''),chr(13),'') as b_anal_scnvxty
,replace(replace(b_anal_interestduration_cnbd,chr(10),''),chr(13),'') as b_anal_interestduration_cnbd
,replace(replace(b_anal_interestcnvxty_cnbd,chr(10),''),chr(13),'') as b_anal_interestcnvxty_cnbd
,replace(replace(b_anal_interestduration,chr(10),''),chr(13),'') as b_anal_interestduration
,replace(replace(b_anal_interestcnvxty,chr(10),''),chr(13),'') as b_anal_interestcnvxty
,replace(replace(b_anal_price_cnbd,chr(10),''),chr(13),'') as b_anal_price_cnbd
,replace(replace(b_anal_bpyield,chr(10),''),chr(13),'') as b_anal_bpyield
,replace(replace(b_anal_exchange,chr(10),''),chr(13),'') as b_anal_exchange
,replace(replace(b_anal_credibility,chr(10),''),chr(13),'') as b_anal_credibility
,replace(replace(b_anal_residualpri,chr(10),''),chr(13),'') as b_anal_residualpri
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_cbondanalysiscnbd
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondanalysiscnbd_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes