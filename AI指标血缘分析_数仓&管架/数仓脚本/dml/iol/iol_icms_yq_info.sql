/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_yq_info
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
create table ${iol_schema}.icms_yq_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_yq_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_yq_info_op purge;
drop table ${iol_schema}.icms_yq_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_yq_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_yq_info where 0=1;

create table ${iol_schema}.icms_yq_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_yq_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_yq_info_cl(
            doc_id -- 文章号
            ,customer_id -- 客户id
            ,label_id -- 标签号
            ,topic_label -- 话题
            ,score -- 舆情得分
            ,publish_time -- 文章发表时间
            ,customer_name -- 客户名称
            ,update_date -- 修改日期
            ,create_date -- 记录日期
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_yq_info_op(
            doc_id -- 文章号
            ,customer_id -- 客户id
            ,label_id -- 标签号
            ,topic_label -- 话题
            ,score -- 舆情得分
            ,publish_time -- 文章发表时间
            ,customer_name -- 客户名称
            ,update_date -- 修改日期
            ,create_date -- 记录日期
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.doc_id, o.doc_id) as doc_id -- 文章号
    ,nvl(n.customer_id, o.customer_id) as customer_id -- 客户id
    ,nvl(n.label_id, o.label_id) as label_id -- 标签号
    ,nvl(n.topic_label, o.topic_label) as topic_label -- 话题
    ,nvl(n.score, o.score) as score -- 舆情得分
    ,nvl(n.publish_time, o.publish_time) as publish_time -- 文章发表时间
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户名称
    ,nvl(n.update_date, o.update_date) as update_date -- 修改日期
    ,nvl(n.create_date, o.create_date) as create_date -- 记录日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,case when
            n.doc_id is null
            and n.customer_id is null
            and n.label_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.doc_id is null
            and n.customer_id is null
            and n.label_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.doc_id is null
            and n.customer_id is null
            and n.label_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_yq_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_yq_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.doc_id = n.doc_id
            and o.customer_id = n.customer_id
            and o.label_id = n.label_id
where (
        o.doc_id is null
        and o.customer_id is null
        and o.label_id is null
    )
    or (
        n.doc_id is null
        and n.customer_id is null
        and n.label_id is null
    )
    or (
        o.topic_label <> n.topic_label
        or o.score <> n.score
        or o.publish_time <> n.publish_time
        or o.customer_name <> n.customer_name
        or o.update_date <> n.update_date
        or o.create_date <> n.create_date
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_yq_info_cl(
            doc_id -- 文章号
            ,customer_id -- 客户id
            ,label_id -- 标签号
            ,topic_label -- 话题
            ,score -- 舆情得分
            ,publish_time -- 文章发表时间
            ,customer_name -- 客户名称
            ,update_date -- 修改日期
            ,create_date -- 记录日期
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_yq_info_op(
            doc_id -- 文章号
            ,customer_id -- 客户id
            ,label_id -- 标签号
            ,topic_label -- 话题
            ,score -- 舆情得分
            ,publish_time -- 文章发表时间
            ,customer_name -- 客户名称
            ,update_date -- 修改日期
            ,create_date -- 记录日期
            ,migtflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.doc_id -- 文章号
    ,o.customer_id -- 客户id
    ,o.label_id -- 标签号
    ,o.topic_label -- 话题
    ,o.score -- 舆情得分
    ,o.publish_time -- 文章发表时间
    ,o.customer_name -- 客户名称
    ,o.update_date -- 修改日期
    ,o.create_date -- 记录日期
    ,o.migtflag -- 
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
from ${iol_schema}.icms_yq_info_bk o
    left join ${iol_schema}.icms_yq_info_op n
        on
            o.doc_id = n.doc_id
            and o.customer_id = n.customer_id
            and o.label_id = n.label_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_yq_info_cl d
        on
            o.doc_id = d.doc_id
            and o.customer_id = d.customer_id
            and o.label_id = d.label_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_yq_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_yq_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_yq_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_yq_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_yq_info exchange partition p_${batch_date} with table ${iol_schema}.icms_yq_info_cl;
alter table ${iol_schema}.icms_yq_info exchange partition p_20991231 with table ${iol_schema}.icms_yq_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_yq_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_yq_info_op purge;
drop table ${iol_schema}.icms_yq_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_yq_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_yq_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
