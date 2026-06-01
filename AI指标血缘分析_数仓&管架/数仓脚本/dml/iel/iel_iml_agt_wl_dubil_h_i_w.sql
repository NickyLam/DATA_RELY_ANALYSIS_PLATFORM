: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_dubil_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_dubil_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.loan_acct_num,chr(13),''),chr(10),'') as loan_acct_num
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,t.loan_pric as loan_pric
,t.nomal_pric as nomal_pric
,t.ovdue_pric as ovdue_pric
,t.idle_pric as idle_pric
,t.bad_debt_pric as bad_debt_pric
,t.pric_bal as pric_bal
,t.s_owe_in_bs_loan_int as s_owe_in_bs_loan_int
,t.s_owe_in_bs_ovdue_int as s_owe_in_bs_ovdue_int
,t.s_owe_in_bs_comp_int_int as s_owe_in_bs_comp_int_int
,t.s_owe_in_bs_other_int as s_owe_in_bs_other_int
,t.s_owe_off_bs_loan_int as s_owe_off_bs_loan_int
,t.s_owe_off_bs_ovdue_int as s_owe_off_bs_ovdue_int
,t.s_owe_off_bs_comp_int_int as s_owe_off_bs_comp_int_int
,t.s_owe_off_bs_other_int as s_owe_off_bs_other_int
,t.actl_recv_loan_int as actl_recv_loan_int
,t.actl_recv_ovdue_int as actl_recv_ovdue_int
,t.actl_recv_comp_int_int as actl_recv_comp_int_int
,t.actl_recv_other_int as actl_recv_other_int
,t.actl_recv_in_bs_int as actl_recv_in_bs_int
,t.actl_recv_off_bs_int as actl_recv_off_bs_int
,t.recvbl_serv_fee as recvbl_serv_fee
,t.recvbl_comm_fee as recvbl_comm_fee
,t.recvbl_other_fee as recvbl_other_fee
,t.s_owe_serv_fee as s_owe_serv_fee
,t.s_owe_comm_fee as s_owe_comm_fee
,t.s_owe_other_fee as s_owe_other_fee
,t.acclat_ic_serv_fee as acclat_ic_serv_fee
,t.acclat_ic_comm_fee as acclat_ic_comm_fee
,t.acclat_ic_other_fee as acclat_ic_other_fee
,t.recvbl_acru_int as recvbl_acru_int
,t.coll_acru_int as coll_acru_int
,t.recvbl_over_int as recvbl_over_int
,t.coll_over_int as coll_over_int
,t.recvbl_acru_pnlt as recvbl_acru_pnlt
,t.coll_acru_pnlt as coll_acru_pnlt
,t.recvbl_pnlt as recvbl_pnlt
,t.coll_pnlt as coll_pnlt
,t.acru_comp_int as acru_comp_int
,t.payoff_dt as payoff_dt
,t.fir_ovdue_dt as fir_ovdue_dt
,t.final_ovdue_dt as final_ovdue_dt
,t.curr_ovdue_start_dt as curr_ovdue_start_dt
,t.curr_ovdue_start_term_minor as curr_ovdue_start_term_minor
,t.curr_ovdue_days as curr_ovdue_days
,t.acm_ovdue_days as acm_ovdue_days
,t.lont_ovdue_days as lont_ovdue_days
,t.acm_ovdue_perds as acm_ovdue_perds
,t.lont_conti_ovdue_perds as lont_conti_ovdue_perds
,replace(replace(t.renew_flg,chr(13),''),chr(10),'') as renew_flg
,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,replace(replace(t.level4_cls_cd,chr(13),''),chr(10),'') as level4_cls_cd
,replace(replace(t.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t.level10_cls_cd,chr(13),''),chr(10),'') as level10_cls_cd
,replace(replace(t.level12_cls_cd,chr(13),''),chr(10),'') as level12_cls_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.user_group_id,chr(13),''),chr(10),'') as user_group_id
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,t.create_tm as create_tm
,t.update_tm as update_tm
,t.grace_period_exp_dt as grace_period_exp_dt
,t.grace_period_days as grace_period_days
,t.grace_period_start_dt as grace_period_start_dt
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_wl_dubil_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_dubil_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes