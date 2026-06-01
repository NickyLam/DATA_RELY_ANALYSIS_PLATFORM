: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_tran_contra_reg_f
CreateDate: 20230414
FileName:   ${iel_data_path}/ncbs_rb_tran_contra_reg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq_no
,reference
,channel_seq_no
,sub_seq_no
,oth_real_base_acct_no
,oth_real_tran_name
,contra_bank_code
,tran_amt
,oth_real_acct_seq_no
,register_seq_no
,tran_timestamp
,company
,source_module

from ${iol_schema}.ncbs_rb_tran_contra_reg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_tran_contra_reg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
