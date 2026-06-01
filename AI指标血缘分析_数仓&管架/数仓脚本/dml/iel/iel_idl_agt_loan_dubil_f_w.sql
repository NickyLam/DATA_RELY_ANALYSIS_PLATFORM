: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_dubil_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_dubil_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.dubil_id
,t1.out_acct_flow_num
,t1.cont_id
,t1.subj_id
,t1.core_party_id
,t1.party_id
,t1.bus_breed_id
,t1.status_cd
,t1.curr_cd
,t1.dubil_amt
,t1.distr_dt
,t1.exp_dt
,t1.exec_exp_dt
,t1.exec_int_rat
,t1.int_accr_way_cd
,t1.pric_bal
,t1.nomal_bal
,t1.ovdue_amt
,t1.idle_bal
,t1.bad_debt_bal
,t1.in_bs_over_int_bal
,t1.off_bs_over_int_bal
,t1.pric_pnlt_amt
,t1.int_pnlt_amt
,t1.ovdue_days
,t1.distr_acct_id
,t1.repay_acct_id
,t1.over_int_days
,t1.acm_debt_perds
,t1.termnt_dt
,t1.oper_org_id
,t1.oper_teller_id
,t1.rgst_org_id
,t1.rgst_teller_id
,t1.input_dt
,t1.modif_dt
,t1.base_rat
,t1.wrtoff_dt
,t1.margin_amt
,t1.margin_acct_id
,t1.advc_flg
,t1.devper_enter_acct_net_amnt
,t1.bill_id
,t1.bnft_bank_no
,t1.bnft_bank_name
,t1.pre_recv_int_flg
,t1.loan_type_cd
,t1.ped
,t1.level5_cls_cd
,t1.ovdue_dt
,t1.over_int_dt
,t1.main_guar_way_cd
,t1.level11_cls_cd
,t1.surp_perds
,t1.each_issue_deduct_amt
,t1.ovdue_exec_int_rat
,t1.org_id
,t1.loan_kind_cd
,t1.advc_amt
,t1.advc_dubil_id
,t1.wrtoff_type_cd
,t1.wrtoff_flow_num
,t1.open_flow_num
,t1.open_dt
,t1.fee_rat
,t1.benefc_open_bank_name
,t1.receiptor_name
,t1.ovdue_int
,t1.attach_rgst_dubil_flg
,t1.next_int_set_day
,t1.repay_acct_bal
,t1.repay_acct_aval_bal
,t1.tenor_type_cd
,t1.tenor_seg_cd
,t1.acm_rtn_pric_amt
,t1.acm_rtn_int_amt
,t1.next_term_rpp_dt
,t1.next_term_rpp_amt
,t1.next_term_repay_int_dt
,t1.next_term_repay_int_amt
,t1.temp_store_dubil_bal
,t1.dubil_bal_chg_dt
,t1.matn_flg
,t1.bad_debt_wrt_off_status_cd
,t1.attach_rgst_checker_id
,t1.bill_type_cd
,t1.bill_kind_cd
,t1.batch_data_src_cd
,t1.acpt_bank_no
,t1.acpt_bank_name
,t1.rela_dubil_flow_id
,t1.wrt_off_amt
,t1.asset_thd_cls_cd
,t1.refac_loan_status_cd
,t1.refac_batch_pkg_id
,t1.refac_batch_exp_dt
,t1.refac_invalid_dt
,t1.edu_hea_flg
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_dubil t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_dubil_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes