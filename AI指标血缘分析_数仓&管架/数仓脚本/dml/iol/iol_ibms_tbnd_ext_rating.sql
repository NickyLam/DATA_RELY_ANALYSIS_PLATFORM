/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbnd_ext_rating
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
drop table ${iol_schema}.ibms_tbnd_ext_rating_ex purge;
alter table ${iol_schema}.ibms_tbnd_ext_rating add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_tbnd_ext_rating;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_tbnd_ext_rating_ex nologging
compress
as
select * from ${iol_schema}.ibms_tbnd_ext_rating where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_tbnd_ext_rating_ex(
    i_code -- 交易代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,b_grade -- 信用评级
    ,b_rating_institution -- 主体评级
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,rating_type -- 0 外部 1内部
    ,imp_date -- 导入日期
    ,pipe_id -- 管道编号
    ,b_id -- 序号
    ,outlook -- 评级展望
    ,shadow_grade -- 影子评级
    ,b_rating_change -- 评级变动方向0.首次1.维持2.调高3.调低
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    i_code -- 交易代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,b_grade -- 信用评级
    ,b_rating_institution -- 主体评级
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,rating_type -- 0 外部 1内部
    ,imp_date -- 导入日期
    ,pipe_id -- 管道编号
    ,b_id -- 序号
    ,outlook -- 评级展望
    ,shadow_grade -- 影子评级
    ,b_rating_change -- 评级变动方向0.首次1.维持2.调高3.调低
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_tbnd_ext_rating
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_tbnd_ext_rating exchange partition p_${batch_date} with table ${iol_schema}.ibms_tbnd_ext_rating_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbnd_ext_rating to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_tbnd_ext_rating_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbnd_ext_rating',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);