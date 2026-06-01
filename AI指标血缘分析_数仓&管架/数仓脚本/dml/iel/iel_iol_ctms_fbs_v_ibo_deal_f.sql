: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_fbs_v_ibo_deal_f
CreateDate: 20230804
FileName:   ${iel_data_path}/ctms_fbs_v_ibo_deal.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cus_number
,branch_number
,deal_sqno
,deal_date
,value_date
,maturity_date
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,rate
,first_amnt
,maturity_amnt
,day_accrd_intrst_amnt
,rate_type
,interest_base
,current_rate
,accrued_amnt
,trade_purpose
,business_date
,counter_party_id
,replace(replace(t1.counter_party_scname,chr(13),''),chr(10),'') as counter_party_scname
,update_time
,pdd_deal_sqno
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,deal_dir
,replace(replace(t1.client_deal_sqno,chr(13),''),chr(10),'') as client_deal_sqno
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type
,replace(replace(t1.deal_source,chr(13),''),chr(10),'') as deal_source
,replace(replace(t1.deal_market,chr(13),''),chr(10),'') as deal_market
,settle_type
,deal_link_sqno
,modify_date
,portfolio_sqno
,portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,replace(replace(t1.portfolio_type,chr(13),''),chr(10),'') as portfolio_type
,replace(replace(t1.portfolio_status,chr(13),''),chr(10),'') as portfolio_status
,portfolio_link_sqno
,ibo_type
,replace(replace(t1.clear_dep,chr(13),''),chr(10),'') as clear_dep
,rsdl_amnt
,float_direction
,intrst_bnchmrk_srno
,replace(replace(t1.intrst_bnchmrk_name,chr(13),''),chr(10),'') as intrst_bnchmrk_name
,replace(replace(t1.intrst_term,chr(13),''),chr(10),'') as intrst_term
,spread_rate
,replace(replace(t1.pmnt_freq,chr(13),''),chr(10),'') as pmnt_freq
,pmnt_stub_rule
,unwind_cnfrm_rate
,replace(replace(t1.fixing_freq,chr(13),''),chr(10),'') as fixing_freq
,fixing_day_count
,frst_pmnt_date
,day_count
,imps_rate
,usd_crncy_amnt
,replace(replace(t1.event_mask,chr(13),''),chr(10),'') as event_mask
,replace(replace(t1.event_type,chr(13),''),chr(10),'') as event_type
,event_link_sqno
,event_date
,replace(replace(t1.ro_roll_type,chr(13),''),chr(10),'') as ro_roll_type
,ro_calc_amount
,ro_intrst_amount
,replace(replace(t1.confirm_indc,chr(13),''),chr(10),'') as confirm_indc
,replace(replace(t1.collateral_method,chr(13),''),chr(10),'') as collateral_method
,replace(replace(t1.delivery_type,chr(13),''),chr(10),'') as delivery_type
,replace(replace(t1.delivery_type2,chr(13),''),chr(10),'') as delivery_type2
,replace(replace(t1.underlying_currency,chr(13),''),chr(10),'') as underlying_currency
,replace(replace(t1.underlying_stip_value,chr(13),''),chr(10),'') as underlying_stip_value
,replace(replace(t1.underlying_discountamt,chr(13),''),chr(10),'') as underlying_discountamt
,replace(replace(t1.underlying_qty,chr(13),''),chr(10),'') as underlying_qty
,replace(replace(t1.underlying_securityid,chr(13),''),chr(10),'') as underlying_securityid
,replace(replace(t1.underlying_dirty_price,chr(13),''),chr(10),'') as underlying_dirty_price
,replace(replace(t1.underlying_value,chr(13),''),chr(10),'') as underlying_value
,replace(replace(t1.face_value,chr(13),''),chr(10),'') as face_value
,replace(replace(t1.underlying_stip_rate,chr(13),''),chr(10),'') as underlying_stip_rate
,replace(replace(t1.underlying_discountamt2,chr(13),''),chr(10),'') as underlying_discountamt2
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.ma_bank_cn,chr(13),''),chr(10),'') as ma_bank_cn
,replace(replace(t1.ma_bank_en,chr(13),''),chr(10),'') as ma_bank_en
,replace(replace(t1.cp_ma_bank_cn,chr(13),''),chr(10),'') as cp_ma_bank_cn
,replace(replace(t1.cp_ma_bank_en,chr(13),''),chr(10),'') as cp_ma_bank_en
,replace(replace(t1.dealer,chr(13),''),chr(10),'') as dealer
,replace(replace(t1.delivery_type_ibo,chr(13),''),chr(10),'') as delivery_type_ibo

from ${iol_schema}.ctms_fbs_v_ibo_deal t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_fbs_v_ibo_deal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
