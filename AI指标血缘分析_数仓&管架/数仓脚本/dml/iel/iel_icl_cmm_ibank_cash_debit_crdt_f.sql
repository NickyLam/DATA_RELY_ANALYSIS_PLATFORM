: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_cash_debit_crdt_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_ibank_cash_debit_crdt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.comb_tran_num,chr(13),''),chr(10),'') as comb_tran_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
,replace(replace(t1.cntpty_cust_id,chr(13),''),chr(10),'') as cntpty_cust_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_open_bank_num,chr(13),''),chr(10),'') as cntpty_open_bank_num
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,replace(replace(t1.cntpty_cls_descb,chr(13),''),chr(10),'') as cntpty_cls_descb
,replace(replace(t1.cntpty_idf_code,chr(13),''),chr(10),'') as cntpty_idf_code
,replace(replace(t1.cntpty_idf_code_type_cd,chr(13),''),chr(10),'') as cntpty_idf_code_type_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.bank_flg,chr(13),''),chr(10),'') as bank_flg
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,value_dt
,exp_dt
,cash_dt
,replace(replace(t1.tenor_cd,chr(13),''),chr(10),'') as tenor_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,replace(replace(t1.int_rat_adj_freq_cd,chr(13),''),chr(10),'') as int_rat_adj_freq_cd
,replace(replace(t1.apv_odd_no,chr(13),''),chr(10),'') as apv_odd_no
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,fac_val_int_rat
,base_rat
,exec_int_rat
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,replace(replace(t1.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg
,actl_bal
,pric_bal
,currt_bal
,acru_int
,recvbl_uncol_pric
,recvbl_uncol_int
,last_update_dt
,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,tran_amt
,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'') as extra_dimen_cd
,stl_dt
,replace(replace(t1.ovdue_status,chr(13),''),chr(10),'') as ovdue_status
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,pric_ovdue_dt
,pric_ovdue_days
,int_ovdue_dt
,int_ovdue_days
,replace(replace(t1.acct_char_descb,chr(13),''),chr(10),'') as acct_char_descb
,replace(replace(t1.acct_attr_descb,chr(13),''),chr(10),'') as acct_attr_descb
,replace(replace(t1.actl_finer_cust_id,chr(13),''),chr(10),'') as actl_finer_cust_id
,replace(replace(t1.actl_finer_name,chr(13),''),chr(10),'') as actl_finer_name
,replace(replace(t1.actl_finer_group_name,chr(13),''),chr(10),'') as actl_finer_group_name
,replace(replace(t1.inpwn_vch_id,chr(13),''),chr(10),'') as inpwn_vch_id
,replace(replace(t1.inpwn_vch_asset_type_id,chr(13),''),chr(10),'') as inpwn_vch_asset_type_id
,replace(replace(t1.inpwn_vch_market_type_id,chr(13),''),chr(10),'') as inpwn_vch_market_type_id
,inpwn_cert_face_lmt
,inpwn_vch_discnt_rat
,inpwn_vch_pct
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,replace(replace(t1.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id
,replace(replace(t1.crdt_fin_instm_id,chr(13),''),chr(10),'') as crdt_fin_instm_id
,replace(replace(t1.asset_uniq_idf_id,chr(13),''),chr(10),'') as asset_uniq_idf_id

from ${icl_schema}.cmm_ibank_cash_debit_crdt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_cash_debit_crdt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
