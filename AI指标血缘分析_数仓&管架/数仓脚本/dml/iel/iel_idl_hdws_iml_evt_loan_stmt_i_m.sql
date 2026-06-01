: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_loan_stmt_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_loan_stmt_m.i.${batch_date}.dat
IF_mark:    i_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.txn_dt as txn_dt
,replace(replace(t1.bill_flow_water_id,chr(13),''),chr(10),'') as bill_flow_water_id
,replace(replace(t1.trx_seq_id,chr(13),''),chr(10),'') as trx_seq_id
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.bal_cmpnt_typ_cd,chr(13),''),chr(10),'') as bal_cmpnt_typ_cd
,replace(replace(t1.stmt_typ_cd,chr(13),''),chr(10),'') as stmt_typ_cd
,replace(replace(t1.bal_ord_nbr,chr(13),''),chr(10),'') as bal_ord_nbr
,replace(replace(t1.loan_txn_cd,chr(13),''),chr(10),'') as loan_txn_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.db_cr_flg,chr(13),''),chr(10),'') as db_cr_flg
,t1.amt as amt
,t1.bal_typ_thi_stm_bal as bal_typ_thi_stm_bal
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,replace(replace(t1.reve_flg,chr(13),''),chr(10),'') as reve_flg
,replace(replace(t1.dbill_num,chr(13),''),chr(10),'') as dbill_num
,t1.thi_stm_bal as thi_stm_bal
,t1.bch_nbr as bch_nbr
,replace(replace(t1.int_categ,chr(13),''),chr(10),'') as int_categ
,t1.etl_dt as etl_dt
,NVL2(t1.data_src_cd,'EVT_LOAN_STMT'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_LOAN_STMT') as etl_task_name 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_iml_evt_loan_stmt t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'mm');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_loan_stmt_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes