/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_stb
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_isbs_stb drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_stb drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_stb add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_stb partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,tbl  -- 参数代码
    ,uil  -- 语种
    ,cod  -- 参数值
    ,txt  -- 注释
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.tbl,chr(13),''),chr(10),'')  -- 参数代码
    ,replace(replace(t1.uil,chr(13),''),chr(10),'')  -- 语种
    ,replace(replace(t1.cod,chr(13),''),chr(10),'')  -- 参数值
    ,replace(replace(t1.txt,chr(13),''),chr(10),'')  -- 注释
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_stb t1    --codetable内容
where t1.etl_dt =to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_stb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);