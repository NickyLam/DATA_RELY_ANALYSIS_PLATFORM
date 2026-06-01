/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ca_product_info_publish
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
create table ${iol_schema}.nfss_ca_product_info_publish_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_ca_product_info_publish
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ca_product_info_publish_op purge;
drop table ${iol_schema}.nfss_ca_product_info_publish_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ca_product_info_publish_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ca_product_info_publish where 0=1;

create table ${iol_schema}.nfss_ca_product_info_publish_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ca_product_info_publish where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ca_product_info_publish_cl(
            id -- 主键
            ,prd_cd -- 产品编码
            ,title -- 标题
            ,content -- 内容
            ,doc_id -- 文件ID
            ,doc_name -- 文件名称
            ,doc_url -- 文件地址
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,report_period -- 报告期时间段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ca_product_info_publish_op(
            id -- 主键
            ,prd_cd -- 产品编码
            ,title -- 标题
            ,content -- 内容
            ,doc_id -- 文件ID
            ,doc_name -- 文件名称
            ,doc_url -- 文件地址
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,report_period -- 报告期时间段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.prd_cd, o.prd_cd) as prd_cd -- 产品编码
    ,nvl(n.title, o.title) as title -- 标题
    ,nvl(n.content, o.content) as content -- 内容
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 文件ID
    ,nvl(n.doc_name, o.doc_name) as doc_name -- 文件名称
    ,nvl(n.doc_url, o.doc_url) as doc_url -- 文件地址
    ,nvl(n.created_time, o.created_time) as created_time -- 创建时间
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.updated_time, o.updated_time) as updated_time -- 更新时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人
    ,nvl(n.report_period, o.report_period) as report_period -- 报告期时间段
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_ca_product_info_publish_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_ca_product_info_publish where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.prd_cd <> n.prd_cd
        or o.title <> n.title
        or o.content <> n.content
        or o.doc_id <> n.doc_id
        or o.doc_name <> n.doc_name
        or o.doc_url <> n.doc_url
        or o.created_time <> n.created_time
        or o.created_by <> n.created_by
        or o.updated_time <> n.updated_time
        or o.updated_by <> n.updated_by
        or o.report_period <> n.report_period
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ca_product_info_publish_cl(
            id -- 主键
            ,prd_cd -- 产品编码
            ,title -- 标题
            ,content -- 内容
            ,doc_id -- 文件ID
            ,doc_name -- 文件名称
            ,doc_url -- 文件地址
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,report_period -- 报告期时间段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ca_product_info_publish_op(
            id -- 主键
            ,prd_cd -- 产品编码
            ,title -- 标题
            ,content -- 内容
            ,doc_id -- 文件ID
            ,doc_name -- 文件名称
            ,doc_url -- 文件地址
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,report_period -- 报告期时间段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.prd_cd -- 产品编码
    ,o.title -- 标题
    ,o.content -- 内容
    ,o.doc_id -- 文件ID
    ,o.doc_name -- 文件名称
    ,o.doc_url -- 文件地址
    ,o.created_time -- 创建时间
    ,o.created_by -- 创建人
    ,o.updated_time -- 更新时间
    ,o.updated_by -- 更新人
    ,o.report_period -- 报告期时间段
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
from ${iol_schema}.nfss_ca_product_info_publish_bk o
    left join ${iol_schema}.nfss_ca_product_info_publish_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_ca_product_info_publish_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_ca_product_info_publish;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_ca_product_info_publish') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_ca_product_info_publish drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_ca_product_info_publish add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_ca_product_info_publish exchange partition p_${batch_date} with table ${iol_schema}.nfss_ca_product_info_publish_cl;
alter table ${iol_schema}.nfss_ca_product_info_publish exchange partition p_20991231 with table ${iol_schema}.nfss_ca_product_info_publish_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ca_product_info_publish to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ca_product_info_publish_op purge;
drop table ${iol_schema}.nfss_ca_product_info_publish_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_ca_product_info_publish_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ca_product_info_publish',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
