/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khfa_fapz
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
drop table ${iol_schema}.pams_khfa_fapz_ex purge;
alter table ${iol_schema}.pams_khfa_fapz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_khfa_fapz;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_khfa_fapz_ex nologging
compress
as
select * from ${iol_schema}.pams_khfa_fapz where 0=1;

insert /*+ append */ into ${iol_schema}.pams_khfa_fapz_ex(
    fabh -- 方案编号
    ,famc -- 方案名称
    ,khnf -- 考核年份
    ,khdx -- 考核对象：1-机构，2-行员
    ,pzms -- 配置模式
    ,jglb -- 机构类别
    ,hylb -- 行员类别
    ,khzq -- 考核周期
    ,khqs -- 考核期数
    ,yyzlbh -- 应用种类编号
    ,yybzz -- 应用标准分
    ,yysx -- 应用上限分
    ,yyxx -- 应用下限分
    ,zt -- 状态
    ,czr -- 操作人
    ,czsj -- 操作时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    fabh -- 方案编号
    ,famc -- 方案名称
    ,khnf -- 考核年份
    ,khdx -- 考核对象：1-机构，2-行员
    ,pzms -- 配置模式
    ,jglb -- 机构类别
    ,hylb -- 行员类别
    ,khzq -- 考核周期
    ,khqs -- 考核期数
    ,yyzlbh -- 应用种类编号
    ,yybzz -- 应用标准分
    ,yysx -- 应用上限分
    ,yyxx -- 应用下限分
    ,zt -- 状态
    ,czr -- 操作人
    ,czsj -- 操作时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_khfa_fapz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_khfa_fapz exchange partition p_${batch_date} with table ${iol_schema}.pams_khfa_fapz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khfa_fapz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_khfa_fapz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khfa_fapz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);