: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_finc_lot_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_finc_lot_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.intnal_cust_id as intnal_cust_id
,t1.seller_cd as seller_cd
,t1.bank_id as bank_id
,t1.bank_cust_id as bank_cust_id
,t1.bank_acct_id as bank_acct_id
,t1.ta_tran_acct_id as ta_tran_acct_id
,t1.ec_flg as ec_flg
,t1.tran_med_type_cd as tran_med_type_cd
,t1.tran_med as tran_med
,t1.ta_cd as ta_cd
,t1.finc_acct_id as finc_acct_id
,t1.prod_id as prod_id
,t1.std_prod_id as std_prod_id
,t1.cont_id as cont_id
,t1.final_tran_dt as final_tran_dt
,t1.lot_tot as lot_tot
,t1.froz_lot as froz_lot
,t1.lonterm_froz_lot as lonterm_froz_lot
,t1.deflt_divd_way_cd as deflt_divd_way_cd
,t1.init_divd_way_cd as init_divd_way_cd
,t1.tran_belong_org_id as tran_belong_org_id
,t1.supp_invest_flg as supp_invest_flg
,t1.buy_cost_amt as buy_cost_amt
,t1.acm_inco_amt as acm_inco_amt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.comb_invest_lot as comb_invest_lot
,t1.loc_froz_lot as loc_froz_lot
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_finc_lot_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_finc_lot_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
