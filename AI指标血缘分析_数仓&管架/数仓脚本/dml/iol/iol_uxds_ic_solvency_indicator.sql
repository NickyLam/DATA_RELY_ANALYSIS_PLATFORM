/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_ic_solvency_indicator
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_ic_solvency_indicator_ex purge;
alter table ${iol_schema}.uxds_ic_solvency_indicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_ic_solvency_indicator;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_ic_solvency_indicator_ex nologging
compress
as
select * from ${iol_schema}.uxds_ic_solvency_indicator where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_ic_solvency_indicator_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,announcement_date -- 公告日期
    ,org_id -- 机构ID
    ,ed -- 截止日期
    ,statement_type_code -- 报表类型编码
    ,report_type_code -- 报告类型编码
    ,statement_year -- 报表年度
    ,chg_seq -- 变动序号
    ,is_latest -- 最新标志
    ,core_smpa -- 核心偿付能力溢额
    ,core_smr -- 核心偿付能力充足率
    ,total_smpa -- 综合偿付能力溢额
    ,total_smr -- 综合偿付能力充足率
    ,insurance_business_income -- 保险业务收入
    ,net_profit -- 净利润
    ,net_asset -- 净资产
    ,approved_asset -- 认可资产
    ,approved_debt -- 认可负债
    ,actual_capital -- 实际资本
    ,actual_first_core_capital -- 实际资本:核心一级资本
    ,actual_second_core_capital -- 实际资本:核心二级资本
    ,actual_first_sub_capital -- 实际资本:附属一级资本
    ,actual_sub_core_capital -- 实际资本:附属二级资本
    ,min_capital -- 最低资本
    ,min_quantify_risk_capital -- 最低资本:量化风险最低资本
    ,min_contral_risk_capital -- 最低资本:控制风险最低资本
    ,min_sub_capital -- 最低资本:附加资本
    ,min_lifeinsur_risk_capital -- 寿险业务保险风险最低资本
    ,min_non_lifeinsur_risk_capital -- 非寿险业务保险风险最低资本
    ,min_market_risk_capital -- 市场风险最低资本
    ,min_credit_risk_capital -- 信用风险最低资本
    ,quantify_risk_disperse_effect -- 量化风险分散效应
    ,spe_contract_loss_absorption -- 特定类别保险合同损失吸收效应
    ,latest_risk_rating -- 最近一次风险综合评级类别
    ,latest_risk_rating_time -- 最近一次风险综合评级对应时间
    ,net_cash_flow -- 净现金流
    ,net_cash_flow_1y -- 净现金流-报告日后第1年
    ,net_cash_flow_2y -- 净现金流-报告日后第2年
    ,net_cash_flow_3y -- 净现金流-报告日后第3年
    ,total_current_ratio_within_3m -- 综合流动比率-3个月内
    ,total_current_ratio_within_1y -- 综合流动比率-1年内
    ,total_current_ratio_over_1y -- 综合流动比率-1年以上
    ,total_current_ratio_1y_to_3y -- 综合流动比率-1-3年内
    ,total_current_ratio_3y_to_5y -- 综合流动比率-3-5年内
    ,total_current_ratio_over_5y -- 综合流动比率-5年以上
    ,lcr_corp_stress_scenario1 -- 流动性覆盖率-公司整体-压力情景1
    ,lcr_corp_stress_scenario2 -- 流动性覆盖率-公司整体-压力情景2
    ,lcr_account_stress_scenario1 -- 流动性覆盖率-独立账户-压力情景1
    ,lcr_account_stress_scenario2 -- 流动性覆盖率-独立账户-压力情景2
    ,currency_code -- 币种名称编码
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,announcement_date -- 公告日期
    ,org_id -- 机构ID
    ,ed -- 截止日期
    ,statement_type_code -- 报表类型编码
    ,report_type_code -- 报告类型编码
    ,statement_year -- 报表年度
    ,chg_seq -- 变动序号
    ,is_latest -- 最新标志
    ,core_smpa -- 核心偿付能力溢额
    ,core_smr -- 核心偿付能力充足率
    ,total_smpa -- 综合偿付能力溢额
    ,total_smr -- 综合偿付能力充足率
    ,insurance_business_income -- 保险业务收入
    ,net_profit -- 净利润
    ,net_asset -- 净资产
    ,approved_asset -- 认可资产
    ,approved_debt -- 认可负债
    ,actual_capital -- 实际资本
    ,actual_first_core_capital -- 实际资本:核心一级资本
    ,actual_second_core_capital -- 实际资本:核心二级资本
    ,actual_first_sub_capital -- 实际资本:附属一级资本
    ,actual_sub_core_capital -- 实际资本:附属二级资本
    ,min_capital -- 最低资本
    ,min_quantify_risk_capital -- 最低资本:量化风险最低资本
    ,min_contral_risk_capital -- 最低资本:控制风险最低资本
    ,min_sub_capital -- 最低资本:附加资本
    ,min_lifeinsur_risk_capital -- 寿险业务保险风险最低资本
    ,min_non_lifeinsur_risk_capital -- 非寿险业务保险风险最低资本
    ,min_market_risk_capital -- 市场风险最低资本
    ,min_credit_risk_capital -- 信用风险最低资本
    ,quantify_risk_disperse_effect -- 量化风险分散效应
    ,spe_contract_loss_absorption -- 特定类别保险合同损失吸收效应
    ,latest_risk_rating -- 最近一次风险综合评级类别
    ,latest_risk_rating_time -- 最近一次风险综合评级对应时间
    ,net_cash_flow -- 净现金流
    ,net_cash_flow_1y -- 净现金流-报告日后第1年
    ,net_cash_flow_2y -- 净现金流-报告日后第2年
    ,net_cash_flow_3y -- 净现金流-报告日后第3年
    ,total_current_ratio_within_3m -- 综合流动比率-3个月内
    ,total_current_ratio_within_1y -- 综合流动比率-1年内
    ,total_current_ratio_over_1y -- 综合流动比率-1年以上
    ,total_current_ratio_1y_to_3y -- 综合流动比率-1-3年内
    ,total_current_ratio_3y_to_5y -- 综合流动比率-3-5年内
    ,total_current_ratio_over_5y -- 综合流动比率-5年以上
    ,lcr_corp_stress_scenario1 -- 流动性覆盖率-公司整体-压力情景1
    ,lcr_corp_stress_scenario2 -- 流动性覆盖率-公司整体-压力情景2
    ,lcr_account_stress_scenario1 -- 流动性覆盖率-独立账户-压力情景1
    ,lcr_account_stress_scenario2 -- 流动性覆盖率-独立账户-压力情景2
    ,currency_code -- 币种名称编码
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_ic_solvency_indicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_ic_solvency_indicator exchange partition p_${batch_date} with table ${iol_schema}.uxds_ic_solvency_indicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_ic_solvency_indicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_ic_solvency_indicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_ic_solvency_indicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);