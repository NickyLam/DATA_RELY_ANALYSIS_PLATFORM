: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_vtms_open_bill_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_vtms_open_bill_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.txn_dt,chr(13),''),chr(10),'') as txn_dt
,replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,replace(replace(t1.acct_seq,chr(13),''),chr(10),'') as acct_seq
,t1.trx_srl_prop as trx_srl_prop
,replace(replace(t1.reverse_evt_txn_dt,chr(13),''),chr(10),'') as reverse_evt_txn_dt
,replace(replace(t1.reverse_evt_id,chr(13),''),chr(10),'') as reverse_evt_id
,replace(replace(t1.txn_org,chr(13),''),chr(10),'') as txn_org
,replace(replace(t1.posting_org_id,chr(13),''),chr(10),'') as posting_org_id
,replace(replace(t1.db_cr_flg,chr(13),''),chr(10),'') as db_cr_flg
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_ccy,chr(13),''),chr(10),'') as txn_ccy
,t1.txn_amt as txn_amt
,t1.txn_excl_rvn_amt as txn_excl_rvn_amt
,t1.tax_amt as tax_amt
,t1.tax_rate as tax_rate
,replace(replace(t1.prc_tax_split_id,chr(13),''),chr(10),'') as prc_tax_split_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.pty_acct_num,chr(13),''),chr(10),'') as pty_acct_num
from ${idl_schema}.hdws_dul_d_vtms_open_bill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_vtms_open_bill_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
