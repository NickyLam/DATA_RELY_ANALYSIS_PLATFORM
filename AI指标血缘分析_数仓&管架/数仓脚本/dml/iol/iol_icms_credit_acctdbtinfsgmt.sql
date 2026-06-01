/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_credit_acctdbtinfsgmt
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
drop table ${iol_schema}.icms_credit_acctdbtinfsgmt_ex purge;
alter table ${iol_schema}.icms_credit_acctdbtinfsgmt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_credit_acctdbtinfsgmt;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_credit_acctdbtinfsgmt_ex nologging
compress
as
select * from ${iol_schema}.icms_credit_acctdbtinfsgmt where 0=1;

insert /*+ append */ into ${iol_schema}.icms_credit_acctdbtinfsgmt_ex(
    acctstatus -- 账户状态
    ,remrepprd -- 剩余还款期数
    ,create_time -- 入库时间
    ,fivecate -- 五级分类
    ,rptdate -- 信息报告日期
    ,deptcode -- 征信机构代码
    ,acctcode -- 账户标识码
    ,rpystatus -- 当前还款状态
    ,fivecateadjdate -- 五级分类认定日期
    ,totoverd -- 当前逾期总额
    ,cust_no -- 客户号码
    ,overdprd -- 当前逾期期数
    ,latrpydate -- 最近一次实际还款日期
    ,extra_info -- 扩展字段
    ,top_deptcode -- 顶级征信机构代码
    ,latrpyamt -- 最近一次实际还款金额
    ,acctbal -- 余额
    ,closedate -- 账户关闭日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acctstatus -- 账户状态
    ,remrepprd -- 剩余还款期数
    ,create_time -- 入库时间
    ,fivecate -- 五级分类
    ,rptdate -- 信息报告日期
    ,deptcode -- 征信机构代码
    ,acctcode -- 账户标识码
    ,rpystatus -- 当前还款状态
    ,fivecateadjdate -- 五级分类认定日期
    ,totoverd -- 当前逾期总额
    ,cust_no -- 客户号码
    ,overdprd -- 当前逾期期数
    ,latrpydate -- 最近一次实际还款日期
    ,extra_info -- 扩展字段
    ,top_deptcode -- 顶级征信机构代码
    ,latrpyamt -- 最近一次实际还款金额
    ,acctbal -- 余额
    ,closedate -- 账户关闭日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_credit_acctdbtinfsgmt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_credit_acctdbtinfsgmt exchange partition p_${batch_date} with table ${iol_schema}.icms_credit_acctdbtinfsgmt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_credit_acctdbtinfsgmt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_credit_acctdbtinfsgmt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_credit_acctdbtinfsgmt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);