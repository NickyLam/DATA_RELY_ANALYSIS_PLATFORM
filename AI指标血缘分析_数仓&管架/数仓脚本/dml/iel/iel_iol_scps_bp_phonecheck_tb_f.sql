: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scps_bp_phonecheck_tb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/scps_bp_phonecheck_tb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.begin_date,chr(13),''),chr(10),'') as begin_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.check_flag,chr(13),''),chr(10),'') as check_flag
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.system_no,chr(13),''),chr(10),'') as system_no
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.vouchgroup,chr(13),''),chr(10),'') as vouchgroup
,replace(replace(t1.doc_id,chr(13),''),chr(10),'') as doc_id
,replace(replace(t1.check_type,chr(13),''),chr(10),'') as check_type
,replace(replace(t1.bus_serial_number,chr(13),''),chr(10),'') as bus_serial_number
,replace(replace(t1.trans_bu_name,chr(13),''),chr(10),'') as trans_bu_name
,replace(replace(t1.trans_bu_phone,chr(13),''),chr(10),'') as trans_bu_phone
,replace(replace(t1.trans_bu_email,chr(13),''),chr(10),'') as trans_bu_email
,replace(replace(t1.is_equal_bus,chr(13),''),chr(10),'') as is_equal_bus
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.check_company,chr(13),''),chr(10),'') as check_company
,replace(replace(t1.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t1.payer_account,chr(13),''),chr(10),'') as payer_account
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.use,chr(13),''),chr(10),'') as use
,replace(replace(t1.ticket_issues_date,chr(13),''),chr(10),'') as ticket_issues_date
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.give_money_date as give_money_date
,t1.give_money_count as give_money_count
,replace(replace(t1.give_money_product,chr(13),''),chr(10),'') as give_money_product
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.cust_mgr_organ,chr(13),''),chr(10),'') as cust_mgr_organ
,replace(replace(t1.cust_mgr_no,chr(13),''),chr(10),'') as cust_mgr_no
,replace(replace(t1.cust_mgr_phone,chr(13),''),chr(10),'') as cust_mgr_phone
,replace(replace(t1.cust_mgr_email,chr(13),''),chr(10),'') as cust_mgr_email
,replace(replace(t1.scene_code,chr(13),''),chr(10),'') as scene_code
,replace(replace(t1.check_expire_date,chr(13),''),chr(10),'') as check_expire_date
,replace(replace(t1.priority_grade,chr(13),''),chr(10),'') as priority_grade
,replace(replace(t1.onesecreason,chr(13),''),chr(10),'') as onesecreason
,replace(replace(t1.onecheckresult,chr(13),''),chr(10),'') as onecheckresult
,replace(replace(t1.trans_bu_ser_no,chr(13),''),chr(10),'') as trans_bu_ser_no
,replace(replace(t1.deal_code,chr(13),''),chr(10),'') as deal_code
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.deal_time as deal_time
,replace(replace(t1.scene_name,chr(13),''),chr(10),'') as scene_name
,replace(replace(t1.operator_name,chr(13),''),chr(10),'') as operator_name
,replace(replace(t1.operator_tel,chr(13),''),chr(10),'') as operator_tel
,replace(replace(t1.extend,chr(13),''),chr(10),'') as extend
from ${iol_schema}.scps_bp_phonecheck_tb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scps_bp_phonecheck_tb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes