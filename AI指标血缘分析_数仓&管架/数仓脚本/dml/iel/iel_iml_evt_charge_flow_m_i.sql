: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_charge_flow_m_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_charge_flow_m.i.${batch_date}.dat
IF_mark:    m_i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.charge_seq_num,chr(13),''),chr(10),'') as charge_seq_num
,t1.tran_dt as tran_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,replace(replace(t1.dep_agt_id,chr(13),''),chr(10),'') as dep_agt_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_begin_num,chr(13),''),chr(10),'') as vouch_begin_num
,t1.vouch_sum_qtty as vouch_sum_qtty
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.acct_flg_idf,chr(13),''),chr(10),'') as acct_flg_idf
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,t1.effect_dt as effect_dt
,replace(replace(t1.revs_org_id,chr(13),''),chr(10),'') as revs_org_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,t1.tran_bank_ratio as tran_bank_ratio
,t1.init_recvbl_fee_amt as init_recvbl_fee_amt
,replace(replace(t1.fee_charge_way_cd,chr(13),''),chr(10),'') as fee_charge_way_cd
,replace(replace(t1.comm_fee_coll_way_cd,chr(13),''),chr(10),'') as comm_fee_coll_way_cd
,replace(replace(t1.fee_type_id,chr(13),''),chr(10),'') as fee_type_id
,replace(replace(t1.acct_dmic_charge_curr_cd,chr(13),''),chr(10),'') as acct_dmic_charge_curr_cd
,t1.acct_dmic_fee_amt as acct_dmic_fee_amt
,t1.fee_discnt_rat as fee_discnt_rat
,replace(replace(t1.fee_discnt_type_cd,chr(13),''),chr(10),'') as fee_discnt_type_cd
,replace(replace(t1.recvbl_fee_seq_num,chr(13),''),chr(10),'') as recvbl_fee_seq_num
,t1.acct_bank_prft_cut_amt as acct_bank_prft_cut_amt
,t1.init_fee_amt as init_fee_amt
,t1.discnt_fee_amt as discnt_fee_amt
,t1.tran_bank_prft_cut_amt as tran_bank_prft_cut_amt
,t1.tax as tax
,t1.fee_price as fee_price
,t1.tax_rat as tax_rat
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,replace(replace(t1.amort_tm_type_cd,chr(13),''),chr(10),'') as amort_tm_type_cd
,replace(replace(t1.amort_tenor_type_cd,chr(13),''),chr(10),'') as amort_tenor_type_cd
,replace(replace(t1.amort_day,chr(13),''),chr(10),'') as amort_day
,replace(replace(t1.amort_mon,chr(13),''),chr(10),'') as amort_mon
,replace(replace(t1.amort_flg,chr(13),''),chr(10),'') as amort_flg
,replace(replace(t1.prft_cut_flg,chr(13),''),chr(10),'') as prft_cut_flg
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.tran_revd_flg,chr(13),''),chr(10),'') as tran_revd_flg
,replace(replace(t1.tran_acct_serv_fee_revs_seq_num,chr(13),''),chr(10),'') as tran_acct_serv_fee_revs_seq_num
,replace(replace(t1.revs_auth_teller,chr(13),''),chr(10),'') as revs_auth_teller
,replace(replace(t1.revs_teller,chr(13),''),chr(10),'') as revs_teller
,replace(replace(t1.org_tran_seq_num,chr(13),''),chr(10),'') as org_tran_seq_num
,replace(replace(t1.end_day_onl_cd,chr(13),''),chr(10),'') as end_day_onl_cd
,replace(replace(t1.termnt_num,chr(13),''),chr(10),'') as termnt_num
,t1.acct_bank_ratio as acct_bank_ratio
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.amort_closing_dt as amort_closing_dt
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.check_entry_cd,chr(13),''),chr(10),'') as check_entry_cd
,t1.amort_begin_dt as amort_begin_dt
from ${iml_schema}.evt_charge_flow t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_charge_flow_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes