/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_lm_client_limit_record
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
drop table ${iol_schema}.ncbs_rb_lm_client_limit_record_ex purge;
alter table ${iol_schema}.ncbs_rb_lm_client_limit_record add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_lm_client_limit_record truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_lm_client_limit_record_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_lm_client_limit_record where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_lm_client_limit_record_ex(
    internal_key -- 账户内部键值
    ,base_acct_no -- 交易账号/卡号
    ,acct_seq_no -- 账户子账号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,client_no -- 客户编号
    ,limit_main_type -- 限额大类
    ,day_limit_max_amt -- 日限额最大值
    ,old_day_limit_amt -- 原日累计最大限制金额
    ,day_limit_max_num -- 日累计最大笔数
    ,old_day_limit_num -- 原日累计最大限制笔数
    ,single_limit_max_amt -- 单笔最大限制金额
    ,old_single_limit_amt -- 原单笔最大限制金额
    ,year_limit_max_amt -- 年限额最大值
    ,old_year_limit_amt -- 原年累计最大限制金额
    ,source_type -- 渠道编号
    ,user_id -- 交易柜员编号
    ,limit_reason -- 限额设置原因
    ,reference -- 交易参考号
    ,tran_timestamp -- 交易时间戳
    ,tran_limit_due_date -- 交易限额有效期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    internal_key -- 账户内部键值
    ,base_acct_no -- 交易账号/卡号
    ,acct_seq_no -- 账户子账号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,client_no -- 客户编号
    ,limit_main_type -- 限额大类
    ,day_limit_max_amt -- 日限额最大值
    ,old_day_limit_amt -- 原日累计最大限制金额
    ,day_limit_max_num -- 日累计最大笔数
    ,old_day_limit_num -- 原日累计最大限制笔数
    ,single_limit_max_amt -- 单笔最大限制金额
    ,old_single_limit_amt -- 原单笔最大限制金额
    ,year_limit_max_amt -- 年限额最大值
    ,old_year_limit_amt -- 原年累计最大限制金额
    ,source_type -- 渠道编号
    ,user_id -- 交易柜员编号
    ,limit_reason -- 限额设置原因
    ,reference -- 交易参考号
    ,tran_timestamp -- 交易时间戳
    ,tran_limit_due_date -- 交易限额有效期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_lm_client_limit_record
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_lm_client_limit_record exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_lm_client_limit_record_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_lm_client_limit_record to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_lm_client_limit_record_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_lm_client_limit_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);