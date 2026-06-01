: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_divd_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_divd_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t.cfm_dt as cfm_dt
,replace(replace(t.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,t.divd_base as divd_base
,t.corp_divd as corp_divd
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,t.bonus_tot_amt as bonus_tot_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.actl_bonus as actl_bonus
,t.eqty_rgst_dt as eqty_rgst_dt
,t.divd_dt as divd_dt
,t.ex_righ_dt as ex_righ_dt
,t.aft_tran_lot as aft_tran_lot
from ${iml_schema}.evt_finc_divd_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_divd_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes