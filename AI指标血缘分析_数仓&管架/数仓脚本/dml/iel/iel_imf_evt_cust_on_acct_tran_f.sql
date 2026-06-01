: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_cust_on_acct_tran_f
CreateDate: 20240829
FileName:   ${iel_data_path}/evt_cust_on_acct_tran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.on_acct_seq_num,chr(13),''),chr(10),'') as on_acct_seq_num
,replace(replace(t1.on_acct_sub_acct_num,chr(13),''),chr(10),'') as on_acct_sub_acct_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.appl_cust_id,chr(13),''),chr(10),'') as appl_cust_id
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,on_acct_tot
,on_acct_amt
,on_acct_bal
,on_acct_exp_dt
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,tran_dt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id
,replace(replace(t1.cntpty_acct_bank_int_flg,chr(13),''),chr(10),'') as cntpty_acct_bank_int_flg
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.gold_bus_id,chr(13),''),chr(10),'') as gold_bus_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,last_modif_dt
,final_modif_dt
,tran_tm

from ${iml_schema}.evt_cust_on_acct_tran t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cust_on_acct_tran.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
