: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_cl_order_f
CreateDate: 20221116
FileName:   ${iel_data_path}/ncbs_cl_order.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.order_seq_no,chr(13),''),chr(10),'') as order_seq_no
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,order_effect_date
,replace(replace(t1.order_type,chr(13),''),chr(10),'') as order_type
,replace(replace(t1.order_status,chr(13),''),chr(10),'') as order_status
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,dd_no
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,tran_date
,replace(replace(t1.order_exec_status,chr(13),''),chr(10),'') as order_exec_status
,replace(replace(t1.failure_reason,chr(13),''),chr(10),'') as failure_reason
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_cl_order t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cl_order.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
