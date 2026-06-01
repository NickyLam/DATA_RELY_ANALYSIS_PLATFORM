/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_inoutbusiclass
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
create table ${iol_schema}.iers_bd_inoutbusiclass_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_inoutbusiclass
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_inoutbusiclass_op purge;
drop table ${iol_schema}.iers_bd_inoutbusiclass_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_inoutbusiclass_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_inoutbusiclass where 0=1;

create table ${iol_schema}.iers_bd_inoutbusiclass_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_inoutbusiclass where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_inoutbusiclass_cl(
            code -- 收支项目编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 收支项目名称
            ,name2 -- 收支项目名称2
            ,name3 -- 收支项目名称3
            ,name4 -- 收支项目名称4
            ,name5 -- 收支项目名称5
            ,name6 -- 收支项目名称6
            ,pk_group -- 所属集团
            ,pk_inoutbusiclass -- 收支项目主键
            ,pk_org -- 所属组织
            ,pk_parent -- 上级收支项目
            ,seq -- 内部编码序号
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_inoutbusiclass_op(
            code -- 收支项目编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 收支项目名称
            ,name2 -- 收支项目名称2
            ,name3 -- 收支项目名称3
            ,name4 -- 收支项目名称4
            ,name5 -- 收支项目名称5
            ,name6 -- 收支项目名称6
            ,pk_group -- 所属集团
            ,pk_inoutbusiclass -- 收支项目主键
            ,pk_org -- 所属组织
            ,pk_parent -- 上级收支项目
            ,seq -- 内部编码序号
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.code, o.code) as code -- 收支项目编码
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 数据来源
    ,nvl(n.def1, o.def1) as def1 -- 自定义项1
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def3, o.def3) as def3 -- 自定义项3
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.innercode, o.innercode) as innercode -- 内部编码
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 助记码
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 收支项目名称
    ,nvl(n.name2, o.name2) as name2 -- 收支项目名称2
    ,nvl(n.name3, o.name3) as name3 -- 收支项目名称3
    ,nvl(n.name4, o.name4) as name4 -- 收支项目名称4
    ,nvl(n.name5, o.name5) as name5 -- 收支项目名称5
    ,nvl(n.name6, o.name6) as name6 -- 收支项目名称6
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_inoutbusiclass, o.pk_inoutbusiclass) as pk_inoutbusiclass -- 收支项目主键
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_parent, o.pk_parent) as pk_parent -- 上级收支项目
    ,nvl(n.seq, o.seq) as seq -- 内部编码序号
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_inoutbusiclass is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_inoutbusiclass is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_inoutbusiclass is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_inoutbusiclass_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_inoutbusiclass where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_inoutbusiclass = n.pk_inoutbusiclass
where (
        o.pk_inoutbusiclass is null
    )
    or (
        n.pk_inoutbusiclass is null
    )
    or (
        o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def2 <> n.def2
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.innercode <> n.innercode
        or o.memo <> n.memo
        or o.mnecode <> n.mnecode
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_parent <> n.pk_parent
        or o.seq <> n.seq
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_inoutbusiclass_cl(
            code -- 收支项目编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 收支项目名称
            ,name2 -- 收支项目名称2
            ,name3 -- 收支项目名称3
            ,name4 -- 收支项目名称4
            ,name5 -- 收支项目名称5
            ,name6 -- 收支项目名称6
            ,pk_group -- 所属集团
            ,pk_inoutbusiclass -- 收支项目主键
            ,pk_org -- 所属组织
            ,pk_parent -- 上级收支项目
            ,seq -- 内部编码序号
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_inoutbusiclass_op(
            code -- 收支项目编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,def1 -- 自定义项1
            ,def2 -- 自定义项2
            ,def3 -- 自定义项3
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,innercode -- 内部编码
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 收支项目名称
            ,name2 -- 收支项目名称2
            ,name3 -- 收支项目名称3
            ,name4 -- 收支项目名称4
            ,name5 -- 收支项目名称5
            ,name6 -- 收支项目名称6
            ,pk_group -- 所属集团
            ,pk_inoutbusiclass -- 收支项目主键
            ,pk_org -- 所属组织
            ,pk_parent -- 上级收支项目
            ,seq -- 内部编码序号
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 收支项目编码
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dataoriginflag -- 数据来源
    ,o.def1 -- 自定义项1
    ,o.def2 -- 自定义项2
    ,o.def3 -- 自定义项3
    ,o.def4 -- 自定义项4
    ,o.def5 -- 自定义项5
    ,o.dr -- 删除标志
    ,o.enablestate -- 启用状态
    ,o.innercode -- 内部编码
    ,o.memo -- 备注
    ,o.mnecode -- 助记码
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 收支项目名称
    ,o.name2 -- 收支项目名称2
    ,o.name3 -- 收支项目名称3
    ,o.name4 -- 收支项目名称4
    ,o.name5 -- 收支项目名称5
    ,o.name6 -- 收支项目名称6
    ,o.pk_group -- 所属集团
    ,o.pk_inoutbusiclass -- 收支项目主键
    ,o.pk_org -- 所属组织
    ,o.pk_parent -- 上级收支项目
    ,o.seq -- 内部编码序号
    ,o.ts -- 时间戳
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
from ${iol_schema}.iers_bd_inoutbusiclass_bk o
    left join ${iol_schema}.iers_bd_inoutbusiclass_op n
        on
            o.pk_inoutbusiclass = n.pk_inoutbusiclass
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_inoutbusiclass_cl d
        on
            o.pk_inoutbusiclass = d.pk_inoutbusiclass
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_inoutbusiclass;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_inoutbusiclass') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_inoutbusiclass drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_inoutbusiclass add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_inoutbusiclass exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_inoutbusiclass_cl;
alter table ${iol_schema}.iers_bd_inoutbusiclass exchange partition p_20991231 with table ${iol_schema}.iers_bd_inoutbusiclass_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_inoutbusiclass to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_inoutbusiclass_op purge;
drop table ${iol_schema}.iers_bd_inoutbusiclass_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_inoutbusiclass_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_inoutbusiclass',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
