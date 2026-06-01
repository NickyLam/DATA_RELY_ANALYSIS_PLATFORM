: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_tb_voucher_journal_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_voucher_journal.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.voucher_status,chr(13),''),chr(10),'') as voucher_status
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.move_id,chr(13),''),chr(10),'') as move_id
,replace(replace(t1.move_type,chr(13),''),chr(10),'') as move_type
,replace(replace(t1.old_status,chr(13),''),chr(10),'') as old_status
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.reserve_flag,chr(13),''),chr(10),'') as reserve_flag
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.tailbox_id,chr(13),''),chr(10),'') as tailbox_id
,replace(replace(t1.tran_desc,chr(13),''),chr(10),'') as tran_desc
,t1.voucher_num as voucher_num
,t1.tran_date as tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,t1.tran_amt as tran_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.voucher_end_no,chr(13),''),chr(10),'') as voucher_end_no
,replace(replace(t1.voucher_start_no,chr(13),''),chr(10),'') as voucher_start_no
,replace(replace(t1.journal_id,chr(13),''),chr(10),'') as journal_id
,replace(replace(t1.tailbox_user_id,chr(13),''),chr(10),'') as tailbox_user_id
from ${iol_schema}.ncbs_tb_voucher_journal t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_voucher_journal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes