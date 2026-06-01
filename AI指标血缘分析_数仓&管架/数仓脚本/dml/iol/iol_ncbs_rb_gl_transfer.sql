/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_gl_transfer
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
drop table ${iol_schema}.ncbs_rb_gl_transfer_ex purge;
alter table ${iol_schema}.ncbs_rb_gl_transfer add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_gl_transfer truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_gl_transfer_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_gl_transfer where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_gl_transfer_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,bank_seq_no -- 银行交易序号
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,gl_posted_flag -- 过账标记
    ,gl_seq_no -- 总账序号
    ,gl_type -- 总账类型
    ,narrative -- 摘要
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,tran_seq_no -- 交易序号
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,value_date -- 记账日期
    ,auth_user_id -- 授权柜员
    ,gl_branch -- 总账机构
    ,gl_ccy -- 总账币种
    ,gl_client_no -- 总账客户号
    ,gl_profit_center -- 总账利润中心
    ,reversal_user_id -- 冲正柜员
    ,reverse_auth_user_id -- 冲正交易授权柜员
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,bank_seq_no -- 银行交易序号
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,gl_posted_flag -- 过账标记
    ,gl_seq_no -- 总账序号
    ,gl_type -- 总账类型
    ,narrative -- 摘要
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,tran_seq_no -- 交易序号
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,value_date -- 记账日期
    ,auth_user_id -- 授权柜员
    ,gl_branch -- 总账机构
    ,gl_ccy -- 总账币种
    ,gl_client_no -- 总账客户号
    ,gl_profit_center -- 总账利润中心
    ,reversal_user_id -- 冲正柜员
    ,reverse_auth_user_id -- 冲正交易授权柜员
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_gl_transfer
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_gl_transfer exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_gl_transfer_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_gl_transfer to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_gl_transfer_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_gl_transfer',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);