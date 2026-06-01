: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acc_cash_ext_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_acc_cash_ext_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(accid,chr(10),''),chr(13),'') as accid
,replace(replace(accname,chr(10),''),chr(13),'') as accname
,replace(replace(markets,chr(10),''),chr(13),'') as markets
,replace(replace(exhacc,chr(10),''),chr(13),'') as exhacc
,replace(replace(password,chr(10),''),chr(13),'') as password
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(dn_ratio,chr(10),''),chr(13),'') as dn_ratio
,replace(replace(threshold,chr(10),''),chr(13),'') as threshold
,replace(replace(large_pay_accno,chr(10),''),chr(13),'') as large_pay_accno
,replace(replace(rate,chr(10),''),chr(13),'') as rate
,replace(replace(bank_code,chr(10),''),chr(13),'') as bank_code
,replace(replace(bank_name,chr(10),''),chr(13),'') as bank_name
,replace(replace(open_date,chr(10),''),chr(13),'') as open_date
,replace(replace(is_dvp,chr(10),''),chr(13),'') as is_dvp
,replace(replace(customer_id,chr(10),''),chr(13),'') as customer_id
,replace(replace(customer_name,chr(10),''),chr(13),'') as customer_name
,replace(replace(inner_accid,chr(10),''),chr(13),'') as inner_accid
,replace(replace(enabled,chr(10),''),chr(13),'') as enabled
,replace(replace(hands_bank_code,chr(10),''),chr(13),'') as hands_bank_code
,replace(replace(coupontype,chr(10),''),chr(13),'') as coupontype
,replace(replace(accounttype,chr(10),''),chr(13),'') as accounttype
,replace(replace(inner_code,chr(10),''),chr(13),'') as inner_code
,replace(replace(oldinst_id,chr(10),''),chr(13),'') as oldinst_id
,replace(replace(inner_accname,chr(10),''),chr(13),'') as inner_accname
,replace(replace(payment_freq,chr(10),''),chr(13),'') as payment_freq
,replace(replace(rate_def_id,chr(10),''),chr(13),'') as rate_def_id
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(create_time,chr(10),''),chr(13),'') as create_time
,replace(replace(invest_type,chr(10),''),chr(13),'') as invest_type
,replace(replace(pay_month,chr(10),''),chr(13),'') as pay_month
,replace(replace(pay_day,chr(10),''),chr(13),'') as pay_day
,replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,replace(replace(coupon,chr(10),''),chr(13),'') as coupon
,replace(replace(close_date,chr(10),''),chr(13),'') as close_date
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(subj_code,chr(10),''),chr(13),'') as subj_code
,replace(replace(swift_code,chr(10),''),chr(13),'') as swift_code
,replace(replace(mid_bank_acct_code,chr(10),''),chr(13),'') as mid_bank_acct_code
,replace(replace(mid_bank_name,chr(10),''),chr(13),'') as mid_bank_name
,replace(replace(mid_swift_code,chr(10),''),chr(13),'') as mid_swift_code
,replace(replace(use_cash_acc,chr(10),''),chr(13),'') as use_cash_acc
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_acc_cash_ext
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acc_cash_ext_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes