: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_call_reg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_call_reg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,biz_account
,cust_name
,cust_id
,br_code
,principal_name
,principal_tel
,principal_phone
,fin_contect_name
,fin_contect_tel
,fin_contect_phone
,chrg_name1
,chrg_tel1
,chrg_phone1
,chrg_name2
,chrg_tel2
,chrg_phone2
,create_date
,update_date
,tr_type
,create_opr
,update_opr
,account_escape_check
,acc_esc_less_check
,check_one
,state
,principal_no_check
,fin_contect_no_check
,chrg_no_check1
,chrg_no_check2
,principal_order
,fin_contect_order
,chrg_order1
,chrg_order2
,acct_name
,open_acct_date
,modify_date
,funds_escape_check
,all_escape_check
,not_funds_escape_check
,other_busi_check
,principal_funds_check
,fin_contect_funds_check
,chrg_funds_check1
,chrg_funds_check2
from ${idl_schema}.odss_flw_t_call_reg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_call_reg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes