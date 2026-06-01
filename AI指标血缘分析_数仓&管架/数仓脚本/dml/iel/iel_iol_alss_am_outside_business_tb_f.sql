: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_am_outside_business_tb_f
CreateDate: 20260319
FileName:   ${iel_data_path}/alss_am_outside_business_tb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.bach_date,chr(13),''),chr(10),'') as bach_date
,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t1.card_id,chr(13),''),chr(10),'') as card_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_acct_organ,chr(13),''),chr(10),'') as open_acct_organ
,replace(replace(t1.approve_result,chr(13),''),chr(10),'') as approve_result
,replace(replace(t1.approve_date,chr(13),''),chr(10),'') as approve_date
,replace(replace(t1.upload_date,chr(13),''),chr(10),'') as upload_date
,replace(replace(t1.jx_money,chr(13),''),chr(10),'') as jx_money
,replace(replace(t1.open_acct_date,chr(13),''),chr(10),'') as open_acct_date
,replace(replace(t1.bd_date,chr(13),''),chr(10),'') as bd_date
,replace(replace(t1.jx_date,chr(13),''),chr(10),'') as jx_date
,replace(replace(t1.old_trans_date,chr(13),''),chr(10),'') as old_trans_date
,replace(replace(t1.one_acct_num,chr(13),''),chr(10),'') as one_acct_num
,replace(replace(t1.is_iden_date,chr(13),''),chr(10),'') as is_iden_date
,replace(replace(t1.nine_info,chr(13),''),chr(10),'') as nine_info
,replace(replace(t1.gg_person,chr(13),''),chr(10),'') as gg_person
,replace(replace(t1.gh_person,chr(13),''),chr(10),'') as gh_person
,replace(replace(t1.last_aum,chr(13),''),chr(10),'') as last_aum
,replace(replace(t1.cus_wealth_level,chr(13),''),chr(10),'') as cus_wealth_level
,replace(replace(t1.last_quarter_approve,chr(13),''),chr(10),'') as last_quarter_approve
,replace(replace(t1.last_quarter_ncbs_approve,chr(13),''),chr(10),'') as last_quarter_ncbs_approve
,replace(replace(t1.data_type,chr(13),''),chr(10),'') as data_type
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.sys_user_id,chr(13),''),chr(10),'') as sys_user_id
,replace(replace(t1.mag_cst_mgr_id,chr(13),''),chr(10),'') as mag_cst_mgr_id
,replace(replace(t1.fail_reason,chr(13),''),chr(10),'') as fail_reason
,replace(replace(t1.bach_no,chr(13),''),chr(10),'') as bach_no
,replace(replace(t1.date1,chr(13),''),chr(10),'') as date1
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.querter,chr(13),''),chr(10),'') as querter
,replace(replace(t1.is_exception_of_phone,chr(13),''),chr(10),'') as is_exception_of_phone

from ${iol_schema}.alss_am_outside_business_tb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_outside_business_tb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
