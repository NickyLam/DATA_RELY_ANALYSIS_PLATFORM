: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_p2p_platf_order_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_p2p_platf_order_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,txn_dt
      ,replace(replace(order_id,chr(10),''),chr(13),'') as order_id
      ,replace(replace(order_typ_ind,chr(10),''),chr(13),'') as order_typ_ind
      ,replace(replace(order_dtl_typ,chr(10),''),chr(13),'') as order_dtl_typ
      ,replace(replace(transaction_ref_num,chr(10),''),chr(13),'') as transaction_ref_num
      ,replace(replace(sub_seq_num,chr(10),''),chr(13),'') as sub_seq_num
      ,replace(replace(platf_trx_seq,chr(10),''),chr(13),'') as platf_trx_seq
      ,replace(replace(merch_num,chr(10),''),chr(13),'') as merch_num
      ,replace(replace(merch_name,chr(10),''),chr(13),'') as merch_name
      ,replace(replace(brw_id,chr(10),''),chr(13),'') as brw_id
      ,replace(replace(txn_tm,chr(10),''),chr(13),'') as txn_tm
      ,posting_date
      ,replace(replace(txn_acct_num,chr(10),''),chr(13),'') as txn_acct_num
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(txn_teller_id,chr(10),''),chr(13),'') as txn_teller_id
      ,replace(replace(cntrpty_cust_nbr,chr(10),''),chr(13),'') as cntrpty_cust_nbr
      ,replace(replace(cntrpty_acct_num,chr(10),''),chr(13),'') as cntrpty_acct_num
      ,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,txn_total_amt
      ,txn_prcp
      ,txn_prft
      ,replace(replace(cost_typ_cd,chr(10),''),chr(13),'') as cost_typ_cd
      ,fee_amt
      ,replace(replace(pay_seq_num,chr(10),''),chr(13),'') as pay_seq_num
      ,replace(replace(frz_seq_num,chr(10),''),chr(13),'') as frz_seq_num
      ,replace(replace(txn_chn_cd,chr(10),''),chr(13),'') as txn_chn_cd
      ,replace(replace(txn_status_cd,chr(10),''),chr(13),'') as txn_status_cd
      ,replace(replace(txn_mode_cd,chr(10),''),chr(13),'') as txn_mode_cd
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_evt_p2p_platf_order_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_p2p_platf_order_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes