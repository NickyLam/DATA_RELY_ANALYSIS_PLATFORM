: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_pcp_agreement_f
CreateDate: 20230829
FileName:   ${iel_data_path}/ncbs_rb_pcp_agreement.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.acct_int_flag,chr(13),''),chr(10),'') as acct_int_flag
,replace(replace(t1.agreement_id,chr(13),''),chr(10),'') as agreement_id
,replace(replace(t1.agreement_status,chr(13),''),chr(10),'') as agreement_status
,replace(replace(t1.cash_pool_attr,chr(13),''),chr(10),'') as cash_pool_attr
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.cyc_ctrl_flag,chr(13),''),chr(10),'') as cyc_ctrl_flag
,replace(replace(t1.down_max_senece,chr(13),''),chr(10),'') as down_max_senece
,replace(replace(t1.down_method,chr(13),''),chr(10),'') as down_method
,replace(replace(t1.down_mod_unit,chr(13),''),chr(10),'') as down_mod_unit
,replace(replace(t1.down_plan,chr(13),''),chr(10),'') as down_plan
,replace(replace(t1.inner_price_flag,chr(13),''),chr(10),'') as inner_price_flag
,replace(replace(t1.inner_price_mode,chr(13),''),chr(10),'') as inner_price_mode
,replace(replace(t1.inner_price_way,chr(13),''),chr(10),'') as inner_price_way
,replace(replace(t1.int_calc_bal,chr(13),''),chr(10),'') as int_calc_bal
,replace(replace(t1.limit_mode,chr(13),''),chr(10),'') as limit_mode
,replace(replace(t1.open_ctrl,chr(13),''),chr(10),'') as open_ctrl
,replace(replace(t1.open_limit,chr(13),''),chr(10),'') as open_limit
,replace(replace(t1.pcp_group_id,chr(13),''),chr(10),'') as pcp_group_id
,replace(replace(t1.price_freq,chr(13),''),chr(10),'') as price_freq
,up_max_senece
,replace(replace(t1.up_method,chr(13),''),chr(10),'') as up_method
,replace(replace(t1.up_plan,chr(13),''),chr(10),'') as up_plan
,replace(replace(t1.down_time,chr(13),''),chr(10),'') as down_time
,effect_date
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.up_time,chr(13),''),chr(10),'') as up_time
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,agree_int_rate
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,cr_rate
,replace(replace(t1.down_day,chr(13),''),chr(10),'') as down_day
,down_fixed_amt
,replace(replace(t1.down_freq,chr(13),''),chr(10),'') as down_freq
,down_remain_amt
,dr_rate
,replace(replace(t1.new_settle_base_acct_no,chr(13),''),chr(10),'') as new_settle_base_acct_no
,over_limit_amt
,replace(replace(t1.pcp_prod_type,chr(13),''),chr(10),'') as pcp_prod_type
,replace(replace(t1.price_day,chr(13),''),chr(10),'') as price_day
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.up_day,chr(13),''),chr(10),'') as up_day
,up_fixed_amt
,replace(replace(t1.up_freq,chr(13),''),chr(10),'') as up_freq
,up_prop
,up_remain_amt
,replace(replace(t1.approval_no,chr(13),''),chr(10),'') as approval_no
,replace(replace(t1.merge_cycle_flag,chr(13),''),chr(10),'') as merge_cycle_flag

from ${iol_schema}.ncbs_rb_pcp_agreement t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_pcp_agreement.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
