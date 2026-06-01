/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_tran_h
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
drop table ${iol_schema}.tgls_gla_tran_h_ex purge;
alter table ${iol_schema}.tgls_gla_tran_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_tran_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_tran_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_tran_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_tran_h_ex(
    stacid -- 账套标记
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,tranti -- 交易时间
    ,tranbr -- 交易机构
    ,usercd -- 用户代码
    ,acctbr -- 账务机构
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水
    ,trantp -- 交易类型
    ,dcmtno -- 凭证号码
    ,dcmttp -- 凭证类型
    ,prcscd -- 处理码
    ,tranam -- 交易金额
    ,itemcd -- 科目代码（交易主科目）
    ,psauus -- 复核用户
    ,strkst -- 冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）
    ,odtrdt -- 原交易日期（被冲正交易日期）
    ,odtrsq -- 原交易流水（被冲正交流流水）
    ,acsrnm -- 附件张数
    ,sourst -- 源系统标识（ltts-综合业务acct-财务）
    ,remark -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,tranti -- 交易时间
    ,tranbr -- 交易机构
    ,usercd -- 用户代码
    ,acctbr -- 账务机构
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水
    ,trantp -- 交易类型
    ,dcmtno -- 凭证号码
    ,dcmttp -- 凭证类型
    ,prcscd -- 处理码
    ,tranam -- 交易金额
    ,itemcd -- 科目代码（交易主科目）
    ,psauus -- 复核用户
    ,strkst -- 冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）
    ,odtrdt -- 原交易日期（被冲正交易日期）
    ,odtrsq -- 原交易流水（被冲正交流流水）
    ,acsrnm -- 附件张数
    ,sourst -- 源系统标识（ltts-综合业务acct-财务）
    ,remark -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_tran_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_tran_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_tran_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_tran_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_tran_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_tran_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);