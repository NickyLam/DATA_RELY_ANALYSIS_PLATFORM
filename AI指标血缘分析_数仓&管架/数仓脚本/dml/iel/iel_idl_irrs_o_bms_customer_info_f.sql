: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_bms_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_bms_customer_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,cust_type
,cust_no
,role_type
,cust_name
,cust_address
,telephone
,fax
,contacter
,post
,province
,city
,class_id
,scale_id
,trade_type_id
,credit_level_id
,open_bank
,bank_account
,register_fund
,group_flag
,group_id
,group_rake
,bank_no
,bank_cate_id
,bank_level
,union_id
,bln_brh_id
,valid_flag
,credit_flag
,organ_code
,has_sign_web
,last_upd_oper_id
,last_upd_time
,flag_isin
from idl.irrs_o_bms_customer_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_bms_customer_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes