: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_finc_tran_cfm_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_tran_cfm_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dtl_cfm_flow_num,chr(13),''),chr(10),'') as dtl_cfm_flow_num
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,t1.cfm_dt as cfm_dt
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,t1.appl_dt as appl_dt
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,t1.init_lot_cfm_dt as init_lot_cfm_dt
,replace(replace(t1.init_lot_cfm_flow_num,chr(13),''),chr(10),'') as init_lot_cfm_flow_num
,t1.cfm_amt as cfm_amt
,t1.cfm_lot as cfm_lot
,t1.invest_prft as invest_prft
from ${iml_schema}.evt_finc_tran_cfm_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_cfm_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes