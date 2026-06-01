/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_judicature_file_query
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
create table ${iol_schema}.ncbs_rb_judicature_file_query_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_judicature_file_query
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_judicature_file_query_op purge;
drop table ${iol_schema}.ncbs_rb_judicature_file_query_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_judicature_file_query_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_judicature_file_query where 0=1;

create table ${iol_schema}.ncbs_rb_judicature_file_query_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_judicature_file_query where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_judicature_file_query_cl(
            file_name -- 文件名称
            ,batch_no -- 批次号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,file_error_msg -- 文件未生成错误描述
            ,query_condition -- 查询条件
            ,query_option -- 查询选项
            ,query_type -- 查询类型
            ,sub_seq_no -- 系统流水号
            ,tran_file_result -- 交易返回结果
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_judicature_file_query_op(
            file_name -- 文件名称
            ,batch_no -- 批次号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,file_error_msg -- 文件未生成错误描述
            ,query_condition -- 查询条件
            ,query_option -- 查询选项
            ,query_type -- 查询类型
            ,sub_seq_no -- 系统流水号
            ,tran_file_result -- 交易返回结果
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.file_name, o.file_name) as file_name -- 文件名称
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.file_error_msg, o.file_error_msg) as file_error_msg -- 文件未生成错误描述
    ,nvl(n.query_condition, o.query_condition) as query_condition -- 查询条件
    ,nvl(n.query_option, o.query_option) as query_option -- 查询选项
    ,nvl(n.query_type, o.query_type) as query_type -- 查询类型
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统流水号
    ,nvl(n.tran_file_result, o.tran_file_result) as tran_file_result -- 交易返回结果
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.batch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_judicature_file_query_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_judicature_file_query where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
where (
        o.batch_no is null
    )
    or (
        n.batch_no is null
    )
    or (
        o.file_name <> n.file_name
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.file_error_msg <> n.file_error_msg
        or o.query_condition <> n.query_condition
        or o.query_option <> n.query_option
        or o.query_type <> n.query_type
        or o.sub_seq_no <> n.sub_seq_no
        or o.tran_file_result <> n.tran_file_result
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_judicature_file_query_cl(
            file_name -- 文件名称
            ,batch_no -- 批次号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,file_error_msg -- 文件未生成错误描述
            ,query_condition -- 查询条件
            ,query_option -- 查询选项
            ,query_type -- 查询类型
            ,sub_seq_no -- 系统流水号
            ,tran_file_result -- 交易返回结果
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_judicature_file_query_op(
            file_name -- 文件名称
            ,batch_no -- 批次号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,file_error_msg -- 文件未生成错误描述
            ,query_condition -- 查询条件
            ,query_option -- 查询选项
            ,query_type -- 查询类型
            ,sub_seq_no -- 系统流水号
            ,tran_file_result -- 交易返回结果
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.file_name -- 文件名称
    ,o.batch_no -- 批次号
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.file_error_msg -- 文件未生成错误描述
    ,o.query_condition -- 查询条件
    ,o.query_option -- 查询选项
    ,o.query_type -- 查询类型
    ,o.sub_seq_no -- 系统流水号
    ,o.tran_file_result -- 交易返回结果
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_judicature_file_query_bk o
    left join ${iol_schema}.ncbs_rb_judicature_file_query_op n
        on
            o.batch_no = n.batch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_judicature_file_query_cl d
        on
            o.batch_no = d.batch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_judicature_file_query;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_judicature_file_query') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_judicature_file_query drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_judicature_file_query add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_judicature_file_query exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_judicature_file_query_cl;
alter table ${iol_schema}.ncbs_rb_judicature_file_query exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_judicature_file_query_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_judicature_file_query to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_judicature_file_query_op purge;
drop table ${iol_schema}.ncbs_rb_judicature_file_query_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_judicature_file_query_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_judicature_file_query',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
