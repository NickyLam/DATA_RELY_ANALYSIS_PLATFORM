: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_rpbl_dtl_i
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_loan_rpbl_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rpbl_dtl_seq_num,chr(13),''),chr(10),'') as rpbl_dtl_seq_num
,tran_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.advise_odd_no,chr(13),''),chr(10),'') as advise_odd_no
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.stl_acct_flg_idf,chr(13),''),chr(10),'') as stl_acct_flg_idf
,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num
,acct_rpbl_amt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm

from ${iml_schema}.evt_loan_rpbl_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_rpbl_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
