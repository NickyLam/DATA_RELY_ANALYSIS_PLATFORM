: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_recvbl_fee_dtl_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_dep_recvbl_fee_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.recvbl_fee_seq_num,chr(13),''),chr(10),'') as recvbl_fee_seq_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,bus_tran_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.charge_acct_id,chr(13),''),chr(10),'') as charge_acct_id
,replace(replace(t1.charge_acct_prod_id,chr(13),''),chr(10),'') as charge_acct_prod_id
,replace(replace(t1.charge_cust_acct_num,chr(13),''),chr(10),'') as charge_cust_acct_num
,replace(replace(t1.charge_acct_curr_cd,chr(13),''),chr(10),'') as charge_acct_curr_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,effect_dt
,last_charge_dt
,tran_revs_dt
,replace(replace(t1.revs_org_id,chr(13),''),chr(10),'') as revs_org_id
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,vouch_sum_qtty
,replace(replace(t1.dep_agt_id,chr(13),''),chr(10),'') as dep_agt_id
,replace(replace(t1.cntpty_bus_id,chr(13),''),chr(10),'') as cntpty_bus_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,discnt_fee_amt
,replace(replace(t1.fee_type_id,chr(13),''),chr(10),'') as fee_type_id
,fee_amt
,init_fee_amt
,next_charge_dt
,tax
,init_recvbl_fee_amt
,fee_price
,replace(replace(t1.charge_freq_cd,chr(13),''),chr(10),'') as charge_freq_cd
,tax_rat
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,replace(replace(t1.need_prft_cut_flg,chr(13),''),chr(10),'') as need_prft_cut_flg
,tran_bank_prft_cut_amt
,replace(replace(t1.fee_charge_way_cd,chr(13),''),chr(10),'') as fee_charge_way_cd
,replace(replace(t1.grace_flg,chr(13),''),chr(10),'') as grace_flg
,replace(replace(t1.tran_revd_flg,chr(13),''),chr(10),'') as tran_revd_flg
,replace(replace(t1.fee_discnt_type_cd,chr(13),''),chr(10),'') as fee_discnt_type_cd
,tran_bank_ratio
,replace(replace(t1.charge_curr_cd,chr(13),''),chr(10),'') as charge_curr_cd
,replace(replace(t1.charge_sub_acct_num,chr(13),''),chr(10),'') as charge_sub_acct_num
,replace(replace(t1.charge_day,chr(13),''),chr(10),'') as charge_day
,replace(replace(t1.termnt_num,chr(13),''),chr(10),'') as termnt_num
,acct_bank_ratio
,acct_bank_prft_cut_amt
,replace(replace(t1.owe_fee_status_cd,chr(13),''),chr(10),'') as owe_fee_status_cd
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,fee_discnt_rat
,replace(replace(t1.revs_auth_teller_id,chr(13),''),chr(10),'') as revs_auth_teller_id
,replace(replace(t1.revs_teller_id,chr(13),''),chr(10),'') as revs_teller_id
,tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id

from ${iml_schema}.evt_dep_recvbl_fee_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_recvbl_fee_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
