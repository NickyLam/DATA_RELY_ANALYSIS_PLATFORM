: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_tran_flow_i
CreateDate: 20251106
FileName:   ${iel_data_path}/evt_loan_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.debit_crdt_flg_cd,chr(13),''),chr(10),'') as debit_crdt_flg_cd
,replace(replace(t1.vtual_flg,chr(13),''),chr(10),'') as vtual_flg
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,tran_tm
,tran_dt
,effect_dt
,tran_amt
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,pric_amt
,int_amt
,pnlt_amt
,comp_int_amt
,tax
,float_ratio
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.chn_sub_flow_num,chr(13),''),chr(10),'') as chn_sub_flow_num
,chn_dt
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,revs_dt
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.belong_module,chr(13),''),chr(10),'') as belong_module
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num
,replace(replace(t1.loan_chn_cd,chr(13),''),chr(10),'') as loan_chn_cd
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code
,replace(replace(t1.modif_bf_org_id,chr(13),''),chr(10),'') as modif_bf_org_id
,replace(replace(t1.rule_id,chr(13),''),chr(10),'') as rule_id
,replace(replace(t1.proc_idf_cd,chr(13),''),chr(10),'') as proc_idf_cd
,replace(replace(t1.bal_chg_type_cd,chr(13),''),chr(10),'') as bal_chg_type_cd

from ${iml_schema}.evt_loan_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
