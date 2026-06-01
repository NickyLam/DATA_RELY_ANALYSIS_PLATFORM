: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_entry_bal_chg_flow_a
CreateDate: 20230130
FileName:   ${iel_data_path}/evt_entry_bal_chg_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.chg_id,chr(13),''),chr(10),'') as chg_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.revo_rela_chg_id,chr(13),''),chr(10),'') as revo_rela_chg_id
,chg_dt
,replace(replace(t1.chg_type_cd,chr(13),''),chr(10),'') as chg_type_cd
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.instr_id,chr(13),''),chr(10),'') as instr_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
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
,asset_fair_val_pl
,liab_fair_val_pl
,recvbl_uncol_bal
,recvbl_uncol_net_price_cost
,recvbl_uncol_acru_int
,amort_dt
,int_adj_amt
,fair_val_pl
,bs_pl
,int_income
,acru_int_inco
,amort_int_income
,curr_post_acru_int_inco
,curr_post_amort_int_income
,update_tm
,curr_issue_acru_int
,curr_issue_int_adj
,curr_issue_evha_val_chag
,curr_issue_asset_evha_val_chag
,curr_issue_liab_evha_val_chag
,fee
,amort_net_price_cost
,amort_int_cost
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
,replace(replace(t1.impam_status_cd,chr(13),''),chr(10),'') as impam_status_cd
,cost_impam_loss
,int_impam_loss
,cost_impam_prep
,wrtn_off_cost
,wrtn_off_acru_int
,wrtn_off_recvbl_uncol_int
,off_bs_acru_int
,off_bs_recvbl_uncol_int
,reset_bf_reclafy_amort_start_dt
,reset_post_reclafy_amort_start_dt
,reclafy_amort_start_dt_int_cost
,acru_int_inco_incremt
,acru_vat
,paybl_vat
,replace(replace(t1.reset_bf_evltion_curr_cd,chr(13),''),chr(10),'') as reset_bf_evltion_curr_cd
,replace(replace(t1.reset_post_evltion_curr_cd,chr(13),''),chr(10),'') as reset_post_evltion_curr_cd
,open_int_cost
,open_ex_yld_rat
,pre_recv_int_income
,provi_int_income
,int_recvbl_inco
,actl_recv_int_income
,at_pre_recv_int_income
,amort_int_income_paybl_vat
,bs_pl_paybl_vat
,fee_pl_paybl_vat
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg

from ${iml_schema}.evt_entry_bal_chg_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_entry_bal_chg_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
