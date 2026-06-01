/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_open_close_reg
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
drop table ${iol_schema}.ncbs_rb_open_close_reg_ex purge;
alter table ${iol_schema}.ncbs_rb_open_close_reg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_open_close_reg;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_open_close_reg_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_open_close_reg where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_open_close_reg_ex(
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reason_code -- 账户用途
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,acct_nature -- 存款账户类型
    ,company -- 法人
    ,inform_bank_flag -- 是否通知人行
    ,is_self -- 视同本人标志
    ,narrative -- 摘要
    ,op_method -- 开销户操作方式
    ,reason_code_desc -- 原因代码描述
    ,reg_type -- 登记类型
    ,seq_no -- 序号
    ,suc_flag -- 社会统一信用代码标志
    ,active_date -- 激活日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,open_branch -- 开立机构
    ,tran_branch -- 核心交易机构编号
    ,approval_no -- 审批单号
    ,narrative_code -- 摘要码
    ,extra_tran_timestamp -- 反洗钱加工时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reason_code -- 账户用途
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,acct_nature -- 存款账户类型
    ,company -- 法人
    ,inform_bank_flag -- 是否通知人行
    ,is_self -- 视同本人标志
    ,narrative -- 摘要
    ,op_method -- 开销户操作方式
    ,reason_code_desc -- 原因代码描述
    ,reg_type -- 登记类型
    ,seq_no -- 序号
    ,suc_flag -- 社会统一信用代码标志
    ,active_date -- 激活日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,open_branch -- 开立机构
    ,tran_branch -- 核心交易机构编号
    ,approval_no -- 审批单号
    ,narrative_code -- 摘要码
    ,extra_tran_timestamp -- 反洗钱加工时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_open_close_reg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_open_close_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_open_close_reg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_open_close_reg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_open_close_reg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_open_close_reg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);