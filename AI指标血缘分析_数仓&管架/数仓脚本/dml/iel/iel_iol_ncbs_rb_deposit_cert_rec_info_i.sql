: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_deposit_cert_rec_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_rb_deposit_cert_rec_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,t1.internal_key as internal_key
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,t1.cert_num as cert_num
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.ch_head,chr(13),''),chr(10),'') as ch_head
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.deposit_cert_no,chr(13),''),chr(10),'') as deposit_cert_no
,replace(replace(t1.deposit_cert_operate_type,chr(13),''),chr(10),'') as deposit_cert_operate_type
,replace(replace(t1.deposit_cert_status,chr(13),''),chr(10),'') as deposit_cert_status
,replace(replace(t1.en_head,chr(13),''),chr(10),'') as en_head
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,t1.print_cnt as print_cnt
,replace(replace(t1.repair_type,chr(13),''),chr(10),'') as repair_type
,replace(replace(t1.res_seq_no,chr(13),''),chr(10),'') as res_seq_no
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,t1.cancel_date as cancel_date
,t1.cert_end_date as cert_end_date
,t1.delete_date as delete_date
,replace(replace(t1.repair_time,chr(13),''),chr(10),'') as repair_time
,t1.tran_date as tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.cancel_auth_user_id,chr(13),''),chr(10),'') as cancel_auth_user_id
,replace(replace(t1.cancel_reason,chr(13),''),chr(10),'') as cancel_reason
,replace(replace(t1.cancel_user_id,chr(13),''),chr(10),'') as cancel_user_id
,t1.cert_bal as cert_bal
,replace(replace(t1.del_auth_user_id,chr(13),''),chr(10),'') as del_auth_user_id
,replace(replace(t1.del_user_id,chr(13),''),chr(10),'') as del_user_id
,replace(replace(t1.pre_reference,chr(13),''),chr(10),'') as pre_reference
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.voucher_end_no,chr(13),''),chr(10),'') as voucher_end_no
,replace(replace(t1.voucher_start_no,chr(13),''),chr(10),'') as voucher_start_no
from ${iol_schema}.ncbs_rb_deposit_cert_rec_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_deposit_cert_rec_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes