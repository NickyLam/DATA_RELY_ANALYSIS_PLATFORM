: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_nfss_v_interbank_transreq_f
CreateDate: 20240826
FileName:   ${iel_data_path}/nfss_v_interbank_transreq.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_name,chr(13),''),chr(10),'') as client_name
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no
,trans_date
,trans_time
,replace(replace(t1.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t1.trans_name,chr(13),''),chr(10),'') as trans_name
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t1.id_code,chr(13),''),chr(10),'') as id_code
,amt
,vol
,replace(replace(t1.bank_acc,chr(13),''),chr(10),'') as bank_acc
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.cnaps_code,chr(13),''),chr(10),'') as cnaps_code
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.curr_type,chr(13),''),chr(10),'') as curr_type
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.busin_code,chr(13),''),chr(10),'') as busin_code
,cfm_date
,cfm_amt
,cfm_vol
,replace(replace(t1.repr_name,chr(13),''),chr(10),'') as repr_name
,replace(replace(t1.repr_id_type,chr(13),''),chr(10),'') as repr_id_type
,replace(replace(t1.repr_id_code,chr(13),''),chr(10),'') as repr_id_code
,replace(replace(t1.repr_mobile,chr(13),''),chr(10),'') as repr_mobile
,replace(replace(t1.actor_name,chr(13),''),chr(10),'') as actor_name
,replace(replace(t1.actor_id_type,chr(13),''),chr(10),'') as actor_id_type
,replace(replace(t1.actor_id_code,chr(13),''),chr(10),'') as actor_id_code
,replace(replace(t1.actor_tel,chr(13),''),chr(10),'') as actor_tel
,replace(replace(t1.actor_mobile,chr(13),''),chr(10),'') as actor_mobile
,replace(replace(t1.square_no,chr(13),''),chr(10),'') as square_no
,seq_no
,square_date
,old_square_date
,replace(replace(t1.liqu_dir,chr(13),''),chr(10),'') as liqu_dir
,square_amt
,frozen_amt
,replace(replace(t1.square_status,chr(13),''),chr(10),'') as square_status
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,open_date
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.debit_account,chr(13),''),chr(10),'') as debit_account
,replace(replace(t1.debit_account_name,chr(13),''),chr(10),'') as debit_account_name
,replace(replace(t1.crebit_account,chr(13),''),chr(10),'') as crebit_account
,replace(replace(t1.crebit_account_name,chr(13),''),chr(10),'') as crebit_account_name

from ${iol_schema}.nfss_v_interbank_transreq t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_v_interbank_transreq.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
