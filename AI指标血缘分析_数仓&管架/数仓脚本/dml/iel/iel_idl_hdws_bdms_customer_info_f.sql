: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_bdms_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_bdms_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.id
,t1.cust_type
,t1.cust_no
,t1.role_type
,t1.cust_name
,t1.cust_address
,t1.telephone
,t1.fax
,t1.contacter
,t1.post
,t1.province
,t1.city
,t1.class_id
,t1.scale_id
,t1.trade_type_id
,t1.credit_level_id
,t1.open_bank
,t1.bank_account
,t1.register_fund
,t1.group_flag
,t1.group_id
,t1.group_rake
,t1.bank_no
,t1.bank_cate_id
,t1.bank_level
,t1.union_id
,t1.bln_brh_id
,t1.valid_flag
,t1.credit_flag
,t1.organ_code
,t1.has_sign_web
,t1.last_upd_oper_id
,t1.last_upd_time
,t1.flag_isin
,t1.industry_type
,t1.usci_code
,t1.is_farming_cust
,t1.is_green_cust
,t1.pjs_scale
,t1.pjs_trade_type
,t1.pjs_province
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_bdms_customer_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_bdms_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes