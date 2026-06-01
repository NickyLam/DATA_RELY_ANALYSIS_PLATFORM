/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_grade_a_score_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_grade_a_score_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_grade_a_score_detail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_a_score_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_grade_a_score_detail where 0=1;

create table ${iol_schema}.rcds_ir_grade_a_score_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_grade_a_score_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_grade_a_score_detail_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,mode_type -- 评分模型类型
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,var_name -- 变量名称
            ,var_desc -- 变量描述
            ,var_value -- 变量取值
            ,grade -- 评分
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_grade_a_score_detail_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,mode_type -- 评分模型类型
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,var_name -- 变量名称
            ,var_desc -- 变量描述
            ,var_value -- 变量取值
            ,grade -- 评分
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.mode_type, o.mode_type) as mode_type -- 评分模型类型
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.var_name, o.var_name) as var_name -- 变量名称
    ,nvl(n.var_desc, o.var_desc) as var_desc -- 变量描述
    ,nvl(n.var_value, o.var_value) as var_value -- 变量取值
    ,nvl(n.grade, o.grade) as grade -- 评分
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_grade_a_score_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_grade_a_score_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.grade_key_id <> n.grade_key_id
        or o.mode_type <> n.mode_type
        or o.data_time <> n.data_time
        or o.serialno <> n.serialno
        or o.var_name <> n.var_name
        or o.var_desc <> n.var_desc
        or o.var_value <> n.var_value
        or o.grade <> n.grade
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_grade_a_score_detail_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,mode_type -- 评分模型类型
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,var_name -- 变量名称
            ,var_desc -- 变量描述
            ,var_value -- 变量取值
            ,grade -- 评分
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_grade_a_score_detail_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,mode_type -- 评分模型类型
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,var_name -- 变量名称
            ,var_desc -- 变量描述
            ,var_value -- 变量取值
            ,grade -- 评分
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.grade_key_id -- 申请评分流水号
    ,o.mode_type -- 评分模型类型
    ,o.data_time -- 数据记录时间
    ,o.serialno -- 申请流水号
    ,o.var_name -- 变量名称
    ,o.var_desc -- 变量描述
    ,o.var_value -- 变量取值
    ,o.grade -- 评分
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_grade_a_score_detail_bk o
    left join ${iol_schema}.rcds_ir_grade_a_score_detail_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_grade_a_score_detail_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_grade_a_score_detail;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_grade_a_score_detail exchange partition p_19000101 with table ${iol_schema}.rcds_ir_grade_a_score_detail_cl;
alter table ${iol_schema}.rcds_ir_grade_a_score_detail exchange partition p_20991231 with table ${iol_schema}.rcds_ir_grade_a_score_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_grade_a_score_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_grade_a_score_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
