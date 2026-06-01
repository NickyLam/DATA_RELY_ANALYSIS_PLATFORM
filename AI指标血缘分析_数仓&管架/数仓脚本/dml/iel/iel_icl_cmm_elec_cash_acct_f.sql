: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_elec_cash_acct_f
CreateDate: 20240426
FileName:   ${iel_data_path}/cmm_elec_cash_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_card_no,chr(13),''),chr(10),'') as cust_acct_card_no
,replace(replace(t1.cust_acct_sub_acct_id,chr(13),''),chr(10),'') as cust_acct_sub_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,open_acct_dt
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,clos_acct_dt
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,acct_bal_uplmi
,sig_tran_lmt
,acm_load_amt
,currt_bal

from ${icl_schema}.cmm_elec_cash_acct t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_elec_cash_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
