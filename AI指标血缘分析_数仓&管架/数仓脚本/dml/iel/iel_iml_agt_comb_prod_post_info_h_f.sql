: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_comb_prod_post_info_h_f
CreateDate: 20230817
FileName:   ${iel_data_path}/agt_comb_prod_post_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.vtual_bank_acct_id,chr(13),''),chr(10),'') as vtual_bank_acct_id
,replace(replace(t1.dtl_prod_id,chr(13),''),chr(10),'') as dtl_prod_id
,imp_dt
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,tot_lot
,froz_lot
,lonterm_froz_lot
,loc_froz_lot
,comb_invest_lot
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd
,divd_ratio
,yd_tot_lot
,tot_amt
,pric
,curr_aval_lmt
,prod_mk_val
,acm_inco
,cap
,float_prft_loss
,unpaid_prft
,froz_unpaid_prft
,td_add_unpaid_prft
,prft_dt

from ${iml_schema}.agt_comb_prod_post_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_comb_prod_post_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
