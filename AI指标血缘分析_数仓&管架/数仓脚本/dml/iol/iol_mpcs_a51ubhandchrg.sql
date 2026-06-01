/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubhandchrg
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
drop table ${iol_schema}.mpcs_a51ubhandchrg_ex purge;
alter table ${iol_schema}.mpcs_a51ubhandchrg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a51ubhandchrg truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubhandchrg_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubhandchrg where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubhandchrg_ex(
    trandate -- 交易日期
    ,trantype -- 交易方类型:I : 发卡方A : 受理方
    ,tranflag -- 交易类型1 : ATM2 : 柜面通3 : POS
    ,brnnbr -- 机构号
    ,tranamt -- 应付金额
    ,recvamt -- 应收金额
    ,uniodate -- 前置日期
    ,unionbr -- 前置流水
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,status -- 状态0 : 失效状态1 : 交易成功2 : 已冲正
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,tranexamt -- 应付交换费
    ,recvexamt -- 应收交换费
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trandate -- 交易日期
    ,trantype -- 交易方类型:I : 发卡方A : 受理方
    ,tranflag -- 交易类型1 : ATM2 : 柜面通3 : POS
    ,brnnbr -- 机构号
    ,tranamt -- 应付金额
    ,recvamt -- 应收金额
    ,uniodate -- 前置日期
    ,unionbr -- 前置流水
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,status -- 状态0 : 失效状态1 : 交易成功2 : 已冲正
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,tranexamt -- 应付交换费
    ,recvexamt -- 应收交换费
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubhandchrg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a51ubhandchrg exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a51ubhandchrg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubhandchrg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubhandchrg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubhandchrg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);