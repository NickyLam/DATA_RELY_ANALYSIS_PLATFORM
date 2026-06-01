: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_dep_acct_tran_dtl_attach_info_a
CreateDate: 20251217
FileName:   ${iel_data_path}/cmm_dep_acct_tran_dtl_attach_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,tran_timestamp
,replace(replace(t1.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.src_tran_flow_num,chr(13),''),chr(10),'') as src_tran_flow_num
,replace(replace(t1.src_seq_no,chr(13),''),chr(10),'') as src_seq_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_open_bank_cd,chr(13),''),chr(10),'') as cntpty_acct_open_bank_cd
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,replace(replace(t1.cntpty_subj_id,chr(13),''),chr(10),'') as cntpty_subj_id
,replace(replace(t1.cntpty_subj_name,chr(13),''),chr(10),'') as cntpty_subj_name
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,replace(replace(t1.src_sys_id,chr(13),''),chr(10),'') as src_sys_id
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.lev_tax_rebate_tran_flg,chr(13),''),chr(10),'') as lev_tax_rebate_tran_flg
,replace(replace(t1.tran_remark,chr(13),''),chr(10),'') as tran_remark

from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_acct_tran_dtl_attach_info.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
