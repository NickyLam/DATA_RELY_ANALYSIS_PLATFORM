/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_grade_a_score_result
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
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_grade_a_score_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_grade_a_score_result;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_result_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_a_score_result_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.rcds_ir_grade_a_score_result where 0=1;

create table ${iol_schema}.rcds_ir_grade_a_score_result_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.rcds_ir_grade_a_score_result where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.rcds_ir_grade_a_score_result_op(
        grade_key_id -- 申请评分流水号
        ,serialno -- 申请流水号
        ,data_time -- 数据记录时间
        ,rist_level -- 风险等级
        ,grade -- 总评分
        ,mode_type -- 评分模型类型
        ,cus_name -- 客户号码
        ,prd_code -- 产品编号
        ,customerid -- 客户证件号码
        ,input_br_id -- 所属机构
        ,input_br_id_all -- 所属机构(所有)
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.grade_key_id -- 申请评分流水号
    ,n.serialno -- 申请流水号
    ,n.data_time -- 数据记录时间
    ,n.rist_level -- 风险等级
    ,n.grade -- 总评分
    ,n.mode_type -- 评分模型类型
    ,n.cus_name -- 客户号码
    ,n.prd_code -- 产品编号
    ,n.customerid -- 客户证件号码
    ,n.input_br_id -- 所属机构
    ,n.input_br_id_all -- 所属机构(所有)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_grade_a_score_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.rcds_ir_grade_a_score_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        o.serialno <> n.serialno
        or o.data_time <> n.data_time
        or o.rist_level <> n.rist_level
        or o.grade <> n.grade
        or o.mode_type <> n.mode_type
        or o.cus_name <> n.cus_name
        or o.prd_code <> n.prd_code
        or o.customerid <> n.customerid
        or o.input_br_id <> n.input_br_id
        or o.input_br_id_all <> n.input_br_id_all
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_grade_a_score_result_cl(
            grade_key_id -- 申请评分流水号
        ,serialno -- 申请流水号
        ,data_time -- 数据记录时间
        ,rist_level -- 风险等级
        ,grade -- 总评分
        ,mode_type -- 评分模型类型
        ,cus_name -- 客户号码
        ,prd_code -- 产品编号
        ,customerid -- 客户证件号码
        ,input_br_id -- 所属机构
        ,input_br_id_all -- 所属机构(所有)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_grade_a_score_result_op(
            grade_key_id -- 申请评分流水号
        ,serialno -- 申请流水号
        ,data_time -- 数据记录时间
        ,rist_level -- 风险等级
        ,grade -- 总评分
        ,mode_type -- 评分模型类型
        ,cus_name -- 客户号码
        ,prd_code -- 产品编号
        ,customerid -- 客户证件号码
        ,input_br_id -- 所属机构
        ,input_br_id_all -- 所属机构(所有)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.serialno -- 申请流水号
    ,o.data_time -- 数据记录时间
    ,o.rist_level -- 风险等级
    ,o.grade -- 总评分
    ,o.mode_type -- 评分模型类型
    ,o.cus_name -- 客户号码
    ,o.prd_code -- 产品编号
    ,o.customerid -- 客户证件号码
    ,o.input_br_id -- 所属机构
    ,o.input_br_id_all -- 所属机构(所有)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_grade_a_score_result_bk o
    left join ${iol_schema}.rcds_ir_grade_a_score_result_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rcds_ir_grade_a_score_result;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_grade_a_score_result exchange partition p_19000101 with table ${iol_schema}.rcds_ir_grade_a_score_result_cl;
alter table ${iol_schema}.rcds_ir_grade_a_score_result exchange partition p_20991231 with table ${iol_schema}.rcds_ir_grade_a_score_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_grade_a_score_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_grade_a_score_result_op purge;
drop table ${iol_schema}.rcds_ir_grade_a_score_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_grade_a_score_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_grade_a_score_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
