: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_bill_discnt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_bill_discnt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt 
,lp_id 
,bus_id 
,batch_id 
,bill_num 
,cust_id 
,cust_name 
,bill_med_cd 
,bill_kind_cd 
,discnt_bus_type_cd 
,sys_in_flg 
,city_wide_flg 
,int_accr_flg 
,appl_dt 
,recv_dt 
,value_dt 
,revo_dt 
,draw_dt 
,exp_dt 
,dir_rher_name 
,discnt_applit_acct_num 
,discnt_applit_bank_no 
,dscnt_props_cate_cd 
,dscnt_props_name 
,dscnt_props_orgnz_cd 
,dscnt_props_acct_num 
,dscnt_props_open_bank_no 
,dscnt_name 
,dscnt_bank_no 
,drawer_name 
,drawer_cate_cd 
,drawer_acct_num 
,drawer_open_bank_no 
,drawer_open_bank_name 
,accptor_name 
,accptor_acct_num 
,accptor_open_bank_no 
,accptor_open_bank_name 
,main_guar_way_cd 
,agent_discnt_flg 
,onl_discnt_flg 
,entry_status_cd 
,entry_dt 
,int_accr_exp_dt 
,discnt_int_rat 
,defer_days 
,int_accr_days 
,not_ngbl_flg 
,hxb_acpt_flg 
,curr_cd 
,fac_val_amt 
,payoff_flg 
,discnt_status_cd 
,int_amt 
,buyer_pay_int_amt 
,actl_amt 
,risk_bear_fee 
,issue_org_id 
,enter_acct_org_id 
,cust_mgr_id 
,dept_id 
,operr_id 
,agent_name 
,drawer_crdt_level_cd 
,drawer_rating_org_name 
,drawer_rating_exp_dt 
,job_cd 
,etl_timestamp from idl.aml_cmm_bill_discnt_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_bill_discnt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes