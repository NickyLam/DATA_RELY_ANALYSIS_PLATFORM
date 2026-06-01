/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_import_item_subtype
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
create table ${iol_schema}.ncbs_tb_import_item_subtype_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_import_item_subtype
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_import_item_subtype_op purge;
drop table ${iol_schema}.ncbs_tb_import_item_subtype_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_import_item_subtype_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_import_item_subtype where 0=1;

create table ${iol_schema}.ncbs_tb_import_item_subtype_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_import_item_subtype where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_import_item_subtype_cl(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,import_item_status -- 贵重物品状态
            ,item_subtype -- 重要物品子类型
            ,item_subtype_desc -- 物品子类型描述
            ,item_type -- 重要物品类型
            ,item_type_desc -- 物品类型描述
            ,last_item_type -- 上次修改物品类型
            ,add_date -- 新增日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,update_branch_id -- 修改机构
            ,update_user_id -- 修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_import_item_subtype_op(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,import_item_status -- 贵重物品状态
            ,item_subtype -- 重要物品子类型
            ,item_subtype_desc -- 物品子类型描述
            ,item_type -- 重要物品类型
            ,item_type_desc -- 物品类型描述
            ,last_item_type -- 上次修改物品类型
            ,add_date -- 新增日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,update_branch_id -- 修改机构
            ,update_user_id -- 修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.import_item_status, o.import_item_status) as import_item_status -- 贵重物品状态
    ,nvl(n.item_subtype, o.item_subtype) as item_subtype -- 重要物品子类型
    ,nvl(n.item_subtype_desc, o.item_subtype_desc) as item_subtype_desc -- 物品子类型描述
    ,nvl(n.item_type, o.item_type) as item_type -- 重要物品类型
    ,nvl(n.item_type_desc, o.item_type_desc) as item_type_desc -- 物品类型描述
    ,nvl(n.last_item_type, o.last_item_type) as last_item_type -- 上次修改物品类型
    ,nvl(n.add_date, o.add_date) as add_date -- 新增日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.update_branch_id, o.update_branch_id) as update_branch_id -- 修改机构
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 修改柜员
    ,case when
            n.item_subtype is null
            and n.item_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.item_subtype is null
            and n.item_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.item_subtype is null
            and n.item_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_import_item_subtype_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_import_item_subtype where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.item_subtype = n.item_subtype
            and o.item_type = n.item_type
where (
        o.item_subtype is null
        and o.item_type is null
    )
    or (
        n.item_subtype is null
        and n.item_type is null
    )
    or (
        o.branch <> n.branch
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.import_item_status <> n.import_item_status
        or o.item_subtype_desc <> n.item_subtype_desc
        or o.item_type_desc <> n.item_type_desc
        or o.last_item_type <> n.last_item_type
        or o.add_date <> n.add_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.update_date <> n.update_date
        or o.update_branch_id <> n.update_branch_id
        or o.update_user_id <> n.update_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_import_item_subtype_cl(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,import_item_status -- 贵重物品状态
            ,item_subtype -- 重要物品子类型
            ,item_subtype_desc -- 物品子类型描述
            ,item_type -- 重要物品类型
            ,item_type_desc -- 物品类型描述
            ,last_item_type -- 上次修改物品类型
            ,add_date -- 新增日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,update_branch_id -- 修改机构
            ,update_user_id -- 修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_import_item_subtype_op(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,import_item_status -- 贵重物品状态
            ,item_subtype -- 重要物品子类型
            ,item_subtype_desc -- 物品子类型描述
            ,item_type -- 重要物品类型
            ,item_type_desc -- 物品类型描述
            ,last_item_type -- 上次修改物品类型
            ,add_date -- 新增日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,update_branch_id -- 修改机构
            ,update_user_id -- 修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.import_item_status -- 贵重物品状态
    ,o.item_subtype -- 重要物品子类型
    ,o.item_subtype_desc -- 物品子类型描述
    ,o.item_type -- 重要物品类型
    ,o.item_type_desc -- 物品类型描述
    ,o.last_item_type -- 上次修改物品类型
    ,o.add_date -- 新增日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.update_date -- 更新日期
    ,o.update_branch_id -- 修改机构
    ,o.update_user_id -- 修改柜员
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
from ${iol_schema}.ncbs_tb_import_item_subtype_bk o
    left join ${iol_schema}.ncbs_tb_import_item_subtype_op n
        on
            o.item_subtype = n.item_subtype
            and o.item_type = n.item_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_import_item_subtype_cl d
        on
            o.item_subtype = d.item_subtype
            and o.item_type = d.item_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_import_item_subtype;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_import_item_subtype') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_import_item_subtype drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_import_item_subtype add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_import_item_subtype exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_import_item_subtype_cl;
alter table ${iol_schema}.ncbs_tb_import_item_subtype exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_import_item_subtype_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_import_item_subtype to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_import_item_subtype_op purge;
drop table ${iol_schema}.ncbs_tb_import_item_subtype_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_import_item_subtype_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_import_item_subtype',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
