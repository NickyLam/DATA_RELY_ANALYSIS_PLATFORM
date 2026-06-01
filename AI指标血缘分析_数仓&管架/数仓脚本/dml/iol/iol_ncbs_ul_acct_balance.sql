/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_acct_balance
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
drop table ${iol_schema}.ncbs_ul_acct_balance_ex purge;
alter table ${iol_schema}.ncbs_ul_acct_balance add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_acct_balance truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_acct_balance_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_acct_balance where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_acct_balance_ex(
    cmisloan_no -- 客户借据编号|客户借据编号
    ,client_no -- 客户编号|客户编号
    ,dd_amt -- 发放金额|发放金额
    ,osl_amt -- 客户未到期本金|客户未到期本金
    ,prd_amt -- 逾期本金 |逾期本金
    ,intp_amt -- 逾期利息|逾期利息
    ,odpp_amt -- 逾期罚息余额  |逾期罚息余额
    ,odip_amt -- 复利余额  |复利余额
    ,gprd_amt -- 宽限期本金 |宽限期本金
    ,gintp_amt -- 宽限期利息 |宽限期利息
    ,godpp_amt -- 宽限期罚息 |宽限期罚息
    ,godip_amt -- 宽限期复利 |宽限期复利
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,batch_no -- 批次号|批次号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cmisloan_no -- 客户借据编号|客户借据编号
    ,client_no -- 客户编号|客户编号
    ,dd_amt -- 发放金额|发放金额
    ,osl_amt -- 客户未到期本金|客户未到期本金
    ,prd_amt -- 逾期本金 |逾期本金
    ,intp_amt -- 逾期利息|逾期利息
    ,odpp_amt -- 逾期罚息余额  |逾期罚息余额
    ,odip_amt -- 复利余额  |复利余额
    ,gprd_amt -- 宽限期本金 |宽限期本金
    ,gintp_amt -- 宽限期利息 |宽限期利息
    ,godpp_amt -- 宽限期罚息 |宽限期罚息
    ,godip_amt -- 宽限期复利 |宽限期复利
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,batch_no -- 批次号|批次号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_acct_balance
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_acct_balance exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_acct_balance_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_acct_balance to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_acct_balance_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_acct_balance',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);