: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_exch_rat_quot_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_exch_rat_quot_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.exch_rat_type_cd,chr(13),''),chr(10),'') as exch_rat_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,effect_dt
,effect_tm
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.quot_type_cd,chr(13),''),chr(10),'') as quot_type_cd
,realtm_exch_rat_exch_buy_price
,realtm_exch_rat_exch_sell_price
,exch_rat_mdl_price
,fcurr_cash_buy_price
,fcurr_cash_sell_price
,max_float_point
,base_exch_rat

from ${iml_schema}.ref_exch_rat_quot_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_exch_rat_quot_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
