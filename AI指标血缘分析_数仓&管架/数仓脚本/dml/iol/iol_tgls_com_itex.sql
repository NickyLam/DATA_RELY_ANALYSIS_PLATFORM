/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_itex
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
create table ${iol_schema}.tgls_com_itex_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_itex
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_itex_op purge;
drop table ${iol_schema}.tgls_com_itex_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_itex_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_itex where 0=1;

create table ${iol_schema}.tgls_com_itex_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_itex where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_itex_cl(
            stacid -- 账套标记
            ,assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
            ,acexcd -- 辅助核算项代码
            ,acexna -- 辅助核算项名称
            ,valide -- 有效状态位
            ,fromdt -- 启用日期
            ,pscope -- 级别
            ,ordeid -- 序号
            ,desctx -- 变量说明
            ,userst -- 使用状态（0未使用，1已使用）
            ,defavl -- 默认值
            ,istkcl -- 是否参与核算0不参与1参与
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_itex_op(
            stacid -- 账套标记
            ,assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
            ,acexcd -- 辅助核算项代码
            ,acexna -- 辅助核算项名称
            ,valide -- 有效状态位
            ,fromdt -- 启用日期
            ,pscope -- 级别
            ,ordeid -- 序号
            ,desctx -- 变量说明
            ,userst -- 使用状态（0未使用，1已使用）
            ,defavl -- 默认值
            ,istkcl -- 是否参与核算0不参与1参与
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.assimp, o.assimp) as assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
    ,nvl(n.acexcd, o.acexcd) as acexcd -- 辅助核算项代码
    ,nvl(n.acexna, o.acexna) as acexna -- 辅助核算项名称
    ,nvl(n.valide, o.valide) as valide -- 有效状态位
    ,nvl(n.fromdt, o.fromdt) as fromdt -- 启用日期
    ,nvl(n.pscope, o.pscope) as pscope -- 级别
    ,nvl(n.ordeid, o.ordeid) as ordeid -- 序号
    ,nvl(n.desctx, o.desctx) as desctx -- 变量说明
    ,nvl(n.userst, o.userst) as userst -- 使用状态（0未使用，1已使用）
    ,nvl(n.defavl, o.defavl) as defavl -- 默认值
    ,nvl(n.istkcl, o.istkcl) as istkcl -- 是否参与核算0不参与1参与
    ,case when
            n.stacid is null
            and n.assimp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.assimp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.assimp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_itex_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_itex where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.assimp = n.assimp
where (
        o.stacid is null
        and o.assimp is null
    )
    or (
        n.stacid is null
        and n.assimp is null
    )
    or (
        o.acexcd <> n.acexcd
        or o.acexna <> n.acexna
        or o.valide <> n.valide
        or o.fromdt <> n.fromdt
        or o.pscope <> n.pscope
        or o.ordeid <> n.ordeid
        or o.desctx <> n.desctx
        or o.userst <> n.userst
        or o.defavl <> n.defavl
        or o.istkcl <> n.istkcl
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_itex_cl(
            stacid -- 账套标记
            ,assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
            ,acexcd -- 辅助核算项代码
            ,acexna -- 辅助核算项名称
            ,valide -- 有效状态位
            ,fromdt -- 启用日期
            ,pscope -- 级别
            ,ordeid -- 序号
            ,desctx -- 变量说明
            ,userst -- 使用状态（0未使用，1已使用）
            ,defavl -- 默认值
            ,istkcl -- 是否参与核算0不参与1参与
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_itex_op(
            stacid -- 账套标记
            ,assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
            ,acexcd -- 辅助核算项代码
            ,acexna -- 辅助核算项名称
            ,valide -- 有效状态位
            ,fromdt -- 启用日期
            ,pscope -- 级别
            ,ordeid -- 序号
            ,desctx -- 变量说明
            ,userst -- 使用状态（0未使用，1已使用）
            ,defavl -- 默认值
            ,istkcl -- 是否参与核算0不参与1参与
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.assimp -- 对应的自定义项（assis0、assis1、assis2、assis3、assis4、assis5、assis6、assis7、assis8、assis9）
    ,o.acexcd -- 辅助核算项代码
    ,o.acexna -- 辅助核算项名称
    ,o.valide -- 有效状态位
    ,o.fromdt -- 启用日期
    ,o.pscope -- 级别
    ,o.ordeid -- 序号
    ,o.desctx -- 变量说明
    ,o.userst -- 使用状态（0未使用，1已使用）
    ,o.defavl -- 默认值
    ,o.istkcl -- 是否参与核算0不参与1参与
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
from ${iol_schema}.tgls_com_itex_bk o
    left join ${iol_schema}.tgls_com_itex_op n
        on
            o.stacid = n.stacid
            and o.assimp = n.assimp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_itex_cl d
        on
            o.stacid = d.stacid
            and o.assimp = d.assimp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_itex;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_itex') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_itex drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_itex add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_itex exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_itex_cl;
alter table ${iol_schema}.tgls_com_itex exchange partition p_20991231 with table ${iol_schema}.tgls_com_itex_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_itex to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_itex_op purge;
drop table ${iol_schema}.tgls_com_itex_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_itex_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_itex',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
