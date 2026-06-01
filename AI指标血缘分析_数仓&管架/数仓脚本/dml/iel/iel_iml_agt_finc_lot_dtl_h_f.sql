: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_lot_dtl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_finc_lot_dtl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,t1.cfm_dt as cfm_dt
,replace(replace(t1.lot_src_cd,chr(13),''),chr(10),'') as lot_src_cd
,t1.lot_tot as lot_tot
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,t1.unpaid_prft as unpaid_prft
,t1.froz_unpaid_prft as froz_unpaid_prft
,t1.new_assign_prft as new_assign_prft
,t1.init_cfm_amt as init_cfm_amt
,t1.init_cfm_lot as init_cfm_lot
,t1.init_corp_nv as init_corp_nv
,replace(replace(t1.init_lot_src_cd,chr(13),''),chr(10),'') as init_lot_src_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,t1.buy_cost as buy_cost
,t1.ped_finc_exp_dt as ped_finc_exp_dt
,replace(replace(t1.ped_finc_flg,chr(13),''),chr(10),'') as ped_finc_flg
from ${iml_schema}.agt_finc_lot_dtl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_lot_dtl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes