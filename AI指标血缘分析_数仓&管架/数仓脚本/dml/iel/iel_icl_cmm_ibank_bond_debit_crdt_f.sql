: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_bond_debit_crdt_f
CreateDate: 20250506
FileName:   ${iel_data_path}/cmm_ibank_bond_debit_crdt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.asset_uniq_idf_id,chr(13),''),chr(10),'') as asset_uniq_idf_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.tran_acct_b_name,chr(13),''),chr(10),'') as tran_acct_b_name
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.cntpty_cust_id,chr(13),''),chr(10),'') as cntpty_cust_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.pric_subj_id,chr(13),''),chr(10),'') as pric_subj_id
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id
,tran_dt
,value_dt
,exp_dt
,tran_amt
,exp_stl_amt
,debit_crdt_fee_rat
,debit_crdt_days
,replace(replace(t1.inpwn_bond_comb,chr(13),''),chr(10),'') as inpwn_bond_comb
,replace(replace(t1.underly_bond_id,chr(13),''),chr(10),'') as underly_bond_id
,inpwn_cert_face_lmt
,acru_int
,int_recvbl
,hold_pos
,currt_bal
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.tran_clear_acct_id,chr(13),''),chr(10),'') as tran_clear_acct_id
,replace(replace(t1.tran_clear_bank_no,chr(13),''),chr(10),'') as tran_clear_bank_no
,replace(replace(t1.tran_clear_bank_name,chr(13),''),chr(10),'') as tran_clear_bank_name

from ${icl_schema}.cmm_ibank_bond_debit_crdt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_bond_debit_crdt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
