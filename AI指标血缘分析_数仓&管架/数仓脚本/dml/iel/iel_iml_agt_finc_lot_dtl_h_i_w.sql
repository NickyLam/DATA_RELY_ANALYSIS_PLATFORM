: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_lot_dtl_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_finc_lot_dtl_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,t.cfm_dt as cfm_dt
,replace(replace(t.lot_src_cd,chr(13),''),chr(10),'') as lot_src_cd
,t.lot_tot as lot_tot
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,t.unpaid_prft as unpaid_prft
,t.froz_unpaid_prft as froz_unpaid_prft
,t.new_assign_prft as new_assign_prft
,t.init_cfm_amt as init_cfm_amt
,t.init_cfm_lot as init_cfm_lot
,t.init_corp_nv as init_corp_nv
,replace(replace(t.init_lot_src_cd,chr(13),''),chr(10),'') as init_lot_src_cd
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,t.buy_cost as buy_cost
,t.ped_finc_exp_dt as ped_finc_exp_dt
,replace(replace(t.ped_finc_flg,chr(13),''),chr(10),'') as ped_finc_flg
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_finc_lot_dtl_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_lot_dtl_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes