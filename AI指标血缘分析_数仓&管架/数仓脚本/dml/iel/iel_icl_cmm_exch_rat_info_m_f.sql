: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_exch_rat_info_m_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_exch_rat_info_m.f.${batch_date}.dat
IF_mark:    m_f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name
,t1.cny_exch_rat as cny_exch_rat
,t1.usd_exch_rat as usd_exch_rat
,t1.eur_exch_rat as eur_exch_rat
,t1.mdl_price as mdl_price
,t1.base_price as base_price
,t1.cash_buy_price as cash_buy_price
,t1.cash_sell_price as cash_sell_price
,t1.exch_buy_price as exch_buy_price
,t1.exch_sell_price as exch_sell_price
,t1.convt_corp as convt_corp
from ${icl_schema}.cmm_exch_rat_info t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_exch_rat_info_m.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes