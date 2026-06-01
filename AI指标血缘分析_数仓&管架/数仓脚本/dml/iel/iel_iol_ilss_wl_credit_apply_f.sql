: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_credit_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_credit_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.serial_no,chr(13),''),chr(10),'') as serial_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.approval_no,chr(13),''),chr(10),'') as approval_no
,replace(replace(t.channel_code,chr(13),''),chr(10),'') as channel_code
,t.quota as quota
,t.expos as expos
,t.loan_rate as loan_rate
,replace(replace(t.cash_type,chr(13),''),chr(10),'') as cash_type
,t.balance as balance
,replace(replace(t.loan_period_type,chr(13),''),chr(10),'') as loan_period_type
,t.loan_period as loan_period
,t.apply_time as apply_time
,t.pass_time as pass_time
,t.begin_day as begin_day
,t.end_day as end_day
,replace(replace(t.deviceid,chr(13),''),chr(10),'') as deviceid
,replace(replace(t.tax_no,chr(13),''),chr(10),'') as tax_no
,t.manual_flg as manual_flg
,t.circ_flg as circ_flg
,t.grp_lmt_flg as grp_lmt_flg
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,replace(replace(t.message,chr(13),''),chr(10),'') as message
,t.group_id as group_id
,replace(replace(t.branch_code,chr(13),''),chr(10),'') as branch_code
,replace(replace(t.appv_user_id,chr(13),''),chr(10),'') as appv_user_id
,replace(replace(t.auth_info,chr(13),''),chr(10),'') as auth_info
,t.create_time as create_time
,t.update_time as update_time
,replace(replace(t.project_no,chr(13),''),chr(10),'') as project_no
,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
,replace(replace(t.uscc_no,chr(13),''),chr(10),'') as uscc_no
,replace(replace(t.person_type,chr(13),''),chr(10),'') as person_type
,replace(replace(t.refereer_id,chr(13),''),chr(10),'') as refereer_id
,replace(replace(t.bind_id_no,chr(13),''),chr(10),'') as bind_id_no
,replace(replace(t.bind_mobile,chr(13),''),chr(10),'') as bind_mobile
,replace(replace(t.agency_no,chr(13),''),chr(10),'') as agency_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_credit_apply t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_credit_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes