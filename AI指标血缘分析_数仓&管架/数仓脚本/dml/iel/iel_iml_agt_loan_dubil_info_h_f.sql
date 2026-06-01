: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_dubil_info_h_f
CreateDate: 20230323
FileName:   ${iel_data_path}/agt_loan_dubil_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.rela_out_acct_flow_num,chr(13),''),chr(10),'') as rela_out_acct_flow_num
,replace(replace(t1.rela_cont_id,chr(13),''),chr(10),'') as rela_cont_id
,replace(replace(t1.init_bus_id,chr(13),''),chr(10),'') as init_bus_id
,happ_dt
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,dubil_amt
,mon_tenor
,day_tenor
,distr_dt
,apot_exp_dt
,actl_exp_dt
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,base_rat
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,exec_year_int_rat
,margin_ratio
,margin_amt
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd
,replace(replace(t1.distr_acct_id,chr(13),''),chr(10),'') as distr_acct_id
,replace(replace(t1.distr_acct_name,chr(13),''),chr(10),'') as distr_acct_name
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name
,repay_num_bal
,repay_num_aval_bal
,curr_bal
,nomal_bal
,ovdue_bal
,idle_bal
,bad_debt_bal
,renew_cnt
,pric_ovdue_fst_dt
,int_ovdue_fst_dt
,in_bs_over_int_bal
,off_bs_over_int_bal
,ovdue_pnlt_bal
,comp_int_bal
,loan_ovdue_days
,over_int_days
,loan_grace_period
,provi_resv_lmt
,pre_loss_amt
,termnt_dt
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg
,replace(replace(t1.low_risk_flg,chr(13),''),chr(10),'') as low_risk_flg
,fir_idtfy_non_dt
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,level5_cls_dt
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd
,level11_cls_dt
,replace(replace(t1.advc_flg,chr(13),''),chr(10),'') as advc_flg
,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t1.init_dubil_id,chr(13),''),chr(10),'') as init_dubil_id
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id
,oper_dt
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,deflt_repay_day
,ovdue_dt
,over_int_dt
,ovdue_int_rat
,replace(replace(t1.accti_org_id,chr(13),''),chr(10),'') as accti_org_id
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.guar_way_cd_two,chr(13),''),chr(10),'') as guar_way_cd_two
,replace(replace(t1.guar_way_cd_three,chr(13),''),chr(10),'') as guar_way_cd_three
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd
,int_rat_float_range
,replace(replace(t1.enter_open_acct_org_id,chr(13),''),chr(10),'') as enter_open_acct_org_id
,replace(replace(t1.bad_debt_wrt_off_status_cd,chr(13),''),chr(10),'') as bad_debt_wrt_off_status_cd
,replace(replace(t1.out_acct_org_id,chr(13),''),chr(10),'') as out_acct_org_id
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd
,ovdue_int_rat_flo_val
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,replace(replace(t1.refac_loan_idf_cd,chr(13),''),chr(10),'') as refac_loan_idf_cd
,replace(replace(t1.old_cust_id,chr(13),''),chr(10),'') as old_cust_id
,replace(replace(t1.old_prod_id,chr(13),''),chr(10),'') as old_prod_id
,loan_tot_perds
,surp_repay_perds
,replace(replace(t1.level10_cls_manu_med_flg,chr(13),''),chr(10),'') as level10_cls_manu_med_flg
,replace(replace(t1.last_level10_cls_cd,chr(13),''),chr(10),'') as last_level10_cls_cd
,last_level10_cls_dt
,replace(replace(t1.last_level5_cls_cd,chr(13),''),chr(10),'') as last_level5_cls_cd
,last_level5_cls_cmplt_dt
,last_term_level5_cls_modif_dt
,next_int_set_dt
,comp_amt

from ${iml_schema}.agt_loan_dubil_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_dubil_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
