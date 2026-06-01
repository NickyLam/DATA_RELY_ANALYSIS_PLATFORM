: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_secu_acct_accti_bal_chg_h_f
CreateDate: 20250506
FileName:   ${iel_data_path}/agt_secu_acct_accti_bal_chg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.chg_id,chr(13),''),chr(10),'') as chg_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.revo_rela_chg_id,chr(13),''),chr(10),'') as revo_rela_chg_id
,chg_dt
,replace(replace(t1.chg_type_cd,chr(13),''),chr(10),'') as chg_type_cd
,replace(replace(t1.accti_obj_id,chr(13),''),chr(10),'') as accti_obj_id
,replace(replace(t1.instr_id,chr(13),''),chr(10),'') as instr_id
,replace(replace(t1.ext_vch_acct_id,chr(13),''),chr(10),'') as ext_vch_acct_id
,replace(replace(t1.intnal_vch_acct_id,chr(13),''),chr(10),'') as intnal_vch_acct_id
,replace(replace(t1.comb_tran_id,chr(13),''),chr(10),'') as comb_tran_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.tran_num,chr(13),''),chr(10),'') as tran_num
,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'') as extra_dimen_cd
,replace(replace(t1.accti_type_cd,chr(13),''),chr(10),'') as accti_type_cd
,actl_qtty
,actl_bal
,net_price_cost
,acru_int
,int_cost
,acru_turn_recvbl_uncol
,recvbl_uncol_turn_actl_recv
,acru_int_theory_attach_provi
,acru_int_actl_attach_provi
,evha_val_chag
,fair_val_pl_asset
,fair_val_pl_liab
,recvbl_uncol_bal
,recvbl_uncol_net_price_cost
,recvbl_uncol_acru_int
,td_amort_bus_cnt
,amort_dt
,int_adj_amt
,fair_val_pl
,bs_pl
,int_income
,acru_int_int_income
,amort_int_income
,curr_post_acru_int_int_income
,curr_post_amort_int_income
,reclafy_fair_val_pl
,futures_margin
,update_tm
,fee
,paybl_fee
,fee_cost
,amort_net_price_cost
,amort_int_cost
,bus_dt
,h_amort_start_dt
,actl_int_rat
,invest_yld_rat
,open_yld_rat
,pre_recv_int
,non_amort_net_price_cost
,non_amort_evha_val_chag
,non_amort_fair_val_pl
,non_amort_bs_pl
,reset_bf_amort_dt
,reset_post_amort_closing_dt
,reset_bf_amort_closing_dt
,wrtn_off_cost
,wrtn_off_acru_int
,wrtn_off_recvbl_uncol_int
,off_bs_acru_int
,off_bs_recvbl_uncol_int
,acru_int_amt
,acru_vat
,paybl_vat
,replace(replace(t1.reset_bf_evltion_curr_cd,chr(13),''),chr(10),'') as reset_bf_evltion_curr_cd
,replace(replace(t1.reset_post_evltion_curr_cd,chr(13),''),chr(10),'') as reset_post_evltion_curr_cd
,stl_dt
,rlizd_evha_val_chag_pl
,curr_post_int_tax
,open_int_cost
,open_ex_yld_rat
,pre_tax_pre_recv_int_income
,provi_int_income
,int_recvbl_inco
,actl_recv_int_income
,provi_int_income_pre_recv_tax
,amort_int_income_paybl_vat
,bs_pl_paybl_vat
,offset_dlvy_dt
,reset_bf_offset_dlvy_dt
,replace(replace(t1.ext_dimen_info,chr(13),''),chr(10),'') as ext_dimen_info
,int_income_estim_tax
,int_income_paybl_vat
,replace(replace(t1.pl_obj_id,chr(13),''),chr(10),'') as pl_obj_id
,replace(replace(t1.old_pl_obj_id,chr(13),''),chr(10),'') as old_pl_obj_id
,at_pre_recv_int_income
,fee_pl_paybl_vat

from ${iml_schema}.agt_secu_acct_accti_bal_chg_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_secu_acct_accti_bal_chg_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
