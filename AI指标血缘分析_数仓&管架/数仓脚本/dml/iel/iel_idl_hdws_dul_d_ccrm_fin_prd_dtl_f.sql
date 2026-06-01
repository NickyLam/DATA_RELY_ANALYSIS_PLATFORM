: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_fin_prd_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_fin_prd_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.fin_inter_cust_nbr,chr(13),''),chr(10),'') as fin_inter_cust_nbr
,replace(replace(t1.retl_cd,chr(13),''),chr(10),'') as retl_cd
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num
,replace(replace(t1.cif_cust_nbr,chr(13),''),chr(10),'') as cif_cust_nbr
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.fin_acct_num,chr(13),''),chr(10),'') as fin_acct_num
,replace(replace(t1.fin_acct_blng_org,chr(13),''),chr(10),'') as fin_acct_blng_org
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.prd_cd,chr(13),''),chr(10),'') as prd_cd
,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t1.prft_fea_cd,chr(13),''),chr(10),'') as prft_fea_cd
,replace(replace(t1.risk_rank,chr(13),''),chr(10),'') as risk_rank
,t1.ipo_stdt as ipo_stdt
,t1.ipo_end_dt as ipo_end_dt
,t1.prd_int_start_dt as prd_int_start_dt
,t1.prd_end_dt as prd_end_dt
,t1.income_due_day as income_due_day
,t1.expt_yld as expt_yld
,t1.actl_yld as actl_yld
,t1.shr_total_qty as shr_total_qty
,t1.term_income as term_income
,t1.aggr_inco as aggr_inco
,t1.aggr_purch_amt as aggr_purch_amt
,t1.aggr_purch_shr as aggr_purch_shr
,t1.aggr_rede_shr as aggr_rede_shr
,t1.aggr_rede_amt as aggr_rede_amt
,replace(replace(t1.divi_mode_cd,chr(13),''),chr(10),'') as divi_mode_cd
,t1.balance as balance
,t1.mon_accum as mon_accum
,t1.qtr_accum as qtr_accum
,t1.year_accum as year_accum
,t1.mavg as mavg
,t1.qavg as qavg
,t1.yavg as yavg
,t1.bal_ratio_last_day as bal_ratio_last_day
,t1.bal_ratio_last_mon as bal_ratio_last_mon
,t1.bal_ratio_last_qtr as bal_ratio_last_qtr
,t1.bal_ratio_ly as bal_ratio_ly
,t1.mavg_ratio_last_day as mavg_ratio_last_day
,t1.mavg_ratio_last_mon as mavg_ratio_last_mon
,t1.mavg_ratio_last_qtr as mavg_ratio_last_qtr
,t1.mavg_ratio_ly as mavg_ratio_ly
,t1.qavg_ratio_last_day as qavg_ratio_last_day
,t1.qavg_ratio_last_mon as qavg_ratio_last_mon
,t1.qavg_ratio_last_qtr as qavg_ratio_last_qtr
,t1.qavg_ratio_ly as qavg_ratio_ly
,t1.yavg_ratio_last_day as yavg_ratio_last_day
,t1.yavg_ratio_last_mon as yavg_ratio_last_mon
,t1.yavg_ratio_last_qtr as yavg_ratio_last_qtr
,t1.yavg_ratio_ly as yavg_ratio_ly
,t1.prd_estab_dt as prd_estab_dt
,replace(replace(t1.prd_status,chr(13),''),chr(10),'') as prd_status
,replace(replace(t1.last_txn_chn,chr(13),''),chr(10),'') as last_txn_chn
,t1.highest_hold_shr as highest_hold_shr
from ${idl_schema}.hdws_dul_d_ccrm_fin_prd_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_fin_prd_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes