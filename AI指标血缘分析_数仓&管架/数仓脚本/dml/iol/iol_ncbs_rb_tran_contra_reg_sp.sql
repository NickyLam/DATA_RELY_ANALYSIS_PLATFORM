/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_contra_reg_sp
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
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_sp_ex purge;
alter table ${iol_schema}.ncbs_rb_tran_contra_reg_sp add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_tran_contra_reg_sp;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_tran_contra_reg_sp_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_tran_contra_reg_sp where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_tran_contra_reg_sp_ex(
    seq_no -- 序号
    ,reference -- 交易参考号
    ,tran_date -- 交易日期
    ,channel_seq_no -- 全局流水号
    ,sub_seq_no -- 系统子流水号
    ,reg_seq_no -- 补录子序号
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_tran_name -- 真实交易对手名称
    ,contra_bank_code -- 交易对手行号
    ,contra_bank_name -- 对手行名
    ,oth_real_acct_seq_no -- 真实交易对手账户序号
    ,oth_internal_key -- 对手账户内部键
    ,tran_amt -- 交易金额
    ,source_module -- 源模块
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq_no -- 序号
    ,reference -- 交易参考号
    ,tran_date -- 交易日期
    ,channel_seq_no -- 全局流水号
    ,sub_seq_no -- 系统子流水号
    ,reg_seq_no -- 补录子序号
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_tran_name -- 真实交易对手名称
    ,contra_bank_code -- 交易对手行号
    ,contra_bank_name -- 对手行名
    ,oth_real_acct_seq_no -- 真实交易对手账户序号
    ,oth_internal_key -- 对手账户内部键
    ,tran_amt -- 交易金额
    ,source_module -- 源模块
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_tran_contra_reg_sp
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_tran_contra_reg_sp exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tran_contra_reg_sp_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tran_contra_reg_sp to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_sp_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tran_contra_reg_sp',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);