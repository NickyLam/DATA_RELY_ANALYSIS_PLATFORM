: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_cap_bal_f
CreateDate: 20220916
FileName:   ${iel_data_path}/cmm_ibank_cap_bal.f.${batch_date}.dat
IF_mark:    f
Logs:
   Sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
    ,replace(replace(t.ext_cap_acct_id,chr(13),''),chr(10),'') as ext_cap_acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
    ,replace(replace(t.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
    ,replace(replace(t.open_acct_bank_no,chr(13),''),chr(10),'') as open_acct_bank_no
    ,replace(replace(t.open_acct_bank_name,chr(13),''),chr(10),'') as open_acct_bank_name
    ,t.open_acct_dt as open_acct_dt
    ,replace(replace(t.cntpty_cust_id,chr(13),''),chr(10),'') as cntpty_cust_id
    ,replace(replace(t.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
    ,replace(replace(t.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
    ,replace(replace(t.intnal_cap_acct_num,chr(13),''),chr(10),'') as intnal_cap_acct_num
    ,replace(replace(t.cap_acct_type_cd,chr(13),''),chr(10),'') as cap_acct_type_cd
    ,replace(replace(t.intnal_acct_num,chr(13),''),chr(10),'') as intnal_acct_num
    ,replace(replace(t.intnal_acct_name,chr(13),''),chr(10),'') as intnal_acct_name
    ,replace(replace(t.pay_int_freq,chr(13),''),chr(10),'') as pay_int_freq
    ,replace(replace(t.prod_type_id,chr(13),''),chr(10),'') as prod_type_id
    ,replace(replace(t.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
    ,replace(replace(t.int_rat_def_id,chr(13),''),chr(10),'') as int_rat_def_id
    ,t.int_rat as int_rat
    ,replace(replace(t.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
    ,replace(replace(t.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.actl_bal as actl_bal
    ,t.froz_bal as froz_bal
    ,t.aval_bal as aval_bal
    ,t.stl_dt as stl_dt
    ,t.open_dt as open_dt
    ,replace(replace(t.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
from icl.cmm_ibank_cap_bal t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')                             " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_cap_bal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes