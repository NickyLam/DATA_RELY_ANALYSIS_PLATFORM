: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_lot_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_finc_lot_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.bank_cust_id,chr(13),''),chr(10),'') as bank_cust_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t.tran_med,chr(13),''),chr(10),'') as tran_med
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,t.final_tran_dt as final_tran_dt
,t.lot_tot as lot_tot
,t.froz_lot as froz_lot
,t.lonterm_froz_lot as lonterm_froz_lot
,replace(replace(t.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd
,replace(replace(t.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
,replace(replace(t.supp_invest_flg,chr(13),''),chr(10),'') as supp_invest_flg
,t.buy_cost_amt as buy_cost_amt
,t.acm_inco_amt as acm_inco_amt
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_finc_lot_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_lot_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes