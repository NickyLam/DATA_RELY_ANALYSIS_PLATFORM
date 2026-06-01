: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_rtis_risk_list_f
CreateDate: 20240307
FileName:   ${iel_data_path}/rtis_risk_list.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,list_id
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,create_time
,update_time
,trans_time
,trans_vol
,risk_level
,list_status
,replace(replace(t1.oper_user_name,chr(13),''),chr(10),'') as oper_user_name
,replace(replace(t1.verifi_strategy,chr(13),''),chr(10),'') as verifi_strategy
,replace(replace(t1.notify_strategy,chr(13),''),chr(10),'') as notify_strategy
,score
,risk_flag_times
,riskless_flag_times
,replace(replace(t1.pay_user_id,chr(13),''),chr(10),'') as pay_user_id
,replace(replace(t1.rec_user_id,chr(13),''),chr(10),'') as rec_user_id
,replace(replace(t1.biz_code,chr(13),''),chr(10),'') as biz_code
,replace(replace(t1.pay_user_name,chr(13),''),chr(10),'') as pay_user_name
,replace(replace(t1.rec_user_name,chr(13),''),chr(10),'') as rec_user_name
,replace(replace(t1.risk_type,chr(13),''),chr(10),'') as risk_type
,replace(replace(t1.rule_code,chr(13),''),chr(10),'') as rule_code
,risk_qualitative
,replace(replace(t1.oper_ip,chr(13),''),chr(10),'') as oper_ip
,replace(replace(t1.oper_ip_addr,chr(13),''),chr(10),'') as oper_ip_addr
,replace(replace(t1.gps_info,chr(13),''),chr(10),'') as gps_info
,replace(replace(t1.base_station_info,chr(13),''),chr(10),'') as base_station_info
,replace(replace(t1.succ_control,chr(13),''),chr(10),'') as succ_control
,replace(replace(t1.finger_print,chr(13),''),chr(10),'') as finger_print
,replace(replace(t1.oper_chnl,chr(13),''),chr(10),'') as oper_chnl
,replace(replace(t1.develop_dept,chr(13),''),chr(10),'') as develop_dept
,replace(replace(t1.deal_dept,chr(13),''),chr(10),'') as deal_dept
,replace(replace(t1.order_status,chr(13),''),chr(10),'') as order_status
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.id_card_number,chr(13),''),chr(10),'') as id_card_number
,replace(replace(t1.mobile_number,chr(13),''),chr(10),'') as mobile_number
,replace(replace(t1.list_strategy,chr(13),''),chr(10),'') as list_strategy
,replace(replace(t1.oper_city,chr(13),''),chr(10),'') as oper_city
,replace(replace(t1.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,warn_id
,replace(replace(t1.verify_code,chr(13),''),chr(10),'') as verify_code
,rule_count
,replace(replace(t1.account_organ,chr(13),''),chr(10),'') as account_organ
,replace(replace(t1.account_organ_id,chr(13),''),chr(10),'') as account_organ_id
,replace(replace(t1.trade_remarks,chr(13),''),chr(10),'') as trade_remarks
,replace(replace(t1.trade_purpose,chr(13),''),chr(10),'') as trade_purpose
,replace(replace(t1.rec_bank_name,chr(13),''),chr(10),'') as rec_bank_name
,replace(replace(t1.trade_channel,chr(13),''),chr(10),'') as trade_channel
,replace(replace(t1.trans_data,chr(13),''),chr(10),'') as trans_data
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,aum_m_avg_bal
,replace(replace(t1.model_type,chr(13),''),chr(10),'') as model_type

from ${iol_schema}.rtis_risk_list t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_risk_list.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
