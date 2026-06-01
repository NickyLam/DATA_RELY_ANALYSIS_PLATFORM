: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_tb_cash_sign_detail_f
CreateDate: 20251014
FileName:   ${iel_data_path}/ncbs_tb_cash_sign_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_name,chr(13),''),chr(10),'') as client_name
,replace(replace(t1.file_path,chr(13),''),chr(10),'') as file_path
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.cash_sign_type,chr(13),''),chr(10),'') as cash_sign_type
,replace(replace(t1.cash_sign_id,chr(13),''),chr(10),'') as cash_sign_id
,replace(replace(t1.cash_sign_no,chr(13),''),chr(10),'') as cash_sign_no
,replace(replace(t1.cash_sign_status,chr(13),''),chr(10),'') as cash_sign_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.reason_id,chr(13),''),chr(10),'') as reason_id
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.cash_sign_branch,chr(13),''),chr(10),'') as cash_sign_branch
,replace(replace(t1.cash_sign_user,chr(13),''),chr(10),'') as cash_sign_user
,cash_sign_dealed_amt
,replace(replace(t1.leaderr_cash_branch,chr(13),''),chr(10),'') as leaderr_cash_branch
,replace(replace(t1.leaderr_user_id,chr(13),''),chr(10),'') as leaderr_user_id
,replace(replace(t1.leaderr_reference,chr(13),''),chr(10),'') as leaderr_reference
,cash_sign_detail_amt
,replace(replace(t1.leaderr_tran_date,chr(13),''),chr(10),'') as leaderr_tran_date

from ${iol_schema}.ncbs_tb_cash_sign_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_cash_sign_detail.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
