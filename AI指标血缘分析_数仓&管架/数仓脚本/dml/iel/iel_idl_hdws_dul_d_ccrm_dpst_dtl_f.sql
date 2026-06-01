: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_dpst_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_dpst_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.acct_num_name,chr(13),''),chr(10),'') as acct_num_name
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,t1.open_dt as open_dt
,t1.int_start_dt as int_start_dt
,t1.open_amt as open_amt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,t1.curr_bal as curr_bal
,t1.mavg as mavg
,t1.yavg as yavg
,t1.qavg as qavg
,t1.mon_accum as mon_accum
,t1.qtr_accum as qtr_accum
,t1.year_accum as year_accum
,t1.bal_ratio_last_mon as bal_ratio_last_mon
,t1.bal_ratio_last_qtr as bal_ratio_last_qtr
,t1.bal_ratio_ly as bal_ratio_ly
,t1.mavg_ratio_last_day as mavg_ratio_last_day
,t1.mavg_ratio_last_mon as mavg_ratio_last_mon
,t1.mavg_ratio_last_qtr as mavg_ratio_last_qtr
,t1.mavg_ratio_ly as mavg_ratio_ly
,t1.qavg_ratio_last_mon as qavg_ratio_last_mon
,t1.qavg_ratio_last_qtr as qavg_ratio_last_qtr
,t1.qavg_ratio_ly as qavg_ratio_ly
,t1.yavg_ratio_last_mon as yavg_ratio_last_mon
,t1.yavg_ratio_last_qtr as yavg_ratio_last_qtr
,t1.yavg_ratio_ly as yavg_ratio_ly
,t1.into_rmb_bal as into_rmb_bal
,t1.into_rmb_mavg as into_rmb_mavg
,t1.into_rmb_qavg as into_rmb_qavg
,t1.into_rmb_yavg as into_rmb_yavg
,t1.into_rmb_mon_accum as into_rmb_mon_accum
,t1.into_rmb_qtr_accum as into_rmb_qtr_accum
,t1.into_rmb_year_accum as into_rmb_year_accum
,t1.into_rmb_bal_ratio_last_day as into_rmb_bal_ratio_last_day
,t1.into_rmb_bal_ratio_last_mon as into_rmb_bal_ratio_last_mon
,t1.into_rmb_bal_ratio_last_qtr as into_rmb_bal_ratio_last_qtr
,t1.into_rmb_bal_ratio_ly as into_rmb_bal_ratio_ly
,t1.into_rmb_mavg_ratio_last_day as into_rmb_mavg_ratio_last_day
,t1.into_rmb_mavg_ratio_last_mon as into_rmb_mavg_ratio_last_mon
,t1.into_rmb_mavg_ratio_last_qtr as into_rmb_mavg_ratio_last_qtr
,t1.into_rmb_mavg_ratio_ly as into_rmb_mavg_ratio_ly
,t1.into_rmb_qavg_ratio_last_day as into_rmb_qavg_ratio_last_day
,t1.into_rmb_qavg_ratio_last_mon as into_rmb_qavg_ratio_last_mon
,t1.into_rmb_qavg_ratio_last_qtr as into_rmb_qavg_ratio_last_qtr
,t1.into_rmb_qavg_ratio_ly as into_rmb_qavg_ratio_ly
,t1.into_rmb_yavg_ratio_last_day as into_rmb_yavg_ratio_last_day
,t1.into_rmb_yavg_ratio_last_mon as into_rmb_yavg_ratio_last_mon
,t1.into_rmb_yavg_ratio_last_qtr as into_rmb_yavg_ratio_last_qtr
,t1.into_rmb_yavg_ratio_ly as into_rmb_yavg_ratio_ly
,replace(replace(t1.peri_units_cd,chr(13),''),chr(10),'') as peri_units_cd
,t1.peri as peri
,t1.exec_rate as exec_rate
,t1.base_rate as base_rate
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,t1.due_dt as due_dt
,t1.colse_dt as colse_dt
,t1.final_trx_dt as final_trx_dt
,replace(replace(t1.org_encd,chr(13),''),chr(10),'') as org_encd
,replace(replace(t1.coa_encd,chr(13),''),chr(10),'') as coa_encd
,replace(replace(t1.guar_mode,chr(13),''),chr(10),'') as guar_mode
,t1.crdt_dt as crdt_dt
,t1.crdt_due_day as crdt_due_day
from ${idl_schema}.hdws_dul_d_ccrm_dpst_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_dpst_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes