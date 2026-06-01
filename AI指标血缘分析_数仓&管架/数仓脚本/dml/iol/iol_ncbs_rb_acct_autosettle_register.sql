/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_autosettle_register
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
drop table ${iol_schema}.ncbs_rb_acct_autosettle_register_ex purge;
alter table ${iol_schema}.ncbs_rb_acct_autosettle_register add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_acct_autosettle_register truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_acct_autosettle_register_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_autosettle_register where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_autosettle_register_ex(
    acct_seq_no -- 账户子账号
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,auto_settle_result -- 结清结果
    ,company -- 法人
    ,seq_no -- 序号
    ,settle_date -- 结算日期
    ,tran_timestamp -- 交易时间戳
    ,ch_client_name -- 客户中文名称
    ,failure_reason -- 失败原因
    ,int_amt -- 利息金额
    ,pri_amt -- 本金金额
    ,settle_acct_no -- 人行清算账户
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_ccy -- 结算币种
    ,settle_prod_type -- 结算账户产品类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,auto_settle_result -- 结清结果
    ,company -- 法人
    ,seq_no -- 序号
    ,settle_date -- 结算日期
    ,tran_timestamp -- 交易时间戳
    ,ch_client_name -- 客户中文名称
    ,failure_reason -- 失败原因
    ,int_amt -- 利息金额
    ,pri_amt -- 本金金额
    ,settle_acct_no -- 人行清算账户
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_ccy -- 结算币种
    ,settle_prod_type -- 结算账户产品类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_acct_autosettle_register
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_acct_autosettle_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_autosettle_register_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_autosettle_register to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_acct_autosettle_register_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_autosettle_register',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);