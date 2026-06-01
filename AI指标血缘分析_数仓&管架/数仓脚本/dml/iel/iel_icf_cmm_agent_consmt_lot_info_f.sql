: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_agent_consmt_lot_info_f
CreateDate: 20230817
FileName:   ${iel_data_path}/cmm_agent_consmt_lot_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.consmt_bus_type_cd,chr(13),''),chr(10),'') as consmt_bus_type_cd
,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.lot_type_cd,chr(13),''),chr(10),'') as lot_type_cd
,fir_subscr_dt
,final_activ_acct_dt
,divd_ratio
,yld_rat
,acm_prft
,unpaid_prft
,froz_unpaid_prft
,curr_issue_prft
,td_prft
,tran_froz_lot
,lonterm_froz_lot
,loc_froz_lot
,ld_tot_lot
,uncfm_prod_amt
,redem_amt
,buy_cost
,tot_lot
,nv
,curr_bal
,ear_d_bal
,ear_m_bal
,ear_s_bal
,ear_y_bal
,y_acm_bal
,s_acm_bal
,m_acm_bal
,y_avg_bal
,q_avg_bal
,m_avg_bal
,actl_value_dt
,actl_exp_dt
,replace(replace(t1.comb_sell_flag,chr(13),''),chr(10),'') as comb_sell_flag
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id

from ${icl_schema}.cmm_agent_consmt_lot_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_agent_consmt_lot_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
