: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_distr_finc_tran_cfm_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_distr_finc_tran_cfm_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.cfm_dt as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd 
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num 
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num 
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id 
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id 
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id 
,t1.cfm_dt as cfm_dt 
,t1.appl_dt as appl_dt 
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id 
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id 
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id 
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id 
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd 
,t1.cfm_amt as cfm_amt 
,t1.cfm_lot as cfm_lot 
,t1.prod_nv as prod_nv 
,t1.cfm_froz_amt as cfm_froz_amt 
,t1.cfm_unfrz_amt as cfm_unfrz_amt 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id 
,t1.invest_prft as invest_prft 
,t1.unpaid_prft as unpaid_prft 
,t1.bank_prft as bank_prft 
,t1.appl_amt as appl_amt 
,t1.appl_lot as appl_lot 
,t1.tran_post_lot as tran_post_lot 
,replace(replace(t1.ta_init_flg,chr(13),''),chr(10),'') as ta_init_flg 
,replace(replace(t1.proc_sucs_flg,chr(13),''),chr(10),'') as proc_sucs_flg 
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code 
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info 
from iml.evt_distr_finc_tran_cfm_dtl t1 
where t1.cfm_dt >= to_date('20201201','yyyymmdd') and t1.cfm_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_distr_finc_tran_cfm_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes