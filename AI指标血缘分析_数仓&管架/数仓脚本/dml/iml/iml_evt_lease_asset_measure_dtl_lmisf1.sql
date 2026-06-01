/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_lease_asset_measure_dtl_lmisf1
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
drop table ${iml_schema}.evt_lease_asset_measure_dtl_lmisf1_tm purge;
alter table ${iml_schema}.evt_lease_asset_measure_dtl add partition p_lmisf1 values ('lmisf1')(
        subpartition p_lmisf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_lease_asset_measure_dtl modify partition p_lmisf1
    add subpartition p_lmisf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lease_asset_measure_dtl_lmisf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,lease_measure_ser_num -- 承租计量序列号
    ,lease_asset_ser_num -- 承租资产序列号
    ,measure_tm -- 计量时间
    ,acct_b_id -- 账簿编号
    ,measure_mon -- 计量月
    ,tm_bg_use_right_asset_bal -- 期初使用权资产余额
    ,curr_issue_depre_amt -- 本期折旧金额
    ,acm_depre_amt -- 累计折旧金额
    ,term_end_use_right_asset_bal -- 期末使用权资产余额
    ,tm_bg_at_paybl_rent_money -- 期初税后应付租赁款
    ,curr_issue_plan_pay_lmt -- 本期计划付款额
    ,acm_acct_paybl -- 累计应付款
    ,term_end_at_paybl_rent_money -- 期末税后应付租赁款
    ,tm_bg_amort_cost_bal -- 期初摊余成本余额
    ,curr_issue_rent_liab_chg -- 本期租赁负债变化
    ,acm_rent_liab_chg -- 累计租赁负债变化
    ,term_end_amort_cost_bal -- 期末摊余成本余额
    ,tm_bg_uncfm_fin_fee_bal -- 期初未确认融资费用余额
    ,curr_issue_int_fee -- 本期利息费用
    ,acm_int_fee -- 累计利息费用
    ,term_end_uncfm_fin_fee_bal -- 期末未确认融资费用余额
    ,curr_modif_use_right_asset_amt -- 本期合同变更使用权资产发生额
    ,curr_modif_paybl_rent_money -- 本期合同变更应付租赁款
    ,curr_modif_amort_cost_amt -- 本期合同变更摊余成本发生额
    ,curr_modif_uncfm_fin_fee_amt -- 本期合同变更未确认融资费用发生额
    ,new_crition_duran_pl_amt -- 新准则期间损益金额
    ,old_crition_duran_pl_amt -- 旧准则期间损益金额
    ,new_old_crition_pl_diff_amt -- 新旧准则损益差异金额
    ,curr_mon_acm_paybl_rent_decrs -- 本期当月累计应付租赁款减少额
    ,curr_mon_acm_rent_liab_chg -- 本期当月累计租赁负债变化
    ,curr_mon_acm_int_fee -- 本期当月累计利息费用
    ,acm_old_crition_duran_pl_amt -- 累计旧准则期间损益金额
    ,dt_type_cd -- 日期类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_lease_asset_measure_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- lmis_asset_lessee_metering_info-1
insert into ${iml_schema}.evt_lease_asset_measure_dtl_lmisf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,lease_measure_ser_num -- 承租计量序列号
    ,lease_asset_ser_num -- 承租资产序列号
    ,measure_tm -- 计量时间
    ,acct_b_id -- 账簿编号
    ,measure_mon -- 计量月
    ,tm_bg_use_right_asset_bal -- 期初使用权资产余额
    ,curr_issue_depre_amt -- 本期折旧金额
    ,acm_depre_amt -- 累计折旧金额
    ,term_end_use_right_asset_bal -- 期末使用权资产余额
    ,tm_bg_at_paybl_rent_money -- 期初税后应付租赁款
    ,curr_issue_plan_pay_lmt -- 本期计划付款额
    ,acm_acct_paybl -- 累计应付款
    ,term_end_at_paybl_rent_money -- 期末税后应付租赁款
    ,tm_bg_amort_cost_bal -- 期初摊余成本余额
    ,curr_issue_rent_liab_chg -- 本期租赁负债变化
    ,acm_rent_liab_chg -- 累计租赁负债变化
    ,term_end_amort_cost_bal -- 期末摊余成本余额
    ,tm_bg_uncfm_fin_fee_bal -- 期初未确认融资费用余额
    ,curr_issue_int_fee -- 本期利息费用
    ,acm_int_fee -- 累计利息费用
    ,term_end_uncfm_fin_fee_bal -- 期末未确认融资费用余额
    ,curr_modif_use_right_asset_amt -- 本期合同变更使用权资产发生额
    ,curr_modif_paybl_rent_money -- 本期合同变更应付租赁款
    ,curr_modif_amort_cost_amt -- 本期合同变更摊余成本发生额
    ,curr_modif_uncfm_fin_fee_amt -- 本期合同变更未确认融资费用发生额
    ,new_crition_duran_pl_amt -- 新准则期间损益金额
    ,old_crition_duran_pl_amt -- 旧准则期间损益金额
    ,new_old_crition_pl_diff_amt -- 新旧准则损益差异金额
    ,curr_mon_acm_paybl_rent_decrs -- 本期当月累计应付租赁款减少额
    ,curr_mon_acm_rent_liab_chg -- 本期当月累计租赁负债变化
    ,curr_mon_acm_int_fee -- 本期当月累计利息费用
    ,acm_old_crition_duran_pl_amt -- 累计旧准则期间损益金额
    ,dt_type_cd -- 日期类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '301001'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 承租计量序列号
    ,P1.LESSEE_ID -- 承租资产序列号
    ,P1.METERING_DATE -- 计量时间
    ,P1.BOOK_CODE -- 账簿编号
    ,P1.PERIOD_NAME -- 计量月
    ,P1.ASSET_AMOUNT_BEGIN -- 期初使用权资产余额
    ,P1.DEPRN_AMOUNT -- 本期折旧金额
    ,P1.ACCUMULATED_DEPRN_AMOUNT -- 累计折旧金额
    ,P1.ASSET_AMOUNT_END -- 期末使用权资产余额
    ,P1.PAYABLE_AMOUNT_BEGIN -- 期初税后应付租赁款
    ,P1.PERIOD_PAYABLE_AMOUNT -- 本期计划付款额
    ,P1.ACCUMULATED_PAYABLE_AMOUNT -- 累计应付款
    ,P1.PAYABLE_AMOUNT_END -- 期末税后应付租赁款
    ,P1.AMORTIZED_COST_BEGIN -- 期初摊余成本余额
    ,P1.PERIOD_AMORTIZED_COST -- 本期租赁负债变化
    ,P1.ACCUMULATED_AMORTIZED_COST -- 累计租赁负债变化
    ,P1.AMORTIZED_COST_END -- 期末摊余成本余额
    ,P1.INTEREST_BEGIN -- 期初未确认融资费用余额
    ,P1.PERIOD_INTEREST -- 本期利息费用
    ,P1.ACCUMULATED_INTEREST -- 累计利息费用
    ,P1.INTEREST_END -- 期末未确认融资费用余额
    ,P1.ASSET_MOD_AMOUNT -- 本期合同变更使用权资产发生额
    ,P1.PAYABLE_AMOUNT_MOD -- 本期合同变更应付租赁款
    ,P1.AMORTIZED_COST_MOD -- 本期合同变更摊余成本发生额
    ,P1.INTEREST_MOD -- 本期合同变更未确认融资费用发生额
    ,P1.NEW_ACCOUNT_AMOUNT -- 新准则期间损益金额
    ,P1.OLD_ACCOUNT_AMOUNT -- 旧准则期间损益金额
    ,P1.DIFFER_AMOUNT -- 新旧准则损益差异金额
    ,P1.MONTH_PAYABLE_AMOUNT -- 本期当月累计应付租赁款减少额
    ,P1.MONTH_AMORTIZED_COST -- 本期当月累计租赁负债变化
    ,P1.MONTH_PERIOD_INTEREST -- 本期当月累计利息费用
    ,P1.ACCUMULATED_ACCOUNT_AMOUNT -- 累计旧准则期间损益金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DATE_TYPE END -- 日期类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'lmis_asset_lessee_metering_info' -- 源表名称
    ,'lmisf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.lmis_asset_lessee_metering_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DATE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'LMIS'
        AND R1.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_METERING_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'DATE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_LEASE_ASSET_MEASURE_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_lease_asset_measure_dtl truncate partition p_lmisf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_lease_asset_measure_dtl exchange subpartition p_lmisf1_${batch_date} with table ${iml_schema}.evt_lease_asset_measure_dtl_lmisf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_lease_asset_measure_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_lease_asset_measure_dtl_lmisf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_lease_asset_measure_dtl', partname => 'p_lmisf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);