: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_cap_sec_tran_f
CreateDate: 20250506
FileName:   ${iel_data_path}/cmm_cap_sec_tran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.tran_acct_b_name,chr(13),''),chr(10),'') as tran_acct_b_name
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,tran_dt
,stl_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,stl_amt
,bond_fac_val
,tran_net_price
,tran_full_price
,exp_yld_rat
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,acru_int
,tran_fee
,tran_tax
,tran_comm
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_acct_open_bank_no,chr(13),''),chr(10),'') as tran_acct_open_bank_no
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_open_bank_no,chr(13),''),chr(10),'') as cntpty_acct_open_bank_no
,replace(replace(t1.tran_acct_open_bank_bank_name,chr(13),''),chr(10),'') as tran_acct_open_bank_bank_name
,replace(replace(t1.cntpty_acct_open_bank_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_bank_name
,replace(replace(t1.tran_clear_acct_id,chr(13),''),chr(10),'') as tran_clear_acct_id
,replace(replace(t1.tran_clear_bank_no,chr(13),''),chr(10),'') as tran_clear_bank_no
,replace(replace(t1.tran_clear_bank_name,chr(13),''),chr(10),'') as tran_clear_bank_name
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id

from ${icl_schema}.cmm_cap_sec_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_cap_sec_tran.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
