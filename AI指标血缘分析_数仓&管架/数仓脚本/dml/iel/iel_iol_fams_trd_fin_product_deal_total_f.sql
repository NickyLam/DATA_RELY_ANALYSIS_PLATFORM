: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_trd_fin_product_deal_total_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_trd_fin_product_deal_total.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.totle_trade_id,chr(13),''),chr(10),'') as totle_trade_id
,replace(replace(t1.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,replace(replace(t1.finprod_type2,chr(13),''),chr(10),'') as finprod_type2
,branch
,trade_date
,vdate
,mdate
,settle_date
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,unit_cprice
,unit_int
,unit_fprice
,par_value
,cprice_amt
,share_amt
,prin_amt
,int_amt
,fprice_amt
,fee_amt_pay
,trade_amt
,fee_amt_unpay
,fee_amt
,replace(replace(t1.ps,chr(13),''),chr(10),'') as ps
,yield
,exer_yield
,replace(replace(t1.inv_aim,chr(13),''),chr(10),'') as inv_aim
,replace(replace(t1.trade_status,chr(13),''),chr(10),'') as trade_status
,replace(replace(t1.p_trade_id,chr(13),''),chr(10),'') as p_trade_id
,replace(replace(t1.is_cancel,chr(13),''),chr(10),'') as is_cancel
,replace(replace(t1.is_clean,chr(13),''),chr(10),'') as is_clean
,replace(replace(t1.cash_id,chr(13),''),chr(10),'') as cash_id
,replace(replace(t1.sec_manage_acct_id,chr(13),''),chr(10),'') as sec_manage_acct_id
,replace(replace(t1.b_trade_id,chr(13),''),chr(10),'') as b_trade_id
,replace(replace(t1.chl_id,chr(13),''),chr(10),'') as chl_id
,replace(replace(t1.counter_id,chr(13),''),chr(10),'') as counter_id
,replace(replace(t1.is_out_trade,chr(13),''),chr(10),'') as is_out_trade
,replace(replace(t1.trade_market,chr(13),''),chr(10),'') as trade_market
,replace(replace(t1.trade_plat,chr(13),''),chr(10),'') as trade_plat
,replace(replace(t1.trade_market_mode,chr(13),''),chr(10),'') as trade_market_mode
,replace(replace(t1.trader,chr(13),''),chr(10),'') as trader
,replace(replace(t1.counter_trader,chr(13),''),chr(10),'') as counter_trader
,replace(replace(t1.counter_contact,chr(13),''),chr(10),'') as counter_contact
,replace(replace(t1.f_trade_id,chr(13),''),chr(10),'') as f_trade_id
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.p_totle_trade_id,chr(13),''),chr(10),'') as p_totle_trade_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,current_sub
,last_amt
,last_red
,last_amt_sub
,accounting_amt
,red_profit
,red_cost
,dqprin_amt
,pay_date
,remain_prin
,replace(replace(t1.tg_busi_type,chr(13),''),chr(10),'') as tg_busi_type
,replace(replace(t1.is_overdue_deal,chr(13),''),chr(10),'') as is_overdue_deal
,replace(replace(t1.clear_type,chr(13),''),chr(10),'') as clear_type
,eff_time
,replace(replace(t1.delivery_type,chr(13),''),chr(10),'') as delivery_type
,replace(replace(t1.m_delivery_type,chr(13),''),chr(10),'') as m_delivery_type
,rate
,repo_term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,settle_speed
,pay_unpaidint_amt
,replace(replace(t1.ispay_unpaidint,chr(13),''),chr(10),'') as ispay_unpaidint

from ${iol_schema}.fams_trd_fin_product_deal_total t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_trd_fin_product_deal_total.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
