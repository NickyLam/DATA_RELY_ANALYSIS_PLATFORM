: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_flw_t_call_reg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_flw_t_call_reg.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.biz_account,chr(13),''),chr(10),'') as biz_account
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.br_code,chr(13),''),chr(10),'') as br_code
    ,replace(replace(t.principal_name,chr(13),''),chr(10),'') as principal_name
    ,replace(replace(t.principal_tel,chr(13),''),chr(10),'') as principal_tel
    ,replace(replace(t.principal_phone,chr(13),''),chr(10),'') as principal_phone
    ,replace(replace(t.fin_contect_name,chr(13),''),chr(10),'') as fin_contect_name
    ,replace(replace(t.fin_contect_tel,chr(13),''),chr(10),'') as fin_contect_tel
    ,replace(replace(t.fin_contect_phone,chr(13),''),chr(10),'') as fin_contect_phone
    ,replace(replace(t.chrg_name1,chr(13),''),chr(10),'') as chrg_name1
    ,replace(replace(t.chrg_tel1,chr(13),''),chr(10),'') as chrg_tel1
    ,replace(replace(t.chrg_phone1,chr(13),''),chr(10),'') as chrg_phone1
    ,replace(replace(t.chrg_name2,chr(13),''),chr(10),'') as chrg_name2
    ,replace(replace(t.chrg_tel2,chr(13),''),chr(10),'') as chrg_tel2
    ,replace(replace(t.chrg_phone2,chr(13),''),chr(10),'') as chrg_phone2
    ,t.create_date as create_date
    ,t.update_date as update_date
    ,replace(replace(t.tr_type,chr(13),''),chr(10),'') as tr_type
    ,replace(replace(t.create_opr,chr(13),''),chr(10),'') as create_opr
    ,replace(replace(t.update_opr,chr(13),''),chr(10),'') as update_opr
    ,replace(replace(t.account_escape_check,chr(13),''),chr(10),'') as account_escape_check
    ,replace(replace(t.acc_esc_less_check,chr(13),''),chr(10),'') as acc_esc_less_check
    ,replace(replace(t.check_one,chr(13),''),chr(10),'') as check_one
    ,replace(replace(t.state,chr(13),''),chr(10),'') as state
    ,replace(replace(t.principal_no_check,chr(13),''),chr(10),'') as principal_no_check
    ,replace(replace(t.fin_contect_no_check,chr(13),''),chr(10),'') as fin_contect_no_check
    ,replace(replace(t.chrg_no_check1,chr(13),''),chr(10),'') as chrg_no_check1
    ,replace(replace(t.chrg_no_check2,chr(13),''),chr(10),'') as chrg_no_check2
    ,replace(replace(t.principal_order,chr(13),''),chr(10),'') as principal_order
    ,replace(replace(t.fin_contect_order,chr(13),''),chr(10),'') as fin_contect_order
    ,replace(replace(t.chrg_order1,chr(13),''),chr(10),'') as chrg_order1
    ,replace(replace(t.chrg_order2,chr(13),''),chr(10),'') as chrg_order2
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.open_acct_date,chr(13),''),chr(10),'') as open_acct_date
    ,replace(replace(t.modify_date,chr(13),''),chr(10),'') as modify_date
    ,replace(replace(t.funds_escape_check,chr(13),''),chr(10),'') as funds_escape_check
    ,replace(replace(t.all_escape_check,chr(13),''),chr(10),'') as all_escape_check
    ,replace(replace(t.not_funds_escape_check,chr(13),''),chr(10),'') as not_funds_escape_check
    ,replace(replace(t.other_busi_check,chr(13),''),chr(10),'') as other_busi_check
    ,replace(replace(t.principal_funds_check,chr(13),''),chr(10),'') as principal_funds_check
    ,replace(replace(t.fin_contect_funds_check,chr(13),''),chr(10),'') as fin_contect_funds_check
    ,replace(replace(t.chrg_funds_check1,chr(13),''),chr(10),'') as chrg_funds_check1
    ,replace(replace(t.chrg_funds_check2,chr(13),''),chr(10),'') as chrg_funds_check2
    ,replace(replace(t.all_check,chr(13),''),chr(10),'') as all_check
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pbss_flw_t_call_reg t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_flw_t_call_reg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes