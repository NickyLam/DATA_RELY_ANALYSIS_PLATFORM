: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_payment_underwrite_fee_f
CreateDate: 20240430
FileName:   ${iel_data_path}/ctms_tbs_vs_payment_underwrite_fee.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,deal_id
,replace(replace(t1.deal_name,chr(13),''),chr(10),'') as deal_name
,aspclient_id
,portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,keepfolder_id
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.cpty_name,chr(13),''),chr(10),'') as cpty_name
,replace(replace(t1.security_code,chr(13),''),chr(10),'') as security_code
,fee
,trade_date
,value_date
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,replace(replace(t1.uw_trade_no,chr(13),''),chr(10),'') as uw_trade_no
,uw_trade_id
,replace(replace(t1.review_status,chr(13),''),chr(10),'') as review_status
,trade_time
,dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.orig_serial_number,chr(13),''),chr(10),'') as orig_serial_number
,replace(replace(t1.link_serial_number,chr(13),''),chr(10),'') as link_serial_number
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.process_status,chr(13),''),chr(10),'') as process_status
,replace(replace(t1.impstatus,chr(13),''),chr(10),'') as impstatus
,replace(replace(t1.prostatus,chr(13),''),chr(10),'') as prostatus
,lastmodified
,datasymbol_id
,user_number
,modify_user
,modify_date
,counterparty_seq
,ori_trade_date
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.cust_key,chr(13),''),chr(10),'') as cust_key
,underwrite_fee_id_grand
,lastmodified_pay
,replace(replace(t1.dn_dealer,chr(13),''),chr(10),'') as dn_dealer

from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_payment_underwrite_fee.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
