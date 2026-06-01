: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_conl_bk_payoff_tran_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_conl_bk_payoff_tran_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_dt
,core_tran_dt
,replace(replace(t1.core_batch_id,chr(13),''),chr(10),'') as core_batch_id
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.recver_ibank_no,chr(13),''),chr(10),'') as recver_ibank_no
,replace(replace(t1.recver_open_brac_name,chr(13),''),chr(10),'') as recver_open_brac_name
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.bank_int_flg,chr(13),''),chr(10),'') as bank_int_flg
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id

from ${iml_schema}.evt_conl_bk_payoff_tran_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_payoff_tran_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
