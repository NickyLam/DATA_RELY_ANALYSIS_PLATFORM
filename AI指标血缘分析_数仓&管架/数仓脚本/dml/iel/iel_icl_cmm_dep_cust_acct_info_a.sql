: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_cust_acct_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_dep_cust_acct_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
etl_dt as etl_dt 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id 
,replace(replace(t1.cust_acct_name,chr(13),''),chr(10),'') as cust_acct_name 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.max_sub_acct_num,chr(13),''),chr(10),'') as max_sub_acct_num 
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id 
,replace(replace(t1.drawdown_way_cd,chr(13),''),chr(10),'') as drawdown_way_cd 
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd 
,replace(replace(t1.acct_drawdown_way_status,chr(13),''),chr(10),'') as acct_drawdown_way_status 
,replace(replace(t1.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd 
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd 
,replace(replace(t1.acpt_pay_status_cd,chr(13),''),chr(10),'') as acpt_pay_status_cd 
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd 
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd 
,replace(replace(t1.vouch_char_cd,chr(13),''),chr(10),'') as vouch_char_cd 
,replace(replace(t1.vouch_form_cd,chr(13),''),chr(10),'') as vouch_form_cd 
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg 
,replace(replace(t1.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg 
,replace(replace(t1.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg 
,replace(replace(t1.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id 
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id 
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id 
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd 
,replace(replace(t1.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num 
,t1.open_acct_dt as open_acct_dt 
,t1.open_acct_tm as open_acct_tm 
,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id 
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id 
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num 
,t1.clos_acct_dt as clos_acct_dt 
,t1.clos_acct_tm as clos_acct_tm 
from icl.cmm_dep_cust_acct_info t1 
where t1.etl_dt >= to_date('20201201','yyyymmdd') and t1.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_cust_acct_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes