: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_pay_order_f
CreateDate: 20251106
FileName:   ${iel_data_path}/amss_pay_order.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,mch_id
,replace(replace(t1.mch_no,chr(13),''),chr(10),'') as mch_no
,replace(replace(t1.mch_name,chr(13),''),chr(10),'') as mch_name
,replace(replace(t1.out_trade_no,chr(13),''),chr(10),'') as out_trade_no
,money
,refund_money
,trade_state
,add_time
,trade_time
,total_fee
,replace(replace(t1.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type
,replace(replace(t1.trade_name,chr(13),''),chr(10),'') as trade_name
,notify_state
,notify_time
,replace(replace(t1.charset,chr(13),''),chr(10),'') as charset
,replace(replace(t1.sign_type,chr(13),''),chr(10),'') as sign_type
,update_version
,center_id
,replace(replace(t1.decrypt_key,chr(13),''),chr(10),'') as decrypt_key
,replace(replace(t1.notify_url,chr(13),''),chr(10),'') as notify_url
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.cash_fee_type,chr(13),''),chr(10),'') as cash_fee_type
,cash_fee
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.termno,chr(13),''),chr(10),'') as termno
,replace(replace(t1.shopno,chr(13),''),chr(10),'') as shopno
,replace(replace(t1.groupno,chr(13),''),chr(10),'') as groupno
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.agentno,chr(13),''),chr(10),'') as agentno
,replace(replace(t1.operno,chr(13),''),chr(10),'') as operno
,replace(replace(t1.deparno,chr(13),''),chr(10),'') as deparno
,replace(replace(t1.body,chr(13),''),chr(10),'') as body
,replace(replace(t1.bank_type,chr(13),''),chr(10),'') as bank_type
,replace(replace(t1.attach,chr(13),''),chr(10),'') as attach
,replace(replace(t1.device_info,chr(13),''),chr(10),'') as device_info
,replace(replace(t1.appid,chr(13),''),chr(10),'') as appid
,replace(replace(t1.partner,chr(13),''),chr(10),'') as partner
,replace(replace(t1.openid,chr(13),''),chr(10),'') as openid
,replace(replace(t1.is_subscribe,chr(13),''),chr(10),'') as is_subscribe
,coupon_fee
,replace(replace(t1.mch_create_ip,chr(13),''),chr(10),'') as mch_create_ip
,replace(replace(t1.pay_create_ip,chr(13),''),chr(10),'') as pay_create_ip
,replace(replace(t1.return_url,chr(13),''),chr(10),'') as return_url
,replace(replace(t1.sub_partner,chr(13),''),chr(10),'') as sub_partner
,replace(replace(t1.sub_appid,chr(13),''),chr(10),'') as sub_appid
,replace(replace(t1.sub_openid,chr(13),''),chr(10),'') as sub_openid
,replace(replace(t1.sub_is_subscribe,chr(13),''),chr(10),'') as sub_is_subscribe
,replace(replace(t1.agentid,chr(13),''),chr(10),'') as agentid
,replace(replace(t1.data_sign,chr(13),''),chr(10),'') as data_sign
,modify_time
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,fld_n1
,fld_n2
,fld_d1
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.sign_agentno,chr(13),''),chr(10),'') as sign_agentno
,replace(replace(t1.client_ip,chr(13),''),chr(10),'') as client_ip
,replace(replace(t1.used_groupno,chr(13),''),chr(10),'') as used_groupno
,mch_discount_amount
,plat_discount_amount
,mch_rate_type
,mch_rate
,cost_rate
,mch_theory_procedure_fee
,mch_real_procedure_fee
,mch_discount_fee
,debit_card_brokerage_limit
,calc_state
,api_provider
,acc_way_period
,replace(replace(t1.pay_center_id,chr(13),''),chr(10),'') as pay_center_id
,replace(replace(t1.quick_serial_no,chr(13),''),chr(10),'') as quick_serial_no
,replace(replace(t1.acct_dt,chr(13),''),chr(10),'') as acct_dt

from ${iol_schema}.amss_pay_order t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_pay_order.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
