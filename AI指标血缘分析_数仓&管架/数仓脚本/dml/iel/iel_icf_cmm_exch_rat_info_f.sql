: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_exch_rat_info_f
CreateDate: 20240531
FileName:   ${iel_data_path}/cmm_exch_rat_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name
,cny_exch_rat
,usd_exch_rat
,eur_exch_rat
,mdl_price
,base_price
,cash_buy_price
,cash_sell_price
,exch_buy_price
,exch_sell_price
,convt_corp
,exch_rat_mdl_price

from ${icl_schema}.cmm_exch_rat_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_exch_rat_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
