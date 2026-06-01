: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_telbank_cap_tran_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_telbank_cap_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.call_flow_num,chr(13),''),chr(10),'') as call_flow_num
,replace(replace(t1.in_call_num,chr(13),''),chr(10),'') as in_call_num
,replace(replace(t1.aud_sys_cd,chr(13),''),chr(10),'') as aud_sys_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,t1.tran_tm as tran_tm
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.avl_aging_cd,chr(13),''),chr(10),'') as avl_aging_cd
,t1.tran_amt as tran_amt
,t1.comm_fee as comm_fee
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t1.redt_flg,chr(13),''),chr(10),'') as redt_flg
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.sign_org_name,chr(13),''),chr(10),'') as sign_org_name
,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
from ${iml_schema}.evt_telbank_cap_tran_flow t1
where t1.etl_dt <= to_date('20230430','yyyymmdd') and t1.etl_dt >= to_date('20230101','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_telbank_cap_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes