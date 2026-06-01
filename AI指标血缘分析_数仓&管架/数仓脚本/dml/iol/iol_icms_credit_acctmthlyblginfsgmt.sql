/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_credit_acctmthlyblginfsgmt
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
drop table ${iol_schema}.icms_credit_acctmthlyblginfsgmt_ex purge;
alter table ${iol_schema}.icms_credit_acctmthlyblginfsgmt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_credit_acctmthlyblginfsgmt;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_credit_acctmthlyblginfsgmt_ex nologging
compress
as
select * from ${iol_schema}.icms_credit_acctmthlyblginfsgmt where 0=1;

insert /*+ append */ into ${iol_schema}.icms_credit_acctmthlyblginfsgmt_ex(
    pridacctbal -- 本期账单余额
    ,usedamt -- 已使用额度
    ,overdprd -- 当前逾期期数
    ,notisubal -- 未出单的大额专项分期余额
    ,fivecateadjdate -- 五级分类认定日期
    ,ovedrawbaove180 -- 透支180天以上未还余额
    ,create_time -- 入库时间
    ,cust_no -- 客户号码
    ,acctbal -- 余额
    ,oved91_180princ -- 逾期91-180天未归还本金
    ,latrpyamt -- 最近一次实际还款金额
    ,deptcode -- 征信机构代码
    ,currpyamt -- 本月应还款金额
    ,totoverd -- 当前逾期总额
    ,oved61_90princ -- 逾期61-90天未归还本金
    ,settdate -- 结算/应还款日
    ,acctcode -- 账户标识码
    ,oved31_60princ -- 逾期31-60天未归还本金
    ,latrpydate -- 最近一次实际还款日期
    ,top_deptcode -- 顶级征信机构代码
    ,rptdate -- 信息报告日期
    ,month -- 月份
    ,acctstatus -- 账户状态
    ,actrpyamt -- 本月实际还款金额
    ,rpyprct -- 实际还款百分比
    ,closedate -- 账户关闭日期
    ,extra_info -- 扩展字段
    ,ovedprinc180 -- 逾期180天以上未归还本金
    ,fivecate -- 五级分类
    ,remrepprd -- 剩余还款期数
    ,rpystatus -- 当前还款状态
    ,overdprinc -- 当前逾期本金
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pridacctbal -- 本期账单余额
    ,usedamt -- 已使用额度
    ,overdprd -- 当前逾期期数
    ,notisubal -- 未出单的大额专项分期余额
    ,fivecateadjdate -- 五级分类认定日期
    ,ovedrawbaove180 -- 透支180天以上未还余额
    ,create_time -- 入库时间
    ,cust_no -- 客户号码
    ,acctbal -- 余额
    ,oved91_180princ -- 逾期91-180天未归还本金
    ,latrpyamt -- 最近一次实际还款金额
    ,deptcode -- 征信机构代码
    ,currpyamt -- 本月应还款金额
    ,totoverd -- 当前逾期总额
    ,oved61_90princ -- 逾期61-90天未归还本金
    ,settdate -- 结算/应还款日
    ,acctcode -- 账户标识码
    ,oved31_60princ -- 逾期31-60天未归还本金
    ,latrpydate -- 最近一次实际还款日期
    ,top_deptcode -- 顶级征信机构代码
    ,rptdate -- 信息报告日期
    ,month -- 月份
    ,acctstatus -- 账户状态
    ,actrpyamt -- 本月实际还款金额
    ,rpyprct -- 实际还款百分比
    ,closedate -- 账户关闭日期
    ,extra_info -- 扩展字段
    ,ovedprinc180 -- 逾期180天以上未归还本金
    ,fivecate -- 五级分类
    ,remrepprd -- 剩余还款期数
    ,rpystatus -- 当前还款状态
    ,overdprinc -- 当前逾期本金
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_credit_acctmthlyblginfsgmt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_credit_acctmthlyblginfsgmt exchange partition p_${batch_date} with table ${iol_schema}.icms_credit_acctmthlyblginfsgmt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_credit_acctmthlyblginfsgmt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_credit_acctmthlyblginfsgmt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_credit_acctmthlyblginfsgmt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);