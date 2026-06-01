/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_int_reback_book
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
drop table ${iol_schema}.ncbs_cl_int_reback_book_ex purge;
alter table ${iol_schema}.ncbs_cl_int_reback_book add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_int_reback_book truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_int_reback_book_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_int_reback_book where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_int_reback_book_ex(
    amt_type -- 金额类型
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,company -- 法人
    ,orig_seq_no -- 原交易序号
    ,receipt_no -- 回收号
    ,seq_no -- 序号
    ,status -- 状态
    ,tran_desc -- 交易描述
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,last_change_auth_user_id -- 最后操作授权柜员
    ,last_change_user_id -- 最后修改柜员
    ,loan_no -- 贷款号
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_prod_type -- 利息返还结算账户产品类型
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,company -- 法人
    ,orig_seq_no -- 原交易序号
    ,receipt_no -- 回收号
    ,seq_no -- 序号
    ,status -- 状态
    ,tran_desc -- 交易描述
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,last_change_auth_user_id -- 最后操作授权柜员
    ,last_change_user_id -- 最后修改柜员
    ,loan_no -- 贷款号
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_prod_type -- 利息返还结算账户产品类型
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_int_reback_book
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_int_reback_book exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_int_reback_book_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_int_reback_book to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_int_reback_book_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_int_reback_book',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);