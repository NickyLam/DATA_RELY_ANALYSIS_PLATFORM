: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_trd_product_deal_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_trd_product_deal_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(trade_id,chr(13),''),chr(10),'') as trade_id
      ,replace(replace(portfolio_id,chr(13),''),chr(10),'') as portfolio_id
      ,replace(replace(custom_cash_type,chr(13),''),chr(10),'') as custom_cash_type
      ,replace(replace(gen_type,chr(13),''),chr(10),'') as gen_type
      ,pur_cfm_date
      ,red_cfm_date
      ,reg_date
      ,bonus_cfm_date
      ,replace(replace(entrust_id,chr(13),''),chr(10),'') as entrust_id
      ,replace(replace(pay_type,chr(13),''),chr(10),'') as pay_type
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,red_profit
      ,red_cost
      ,reg_date_amt
      ,replace(replace(mp_finprod_id,chr(13),''),chr(10),'') as mp_finprod_id
      ,mp_branch
      ,replace(replace(deal_mode,chr(13),''),chr(10),'') as deal_mode
      ,replace(replace(exc_deal_type,chr(13),''),chr(10),'') as exc_deal_type
      ,replace(replace(cur_pair,chr(13),''),chr(10),'') as cur_pair
      ,replace(replace(term_type,chr(13),''),chr(10),'') as term_type
      ,usd_amt
      ,replace(replace(our_role,chr(13),''),chr(10),'') as our_role
      ,quot_pre
      ,priced_date
      ,priced_date_rate
      ,dif_pay_amt
      ,replace(replace(dif_pay_ccy,chr(13),''),chr(10),'') as dif_pay_ccy
      ,replace(replace(dif_ps,chr(13),''),chr(10),'') as dif_ps
      ,lock_mdate
      ,replace(replace(with_lock_period,chr(13),''),chr(10),'') as with_lock_period
      ,replace(replace(ref_rate,chr(13),''),chr(10),'') as ref_rate
      ,deviation
      ,replace(replace(asset_recommand_org,chr(13),''),chr(10),'') as asset_recommand_org
      ,exp_con_value
      ,deposit_amt
      ,replace(replace(r_finprod_id,chr(13),''),chr(10),'') as r_finprod_id
      ,terminate_rate
      ,penalty_intamt
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_trd_product_deal_add
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_trd_product_deal_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes