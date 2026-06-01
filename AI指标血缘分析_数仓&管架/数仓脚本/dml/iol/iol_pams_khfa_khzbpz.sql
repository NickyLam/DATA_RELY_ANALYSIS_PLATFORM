/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khfa_khzbpz
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
drop table ${iol_schema}.pams_khfa_khzbpz_ex purge;
alter table ${iol_schema}.pams_khfa_khzbpz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_khfa_khzbpz;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_khfa_khzbpz_ex nologging
compress
as
select * from ${iol_schema}.pams_khfa_khzbpz where 0=1;

insert /*+ append */ into ${iol_schema}.pams_khfa_khzbpz_ex(
    fabh -- 方案编号
    ,khzbdh -- 考核指标代号
    ,wdmc -- 维度名称
    ,wdqz -- 维度权重
    ,zbqz -- 指标权重
    ,jldw -- 计量单位
    ,bdz -- 
    ,fdz -- 
    ,mbbh -- 模板编号
    ,qjlx -- 
    ,jsfs -- 
    ,xh -- 序号
    ,tlbl -- 提留比例
    ,tjcx -- 统计程序
    ,xmmc -- 项目名称
    ,zswdqz -- 
    ,zszbqz -- 折算指标权重
    ,pjbh -- 评价编号
    ,khnr -- 考核内容
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    fabh -- 方案编号
    ,khzbdh -- 考核指标代号
    ,wdmc -- 维度名称
    ,wdqz -- 维度权重
    ,zbqz -- 指标权重
    ,jldw -- 计量单位
    ,bdz -- 
    ,fdz -- 
    ,mbbh -- 模板编号
    ,qjlx -- 
    ,jsfs -- 
    ,xh -- 序号
    ,tlbl -- 提留比例
    ,tjcx -- 统计程序
    ,xmmc -- 项目名称
    ,zswdqz -- 
    ,zszbqz -- 折算指标权重
    ,pjbh -- 评价编号
    ,khnr -- 考核内容
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_khfa_khzbpz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_khfa_khzbpz exchange partition p_${batch_date} with table ${iol_schema}.pams_khfa_khzbpz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khfa_khzbpz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_khfa_khzbpz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khfa_khzbpz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);