: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_finc_lot_dtl_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_finc_lot_dtl_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.seller_id as seller_id
,t1.prod_id as prod_id
,t1.ta_cfm_flow_num as ta_cfm_flow_num
,t1.finc_cust_id as finc_cust_id
,t1.cust_id as cust_id
,t1.ta_tran_acct_id as ta_tran_acct_id
,t1.ec_idf_cd as ec_idf_cd
,t1.ta_cd as ta_cd
,t1.finc_acct_id as finc_acct_id
,t1.appl_flow_num as appl_flow_num
,t1.cfm_dt as cfm_dt
,t1.lot_src_cd as lot_src_cd
,t1.lot_tot as lot_tot
,t1.divd_way_cd as divd_way_cd
,t1.init_divd_way_cd as init_divd_way_cd
,t1.belong_org_id as belong_org_id
,t1.cust_type_cd as cust_type_cd
,t1.unpaid_prft as unpaid_prft
,t1.froz_unpaid_prft as froz_unpaid_prft
,t1.new_assign_prft as new_assign_prft
,t1.init_cfm_amt as init_cfm_amt
,t1.init_cfm_lot as init_cfm_lot
,t1.init_corp_nv as init_corp_nv
,t1.init_lot_src_cd as init_lot_src_cd
,t1.tran_chn_cd as tran_chn_cd
,t1.cust_grouping_cd as cust_grouping_cd
,t1.bank_acct_id as bank_acct_id
,t1.tran_med_type_cd as tran_med_type_cd
,t1.tran_med_id as tran_med_id
,t1.cont_id as cont_id
,t1.buy_cost as buy_cost
,t1.ped_finc_exp_dt as ped_finc_exp_dt
,t1.ped_finc_flg as ped_finc_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_finc_lot_dtl_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_finc_lot_dtl_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
