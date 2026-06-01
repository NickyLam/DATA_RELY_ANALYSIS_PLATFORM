: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_myloan_dubil_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_myloan_dubil.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id
,replace(replace(t1.loan_status_cd,chr(13),''),chr(10),'') as loan_status_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.loan_cap_use_position_cd,chr(13),''),chr(10),'') as loan_cap_use_position_cd
,distr_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,distr_amt
,loan_value_dt
,loan_exp_dt
,loan_cont_tenor
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,grace_period_days
,replace(replace(t1.src_int_rat_type_cd,chr(13),''),chr(10),'') as src_int_rat_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,replace(replace(t1.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq
,loan_actl_day_int_rat
,replace(replace(t1.pric_repay_freq_cd,chr(13),''),chr(10),'') as pric_repay_freq_cd
,replace(replace(t1.int_repay_freq_cd,chr(13),''),chr(10),'') as int_repay_freq_cd
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id
,replace(replace(t1.recvbl_num_type_cd,chr(13),''),chr(10),'') as recvbl_num_type_cd
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_bank_name,chr(13),''),chr(10),'') as recvbl_bank_name
,replace(replace(t1.repay_num_type_cd,chr(13),''),chr(10),'') as repay_num_type_cd
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.repay_bank_name,chr(13),''),chr(10),'') as repay_bank_name
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,acctnt_dt
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
,payoff_dt
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t1.acru_non_acru_flg,chr(13),''),chr(10),'') as acru_non_acru_flg
,next_repay_dt
,unpayoff_perds
,ovdue_pd_cnt
,pric_ovdue_days
,int_ovdue_days
,nomal_pric_bal
,ovdue_pric_bal
,replace(replace(t1.loan_dir_indus_cd,chr(13),''),chr(10),'') as loan_dir_indus_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,nomal_int_bal
,ovdue_int_bal
,ovdue_pric_pnlt_bal
,ovdue_int_pnlt_bal
,loan_exec_year_int_rat
,lpr_int_rat
,int_rat_float_spread_val
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.contri_type_cd,chr(13),''),chr(10),'') as contri_type_cd
,contri_ratio
,replace(replace(t1.white_list_cust_flg,chr(13),''),chr(10),'') as white_list_cust_flg
,replace(replace(t1.cust_char_cd,chr(13),''),chr(10),'') as cust_char_cd
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg
,create_dt
,update_dt

from ${iml_schema}.agt_myloan_dubil t1
where create_dt <= to_date('${batch_date}','yyyymmdd')-1 and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_dubil.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
