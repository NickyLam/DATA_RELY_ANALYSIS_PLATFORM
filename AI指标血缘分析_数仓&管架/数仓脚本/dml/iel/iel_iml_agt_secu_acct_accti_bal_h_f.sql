: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_secu_acct_accti_bal_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_secu_acct_accti_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.ext_vch_acct_id,chr(13),''),chr(10),'') as ext_vch_acct_id
,replace(replace(t1.intnal_vch_acct_id,chr(13),''),chr(10),'') as intnal_vch_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.tran_num,chr(13),''),chr(10),'') as tran_num
,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'') as extra_dimen_cd
,actl_qtty
,actl_bal
,net_price_cost
,acru_int
,int_cost
,evha_val_chag
,recvbl_uncol_bal
,recvbl_uncol_net_price_cost
,recvbl_uncol_acru_int
,td_amort_bus_cnt
,amort_dt
,int_adj_amt
,fair_val_pl
,bs_pl
,int_income
,acru_int_inco
,amort_int_income
,curr_post_acru_int_int_income
,curr_post_amort_int_income
,reclafy_fair_val_pl
,impam_prep
,impam_loss
,futures_margin
,open_dt
,last_update_dt
,fee
,paybl_fee
,fee_cost
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
,provi_amort_closing_dt
,replace(replace(t1.impam_status_cd,chr(13),''),chr(10),'') as impam_status_cd
,cost_impam_loss
,int_impam_loss
,cost_impam_prep
,wrtn_off_cost
,wrtn_off_acru_int
,wrtn_off_recvbl_uncol_int
,off_bs_acru_int
,off_bs_recvbl_uncol_int
,acru_int_amt
,acru_vat
,paybl_vat
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,stl_dt
,rlizd_evha_val_chag_pl
,curr_post_int_tax
,open_int_cost
,open_ex_yld_rat
,pre_recv_int_income
,provi_int_income
,int_recvbl_inco
,actl_recv_int_income
,provi_int_income_pre_recv_tax
,amort_int_income_paybl_vat
,offset_dlvy_dt
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,at_pre_recv_int_income
,replace(replace(t1.ext_dimen_info,chr(13),''),chr(10),'') as ext_dimen_info
,replace(replace(t1.comb_tran_id,chr(13),''),chr(10),'') as comb_tran_id

from ${iml_schema}.agt_secu_acct_accti_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_secu_acct_accti_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
