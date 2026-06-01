: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_acc_cash_ext_f
CreateDate: 20240724
FileName:   ${iel_data_path}/ibms_ttrd_acc_cash_ext.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.accid,chr(13),''),chr(10),'') as accid
,replace(replace(t1.accname,chr(13),''),chr(10),'') as accname
,replace(replace(t1.markets,chr(13),''),chr(10),'') as markets
,replace(replace(t1.exhacc,chr(13),''),chr(10),'') as exhacc
,replace(replace(t1.password,chr(13),''),chr(10),'') as password
,status
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,dn_ratio
,threshold
,replace(replace(t1.large_pay_accno,chr(13),''),chr(10),'') as large_pay_accno
,rate
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.open_date,chr(13),''),chr(10),'') as open_date
,replace(replace(t1.is_dvp,chr(13),''),chr(10),'') as is_dvp
,replace(replace(t1.customer_id,chr(13),''),chr(10),'') as customer_id
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.inner_accid,chr(13),''),chr(10),'') as inner_accid
,replace(replace(t1.enabled,chr(13),''),chr(10),'') as enabled
,replace(replace(t1.hands_bank_code,chr(13),''),chr(10),'') as hands_bank_code
,replace(replace(t1.coupontype,chr(13),''),chr(10),'') as coupontype
,replace(replace(t1.accounttype,chr(13),''),chr(10),'') as accounttype
,replace(replace(t1.inner_code,chr(13),''),chr(10),'') as inner_code
,replace(replace(t1.oldinst_id,chr(13),''),chr(10),'') as oldinst_id
,replace(replace(t1.inner_accname,chr(13),''),chr(10),'') as inner_accname
,replace(replace(t1.payment_freq,chr(13),''),chr(10),'') as payment_freq
,rate_def_id
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,invest_type
,pay_month
,pay_day
,i_id
,coupon
,replace(replace(t1.close_date,chr(13),''),chr(10),'') as close_date
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.subj_code,chr(13),''),chr(10),'') as subj_code
,replace(replace(t1.swift_code,chr(13),''),chr(10),'') as swift_code
,replace(replace(t1.mid_bank_acct_code,chr(13),''),chr(10),'') as mid_bank_acct_code
,replace(replace(t1.mid_bank_name,chr(13),''),chr(10),'') as mid_bank_name
,replace(replace(t1.mid_swift_code,chr(13),''),chr(10),'') as mid_swift_code
,use_cash_acc
,replace(replace(t1.bank_legal_person_name,chr(13),''),chr(10),'') as bank_legal_person_name
,replace(replace(t1.branch_bank_number,chr(13),''),chr(10),'') as branch_bank_number
,replace(replace(t1.account_nature,chr(13),''),chr(10),'') as account_nature
,replace(replace(t1.account_attribute,chr(13),''),chr(10),'') as account_attribute
,replace(replace(t1.cross_border_acc,chr(13),''),chr(10),'') as cross_border_acc

from ${iol_schema}.ibms_ttrd_acc_cash_ext t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_acc_cash_ext.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
