: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.role_type,chr(13),''),chr(10),'') as role_type
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_address,chr(13),''),chr(10),'') as cust_address
,replace(replace(t.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t.contacter,chr(13),''),chr(10),'') as contacter
,replace(replace(t.post,chr(13),''),chr(10),'') as post
,replace(replace(t.province,chr(13),''),chr(10),'') as province
,replace(replace(t.city,chr(13),''),chr(10),'') as city
,t.class_id as class_id
,t.scale_id as scale_id
,t.trade_type_id as trade_type_id
,t.credit_level_id as credit_level_id
,replace(replace(t.open_bank,chr(13),''),chr(10),'') as open_bank
,replace(replace(t.bank_account,chr(13),''),chr(10),'') as bank_account
,replace(replace(t.register_fund,chr(13),''),chr(10),'') as register_fund
,replace(replace(t.group_flag,chr(13),''),chr(10),'') as group_flag
,t.group_id as group_id
,t.group_rake as group_rake
,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
,t.bank_cate_id as bank_cate_id
,replace(replace(t.bank_level,chr(13),''),chr(10),'') as bank_level
,t.union_id as union_id
,t.bln_brh_id as bln_brh_id
,replace(replace(t.valid_flag,chr(13),''),chr(10),'') as valid_flag
,replace(replace(t.credit_flag,chr(13),''),chr(10),'') as credit_flag
,replace(replace(t.organ_code,chr(13),''),chr(10),'') as organ_code
,replace(replace(t.has_sign_web,chr(13),''),chr(10),'') as has_sign_web
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.flag_isin,chr(13),''),chr(10),'') as flag_isin
,replace(replace(t.industry_type,chr(13),''),chr(10),'') as industry_type
,replace(replace(t.usci_code,chr(13),''),chr(10),'') as usci_code
,replace(replace(t.is_farming_cust,chr(13),''),chr(10),'') as is_farming_cust
,replace(replace(t.is_green_cust,chr(13),''),chr(10),'') as is_green_cust
,replace(replace(t.pjs_scale,chr(13),''),chr(10),'') as pjs_scale
,replace(replace(t.pjs_trade_type,chr(13),''),chr(10),'') as pjs_trade_type
,replace(replace(t.pjs_province,chr(13),''),chr(10),'') as pjs_province
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_customer_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes