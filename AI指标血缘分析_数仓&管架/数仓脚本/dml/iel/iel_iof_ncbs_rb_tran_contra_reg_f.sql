: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_tran_contra_reg_f
CreateDate: 20241230
FileName:   ${iel_data_path}/ncbs_rb_tran_contra_reg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,replace(replace(t1.oth_real_base_acct_no,chr(13),''),chr(10),'') as oth_real_base_acct_no
,replace(replace(t1.oth_real_tran_name,chr(13),''),chr(10),'') as oth_real_tran_name
,replace(replace(t1.contra_bank_code,chr(13),''),chr(10),'') as contra_bank_code
,tran_amt
,replace(replace(t1.oth_real_acct_seq_no,chr(13),''),chr(10),'') as oth_real_acct_seq_no
,register_seq_no
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module

from ${iol_schema}.ncbs_rb_tran_contra_reg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_tran_contra_reg.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
