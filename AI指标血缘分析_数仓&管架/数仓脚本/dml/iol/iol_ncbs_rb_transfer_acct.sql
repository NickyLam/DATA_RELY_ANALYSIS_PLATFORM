/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_transfer_acct
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
drop table ${iol_schema}.ncbs_rb_transfer_acct_ex purge;
alter table ${iol_schema}.ncbs_rb_transfer_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_transfer_acct;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_transfer_acct_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_transfer_acct where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_transfer_acct_ex(
    base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,company -- 法人
    ,td_inout_operate_type -- 定期账户转入转出操作类型
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,in_seq_no -- 转入账户序号
    ,oper_user_id -- 操作柜员
    ,out_seq_no -- 转出账户序号
    ,tran_branch -- 核心交易机构编号
    ,transfer_in_after_acct -- 移入后账号
    ,transfer_in_befor_acct -- 移入前账号
    ,transfer_out_after_acct -- 移出后账号
    ,transfer_out_before_acct -- 移出前账号
    ,transfer_in_after_seq_no -- 移入后账户序号
    ,transfer_out_before_seq_no -- 移出前账户序号
    ,transfer_out_after_seq_no -- 移出后账户序号
    ,transfer_in_befor_seq_no -- 移入前账户序号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,company -- 法人
    ,td_inout_operate_type -- 定期账户转入转出操作类型
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,in_seq_no -- 转入账户序号
    ,oper_user_id -- 操作柜员
    ,out_seq_no -- 转出账户序号
    ,tran_branch -- 核心交易机构编号
    ,transfer_in_after_acct -- 移入后账号
    ,transfer_in_befor_acct -- 移入前账号
    ,transfer_out_after_acct -- 移出后账号
    ,transfer_out_before_acct -- 移出前账号
    ,transfer_in_after_seq_no -- 移入后账户序号
    ,transfer_out_before_seq_no -- 移出前账户序号
    ,transfer_out_after_seq_no -- 移出后账户序号
    ,transfer_in_befor_seq_no -- 移入前账户序号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_transfer_acct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_transfer_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_transfer_acct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_transfer_acct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_transfer_acct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_transfer_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);