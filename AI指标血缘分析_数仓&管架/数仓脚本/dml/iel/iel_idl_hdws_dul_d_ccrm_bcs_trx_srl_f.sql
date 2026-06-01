: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_bcs_trx_srl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_bcs_trx_srl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.txn_tms,chr(13),''),chr(10),'') as txn_tms
,replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,replace(replace(t1.oper_tell_num,chr(13),''),chr(10),'') as oper_tell_num
,replace(replace(t1.sys_src,chr(13),''),chr(10),'') as sys_src
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.txn_typ,chr(13),''),chr(10),'') as txn_typ
,replace(replace(t1.txn_chn,chr(13),''),chr(10),'') as txn_chn
,replace(replace(t1.txn_org,chr(13),''),chr(10),'') as txn_org
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,t1.txn_amt as txn_amt
,t1.txn_amt_into_rmb as txn_amt_into_rmb
,t1.txn_after_after as txn_after_after
,t1.txn_after_after_into_rmb as txn_after_after_into_rmb
,replace(replace(t1.db_cr_typ,chr(13),''),chr(10),'') as db_cr_typ
,replace(replace(t1.coa_num,chr(13),''),chr(10),'') as coa_num
,replace(replace(t1.rela_acct_num,chr(13),''),chr(10),'') as rela_acct_num
,replace(replace(t1.rela_org_name,chr(13),''),chr(10),'') as rela_org_name
,replace(replace(t1.rela_org_sname,chr(13),''),chr(10),'') as rela_org_sname
,replace(replace(t1.rela_org_num,chr(13),''),chr(10),'') as rela_org_num
,replace(replace(t1.rela_cust_nbr_num,chr(13),''),chr(10),'') as rela_cust_nbr_num
,replace(replace(t1.rela_pty_name,chr(13),''),chr(10),'') as rela_pty_name
,replace(replace(t1.rec_status,chr(13),''),chr(10),'') as rec_status
,replace(replace(t1.trx_txt,chr(13),''),chr(10),'') as trx_txt
from ${idl_schema}.hdws_dul_d_ccrm_bcs_trx_srl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_bcs_trx_srl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes