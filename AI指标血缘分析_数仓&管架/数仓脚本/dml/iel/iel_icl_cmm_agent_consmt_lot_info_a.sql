: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_agent_consmt_lot_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_agent_consmt_lot_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t.consmt_bus_type_cd,chr(13),''),chr(10),'') as consmt_bus_type_cd
,replace(replace(t.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.lot_type_cd,chr(13),''),chr(10),'') as lot_type_cd
,t.fir_subscr_dt as fir_subscr_dt
,t.final_activ_acct_dt as final_activ_acct_dt
,t.divd_ratio as divd_ratio
,t.yld_rat as yld_rat
,t.acm_prft as acm_prft
,t.unpaid_prft as unpaid_prft
,t.froz_unpaid_prft as froz_unpaid_prft
,t.curr_issue_prft as curr_issue_prft
,t.td_prft as td_prft
,t.tran_froz_lot as tran_froz_lot
,t.lonterm_froz_lot as lonterm_froz_lot
,t.loc_froz_lot as loc_froz_lot
,t.ld_tot_lot as ld_tot_lot
,t.uncfm_prod_amt as uncfm_prod_amt
,t.redem_amt as redem_amt
,t.buy_cost as buy_cost
,t.tot_lot as tot_lot
,t.nv as nv
,t.curr_bal as curr_bal
,t.ear_d_bal as ear_d_bal
,t.ear_m_bal as ear_m_bal
,t.ear_s_bal as ear_s_bal
,t.ear_y_bal as ear_y_bal
,t.y_acm_bal as y_acm_bal
,t.s_acm_bal as s_acm_bal
,t.m_acm_bal as m_acm_bal
,t.y_avg_bal as y_avg_bal
,t.q_avg_bal as q_avg_bal
,t.m_avg_bal as m_avg_bal
from icl.cmm_agent_consmt_lot_info t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_agent_consmt_lot_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes