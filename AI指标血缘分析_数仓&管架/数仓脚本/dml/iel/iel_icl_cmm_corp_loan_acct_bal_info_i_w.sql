: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_acct_bal_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_acct_bal_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.dubil_num,chr(13),''),chr(10),'') as dubil_num
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd
,t.dubil_amt as dubil_amt
,t.nomal_pric as nomal_pric
,t.ovdue_pric as ovdue_pric
,t.idle_pric as idle_pric
,t.bad_debt_pric as bad_debt_pric
,t.wrt_off_pric as wrt_off_pric
,t.wrt_off_int as wrt_off_int
,t.in_bs_int as in_bs_int
,t.off_bs_int as off_bs_int
,t.pric_bal as pric_bal
,t.currt_bal as currt_bal
,t.cl_curr_currt_bal as cl_curr_currt_bal
,t.ear_d_bal as ear_d_bal
,t.ear_m_bal as ear_m_bal
,t.ear_s_bal as ear_s_bal
,t.ear_y_bal as ear_y_bal
,t.y_acm_bal as y_acm_bal
,t.s_acm_bal as s_acm_bal
,t.m_acm_bal as m_acm_bal
,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal
,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal
,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal
,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal
,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal
,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal
,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal
,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal
,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal
,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal
,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal
,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal
,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal
,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal
,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal
,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal
,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal
,t.y_avg_bal as y_avg_bal
,t.q_avg_bal as q_avg_bal
,t.m_avg_bal as m_avg_bal
,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal
,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal
,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal
,t.nomal_pric_y_acm_bal as nomal_pric_y_acm_bal
,t.nomal_pric_s_acm_bal as nomal_pric_s_acm_bal
,t.nomal_pric_m_acm_bal as nomal_pric_m_acm_bal
,t.nomal_pric_cl_curr_y_acm_bal as nomal_pric_cl_curr_y_acm_bal
,t.nomal_pric_cl_curr_s_acm_bal as nomal_pric_cl_curr_s_acm_bal
,t.nomal_pric_cl_curr_m_acm_bal as nomal_pric_cl_curr_m_acm_bal
,t.nomal_pric_y_avg_bal as nomal_pric_y_avg_bal
,t.nomal_pric_q_avg_bal as nomal_pric_q_avg_bal
,t.nomal_pric_m_avg_bal as nomal_pric_m_avg_bal
,t.nomal_pric_cl_curr_y_avg_bal as nomal_pric_cl_curr_y_avg_bal
,t.nomal_pric_cl_curr_q_avg_bal as nomal_pric_cl_curr_q_avg_bal
,t.nomal_pric_cl_curr_m_avg_bal as nomal_pric_cl_curr_m_avg_bal
,t.ovdue_pric_y_acm_bal as ovdue_pric_y_acm_bal
,t.ovdue_pric_s_acm_bal as ovdue_pric_s_acm_bal
,t.ovdue_pric_m_acm_bal as ovdue_pric_m_acm_bal
,t.ovdue_pric_cl_curr_y_acm_bal as ovdue_pric_cl_curr_y_acm_bal
,t.ovdue_pric_cl_curr_s_acm_bal as ovdue_pric_cl_curr_s_acm_bal
,t.ovdue_pric_cl_curr_m_acm_bal as ovdue_pric_cl_curr_m_acm_bal
,t.ovdue_pric_y_avg_bal as ovdue_pric_y_avg_bal
,t.ovdue_pric_q_avg_bal as ovdue_pric_q_avg_bal
,t.ovdue_pric_m_avg_bal as ovdue_pric_m_avg_bal
,t.ovdue_pric_cl_curr_y_avg_bal as ovdue_pric_cl_curr_y_avg_bal
,t.ovdue_pric_cl_curr_q_avg_bal as ovdue_pric_cl_curr_q_avg_bal
,t.ovdue_pric_cl_curr_m_avg_bal as ovdue_pric_cl_curr_m_avg_bal
,t.idle_pric_y_acm_bal as idle_pric_y_acm_bal
,t.idle_pric_s_acm_bal as idle_pric_s_acm_bal
,t.idle_pric_m_acm_bal as idle_pric_m_acm_bal
,t.idle_pric_cl_curr_y_acm_bal as idle_pric_cl_curr_y_acm_bal
,t.idle_pric_cl_curr_s_acm_bal as idle_pric_cl_curr_s_acm_bal
,t.idle_pric_cl_curr_m_acm_bal as idle_pric_cl_curr_m_acm_bal
,t.idle_pric_y_avg_bal as idle_pric_y_avg_bal
,t.idle_pric_q_avg_bal as idle_pric_q_avg_bal
,t.idle_pric_m_avg_bal as idle_pric_m_avg_bal
,t.idle_pric_dc_y_avg_bal as idle_pric_dc_y_avg_bal
,t.idle_pric_dc_q_avg_bal as idle_pric_dc_q_avg_bal
,t.idle_pric_dc_m_avg_bal as idle_pric_dc_m_avg_bal
,t.bad_debt_pric_y_acm_bal as bad_debt_pric_y_acm_bal
,t.bad_debt_pric_s_acm_bal as bad_debt_pric_s_acm_bal
,t.bad_debt_pric_m_acm_bal as bad_debt_pric_m_acm_bal
,t.bad_debt_cl_curr_y_acm_bal as bad_debt_cl_curr_y_acm_bal
,t.bad_debt_cl_curr_s_acm_bal as bad_debt_cl_curr_s_acm_bal
,t.bad_debt_cl_curr_m_acm_bal as bad_debt_cl_curr_m_acm_bal
,t.bad_debt_pric_y_avg_bal as bad_debt_pric_y_avg_bal
,t.bad_debt_pric_q_avg_bal as bad_debt_pric_q_avg_bal
,t.bad_debt_pric_m_avg_bal as bad_debt_pric_m_avg_bal
,t.bad_debt_pric_dc_y_avg_bal as bad_debt_pric_dc_y_avg_bal
,t.bad_debt_pric_dc_q_avg_bal as bad_debt_pric_dc_q_avg_bal
,t.bad_debt_pric_dc_m_avg_bal as bad_debt_pric_dc_m_avg_bal
,t.in_bs_int_y_acm_bal as in_bs_int_y_acm_bal
,t.in_bs_int_s_acm_bal as in_bs_int_s_acm_bal
,t.in_bs_int_m_acm_bal as in_bs_int_m_acm_bal
,t.in_bs_int_cl_curr_y_acm_bal as in_bs_int_cl_curr_y_acm_bal
,t.in_bs_int_cl_curr_s_acm_bal as in_bs_int_cl_curr_s_acm_bal
,t.in_bs_int_cl_curr_m_acm_bal as in_bs_int_cl_curr_m_acm_bal
,t.in_bs_int_y_avg_bal as in_bs_int_y_avg_bal
,t.in_bs_int_q_avg_bal as in_bs_int_q_avg_bal
,t.in_bs_int_m_avg_bal as in_bs_int_m_avg_bal
,t.in_bs_int_dc_y_avg_bal as in_bs_int_dc_y_avg_bal
,t.in_bs_int_dc_q_avg_bal as in_bs_int_dc_q_avg_bal
,t.in_bs_int_dc_m_avg_bal as in_bs_int_dc_m_avg_bal
,t.off_bs_int_y_acm_bal as off_bs_int_y_acm_bal
,t.off_bs_int_s_acm_bal as off_bs_int_s_acm_bal
,t.off_bs_int_m_acm_bal as off_bs_int_m_acm_bal
,t.off_bs_int_cl_curr_y_acm_bal as off_bs_int_cl_curr_y_acm_bal
,t.off_bs_int_cl_curr_s_acm_bal as off_bs_int_cl_curr_s_acm_bal
,t.off_bs_int_cl_curr_m_acm_bal as off_bs_int_cl_curr_m_acm_bal
,t.off_bs_int_y_avg_bal as off_bs_int_y_avg_bal
,t.off_bs_int_q_avg_bal as off_bs_int_q_avg_bal
,t.off_bs_int_m_avg_bal as off_bs_int_m_avg_bal
,t.off_bs_int_dc_y_avg_bal as off_bs_int_dc_y_avg_bal
,t.off_bs_int_dc_q_avg_bal as off_bs_int_dc_q_avg_bal
,t.off_bs_int_dc_m_avg_bal as off_bs_int_dc_m_avg_bal
from ${icl_schema}.cmm_corp_loan_acct_bal_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_acct_bal_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes