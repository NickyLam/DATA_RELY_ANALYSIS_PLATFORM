/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_lpcl
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
drop table ${iol_schema}.tgls_gla_lpcl_ex purge;
alter table ${iol_schema}.tgls_gla_lpcl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_lpcl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_lpcl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_lpcl where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_lpcl_ex(
    stacid -- 账套标记
    ,systid -- 源系统标识（ltts-综合业务acct-财务）
    ,sourdt -- 源系统日期（结转日期）
    ,brchcd -- 机构编号
    ,itemcd -- 科目编号
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,crcycd -- 币种代码
    ,amntcd -- 借贷方向
    ,tranam -- 交易金额
    ,transt -- 处理状态（或结转状态1已处理0未处理）
    ,geldtp -- 统计频度（m月、q季、h半年、y年）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,systid -- 源系统标识（ltts-综合业务acct-财务）
    ,sourdt -- 源系统日期（结转日期）
    ,brchcd -- 机构编号
    ,itemcd -- 科目编号
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,crcycd -- 币种代码
    ,amntcd -- 借贷方向
    ,tranam -- 交易金额
    ,transt -- 处理状态（或结转状态1已处理0未处理）
    ,geldtp -- 统计频度（m月、q季、h半年、y年）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_lpcl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_lpcl exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_lpcl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_lpcl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_lpcl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_lpcl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);