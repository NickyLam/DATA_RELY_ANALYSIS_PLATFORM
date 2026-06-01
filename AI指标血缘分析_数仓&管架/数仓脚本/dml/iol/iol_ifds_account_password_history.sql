/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifds_account_password_history
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
drop table ${iol_schema}.ifds_account_password_history_ex purge;
alter table ${iol_schema}.ifds_account_password_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifds_account_password_history;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifds_account_password_history_ex nologging
compress
as
select * from ${iol_schema}.ifds_account_password_history where 0=1;

insert /*+ append */ into ${iol_schema}.ifds_account_password_history_ex(
    account_id -- E账户编号
    ,password_type_id -- 密码类型
    ,old_password -- 旧密码
    ,new_password -- 新密码
    ,modify_time -- 密码修改时间
    ,tran_teller_no -- 柜员
    ,tran_seq_no -- 交易流水
    ,branch_id -- 机构
    ,channel -- 渠道
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    account_id -- E账户编号
    ,password_type_id -- 密码类型
    ,old_password -- 旧密码
    ,new_password -- 新密码
    ,modify_time -- 密码修改时间
    ,tran_teller_no -- 柜员
    ,tran_seq_no -- 交易流水
    ,branch_id -- 机构
    ,channel -- 渠道
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifds_account_password_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifds_account_password_history exchange partition p_${batch_date} with table ${iol_schema}.ifds_account_password_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifds_account_password_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifds_account_password_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifds_account_password_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);