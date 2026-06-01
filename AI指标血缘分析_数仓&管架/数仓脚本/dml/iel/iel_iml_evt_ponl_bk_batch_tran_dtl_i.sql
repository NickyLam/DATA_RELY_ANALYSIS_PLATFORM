: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_bk_batch_tran_dtl_i
CreateDate: 20230606
FileName:   ${iel_data_path}/evt_ponl_bk_batch_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.dtl_flow_num,chr(13),''),chr(10),'') as dtl_flow_num
,replace(replace(t1.onl_bank_tran_flow_num,chr(13),''),chr(10),'') as onl_bank_tran_flow_num
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_acct_type_cd,chr(13),''),chr(10),'') as pay_acct_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.pay_dept_id,chr(13),''),chr(10),'') as pay_dept_id
,replace(replace(t1.pay_ec_idf_cd,chr(13),''),chr(10),'') as pay_ec_idf_cd
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,replace(replace(t1.recvbl_cust_type_cd,chr(13),''),chr(10),'') as recvbl_cust_type_cd
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.recv_bank_prov_cd,chr(13),''),chr(10),'') as recv_bank_prov_cd
,replace(replace(t1.recv_bank_prov_name,chr(13),''),chr(10),'') as recv_bank_prov_name
,replace(replace(t1.recv_bank_city_cd,chr(13),''),chr(10),'') as recv_bank_city_cd
,replace(replace(t1.recv_bank_city_name,chr(13),''),chr(10),'') as recv_bank_city_name
,replace(replace(t1.recv_bank_brac_id,chr(13),''),chr(10),'') as recv_bank_brac_id
,replace(replace(t1.recv_bank_brac_name,chr(13),''),chr(10),'') as recv_bank_brac_name
,replace(replace(t1.recvbl_clear_bk_no,chr(13),''),chr(10),'') as recvbl_clear_bk_no
,replace(replace(t1.recver_mobile_no,chr(13),''),chr(10),'') as recver_mobile_no
,tran_amt
,tran_fee
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,tran_dt
,tran_tm
,replace(replace(t1.save_recver_flg,chr(13),''),chr(10),'') as save_recver_flg
,replace(replace(t1.advise_recver_flg,chr(13),''),chr(10),'') as advise_recver_flg
,replace(replace(t1.dtl_status_cd,chr(13),''),chr(10),'') as dtl_status_cd
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,proc_start_tm
,proc_end_tm
,replace(replace(t1.proc_flow_num,chr(13),''),chr(10),'') as proc_flow_num
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,core_tran_dt
,replace(replace(t1.tran_out_way_cd,chr(13),''),chr(10),'') as tran_out_way_cd
,tran_out_dt

from ${iml_schema}.evt_ponl_bk_batch_tran_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_bk_batch_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
