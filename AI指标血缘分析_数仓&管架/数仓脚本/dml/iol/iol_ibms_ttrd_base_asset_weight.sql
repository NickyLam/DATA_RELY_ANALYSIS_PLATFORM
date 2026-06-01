/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_base_asset_weight
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
create table ${iol_schema}.ibms_ttrd_base_asset_weight_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_base_asset_weight
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_op purge;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_base_asset_weight_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_base_asset_weight where 0=1;

create table ${iol_schema}.ibms_ttrd_base_asset_weight_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_base_asset_weight where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_base_asset_weight_cl(
            id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,temp_id -- 模板id
            ,proportion -- 占资产总额比例
            ,top_ten_pro -- 前10大占比
            ,remark -- 备注
            ,weight -- 权重
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_base_asset_weight_op(
            id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,temp_id -- 模板id
            ,proportion -- 占资产总额比例
            ,top_ten_pro -- 前10大占比
            ,remark -- 备注
            ,weight -- 权重
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产大类
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.temp_id, o.temp_id) as temp_id -- 模板id
    ,nvl(n.proportion, o.proportion) as proportion -- 占资产总额比例
    ,nvl(n.top_ten_pro, o.top_ten_pro) as top_ten_pro -- 前10大占比
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.weight, o.weight) as weight -- 权重
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
from (select * from ${iol_schema}.ibms_ttrd_base_asset_weight_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_base_asset_weight where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.temp_id <> n.temp_id
        or o.proportion <> n.proportion
        or o.top_ten_pro <> n.top_ten_pro
        or o.remark <> n.remark
        or o.weight <> n.weight
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_base_asset_weight_cl(
            id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,temp_id -- 模板id
            ,proportion -- 占资产总额比例
            ,top_ten_pro -- 前10大占比
            ,remark -- 备注
            ,weight -- 权重
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_base_asset_weight_op(
            id -- 主键
            ,i_code -- 金融工具代码
            ,a_type -- 资产大类
            ,m_type -- 市场类型
            ,temp_id -- 模板id
            ,proportion -- 占资产总额比例
            ,top_ten_pro -- 前10大占比
            ,remark -- 备注
            ,weight -- 权重
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产大类
    ,o.m_type -- 市场类型
    ,o.temp_id -- 模板id
    ,o.proportion -- 占资产总额比例
    ,o.top_ten_pro -- 前10大占比
    ,o.remark -- 备注
    ,o.weight -- 权重
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
from ${iol_schema}.ibms_ttrd_base_asset_weight_bk o
    left join ${iol_schema}.ibms_ttrd_base_asset_weight_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_base_asset_weight_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_base_asset_weight;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_base_asset_weight') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_base_asset_weight drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_base_asset_weight add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_base_asset_weight exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_base_asset_weight_cl;
alter table ${iol_schema}.ibms_ttrd_base_asset_weight exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_base_asset_weight_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_base_asset_weight to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_op purge;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_base_asset_weight',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
