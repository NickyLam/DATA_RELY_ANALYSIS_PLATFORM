: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_trade_product_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_fin_trade_product.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,branch
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,replace(replace(t1.finprod_type2,chr(13),''),chr(10),'') as finprod_type2
,replace(replace(t1.profit_type,chr(13),''),chr(10),'') as profit_type
,replace(replace(t1.branch_type,chr(13),''),chr(10),'') as branch_type
,replace(replace(t1.chl_agrt_id,chr(13),''),chr(10),'') as chl_agrt_id
,prin
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,vdate
,mdate
,term
,replace(replace(t1.int_type,chr(13),''),chr(10),'') as int_type
,int_rate
,replace(replace(t1.int_rate_id,chr(13),''),chr(10),'') as int_rate_id
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,m_prin_amt
,m_int_amt
,m_trade_amt
,replace(replace(t1.capi_income_feature,chr(13),''),chr(10),'') as capi_income_feature
,replace(replace(t1.o_finprod_id,chr(13),''),chr(10),'') as o_finprod_id
,replace(replace(t1.trade_market,chr(13),''),chr(10),'') as trade_market
,replace(replace(t1.calendar_id,chr(13),''),chr(10),'') as calendar_id
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,replace(replace(t1.counter_id,chr(13),''),chr(10),'') as counter_id
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,m_unit_cprice
,m_unit_int
,m_unit_fprice
,m_yield
,replace(replace(t1.m_delivery_type,chr(13),''),chr(10),'') as m_delivery_type
,vpay_date
,mpay_date
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,act_cap_days
,replace(replace(t1.irs_type,chr(13),''),chr(10),'') as irs_type
,replace(replace(t1.exc_ps,chr(13),''),chr(10),'') as exc_ps
,replace(replace(t1.cur_pair,chr(13),''),chr(10),'') as cur_pair
,replace(replace(t1.exc_fxs_term_type,chr(13),''),chr(10),'') as exc_fxs_term_type
,usd_amt
,replace(replace(t1.dif_settle_ref_rate,chr(13),''),chr(10),'') as dif_settle_ref_rate
,replace(replace(t1.conflict_solve_way,chr(13),''),chr(10),'') as conflict_solve_way
,replace(replace(t1.period_id,chr(13),''),chr(10),'') as period_id
,replace(replace(t1.is_rush_back,chr(13),''),chr(10),'') as is_rush_back
,replace(replace(t1.contract_name,chr(13),''),chr(10),'') as contract_name

from ${iol_schema}.fams_fin_trade_product t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_trade_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
