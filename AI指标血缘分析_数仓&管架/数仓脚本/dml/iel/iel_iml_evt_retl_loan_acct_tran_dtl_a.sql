: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_retl_loan_acct_tran_dtl_a
CreateDate: 20220407
FileName:   ${iel_data_path}/evt_retl_loan_acct_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.acct_dt as acct_dt
    ,replace(replace(t.dtl_id,chr(13),''),chr(10),'') as dtl_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.acctnt_cate_cd,chr(13),''),chr(10),'') as acctnt_cate_cd
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
    ,t.tran_amt as tran_amt
    ,t.acct_bal as acct_bal
    ,replace(replace(t.bal_field_name,chr(13),''),chr(10),'') as bal_field_name
    ,replace(replace(t.bal_field_cn_name,chr(13),''),chr(10),'') as bal_field_cn_name
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.tran_evt_cd,chr(13),''),chr(10),'') as tran_evt_cd
    ,replace(replace(t.evt_descb,chr(13),''),chr(10),'') as evt_descb
    ,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
    ,replace(replace(t.revs_flg,chr(13),''),chr(10),'') as revs_flg
    ,replace(replace(t.brevs_flg,chr(13),''),chr(10),'') as brevs_flg
    ,t.tran_tm as tran_tm
from iml.evt_retl_loan_acct_tran_dtl t 
  where t.acct_dt >= to_date('20210101','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_retl_loan_acct_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes