: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_finc_divd_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_divd_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t1.cfm_dt as cfm_dt
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,t1.divd_base as divd_base
,t1.corp_divd as corp_divd
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,t1.bonus_tot_amt as bonus_tot_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.actl_bonus as actl_bonus
,t1.eqty_rgst_dt as eqty_rgst_dt
,t1.divd_dt as divd_dt
,t1.ex_righ_dt as ex_righ_dt
,t1.aft_tran_lot as aft_tran_lot
from ${iml_schema}.evt_finc_divd_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_divd_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes