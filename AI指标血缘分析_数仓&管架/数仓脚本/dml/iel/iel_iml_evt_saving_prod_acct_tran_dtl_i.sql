: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_saving_prod_acct_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_saving_prod_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.liab_acct_id,chr(13),''),chr(10),'') as liab_acct_id
    ,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
    ,replace(replace(t.cust_acct_sub_acct_id,chr(13),''),chr(10),'') as cust_acct_sub_acct_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,t.tran_amt as tran_amt
    ,t.exec_int_rat as exec_int_rat
    ,t.int_amt as int_amt
    ,t.tran_bal as tran_bal
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
    ,replace(replace(t.tran_kind_dtl_cd,chr(13),''),chr(10),'') as tran_kind_dtl_cd
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,t.liab_acct_open_dt as liab_acct_open_dt
    ,t.depot_dt as depot_dt
    ,t.tran_dt as tran_dt
    ,t.tran_ser_num as tran_ser_num    
from iml.evt_saving_prod_acct_tran_dtl t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_saving_prod_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes