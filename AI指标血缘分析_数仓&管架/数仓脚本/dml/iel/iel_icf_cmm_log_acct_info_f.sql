: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_log_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_log_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.log_cont_id,chr(13),''),chr(10),'') as log_cont_id
,replace(replace(t1.log_acct_num,chr(13),''),chr(10),'') as log_acct_num
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.out_acct_acct_num,chr(13),''),chr(10),'') as out_acct_acct_num
,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num
,replace(replace(t1.crdt_contr_no,chr(13),''),chr(10),'') as crdt_contr_no
,replace(replace(t1.recvbl_num,chr(13),''),chr(10),'') as recvbl_num
,replace(replace(t1.subj_cd,chr(13),''),chr(10),'') as subj_cd
,replace(replace(t1.log_kind_cd,chr(13),''),chr(10),'') as log_kind_cd
,replace(replace(t1.fin_log_flg,chr(13),''),chr(10),'') as fin_log_flg
,replace(replace(t1.overs_log_flg,chr(13),''),chr(10),'') as overs_log_flg
,replace(replace(t1.advc_flg,chr(13),''),chr(10),'') as advc_flg
,replace(replace(t1.advc_dubil_id,chr(13),''),chr(10),'') as advc_dubil_id
,replace(replace(t1.log_status,chr(13),''),chr(10),'') as log_status
,replace(replace(t1.wrtoff_way,chr(13),''),chr(10),'') as wrtoff_way
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.benefc_acct_num,chr(13),''),chr(10),'') as benefc_acct_num
,replace(replace(t1.benefc_open_bank_name,chr(13),''),chr(10),'') as benefc_open_bank_name
,replace(replace(t1.guar_org_id,chr(13),''),chr(10),'') as guar_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,t1.open_dt as open_dt
,t1.wrtoff_dt as wrtoff_dt
,t1.start_dt as start_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.open_flow,chr(13),''),chr(10),'') as open_flow
,replace(replace(t1.wrtoff_flow,chr(13),''),chr(10),'') as wrtoff_flow
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.nomal_int_rat as nomal_int_rat
,t1.ovdue_int_rat as ovdue_int_rat
,t1.advc_int_rat as advc_int_rat
,t1.comm_fee_rat as comm_fee_rat
,t1.comm_fee_amt as comm_fee_amt
,t1.compens_amt as compens_amt
,t1.advc_amt as advc_amt
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.margin_curr,chr(13),''),chr(10),'') as margin_curr
,t1.margin_ratio as margin_ratio
,t1.margin_amt as margin_amt
,t1.log_amt as log_amt
,t1.currt_bal as currt_bal
,t1.cl_curr_currt_bal as cl_curr_currt_bal
,t1.ear_d_bal as ear_d_bal
,t1.ear_m_bal as ear_m_bal
,t1.ear_s_bal as ear_s_bal
,t1.ear_y_bal as ear_y_bal
,t1.y_acm_bal as y_acm_bal
,t1.s_acm_bal as s_acm_bal
,t1.m_acm_bal as m_acm_bal
,t1.cl_curr_ear_d_bal as cl_curr_ear_d_bal
,t1.cl_curr_ear_m_bal as cl_curr_ear_m_bal
,t1.cl_curr_ear_s_bal as cl_curr_ear_s_bal
,t1.cl_curr_ear_y_bal as cl_curr_ear_y_bal
,t1.cl_curr_y_acm_bal as cl_curr_y_acm_bal
,t1.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal
,t1.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal
,t1.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal
,t1.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal
,t1.cl_curr_s_acm_bal as cl_curr_s_acm_bal
,t1.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal
,t1.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal
,t1.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal
,t1.cl_curr_m_acm_bal as cl_curr_m_acm_bal
,t1.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal
,t1.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal
,t1.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal
,t1.y_avg_bal as y_avg_bal
,t1.q_avg_bal as q_avg_bal
,t1.m_avg_bal as m_avg_bal
,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal
,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal
,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal
,replace(replace(t1.margin_sub_acct_num,chr(13),''),chr(10),'') as margin_sub_acct_num
,replace(replace(t1.benefc_cty_cd,chr(13),''),chr(10),'') as benefc_cty_cd
,replace(replace(t1.open_bk_bic,chr(13),''),chr(10),'') as open_bk_bic
,replace(replace(t1.advise_bank_bic,chr(13),''),chr(10),'') as advise_bank_bic
,replace(replace(t1.final_bnft_bk_bic,chr(13),''),chr(10),'') as final_bnft_bk_bic
,t1.tran_cmplt_tm as tran_cmplt_tm
,t1.usd_tran_amt as usd_tran_amt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
from ${icl_schema}.cmm_log_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_log_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes