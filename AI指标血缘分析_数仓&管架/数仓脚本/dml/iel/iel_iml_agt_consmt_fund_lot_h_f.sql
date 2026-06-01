: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_consmt_fund_lot_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_consmt_fund_lot_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,final_chg_dt
,lot_tot
,tran_froz_lot
,lonterm_froz_lot
,comb_invest_lot
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd
,bonus_ratio
,yd_lot_tot
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.supp_invest_flg,chr(13),''),chr(10),'') as supp_invest_flg
,loc_froz_lot
,curr_issue_prft
,prft_cust_ratio
,buy_cost
,acm_inco
,unpaid_prft
,froz_unpaid_prft
,new_assign_prft

from ${iml_schema}.agt_consmt_fund_lot_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_consmt_fund_lot_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
