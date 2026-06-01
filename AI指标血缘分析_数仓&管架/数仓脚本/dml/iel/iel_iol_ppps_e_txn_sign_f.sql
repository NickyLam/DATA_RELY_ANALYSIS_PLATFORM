: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ppps_e_txn_sign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ppps_e_txn_sign.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,replace(replace(t1.trx_id,chr(13),''),chr(10),'') as trx_id
,replace(replace(t1.issr_id,chr(13),''),chr(10),'') as issr_id
,replace(replace(t1.trx_dt_tm,chr(13),''),chr(10),'') as trx_dt_tm
,replace(replace(t1.trx_ctgy,chr(13),''),chr(10),'') as trx_ctgy
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t1.txn_time,chr(13),''),chr(10),'') as txn_time
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.instg_id,chr(13),''),chr(10),'') as instg_id
,replace(replace(t1.instg_acct_de,chr(13),''),chr(10),'') as instg_acct_de
,replace(replace(t1.sgn_acct_issr_id,chr(13),''),chr(10),'') as sgn_acct_issr_id
,replace(replace(t1.sgn_acct_tp,chr(13),''),chr(10),'') as sgn_acct_tp
,replace(replace(t1.sgn_acct_id_de,chr(13),''),chr(10),'') as sgn_acct_id_de
,replace(replace(t1.sgn_acct_nm_de,chr(13),''),chr(10),'') as sgn_acct_nm_de
,replace(replace(t1.id_tp,chr(13),''),chr(10),'') as id_tp
,replace(replace(t1.id_no_de,chr(13),''),chr(10),'') as id_no_de
,replace(replace(t1.mob_no_de,chr(13),''),chr(10),'') as mob_no_de
,replace(replace(t1.sgn_acct_lvl,chr(13),''),chr(10),'') as sgn_acct_lvl
,replace(replace(t1.sms_seq_no,chr(13),''),chr(10),'') as sms_seq_no
,replace(replace(t1.sms_index,chr(13),''),chr(10),'') as sms_index
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.biz_sts_cd,chr(13),''),chr(10),'') as biz_sts_cd
,replace(replace(t1.biz_sts_desc,chr(13),''),chr(10),'') as biz_sts_desc
,replace(replace(t1.sys_rtn_cd,chr(13),''),chr(10),'') as sys_rtn_cd
,replace(replace(t1.sys_rtn_desc,chr(13),''),chr(10),'') as sys_rtn_desc
,replace(replace(t1.sys_rtn_tm,chr(13),''),chr(10),'') as sys_rtn_tm
,t1.insert_time as insert_time
,t1.update_time as update_time
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ppps_e_txn_sign t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ppps_e_txn_sign.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes