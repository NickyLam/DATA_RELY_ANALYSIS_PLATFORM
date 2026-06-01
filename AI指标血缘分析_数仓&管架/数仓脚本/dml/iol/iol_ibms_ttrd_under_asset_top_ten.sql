/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_under_asset_top_ten
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
create table ${iol_schema}.ibms_ttrd_under_asset_top_ten_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_under_asset_top_ten
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten_op purge;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_under_asset_top_ten_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_under_asset_top_ten where 0=1;

create table ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_under_asset_top_ten where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl(
            id -- 主键
            ,i_code -- 产品代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,asset_code -- 资产代码
            ,asset_name -- 资产名称
            ,asset_type -- 资产类型
            ,asset_net_per -- 占资产净值比例（%）
            ,map_weight -- 映射权重
            ,g4b_field_no -- G4B栏位号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_under_asset_top_ten_op(
            id -- 主键
            ,i_code -- 产品代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,asset_code -- 资产代码
            ,asset_name -- 资产名称
            ,asset_type -- 资产类型
            ,asset_net_per -- 占资产净值比例（%）
            ,map_weight -- 映射权重
            ,g4b_field_no -- G4B栏位号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 产品代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产大类
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.asset_code, o.asset_code) as asset_code -- 资产代码
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_type, o.asset_type) as asset_type -- 资产类型
    ,nvl(n.asset_net_per, o.asset_net_per) as asset_net_per -- 占资产净值比例（%）
    ,nvl(n.map_weight, o.map_weight) as map_weight -- 映射权重
    ,nvl(n.g4b_field_no, o.g4b_field_no) as g4b_field_no -- G4B栏位号
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
from (select * from ${iol_schema}.ibms_ttrd_under_asset_top_ten_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_under_asset_top_ten where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.asset_code <> n.asset_code
        or o.asset_name <> n.asset_name
        or o.asset_type <> n.asset_type
        or o.asset_net_per <> n.asset_net_per
        or o.map_weight <> n.map_weight
        or o.g4b_field_no <> n.g4b_field_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl(
            id -- 主键
            ,i_code -- 产品代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,asset_code -- 资产代码
            ,asset_name -- 资产名称
            ,asset_type -- 资产类型
            ,asset_net_per -- 占资产净值比例（%）
            ,map_weight -- 映射权重
            ,g4b_field_no -- G4B栏位号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_under_asset_top_ten_op(
            id -- 主键
            ,i_code -- 产品代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,asset_code -- 资产代码
            ,asset_name -- 资产名称
            ,asset_type -- 资产类型
            ,asset_net_per -- 占资产净值比例（%）
            ,map_weight -- 映射权重
            ,g4b_field_no -- G4B栏位号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.i_code -- 产品代码
    ,o.a_type -- 资产大类
    ,o.m_type -- 市场类型
    ,o.asset_code -- 资产代码
    ,o.asset_name -- 资产名称
    ,o.asset_type -- 资产类型
    ,o.asset_net_per -- 占资产净值比例（%）
    ,o.map_weight -- 映射权重
    ,o.g4b_field_no -- G4B栏位号
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
from ${iol_schema}.ibms_ttrd_under_asset_top_ten_bk o
    left join ${iol_schema}.ibms_ttrd_under_asset_top_ten_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_under_asset_top_ten;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_under_asset_top_ten') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_under_asset_top_ten drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_under_asset_top_ten add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_under_asset_top_ten exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl;
alter table ${iol_schema}.ibms_ttrd_under_asset_top_ten exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_under_asset_top_ten_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_under_asset_top_ten to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten_op purge;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_under_asset_top_ten',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
