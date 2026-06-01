/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_txn_limit_detail
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
create table ${iol_schema}.ppps_t_txn_limit_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_t_txn_limit_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_txn_limit_detail_op purge;
drop table ${iol_schema}.ppps_t_txn_limit_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_limit_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_txn_limit_detail where 0=1;

create table ${iol_schema}.ppps_t_txn_limit_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_txn_limit_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_txn_limit_detail_cl(
            id -- 自增主键
            ,limit_agreement_id -- 限额协议号
            ,limit_object_id -- 限额对像id
            ,limit_template_item -- 限制模板选项
            ,item_value -- 限制类型值
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_txn_limit_detail_op(
            id -- 自增主键
            ,limit_agreement_id -- 限额协议号
            ,limit_object_id -- 限额对像id
            ,limit_template_item -- 限制模板选项
            ,item_value -- 限制类型值
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.limit_agreement_id, o.limit_agreement_id) as limit_agreement_id -- 限额协议号
    ,nvl(n.limit_object_id, o.limit_object_id) as limit_object_id -- 限额对像id
    ,nvl(n.limit_template_item, o.limit_template_item) as limit_template_item -- 限制模板选项
    ,nvl(n.item_value, o.item_value) as item_value -- 限制类型值
    ,nvl(n.remark, o.remark) as remark -- 备注信息
    ,nvl(n.create_time, o.create_time) as create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
    ,nvl(n.update_time, o.update_time) as update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
    ,case when
            n.limit_agreement_id is null
            and n.limit_template_item is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.limit_agreement_id is null
            and n.limit_template_item is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.limit_agreement_id is null
            and n.limit_template_item is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_t_txn_limit_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_t_txn_limit_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.limit_agreement_id = n.limit_agreement_id
            and o.limit_template_item = n.limit_template_item
where (
        o.limit_agreement_id is null
        and o.limit_template_item is null
    )
    or (
        n.limit_agreement_id is null
        and n.limit_template_item is null
    )
    or (
        o.id <> n.id
        or o.limit_object_id <> n.limit_object_id
        or o.item_value <> n.item_value
        or o.remark <> n.remark
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_txn_limit_detail_cl(
            id -- 自增主键
            ,limit_agreement_id -- 限额协议号
            ,limit_object_id -- 限额对像id
            ,limit_template_item -- 限制模板选项
            ,item_value -- 限制类型值
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_txn_limit_detail_op(
            id -- 自增主键
            ,limit_agreement_id -- 限额协议号
            ,limit_object_id -- 限额对像id
            ,limit_template_item -- 限制模板选项
            ,item_value -- 限制类型值
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.limit_agreement_id -- 限额协议号
    ,o.limit_object_id -- 限额对像id
    ,o.limit_template_item -- 限制模板选项
    ,o.item_value -- 限制类型值
    ,o.remark -- 备注信息
    ,o.create_time -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
    ,o.update_time -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
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
from ${iol_schema}.ppps_t_txn_limit_detail_bk o
    left join ${iol_schema}.ppps_t_txn_limit_detail_op n
        on
            o.limit_agreement_id = n.limit_agreement_id
            and o.limit_template_item = n.limit_template_item
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_t_txn_limit_detail_cl d
        on
            o.limit_agreement_id = d.limit_agreement_id
            and o.limit_template_item = d.limit_template_item
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_t_txn_limit_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_t_txn_limit_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_t_txn_limit_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_t_txn_limit_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_t_txn_limit_detail exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_txn_limit_detail_cl;
alter table ${iol_schema}.ppps_t_txn_limit_detail exchange partition p_20991231 with table ${iol_schema}.ppps_t_txn_limit_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_txn_limit_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_txn_limit_detail_op purge;
drop table ${iol_schema}.ppps_t_txn_limit_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_t_txn_limit_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_txn_limit_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
