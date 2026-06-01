/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_with_hold_detail
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
drop table ${iol_schema}.ncbs_rb_batch_with_hold_detail_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_with_hold_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_batch_with_hold_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_with_hold_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_with_hold_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_with_hold_detail_ex(
    client_no -- 客户编号
    ,reference -- 交易参考号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,error_msg -- 错误代码
    ,issue_no -- 发布编号
    ,periods -- 批量扣扣频率
    ,weight -- 权重
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,actual_amt -- 实际金额
    ,loan_internal_key -- 贷款账户key值
    ,loan_no -- 贷款号
    ,settle_base_acct_no -- 结算账号
    ,settle_ccy -- 结算币种
    ,settle_prod_type -- 结算账户产品类型
    ,settle_seq_no -- 清算序号
    ,total_amt -- 总金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,reference -- 交易参考号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,error_msg -- 错误代码
    ,issue_no -- 发布编号
    ,periods -- 批量扣扣频率
    ,weight -- 权重
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,actual_amt -- 实际金额
    ,loan_internal_key -- 贷款账户key值
    ,loan_no -- 贷款号
    ,settle_base_acct_no -- 结算账号
    ,settle_ccy -- 结算币种
    ,settle_prod_type -- 结算账户产品类型
    ,settle_seq_no -- 清算序号
    ,total_amt -- 总金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_with_hold_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_with_hold_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_with_hold_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_with_hold_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_with_hold_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_with_hold_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);