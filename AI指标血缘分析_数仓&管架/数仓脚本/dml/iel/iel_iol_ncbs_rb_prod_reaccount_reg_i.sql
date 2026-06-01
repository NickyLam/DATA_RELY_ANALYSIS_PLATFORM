: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_prod_reaccount_reg_i
CreateDate: 20240827
FileName:   ${iel_data_path}/ncbs_rb_prod_reaccount_reg.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.dr_cr_flag,chr(13),''),chr(10),'') as dr_cr_flag
,replace(replace(t1.pri_amt_str,chr(13),''),chr(10),'') as pri_amt_str
,int_amt
,prod_balance
,tran_date
,replace(replace(t1.tran_time,chr(13),''),chr(10),'') as tran_time
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.channel_muster,chr(13),''),chr(10),'') as channel_muster
,collect_principal_amt
,replace(replace(t1.collect_tran_remark,chr(13),''),chr(10),'') as collect_tran_remark
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.agreement_type,chr(13),''),chr(10),'') as agreement_type
,replace(replace(t1.agreement_id,chr(13),''),chr(10),'') as agreement_id
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,mon_avg_amt

from ${iol_schema}.ncbs_rb_prod_reaccount_reg t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_prod_reaccount_reg.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
