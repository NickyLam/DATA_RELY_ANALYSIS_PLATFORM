: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_dubil_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
    ,replace(replace(t.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
    ,replace(replace(t.rela_dubil_id,chr(13),''),chr(10),'') as rela_dubil_id
    ,replace(replace(t.bill_num,chr(13),''),chr(10),'') as bill_num
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.host_cust_id,chr(13),''),chr(10),'') as host_cust_id
    ,replace(replace(t.distr_acct_num,chr(13),''),chr(10),'') as distr_acct_num
    ,replace(replace(t.repay_num,chr(13),''),chr(10),'') as repay_num
    ,replace(replace(t.secd_repay_num,chr(13),''),chr(10),'') as secd_repay_num
    ,replace(replace(t.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num
    ,replace(replace(t.manu_cont_id,chr(13),''),chr(10),'') as manu_cont_id
    ,replace(replace(t.crdt_lmt_agt_id,chr(13),''),chr(10),'') as crdt_lmt_agt_id
    ,replace(replace(t.advc_flg,chr(13),''),chr(10),'') as advc_flg
    ,replace(replace(t.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg
    ,replace(replace(t.attach_rgst_dubil_flg,chr(13),''),chr(10),'') as attach_rgst_dubil_flg
    ,replace(replace(t.matn_flg,chr(13),''),chr(10),'') as matn_flg
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
    ,replace(replace(t.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg
    ,replace(replace(t.stop_accr_int_flg,chr(13),''),chr(10),'') as stop_accr_int_flg
    ,replace(replace(t.sign_crdt_cont_flg,chr(13),''),chr(10),'') as sign_crdt_cont_flg
    ,replace(replace(t.pric_auto_rtn_flg,chr(13),''),chr(10),'') as pric_auto_rtn_flg
    ,replace(replace(t.int_auto_rtn_flg,chr(13),''),chr(10),'') as int_auto_rtn_flg
    ,replace(replace(t.crdt_distr_repay_plan_flg,chr(13),''),chr(10),'') as crdt_distr_repay_plan_flg
    ,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
    ,replace(replace(t.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
    ,replace(replace(t.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
    ,replace(replace(t.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
    ,replace(replace(t.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
    ,replace(replace(t.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd
    ,replace(replace(t.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
    ,replace(replace(t.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd
    ,replace(replace(t.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
    ,replace(replace(t.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
    ,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
    ,replace(replace(t.loan_kind_cd,chr(13),''),chr(10),'') as loan_kind_cd
    ,replace(replace(t.wrtoff_type_cd,chr(13),''),chr(10),'') as wrtoff_type_cd
    ,replace(replace(t.loan_tenor_type_cd,chr(13),''),chr(10),'') as loan_tenor_type_cd
    ,replace(replace(t.loan_tenor_seg_cd,chr(13),''),chr(10),'') as loan_tenor_seg_cd
    ,replace(replace(t.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
    ,replace(replace(t.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
    ,replace(replace(t.data_src_flg,chr(13),''),chr(10),'') as data_src_flg
    ,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
    ,replace(replace(t.col_int_type_cd,chr(13),''),chr(10),'') as col_int_type_cd
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
    ,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq
    ,replace(replace(t.inst_loan_repay_way_cd,chr(13),''),chr(10),'') as inst_loan_repay_way_cd
    ,replace(replace(t.money_use_type_cd,chr(13),''),chr(10),'') as money_use_type_cd
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
    ,replace(replace(t.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
    ,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
    ,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
    ,replace(replace(t.attach_rgst_check_teller_id,chr(13),''),chr(10),'') as attach_rgst_check_teller_id
    ,replace(replace(t.benefc_name,chr(13),''),chr(10),'') as benefc_name
    ,replace(replace(t.bnft_bk_no,chr(13),''),chr(10),'') as bnft_bk_no
    ,replace(replace(t.bnft_bk_name,chr(13),''),chr(10),'') as bnft_bk_name
    ,replace(replace(t.acpt_bank_no,chr(13),''),chr(10),'') as acpt_bank_no
    ,replace(replace(t.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name
    ,replace(replace(t.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
    ,replace(replace(t.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd
    ,t.margin_amt as margin_amt
    ,t.margin_ratio as margin_ratio
    ,replace(replace(t.dubil_wrtoff_flow_num,chr(13),''),chr(10),'') as dubil_wrtoff_flow_num
    ,replace(replace(t.dubil_open_flow_num,chr(13),''),chr(10),'') as dubil_open_flow_num
    ,t.dubil_open_dt as dubil_open_dt
    ,t.distr_dt as distr_dt
    ,t.apot_exp_dt as apot_exp_dt
    ,t.exec_exp_dt as exec_exp_dt
    ,t.next_int_set_dt as next_int_set_dt
    ,t.loan_cls_dt as loan_cls_dt
    ,t.next_term_rpp_dt as next_term_rpp_dt
    ,t.next_term_repay_int_dt as next_term_repay_int_dt
    ,t.payoff_dt as payoff_dt
    ,t.ovdue_dt as ovdue_dt
    ,t.over_int_dt as over_int_dt
    ,t.ovdue_days as ovdue_days
    ,t.over_int_days as over_int_days
    ,t.loan_ped as loan_ped
    ,t.inst_loan_tot_perds as inst_loan_tot_perds
    ,t.surp_perds as surp_perds
    ,t.acm_debt_perds as acm_debt_perds
    ,t.exec_int_rat as exec_int_rat
    ,t.ovdue_int_rat as ovdue_int_rat
    ,t.comm_fee_fee_rat as comm_fee_fee_rat
    ,t.next_term_rpp_amt as next_term_rpp_amt
    ,t.next_term_repay_int_amt as next_term_repay_int_amt
    ,t.repay_num_bal as repay_num_bal
    ,t.repay_num_aval_bal as repay_num_aval_bal
    ,t.eh_issue_deduct_amt as eh_issue_deduct_amt
    ,t.ovdue_int as ovdue_int
    ,t.dubil_amt as dubil_amt
    ,t.dubil_bal as dubil_bal
    ,t.nomal_pric as nomal_pric
    ,t.ovdue_pric as ovdue_pric
    ,t.idle_pric as idle_pric
    ,t.bad_debt_pric as bad_debt_pric
    ,t.in_bs_over_int_bal as in_bs_over_int_bal
    ,t.off_bs_over_int_bal as off_bs_over_int_bal
    ,t.pric_pnlt as pric_pnlt
    ,t.int_pnlt as int_pnlt
    ,replace(replace(t.cap_ratio,chr(13),''),chr(10),'') as cap_ratio
    ,replace(replace(t.intnl_trad_fin_rela_id_2,chr(13),''),chr(10),'') as intnl_trad_fin_rela_id_2
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
    ,replace(replace(t.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg
    ,replace(replace(t.refac_loan_status_cd,chr(13),''),chr(10),'') as refac_loan_status_cd
    ,replace(replace(t.crdtc_subm_bus_breed_cd,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_cd
    ,replace(replace(t.crdtc_subm_bus_breed_descb,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_descb
    ,t.base_rat as base_rat
    ,replace(replace(t.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg
    ,replace(replace(t.file_int_accr_flg,chr(13),''),chr(10),'') as file_int_accr_flg
    ,replace(replace(t.refac_loan_batch_pkg_id,chr(13),''),chr(10),'') as refac_loan_batch_pkg_id
    ,t.refac_loan_batch_exp_dt as refac_loan_batch_exp_dt
    ,t.refac_loan_use_int_rat as refac_loan_use_int_rat
    ,t.level5_cls_idtfy_dt as level5_cls_idtfy_dt
    ,t.entr_pay_amt as entr_pay_amt
    ,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
from icl.cmm_corp_loan_dubil_info t 
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_dubil_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes