/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_client_merge
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
create table ${iol_schema}.ncbs_rb_client_merge_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_client_merge
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_merge_op purge;
drop table ${iol_schema}.ncbs_rb_client_merge_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_merge_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_merge where 0=1;

create table ${iol_schema}.ncbs_rb_client_merge_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_merge where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_merge_cl(
            user_id -- 交易柜员编号
            ,company -- 法人
            ,merge_flag -- 合并状态
            ,merge_no -- 合并编号
            ,merge_date -- 合并日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name_a -- 客户中文名1
            ,ch_client_name_b -- 客户中文名2
            ,client_a -- 客户a
            ,client_b -- 客户b
            ,document_type_a -- 被合并客户证件类型
            ,document_id_a -- 被合并客户证件号码
            ,document_type_b -- 合并目标客户证件类型
            ,document_id_b -- 合并目标客户证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_merge_op(
            user_id -- 交易柜员编号
            ,company -- 法人
            ,merge_flag -- 合并状态
            ,merge_no -- 合并编号
            ,merge_date -- 合并日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name_a -- 客户中文名1
            ,ch_client_name_b -- 客户中文名2
            ,client_a -- 客户a
            ,client_b -- 客户b
            ,document_type_a -- 被合并客户证件类型
            ,document_id_a -- 被合并客户证件号码
            ,document_type_b -- 合并目标客户证件类型
            ,document_id_b -- 合并目标客户证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.merge_flag, o.merge_flag) as merge_flag -- 合并状态
    ,nvl(n.merge_no, o.merge_no) as merge_no -- 合并编号
    ,nvl(n.merge_date, o.merge_date) as merge_date -- 合并日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.ch_client_name_a, o.ch_client_name_a) as ch_client_name_a -- 客户中文名1
    ,nvl(n.ch_client_name_b, o.ch_client_name_b) as ch_client_name_b -- 客户中文名2
    ,nvl(n.client_a, o.client_a) as client_a -- 客户a
    ,nvl(n.client_b, o.client_b) as client_b -- 客户b
    ,nvl(n.document_type_a, o.document_type_a) as document_type_a -- 被合并客户证件类型
    ,nvl(n.document_id_a, o.document_id_a) as document_id_a -- 被合并客户证件号码
    ,nvl(n.document_type_b, o.document_type_b) as document_type_b -- 合并目标客户证件类型
    ,nvl(n.document_id_b, o.document_id_b) as document_id_b -- 合并目标客户证件号码
    ,case when
            n.merge_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.merge_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.merge_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_client_merge_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_client_merge where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.merge_no = n.merge_no
where (
        o.merge_no is null
    )
    or (
        n.merge_no is null
    )
    or (
        o.user_id <> n.user_id
        or o.company <> n.company
        or o.merge_flag <> n.merge_flag
        or o.merge_date <> n.merge_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.ch_client_name_a <> n.ch_client_name_a
        or o.ch_client_name_b <> n.ch_client_name_b
        or o.client_a <> n.client_a
        or o.client_b <> n.client_b
        or o.document_type_a <> n.document_type_a
        or o.document_id_a <> n.document_id_a
        or o.document_type_b <> n.document_type_b
        or o.document_id_b <> n.document_id_b
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_merge_cl(
            user_id -- 交易柜员编号
            ,company -- 法人
            ,merge_flag -- 合并状态
            ,merge_no -- 合并编号
            ,merge_date -- 合并日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name_a -- 客户中文名1
            ,ch_client_name_b -- 客户中文名2
            ,client_a -- 客户a
            ,client_b -- 客户b
            ,document_type_a -- 被合并客户证件类型
            ,document_id_a -- 被合并客户证件号码
            ,document_type_b -- 合并目标客户证件类型
            ,document_id_b -- 合并目标客户证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_merge_op(
            user_id -- 交易柜员编号
            ,company -- 法人
            ,merge_flag -- 合并状态
            ,merge_no -- 合并编号
            ,merge_date -- 合并日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name_a -- 客户中文名1
            ,ch_client_name_b -- 客户中文名2
            ,client_a -- 客户a
            ,client_b -- 客户b
            ,document_type_a -- 被合并客户证件类型
            ,document_id_a -- 被合并客户证件号码
            ,document_type_b -- 合并目标客户证件类型
            ,document_id_b -- 合并目标客户证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.merge_flag -- 合并状态
    ,o.merge_no -- 合并编号
    ,o.merge_date -- 合并日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.ch_client_name_a -- 客户中文名1
    ,o.ch_client_name_b -- 客户中文名2
    ,o.client_a -- 客户a
    ,o.client_b -- 客户b
    ,o.document_type_a -- 被合并客户证件类型
    ,o.document_id_a -- 被合并客户证件号码
    ,o.document_type_b -- 合并目标客户证件类型
    ,o.document_id_b -- 合并目标客户证件号码
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
from ${iol_schema}.ncbs_rb_client_merge_bk o
    left join ${iol_schema}.ncbs_rb_client_merge_op n
        on
            o.merge_no = n.merge_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_client_merge_cl d
        on
            o.merge_no = d.merge_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_client_merge;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_client_merge') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_client_merge drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_client_merge add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_client_merge exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_client_merge_cl;
alter table ${iol_schema}.ncbs_rb_client_merge exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_client_merge_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_client_merge to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_merge_op purge;
drop table ${iol_schema}.ncbs_rb_client_merge_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_client_merge_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_client_merge',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
