: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_dep_cust_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_dep_cust_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,cust_acct_id
,cust_acct_name
,cust_id
,max_sub_acct_num
,std_prod_id
,drawdown_way_cd
,acct_status_cd
,acct_drawdown_way_status
,froz_status_cd
,stop_pay_status_cd
,acpt_pay_status_cd
,acct_usage_cd
,sleep_acct_flg
,dormt_acct_flg
,privavy_acct_flg
,acct_belong_org_id
,open_acct_org_id
,open_acct_teller_id
,open_acct_chn_cd
,open_acct_flow_num
,open_acct_dt
,open_acct_tm
,close_acct_org_id
,clos_acct_teller_id
,clos_acct_flow_num
,clos_acct_dt
,clos_acct_tm from idl.aml_cmm_dep_cust_acct_info where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_dep_cust_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes