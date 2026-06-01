: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_secd_pay_sign_agt_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_secd_pay_sign_agt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,t1.agt_sign_dt as agt_sign_dt
,replace(replace(t1.init_dir_prtcpt_org_id,chr(13),''),chr(10),'') as init_dir_prtcpt_org_id
,replace(replace(t1.init_chn_flow_num,chr(13),''),chr(10),'') as init_chn_flow_num
,replace(replace(t1.init_agt_id,chr(13),''),chr(10),'') as init_agt_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.coll_agt_type_cd,chr(13),''),chr(10),'') as coll_agt_type_cd
,replace(replace(t1.stock_agt_flg,chr(13),''),chr(10),'') as stock_agt_flg
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.update_tm as update_tm
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'') as nostro_cd
,replace(replace(t1.acpt_pay_type_cd,chr(13),''),chr(10),'') as acpt_pay_type_cd
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recvbl_bank_no,chr(13),''),chr(10),'') as recvbl_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_acct_type,chr(13),''),chr(10),'') as payer_acct_type
,replace(replace(t1.payer_open_bank_num,chr(13),''),chr(10),'') as payer_open_bank_num
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,t1.once_deduct_lmt as once_deduct_lmt
,t1.deduct_ped_int_lmt_cnt as deduct_ped_int_lmt_cnt
,t1.deduct_ped_inner_buckle_fee_lmt as deduct_ped_inner_buckle_fee_lmt
,replace(replace(t1.deduct_tm_corp,chr(13),''),chr(10),'') as deduct_tm_corp
,t1.deduct_tm_length as deduct_tm_length
,replace(replace(t1.deduct_tm_descb,chr(13),''),chr(10),'') as deduct_tm_descb
,replace(replace(t1.addit_info,chr(13),''),chr(10),'') as addit_info
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.auth_mode_cd,chr(13),''),chr(10),'') as auth_mode_cd
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.whole_proc_idf,chr(13),''),chr(10),'') as whole_proc_idf
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_secd_pay_sign_agt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_secd_pay_sign_agt_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes