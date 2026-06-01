/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_gl_acct_bal_glmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_gl_acct_bal_glmsi1_tm purge;
alter table ${iml_schema}.fin_gl_acct_bal add partition p_glmsi1 values ('glmsi1')(
        subpartition p_glmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_gl_acct_bal modify partition p_glmsi1
    add subpartition p_glmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_gl_acct_bal_glmsi1_tm
compress ${option_switch} for query high
as
select
    acct_set_id -- 账套编号
    ,lp_id -- 法人编号
    ,acct_dt -- 账务日期
    ,acct_duran -- 账务期间
    ,subj_comb_id -- 科目组合编号
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,duty_center_id -- 责任中心编号
    ,subj_id -- 科目编号
    ,budget_subj_id -- 预算科目编号
    ,strip_line_id -- 条线编号
    ,prod_id -- 产品编号
    ,yd_oc_dr_bal -- 昨日原币借方余额
    ,yd_oc_cr_bal -- 昨日原币贷方余额
    ,yd_dc_dr_bal -- 昨日本币借方余额
    ,yd_dc_cr_bal -- 昨日本币贷方余额
    ,yd_usd_dr_bal -- 昨日美元借方余额
    ,yd_usd_cr_bal -- 昨日美元贷方余额
    ,yd_oc_rept_dr_bal -- 昨日原币报表借方余额
    ,yd_oc_rept_cr_bal -- 昨日原币报表贷方余额
    ,yd_dc_rept_dr_bal -- 昨日本币报表借方余额
    ,yd_dc_rept_cr_bal -- 昨日本币报表贷方余额
    ,yd_usd_rept_dr_bal -- 昨日美元报表借方余额
    ,yd_usd_rept_cr_bal -- 昨日美元报表贷方余额
    ,td_oc_dr_amt -- 本日原币借方发生额
    ,td_oc_cr_amt -- 本日原币贷方发生额
    ,td_dc_dr_amt -- 本日本币借方发生额
    ,td_dc_cr_amt -- 本日本币贷方发生额
    ,td_usd_dr_amt -- 本日美元借方发生额
    ,td_usd_cr_amt -- 本日美元贷方发生额
    ,td_oc_dr_bal -- 本日原币借方余额
    ,td_oc_cr_bal -- 本日原币贷方余额
    ,td_dc_dr_bal -- 本日本币借方余额
    ,td_dc_cr_bal -- 本日本币贷方余额
    ,td_usd_dr_bal -- 本日美元借方余额
    ,td_usd_cr_bal -- 本日美元贷方余额
    ,td_oc_rept_dr_bal -- 本日原币报表借方余额
    ,td_oc_rept_cr_bal -- 本日原币报表贷方余额
    ,td_dc_rept_dr_bal -- 本日本币报表借方余额
    ,td_dc_rept_cr_bal -- 本日本币报表贷方余额
    ,td_usd_rept_dr_bal -- 本日美元报表借方余额
    ,td_usd_rept_cr_bal -- 本日美元报表贷方余额
    ,ten_dys_bg_dr_oc_bal -- 旬期初借方原币余额
    ,ten_dys_bg_cr_oc_bal -- 旬期初贷方原币余额
    ,ten_dys_bg_dr_dc_bal -- 旬期初借方本币余额
    ,ten_dys_bg_cr_dc_bal -- 旬期初贷方本币余额
    ,ten_dys_bg_dr_usd_bal -- 旬期初借方美元余额
    ,ten_dys_bg_cr_usd_bal -- 旬期初贷方美元余额
    ,mon_tm_bg_dr_oc_bal -- 月期初借方原币余额
    ,mon_tm_bg_cr_oc_bal -- 月期初贷方原币余额
    ,mon_tm_bg_dr_dc_bal -- 月期初借方本币余额
    ,mon_tm_bg_cr_dc_bal -- 月期初贷方本币余额
    ,mon_tm_bg_dr_usd_bal -- 月期初借方美元余额
    ,mon_tm_bg_cr_usd_bal -- 月期初贷方美元余额
    ,mon_tm_bg_dr_rept_oc_bal -- 月期初借方报表原币余额
    ,mon_tm_bg_cr_rept_oc_bal -- 月期初贷方报表原币余额
    ,mon_tm_bg_dr_rept_dc_bal -- 月期初借方报表本币余额
    ,mon_tm_bg_cr_rept_dc_bal -- 月期初贷方报表本币余额
    ,mon_tm_bg_dr_rept_usd_bal -- 月期初借方报表美元余额
    ,mon_tm_bg_cr_rept_usd_bal -- 月期初贷方报表美元余额
    ,th_mon_oc_dr_amt -- 本月原币借方发生额
    ,th_mon_oc_cr_amt -- 本月原币贷方发生额
    ,th_mon_dc_dr_amt -- 本月本币借方发生额
    ,th_mon_dc_cr_amt -- 本月本币贷方发生额
    ,th_mon_usd_dr_amt -- 本月美元借方发生额
    ,th_mon_usd_cr_amt -- 本月美元贷方发生额
    ,ssn_tm_bg_dr_oc_bal -- 季期初借方原币余额
    ,ssn_tm_bg_cr_oc_bal -- 季期初贷方原币余额
    ,ssn_tm_bg_dr_dc_bal -- 季期初借方本币余额
    ,ssn_tm_bg_cr_dc_bal -- 季期初贷方本币余额
    ,ssn_tm_bg_dr_usd_bal -- 季期初借方美元余额
    ,ssn_tm_bg_cr_usd_bal -- 季期初贷方美元余额
    ,ssn_tm_bg_dr_rept_oc_bal -- 季期初借方报表原币余额
    ,ssn_tm_bg_cr_rept_oc_bal -- 季期初贷方报表原币余额
    ,ssn_tm_bg_dr_rept_dc_bal -- 季期初借方报表本币余额
    ,ssn_tm_bg_cr_rept_dc_bal -- 季期初贷方报表本币余额
    ,ssn_tm_bg_dr_rept_usd_bal -- 季期初借方报表美元余额
    ,ssn_tm_bg_cr_rept_usd_bal -- 季期初贷方报表美元余额
    ,th_quar_oc_dr_amt -- 本季原币借方发生额
    ,th_quar_oc_cr_amt -- 本季原币贷方发生额
    ,th_quar_dc_dr_amt -- 本季本币借方发生额
    ,th_quar_dc_cr_amt -- 本季本币贷方发生额
    ,th_quar_usd_dr_amt -- 本季美元借方发生额
    ,th_quar_usd_cr_amt -- 本季美元贷方发生额
    ,half_y_tm_bg_dr_oc_bal -- 半年期初借方原币余额
    ,half_y_tm_bg_cr_oc_bal -- 半年期初贷方原币余额
    ,half_y_tm_bg_dr_dc_bal -- 半年期初借方本币余额
    ,half_y_tm_bg_cr_dc_bal -- 半年期初贷方本币余额
    ,half_y_tm_bg_dr_usd_bal -- 半年期初借方美元余额
    ,half_y_tm_bg_cr_usd_bal -- 半年期初贷方美元余额
    ,half_y_tm_bg_dr_rept_oc_bal -- 半年期初借方报表原币余额
    ,half_y_tm_bg_cr_rept_oc_bal -- 半年期初贷方报表原币余额
    ,half_y_tm_bg_dr_rept_dc_bal -- 半年期初借方报表本币余额
    ,half_y_tm_bg_cr_rept_dc_bal -- 半年期初贷方报表本币余额
    ,half_y_tm_bg_dr_rept_usd_bal -- 半年期初借方报表美元余额
    ,half_y_tm_bg_cr_rept_usd_bal -- 半年期初贷方报表美元余额
    ,half_y_oc_dr_amt -- 半年原币借方发生额
    ,half_y_oc_cr_amt -- 半年原币贷方发生额
    ,half_y_dc_dr_amt -- 半年本币借方发生额
    ,half_y_dc_cr_amt -- 半年本币贷方发生额
    ,half_y_usd_dr_amt -- 半年美元借方发生额
    ,half_y_usd_cr_amt -- 半年美元贷方发生额
    ,year_tm_bg_dr_oc_bal -- 年期初借方原币余额
    ,year_tm_bg_cr_oc_bal -- 年期初贷方原币余额
    ,year_tm_bg_dr_dc_bal -- 年期初借方本币余额
    ,year_tm_bg_cr_dc_bal -- 年期初贷方本币余额
    ,year_tm_bg_dr_usd_bal -- 年期初借方美元余额
    ,year_tm_bg_cr_usd_bal -- 年期初贷方美元余额
    ,year_tm_bg_dr_rept_oc_bal -- 年期初借方报表原币余额
    ,year_tm_bg_cr_rept_oc_bal -- 年期初贷方报表原币余额
    ,year_tm_bg_dr_rept_dc_bal -- 年期初借方报表本币余额
    ,year_tm_bg_cr_rept_dc_bal -- 年期初贷方报表本币余额
    ,year_tm_bg_dr_rept_usd_bal -- 年期初借方报表美元余额
    ,year_tm_bg_cr_rept_usd_bal -- 年期初贷方报表美元余额
    ,th_year_oc_dr_amt -- 本年原币借方发生额
    ,th_year_oc_cr_amt -- 本年原币贷方发生额
    ,th_year_dc_dr_amt -- 本年本币借方发生额
    ,th_year_dc_cr_amt -- 本年本币贷方发生额
    ,th_year_usd_dr_amt -- 本年美元借方发生额
    ,th_year_usd_cr_amt -- 本年美元贷方发生额
    ,src_id -- 来源编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_gl_acct_bal
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- glms_cux_gl_daily_balance-
insert into ${iml_schema}.fin_gl_acct_bal_glmsi1_tm(
    acct_set_id -- 账套编号
    ,lp_id -- 法人编号
    ,acct_dt -- 账务日期
    ,acct_duran -- 账务期间
    ,subj_comb_id -- 科目组合编号
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,duty_center_id -- 责任中心编号
    ,subj_id -- 科目编号
    ,budget_subj_id -- 预算科目编号
    ,strip_line_id -- 条线编号
    ,prod_id -- 产品编号
    ,yd_oc_dr_bal -- 昨日原币借方余额
    ,yd_oc_cr_bal -- 昨日原币贷方余额
    ,yd_dc_dr_bal -- 昨日本币借方余额
    ,yd_dc_cr_bal -- 昨日本币贷方余额
    ,yd_usd_dr_bal -- 昨日美元借方余额
    ,yd_usd_cr_bal -- 昨日美元贷方余额
    ,yd_oc_rept_dr_bal -- 昨日原币报表借方余额
    ,yd_oc_rept_cr_bal -- 昨日原币报表贷方余额
    ,yd_dc_rept_dr_bal -- 昨日本币报表借方余额
    ,yd_dc_rept_cr_bal -- 昨日本币报表贷方余额
    ,yd_usd_rept_dr_bal -- 昨日美元报表借方余额
    ,yd_usd_rept_cr_bal -- 昨日美元报表贷方余额
    ,td_oc_dr_amt -- 本日原币借方发生额
    ,td_oc_cr_amt -- 本日原币贷方发生额
    ,td_dc_dr_amt -- 本日本币借方发生额
    ,td_dc_cr_amt -- 本日本币贷方发生额
    ,td_usd_dr_amt -- 本日美元借方发生额
    ,td_usd_cr_amt -- 本日美元贷方发生额
    ,td_oc_dr_bal -- 本日原币借方余额
    ,td_oc_cr_bal -- 本日原币贷方余额
    ,td_dc_dr_bal -- 本日本币借方余额
    ,td_dc_cr_bal -- 本日本币贷方余额
    ,td_usd_dr_bal -- 本日美元借方余额
    ,td_usd_cr_bal -- 本日美元贷方余额
    ,td_oc_rept_dr_bal -- 本日原币报表借方余额
    ,td_oc_rept_cr_bal -- 本日原币报表贷方余额
    ,td_dc_rept_dr_bal -- 本日本币报表借方余额
    ,td_dc_rept_cr_bal -- 本日本币报表贷方余额
    ,td_usd_rept_dr_bal -- 本日美元报表借方余额
    ,td_usd_rept_cr_bal -- 本日美元报表贷方余额
    ,ten_dys_bg_dr_oc_bal -- 旬期初借方原币余额
    ,ten_dys_bg_cr_oc_bal -- 旬期初贷方原币余额
    ,ten_dys_bg_dr_dc_bal -- 旬期初借方本币余额
    ,ten_dys_bg_cr_dc_bal -- 旬期初贷方本币余额
    ,ten_dys_bg_dr_usd_bal -- 旬期初借方美元余额
    ,ten_dys_bg_cr_usd_bal -- 旬期初贷方美元余额
    ,mon_tm_bg_dr_oc_bal -- 月期初借方原币余额
    ,mon_tm_bg_cr_oc_bal -- 月期初贷方原币余额
    ,mon_tm_bg_dr_dc_bal -- 月期初借方本币余额
    ,mon_tm_bg_cr_dc_bal -- 月期初贷方本币余额
    ,mon_tm_bg_dr_usd_bal -- 月期初借方美元余额
    ,mon_tm_bg_cr_usd_bal -- 月期初贷方美元余额
    ,mon_tm_bg_dr_rept_oc_bal -- 月期初借方报表原币余额
    ,mon_tm_bg_cr_rept_oc_bal -- 月期初贷方报表原币余额
    ,mon_tm_bg_dr_rept_dc_bal -- 月期初借方报表本币余额
    ,mon_tm_bg_cr_rept_dc_bal -- 月期初贷方报表本币余额
    ,mon_tm_bg_dr_rept_usd_bal -- 月期初借方报表美元余额
    ,mon_tm_bg_cr_rept_usd_bal -- 月期初贷方报表美元余额
    ,th_mon_oc_dr_amt -- 本月原币借方发生额
    ,th_mon_oc_cr_amt -- 本月原币贷方发生额
    ,th_mon_dc_dr_amt -- 本月本币借方发生额
    ,th_mon_dc_cr_amt -- 本月本币贷方发生额
    ,th_mon_usd_dr_amt -- 本月美元借方发生额
    ,th_mon_usd_cr_amt -- 本月美元贷方发生额
    ,ssn_tm_bg_dr_oc_bal -- 季期初借方原币余额
    ,ssn_tm_bg_cr_oc_bal -- 季期初贷方原币余额
    ,ssn_tm_bg_dr_dc_bal -- 季期初借方本币余额
    ,ssn_tm_bg_cr_dc_bal -- 季期初贷方本币余额
    ,ssn_tm_bg_dr_usd_bal -- 季期初借方美元余额
    ,ssn_tm_bg_cr_usd_bal -- 季期初贷方美元余额
    ,ssn_tm_bg_dr_rept_oc_bal -- 季期初借方报表原币余额
    ,ssn_tm_bg_cr_rept_oc_bal -- 季期初贷方报表原币余额
    ,ssn_tm_bg_dr_rept_dc_bal -- 季期初借方报表本币余额
    ,ssn_tm_bg_cr_rept_dc_bal -- 季期初贷方报表本币余额
    ,ssn_tm_bg_dr_rept_usd_bal -- 季期初借方报表美元余额
    ,ssn_tm_bg_cr_rept_usd_bal -- 季期初贷方报表美元余额
    ,th_quar_oc_dr_amt -- 本季原币借方发生额
    ,th_quar_oc_cr_amt -- 本季原币贷方发生额
    ,th_quar_dc_dr_amt -- 本季本币借方发生额
    ,th_quar_dc_cr_amt -- 本季本币贷方发生额
    ,th_quar_usd_dr_amt -- 本季美元借方发生额
    ,th_quar_usd_cr_amt -- 本季美元贷方发生额
    ,half_y_tm_bg_dr_oc_bal -- 半年期初借方原币余额
    ,half_y_tm_bg_cr_oc_bal -- 半年期初贷方原币余额
    ,half_y_tm_bg_dr_dc_bal -- 半年期初借方本币余额
    ,half_y_tm_bg_cr_dc_bal -- 半年期初贷方本币余额
    ,half_y_tm_bg_dr_usd_bal -- 半年期初借方美元余额
    ,half_y_tm_bg_cr_usd_bal -- 半年期初贷方美元余额
    ,half_y_tm_bg_dr_rept_oc_bal -- 半年期初借方报表原币余额
    ,half_y_tm_bg_cr_rept_oc_bal -- 半年期初贷方报表原币余额
    ,half_y_tm_bg_dr_rept_dc_bal -- 半年期初借方报表本币余额
    ,half_y_tm_bg_cr_rept_dc_bal -- 半年期初贷方报表本币余额
    ,half_y_tm_bg_dr_rept_usd_bal -- 半年期初借方报表美元余额
    ,half_y_tm_bg_cr_rept_usd_bal -- 半年期初贷方报表美元余额
    ,half_y_oc_dr_amt -- 半年原币借方发生额
    ,half_y_oc_cr_amt -- 半年原币贷方发生额
    ,half_y_dc_dr_amt -- 半年本币借方发生额
    ,half_y_dc_cr_amt -- 半年本币贷方发生额
    ,half_y_usd_dr_amt -- 半年美元借方发生额
    ,half_y_usd_cr_amt -- 半年美元贷方发生额
    ,year_tm_bg_dr_oc_bal -- 年期初借方原币余额
    ,year_tm_bg_cr_oc_bal -- 年期初贷方原币余额
    ,year_tm_bg_dr_dc_bal -- 年期初借方本币余额
    ,year_tm_bg_cr_dc_bal -- 年期初贷方本币余额
    ,year_tm_bg_dr_usd_bal -- 年期初借方美元余额
    ,year_tm_bg_cr_usd_bal -- 年期初贷方美元余额
    ,year_tm_bg_dr_rept_oc_bal -- 年期初借方报表原币余额
    ,year_tm_bg_cr_rept_oc_bal -- 年期初贷方报表原币余额
    ,year_tm_bg_dr_rept_dc_bal -- 年期初借方报表本币余额
    ,year_tm_bg_cr_rept_dc_bal -- 年期初贷方报表本币余额
    ,year_tm_bg_dr_rept_usd_bal -- 年期初借方报表美元余额
    ,year_tm_bg_cr_rept_usd_bal -- 年期初贷方报表美元余额
    ,th_year_oc_dr_amt -- 本年原币借方发生额
    ,th_year_oc_cr_amt -- 本年原币贷方发生额
    ,th_year_dc_dr_amt -- 本年本币借方发生额
    ,th_year_dc_cr_amt -- 本年本币贷方发生额
    ,th_year_usd_dr_amt -- 本年美元借方发生额
    ,th_year_usd_cr_amt -- 本年美元贷方发生额
    ,src_id -- 来源编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.LEDGER_ID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.TRANSACTION_DATE -- 账务日期
    ,P1.PERIOD_NAME -- 账务期间
    ,P1.CODE_COMBINATION_ID -- 科目组合编号
    ,CASE WHEN TRIM(P1.CURRENCY_CODE) IS NULL THEN 'CNY' ELSE P1.CURRENCY_CODE END -- 币种代码
    ,P1.SEGMENT1 -- 机构编号
    ,P1.SEGMENT2 -- 责任中心编号
    ,P1.SEGMENT3 -- 科目编号
    ,P1.SEGMENT4 -- 预算科目编号
    ,P1.SEGMENT5 -- 条线编号
    ,P1.SEGMENT6 -- 产品编号
    ,P1.YOD_BALANCE_DR -- 昨日原币借方余额
    ,P1.YOD_BALANCE_CR -- 昨日原币贷方余额
    ,P1.YOD_FUN_BALANCE_DR -- 昨日本币借方余额
    ,P1.YOD_FUN_BALANCE_CR -- 昨日本币贷方余额
    ,P1.YOD_USD_BALANCE_DR -- 昨日美元借方余额
    ,P1.YOD_USD_BALANCE_CR -- 昨日美元贷方余额
    ,P1.YOD_REP_BALANCE_DR -- 昨日原币报表借方余额
    ,P1.YOD_REP_BALANCE_CR -- 昨日原币报表贷方余额
    ,P1.YOD_REP_FUN_BALANCE_DR -- 昨日本币报表借方余额
    ,P1.YOD_REP_FUN_BALANCE_CR -- 昨日本币报表贷方余额
    ,P1.YOD_REP_USD_BALANCE_DR -- 昨日美元报表借方余额
    ,P1.YOD_REP_USD_BALANCE_CR -- 昨日美元报表贷方余额
    ,P1.DTD_BALANCE_DR -- 本日原币借方发生额
    ,P1.DTD_BALANCE_CR -- 本日原币贷方发生额
    ,P1.DTD_FUN_BALANCE_DR -- 本日本币借方发生额
    ,P1.DTD_FUN_BALANCE_CR -- 本日本币贷方发生额
    ,P1.DTD_USD_BALANCE_DR -- 本日美元借方发生额
    ,P1.DTD_USD_BALANCE_CR -- 本日美元贷方发生额
    ,P1.EOD_BALANCE_DR -- 本日原币借方余额
    ,P1.EOD_BALANCE_CR -- 本日原币贷方余额
    ,P1.EOD_FUN_BALANCE_DR -- 本日本币借方余额
    ,P1.EOD_FUN_BALANCE_CR -- 本日本币贷方余额
    ,P1.EOD_USD_BALANCE_DR -- 本日美元借方余额
    ,P1.EOD_USD_BALANCE_CR -- 本日美元贷方余额
    ,P1.EOD_REP_BALANCE_DR -- 本日原币报表借方余额
    ,P1.EOD_REP_BALANCE_CR -- 本日原币报表贷方余额
    ,P1.EOD_REP_FUN_BALANCE_DR -- 本日本币报表借方余额
    ,P1.EOD_REP_FUN_BALANCE_CR -- 本日本币报表贷方余额
    ,P1.EOD_REP_USD_BALANCE_DR -- 本日美元报表借方余额
    ,P1.EOD_REP_USD_BALANCE_CR -- 本日美元报表贷方余额
    ,P1.TEN_DAYS_BEGIN_DR -- 旬期初借方原币余额
    ,P1.TEN_DAYS_BEGIN_CR -- 旬期初贷方原币余额
    ,P1.TEN_DAYS_BEGIN_FUN_DR -- 旬期初借方本币余额
    ,P1.TEN_DAYS_BEGIN_FUN_CR -- 旬期初贷方本币余额
    ,P1.TEN_DAYS_BEGIN_USD_DR -- 旬期初借方美元余额
    ,P1.TEN_DAYS_BEGIN_USD_CR -- 旬期初贷方美元余额
    ,P1.MONTH_BEGIN_DR -- 月期初借方原币余额
    ,P1.MONTH_BEGIN_CR -- 月期初贷方原币余额
    ,P1.MONTH_BEGIN_FUN_DR -- 月期初借方本币余额
    ,P1.MONTH_BEGIN_FUN_CR -- 月期初贷方本币余额
    ,P1.MONTH_BEGIN_USD_DR -- 月期初借方美元余额
    ,P1.MONTH_BEGIN_USD_CR -- 月期初贷方美元余额
    ,P1.MONTH_REP_BEGIN_DR -- 月期初借方报表原币余额
    ,P1.MONTH_REP_BEGIN_CR -- 月期初贷方报表原币余额
    ,P1.MONTH_REP_BEGIN_FUN_DR -- 月期初借方报表本币余额
    ,P1.MONTH_REP_BEGIN_FUN_CR -- 月期初贷方报表本币余额
    ,P1.MONTH_REP_BEGIN_USD_DR -- 月期初借方报表美元余额
    ,P1.MONTH_REP_BEGIN_USD_CR -- 月期初贷方报表美元余额
    ,P1.MTM_BALANCE_DR -- 本月原币借方发生额
    ,P1.MTM_BALANCE_CR -- 本月原币贷方发生额
    ,P1.MTM_FUN_BALANCE_DR -- 本月本币借方发生额
    ,P1.MTM_FUN_BALANCE_CR -- 本月本币贷方发生额
    ,P1.MTM_USD_BALANCE_DR -- 本月美元借方发生额
    ,P1.MTM_USD_BALANCE_CR -- 本月美元贷方发生额
    ,P1.QUARTER_BEGIN_DR -- 季期初借方原币余额
    ,P1.QUARTER_BEGIN_CR -- 季期初贷方原币余额
    ,P1.QUARTER_BEGIN_FUN_DR -- 季期初借方本币余额
    ,P1.QUARTER_BEGIN_FUN_CR -- 季期初贷方本币余额
    ,P1.QUARTER_BEGIN_USD_DR -- 季期初借方美元余额
    ,P1.QUARTER_BEGIN_USD_CR -- 季期初贷方美元余额
    ,P1.QUARTER_REP_BEGIN_DR -- 季期初借方报表原币余额
    ,P1.QUARTER_REP_BEGIN_CR -- 季期初贷方报表原币余额
    ,P1.QUARTER_REP_BEGIN_FUN_DR -- 季期初借方报表本币余额
    ,P1.QUARTER_REP_BEGIN_FUN_CR -- 季期初贷方报表本币余额
    ,P1.QUARTER_REP_BEGIN_USD_DR -- 季期初借方报表美元余额
    ,P1.QUARTER_REP_BEGIN_USD_CR -- 季期初贷方报表美元余额
    ,P1.QTQ_BALANCE_DR -- 本季原币借方发生额
    ,P1.QTQ_BALANCE_CR -- 本季原币贷方发生额
    ,P1.QTQ_FUN_BALANCE_DR -- 本季本币借方发生额
    ,P1.QTQ_FUN_BALANCE_CR -- 本季本币贷方发生额
    ,P1.QTQ_USD_BALANCE_DR -- 本季美元借方发生额
    ,P1.QTQ_USD_BALANCE_CR -- 本季美元贷方发生额
    ,P1.HALF_YEAR_BEGIN_DR -- 半年期初借方原币余额
    ,P1.HALF_YEAR_BEGIN_CR -- 半年期初贷方原币余额
    ,P1.HALF_YEAR_BEGIN_FUN_DR -- 半年期初借方本币余额
    ,P1.HALF_YEAR_BEGIN_FUN_CR -- 半年期初贷方本币余额
    ,P1.HALF_YEAR_BEGIN_USD_DR -- 半年期初借方美元余额
    ,P1.HALF_YEAR_BEGIN_USD_CR -- 半年期初贷方美元余额
    ,P1.HALF_REP_YEAR_BEGIN_DR -- 半年期初借方报表原币余额
    ,P1.HALF_REP_YEAR_BEGIN_CR -- 半年期初贷方报表原币余额
    ,P1.HALF_REP_YEAR_BEGIN_FUN_DR -- 半年期初借方报表本币余额
    ,P1.HALF_REP_YEAR_BEGIN_FUN_CR -- 半年期初贷方报表本币余额
    ,P1.HALF_REP_YEAR_BEGIN_USD_DR -- 半年期初借方报表美元余额
    ,P1.HALF_REP_YEAR_BEGIN_USD_CR -- 半年期初贷方报表美元余额
    ,P1.HTH_BALANCE_DR -- 半年原币借方发生额
    ,P1.HTH_BALANCE_CR -- 半年原币贷方发生额
    ,P1.HTH_FUN_BALANCE_DR -- 半年本币借方发生额
    ,P1.HTH_FUN_BALANCE_CR -- 半年本币贷方发生额
    ,P1.HTH_USD_BALANCE_DR -- 半年美元借方发生额
    ,P1.HTH_USD_BALANCE_CR -- 半年美元贷方发生额
    ,P1.YEAR_BEGIN_DR -- 年期初借方原币余额
    ,P1.YEAR_BEGIN_CR -- 年期初贷方原币余额
    ,P1.YEAR_BEGIN_FUN_DR -- 年期初借方本币余额
    ,P1.YEAR_BEGIN_FUN_CR -- 年期初贷方本币余额
    ,P1.YEAR_BEGIN_USD_DR -- 年期初借方美元余额
    ,P1.YEAR_BEGIN_USD_CR -- 年期初贷方美元余额
    ,P1.YEAR_REP_BEGIN_DR -- 年期初借方报表原币余额
    ,P1.YEAR_REP_BEGIN_CR -- 年期初贷方报表原币余额
    ,P1.YEAR_REP_BEGIN_FUN_DR -- 年期初借方报表本币余额
    ,P1.YEAR_REP_BEGIN_FUN_CR -- 年期初贷方报表本币余额
    ,P1.YEAR_REP_BEGIN_USD_DR -- 年期初借方报表美元余额
    ,P1.YEAR_REP_BEGIN_USD_CR -- 年期初贷方报表美元余额
    ,P1.YTY_BALANCE_DR -- 本年原币借方发生额
    ,P1.YTY_BALANCE_CR -- 本年原币贷方发生额
    ,P1.YTY_FUN_BALANCE_DR -- 本年本币借方发生额
    ,P1.YTY_FUN_BALANCE_CR -- 本年本币贷方发生额
    ,P1.YTY_USD_BALANCE_DR -- 本年美元借方发生额
    ,P1.YTY_USD_BALANCE_CR -- 本年美元贷方发生额
    ,P1.SEGMENT7 -- 来源编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'glms_cux_gl_daily_balance' -- 源表名称
    ,'glmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.glms_cux_gl_daily_balance p1
    inner join ${iol_schema}.glms_fnd_flex_values_vl p3 on P3.FLEX_VALUE = P1.SEGMENT7 AND P3.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P3.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    inner join ${iol_schema}.glms_fnd_flex_value_sets p2 on P3.FLEX_VALUE_SET_ID = P2.FLEX_VALUE_SET_ID AND P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT >TO_DATE('${batch_date}','YYYYMMDD')
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')  AND P2.FLEX_VALUE_SET_NAME = 'COA_SOURCE'
AND P1.LEDGER_ID IN
(SELECT LEDGER_ID FROM ${iol_schema}.GLMS_GL_LEDGERS P4 WHERE SHORT_NAME IN ('GH_GL_LEDGER', 'GH_RV_LEDGER') AND P4.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P4.END_DT>TO_DATE('${batch_date}','YYYYMMDD'))
AND P1.SEGMENT3 != '9999' 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.fin_gl_acct_bal truncate subpartition p_glmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.fin_gl_acct_bal exchange subpartition p_glmsi1_${batch_date} with table ${iml_schema}.fin_gl_acct_bal_glmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_gl_acct_bal to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_gl_acct_bal_glmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_gl_acct_bal', partname => 'p_glmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);