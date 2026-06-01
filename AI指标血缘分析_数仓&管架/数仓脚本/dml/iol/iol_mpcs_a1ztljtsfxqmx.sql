/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ztljtsfxqmx
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
drop table ${iol_schema}.mpcs_a1ztljtsfxqmx_ex purge;
alter table ${iol_schema}.mpcs_a1ztljtsfxqmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a1ztljtsfxqmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1ztljtsfxqmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ztljtsfxqmx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1ztljtsfxqmx_ex(
    transdt -- 中台交易日期
    ,transtm -- 中台交易时间
    ,mainseq -- 中台交易流水
    ,chnlid -- 交易渠道:1.柜面转账；2.微信内部户；3.支付宝内部户 4.行外 5.行内
    ,base_acct_no -- 主账户号(内部户)
    ,base_acct_name -- 主账号名称(内部户名称)
    ,tran_amt -- 核心交易金额
    ,pay_acct -- 付款账户
    ,pay_name -- 付款账户名
    ,recv_acct -- 收款账户
    ,recv_name -- 收款账户名
    ,inhostdt -- 收入的核心日期
    ,inhosttm -- 收入的核心时间
    ,inhostseqno -- 收入的核心流水
    ,inhostseqnosub -- 收入的核心子流水
    ,outhostdt -- 支出的核心日期
    ,outhosttm -- 支出的核心时间
    ,outhostseqno -- 支出的核心流水
    ,outhostseqnosub -- 支出的核心子流水
    ,remark -- 备注
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdt -- 中台交易日期
    ,transtm -- 中台交易时间
    ,mainseq -- 中台交易流水
    ,chnlid -- 交易渠道:1.柜面转账；2.微信内部户；3.支付宝内部户 4.行外 5.行内
    ,base_acct_no -- 主账户号(内部户)
    ,base_acct_name -- 主账号名称(内部户名称)
    ,tran_amt -- 核心交易金额
    ,pay_acct -- 付款账户
    ,pay_name -- 付款账户名
    ,recv_acct -- 收款账户
    ,recv_name -- 收款账户名
    ,inhostdt -- 收入的核心日期
    ,inhosttm -- 收入的核心时间
    ,inhostseqno -- 收入的核心流水
    ,inhostseqnosub -- 收入的核心子流水
    ,outhostdt -- 支出的核心日期
    ,outhosttm -- 支出的核心时间
    ,outhostseqno -- 支出的核心流水
    ,outhostseqnosub -- 支出的核心子流水
    ,remark -- 备注
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1ztljtsfxqmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1ztljtsfxqmx exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ztljtsfxqmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ztljtsfxqmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1ztljtsfxqmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ztljtsfxqmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);