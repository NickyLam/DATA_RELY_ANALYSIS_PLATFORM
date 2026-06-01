: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_upps_t_rsk_epcc_trans_f
CreateDate: 20180529
FileName:   ${iel_data_path}/upps_t_rsk_epcc_trans.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trans_flowno,chr(13),''),chr(10),'') as trans_flowno
,replace(replace(t.trans_time,chr(13),''),chr(10),'') as trans_time
,replace(replace(t.trans_state,chr(13),''),chr(10),'') as trans_state
,replace(replace(t.trans_accno,chr(13),''),chr(10),'') as trans_accno
,t.trans_amount as trans_amount
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t.out_in_flag,chr(13),''),chr(10),'') as out_in_flag
,replace(replace(t.crossb_flag,chr(13),''),chr(10),'') as crossb_flag
,replace(replace(t.trans_location,chr(13),''),chr(10),'') as trans_location
,replace(replace(t.trans_channel,chr(13),''),chr(10),'') as trans_channel
,replace(replace(t.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t.client_mac,chr(13),''),chr(10),'') as client_mac
,replace(replace(t.client_ter_no,chr(13),''),chr(10),'') as client_ter_no
,replace(replace(t.client_os,chr(13),''),chr(10),'') as client_os
,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t.trans_type,chr(13),''),chr(10),'') as trans_type
,replace(replace(t.trans_accno_f,chr(13),''),chr(10),'') as trans_accno_f
,replace(replace(t.trans_accno_bank,chr(13),''),chr(10),'') as trans_accno_bank
,replace(replace(t.petty_flag,chr(13),''),chr(10),'') as petty_flag
,replace(replace(t.merchant_code,chr(13),''),chr(10),'') as merchant_code
,replace(replace(t.cart_type,chr(13),''),chr(10),'') as cart_type
,replace(replace(t.cart_trs_type,chr(13),''),chr(10),'') as cart_trs_type
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t.sub_channel_code,chr(13),''),chr(10),'') as sub_channel_code
,replace(replace(t.sub_biz_code,chr(13),''),chr(10),'') as sub_biz_code
,replace(replace(t.merchant_type,chr(13),''),chr(10),'') as merchant_type
,replace(replace(t.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t.gc_code,chr(13),''),chr(10),'') as gc_code
,replace(replace(t.pos_input_type,chr(13),''),chr(10),'') as pos_input_type
,replace(replace(t.pwd_valid_flag,chr(13),''),chr(10),'') as pwd_valid_flag
,replace(replace(t.response_code,chr(13),''),chr(10),'') as response_code
,replace(replace(t.response_msg,chr(13),''),chr(10),'') as response_msg
,replace(replace(t.origin_seq,chr(13),''),chr(10),'') as origin_seq
,t.ori_trx_amt as ori_trx_amt
,replace(replace(t.ori_ordr_id,chr(13),''),chr(10),'') as ori_ordr_id
,replace(replace(t.pyer_acct_tp,chr(13),''),chr(10),'') as pyer_acct_tp
,replace(replace(t.sgn_no,chr(13),''),chr(10),'') as sgn_no
,replace(replace(t.device_mode,chr(13),''),chr(10),'') as device_mode
,replace(replace(t.risk_score,chr(13),''),chr(10),'') as risk_score
,replace(replace(t.risk_reason_code,chr(13),''),chr(10),'') as risk_reason_code
,replace(replace(t.ordr_id,chr(13),''),chr(10),'') as ordr_id
,replace(replace(t.pyer_trx_trm_no,chr(13),''),chr(10),'') as pyer_trx_trm_no
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.upps_t_rsk_epcc_trans t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd') ;
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/upps_t_rsk_epcc_trans.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes