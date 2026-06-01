/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a0jtpmisqrymyzlinfo
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
alter table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 中台流水号
    ,transdt  -- 交易日期
    ,modifydttm  -- 修改日期时间
    ,year_month  -- 年月
    ,currency_code  -- 币种
    ,exchange  -- 折算率
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.modifydttm,chr(13),''),chr(10),'')  -- 修改日期时间
    ,replace(replace(t1.year_month,chr(13),''),chr(10),'')  -- 年月
    ,replace(replace(t1.currency_code,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.exchange,chr(13),''),chr(10),'')  -- 折算率
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo t1    --美元折率查询表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a0jtpmisqrymyzlinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);