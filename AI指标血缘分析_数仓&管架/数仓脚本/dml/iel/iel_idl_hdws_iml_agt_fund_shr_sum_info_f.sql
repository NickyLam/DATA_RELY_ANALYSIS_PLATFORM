: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_fund_shr_sum_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_fund_shr_sum_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.fund_prd_id,chr(13),''),chr(10),'') as fund_prd_id
,replace(replace(t1.ta_acct_num,chr(13),''),chr(10),'') as ta_acct_num
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,t1.last_fund_shr as last_fund_shr
,t1.intraday_chg_shr as intraday_chg_shr
,t1.sale_sys_txn_intraday_chg_shr as sale_sys_txn_intraday_chg_shr
,t1.last_txn_frozen_shr as last_txn_frozen_shr
,t1.intraday_txn_frozen_shr as intraday_txn_frozen_shr
,t1.purch_txn_cfm_day_frozen_shr as purch_txn_cfm_day_frozen_shr
,t1.sale_sys_txn_frozen_shr as sale_sys_txn_frozen_shr
,t1.sale_sys_liqdt_interim_txn_fro as sale_sys_liqdt_interim_txn_fro
,t1.last_abnormal_frozen_shr as last_abnormal_frozen_shr
,t1.intraday_abnormal_frozen_shr as intraday_abnormal_frozen_shr
,t1.sale_sys_abnormal_frozen_shr as sale_sys_abnormal_frozen_shr
,t1.buy_cost as buy_cost
,t1.redeem_amt as redeem_amt
,t1.cost_amt as cost_amt
,t1.unpaid_income as unpaid_income
,t1.cash_unpaid_income as cash_unpaid_income
,t1.cash_shr as cash_shr
,t1.frozen_unpaid_income as frozen_unpaid_income
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,NVL2(t1.data_src_cd,'AGT_FUND_SHR_SUM_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_FUND_SHR_SUM_INFO') as etl_task_name
from ${idl_schema}.hdws_iml_agt_fund_shr_sum_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_fund_shr_sum_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes