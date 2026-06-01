: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_acct_accti_flow_i
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_loan_acct_accti_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.accti_seq_num,chr(13),''),chr(10),'') as accti_seq_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.camp_prod_id,chr(13),''),chr(10),'') as camp_prod_id
,replace(replace(t1.camp_prod_name,chr(13),''),chr(10),'') as camp_prod_name
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,tran_dt
,tran_tm
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,tran_amt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,revs_dt
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id

from ${iml_schema}.evt_loan_acct_accti_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_acct_accti_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
