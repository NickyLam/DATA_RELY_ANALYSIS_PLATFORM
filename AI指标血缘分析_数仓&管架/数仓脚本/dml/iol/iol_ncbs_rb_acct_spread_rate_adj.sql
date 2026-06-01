/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_spread_rate_adj
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
drop table ${iol_schema}.ncbs_rb_acct_spread_rate_adj_ex purge;
alter table ${iol_schema}.ncbs_rb_acct_spread_rate_adj add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_acct_spread_rate_adj truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_acct_spread_rate_adj_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_spread_rate_adj where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_spread_rate_adj_ex(
    seq_no -- 序号
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,before_acct_spread_rate -- 调整前分户级利率浮动百分点
    ,after_acct_spread_rate -- 调整后分户级利率浮动百分点
    ,before_real_rate -- 调整前执行利率
    ,after_real_rate -- 调整后执行利率
    ,int_class -- 利息分类
    ,tran_date -- 交易日期
    ,reference -- 交易参考号
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq_no -- 序号
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,before_acct_spread_rate -- 调整前分户级利率浮动百分点
    ,after_acct_spread_rate -- 调整后分户级利率浮动百分点
    ,before_real_rate -- 调整前执行利率
    ,after_real_rate -- 调整后执行利率
    ,int_class -- 利息分类
    ,tran_date -- 交易日期
    ,reference -- 交易参考号
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_acct_spread_rate_adj
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_acct_spread_rate_adj exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_spread_rate_adj_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_spread_rate_adj to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_acct_spread_rate_adj_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_spread_rate_adj',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);