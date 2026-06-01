/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_gl_dtlfreevalue
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
drop table ${iol_schema}.iers_gl_dtlfreevalue_ex purge;
alter table ${iol_schema}.iers_gl_dtlfreevalue add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.iers_gl_dtlfreevalue truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.iers_gl_dtlfreevalue_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_dtlfreevalue where 0=1;

insert /*+ append */ into ${iol_schema}.iers_gl_dtlfreevalue_ex(
    pk_dtlfreevalue -- 分录自定义项主键
    ,dr -- 删除标志
    ,freevalue1 -- 对方类型
    ,freevalue10 -- 预留字段10
    ,freevalue11 -- 预留字段11
    ,freevalue12 -- 预留字段12
    ,freevalue13 -- 预留字段13
    ,freevalue14 -- 预留字段14
    ,freevalue15 -- 预留字段15
    ,freevalue16 -- 预留字段16
    ,freevalue17 -- 预留字段17
    ,freevalue18 -- 预留字段18
    ,freevalue19 -- 预留字段19
    ,freevalue2 -- 人员
    ,freevalue20 -- 预留字段20
    ,freevalue21 -- 预留字段21
    ,freevalue22 -- 预留字段22
    ,freevalue23 -- 预留字段23
    ,freevalue24 -- 预留字段24
    ,freevalue25 -- 预留字段25
    ,freevalue26 -- 预留字段26
    ,freevalue27 -- 预留字段27
    ,freevalue28 -- 预留字段28
    ,freevalue29 -- 预留字段29
    ,freevalue3 -- 个人银行账户
    ,freevalue30 -- 预留字段30
    ,freevalue4 -- 预留字段4
    ,freevalue5 -- 供应商
    ,freevalue6 -- 供应商银行账户
    ,freevalue7 -- 预留字段7
    ,freevalue8 -- 预留字段8
    ,freevalue9 -- 预留字段9
    ,pk_detail -- 分录标识
    ,ts -- 时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pk_dtlfreevalue -- 分录自定义项主键
    ,dr -- 删除标志
    ,freevalue1 -- 对方类型
    ,freevalue10 -- 预留字段10
    ,freevalue11 -- 预留字段11
    ,freevalue12 -- 预留字段12
    ,freevalue13 -- 预留字段13
    ,freevalue14 -- 预留字段14
    ,freevalue15 -- 预留字段15
    ,freevalue16 -- 预留字段16
    ,freevalue17 -- 预留字段17
    ,freevalue18 -- 预留字段18
    ,freevalue19 -- 预留字段19
    ,freevalue2 -- 人员
    ,freevalue20 -- 预留字段20
    ,freevalue21 -- 预留字段21
    ,freevalue22 -- 预留字段22
    ,freevalue23 -- 预留字段23
    ,freevalue24 -- 预留字段24
    ,freevalue25 -- 预留字段25
    ,freevalue26 -- 预留字段26
    ,freevalue27 -- 预留字段27
    ,freevalue28 -- 预留字段28
    ,freevalue29 -- 预留字段29
    ,freevalue3 -- 个人银行账户
    ,freevalue30 -- 预留字段30
    ,freevalue4 -- 预留字段4
    ,freevalue5 -- 供应商
    ,freevalue6 -- 供应商银行账户
    ,freevalue7 -- 预留字段7
    ,freevalue8 -- 预留字段8
    ,freevalue9 -- 预留字段9
    ,pk_detail -- 分录标识
    ,ts -- 时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.iers_gl_dtlfreevalue
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.iers_gl_dtlfreevalue exchange partition p_${batch_date} with table ${iol_schema}.iers_gl_dtlfreevalue_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_gl_dtlfreevalue to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.iers_gl_dtlfreevalue_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_gl_dtlfreevalue',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);