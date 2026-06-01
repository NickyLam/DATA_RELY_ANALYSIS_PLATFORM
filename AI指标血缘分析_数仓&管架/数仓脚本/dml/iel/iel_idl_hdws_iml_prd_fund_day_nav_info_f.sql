: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_prd_fund_day_nav_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_prd_fund_day_nav_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.fund_prd_id,chr(13),''),chr(10),'') as fund_prd_id
,replace(replace(t1.ta_acct_num,chr(13),''),chr(10),'') as ta_acct_num
,t1.etl_dt as etl_dt
,t1.nav_dt as nav_dt
,t1.last_update_dt as last_update_dt
,t1.intraday_fund_total_shr as intraday_fund_total_shr
,t1.intraday_total_amt as intraday_total_amt
,t1.intraday_fund_nav as intraday_fund_nav
,t1.aggr_nav as aggr_nav
,t1.aggr_fund_unit_nav as aggr_fund_unit_nav
,t1.break_even_nav as break_even_nav
,t1.break_even_due_day as break_even_due_day
,t1.ccy_fund_intraday_income as ccy_fund_intraday_income
,t1.ccy_fund_unit_yld as ccy_fund_unit_yld
,t1.ccy_fund_7days_annu_return_rat as ccy_fund_7days_annu_return_rat
,t1.sale_srv_fee as sale_srv_fee
,replace(replace(t1.fund_status_cd,chr(13),''),chr(10),'') as fund_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,NVL2(t1.data_src_cd,'PRD_FUND_DAY_NAV_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PRD_FUND_DAY_NAV_INFO') as etl_task_name
from ${idl_schema}.hdws_iml_prd_fund_day_nav_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_prd_fund_day_nav_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes