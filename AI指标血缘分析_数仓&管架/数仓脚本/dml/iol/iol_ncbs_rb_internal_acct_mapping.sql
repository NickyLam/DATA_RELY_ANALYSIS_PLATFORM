/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_internal_acct_mapping
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
drop table ${iol_schema}.ncbs_rb_internal_acct_mapping_ex purge;
alter table ${iol_schema}.ncbs_rb_internal_acct_mapping add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_internal_acct_mapping;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_internal_acct_mapping_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_internal_acct_mapping where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_internal_acct_mapping_ex(
    base_acct_no -- 交易账号/卡号
    ,tran_type -- 交易类型
    ,channel_type_rule -- 渠道类型规则
    ,company -- 法人
    ,inter_tran_type -- 内部交易类型
    ,libra_op_time -- libra执行次数
    ,channel -- 渠道
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,oth_acct_no -- 对方账号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no -- 交易账号/卡号
    ,tran_type -- 交易类型
    ,channel_type_rule -- 渠道类型规则
    ,company -- 法人
    ,inter_tran_type -- 内部交易类型
    ,libra_op_time -- libra执行次数
    ,channel -- 渠道
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,oth_acct_no -- 对方账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_internal_acct_mapping
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_internal_acct_mapping exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_internal_acct_mapping_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_internal_acct_mapping to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_internal_acct_mapping_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_internal_acct_mapping',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);