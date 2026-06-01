: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_exch_rat_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_exch_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,effect_dt
,invalid_dt
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.cn_name,chr(13),''),chr(10),'') as cn_name
,replace(replace(t1.en_abbr,chr(13),''),chr(10),'') as en_abbr
,convt_corp
,cash_buy_price
,cash_sell_price
,exch_buy_price
,exch_sell_price
,mdl_p
,fori_exch_mdl_p

from ${iml_schema}.ref_exch_rat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_exch_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
