/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_sys_cond
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
create table ${iol_schema}.tgls_sys_cond_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_sys_cond
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_cond_op purge;
drop table ${iol_schema}.tgls_sys_cond_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_cond_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_cond where 0=1;

create table ${iol_schema}.tgls_sys_cond_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_cond where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_cond_cl(
            condcd -- 条件码
            ,condtp -- 条件码类型
            ,condna -- 条件名称
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 模块
            ,projcd -- 项目编号
            ,formul -- 执行条件公式
            ,formna -- 执行条件公式名称
            ,stacid -- 账套
            ,fumodu -- 所属功能模块,0：会计引擎1：会计计量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_cond_op(
            condcd -- 条件码
            ,condtp -- 条件码类型
            ,condna -- 条件名称
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 模块
            ,projcd -- 项目编号
            ,formul -- 执行条件公式
            ,formna -- 执行条件公式名称
            ,stacid -- 账套
            ,fumodu -- 所属功能模块,0：会计引擎1：会计计量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.condcd, o.condcd) as condcd -- 条件码
    ,nvl(n.condtp, o.condtp) as condtp -- 条件码类型
    ,nvl(n.condna, o.condna) as condna -- 条件名称
    ,nvl(n.desctx, o.desctx) as desctx -- 说明
    ,nvl(n.vermod, o.vermod) as vermod -- 版本模式
    ,nvl(n.module, o.module) as module -- 模块
    ,nvl(n.projcd, o.projcd) as projcd -- 项目编号
    ,nvl(n.formul, o.formul) as formul -- 执行条件公式
    ,nvl(n.formna, o.formna) as formna -- 执行条件公式名称
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.fumodu, o.fumodu) as fumodu -- 所属功能模块,0：会计引擎1：会计计量
    ,case when
            n.condcd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.condcd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.condcd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_sys_cond_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_sys_cond where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.condcd = n.condcd
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
where (
        o.condcd is null
        and o.vermod is null
        and o.projcd is null
        and o.stacid is null
    )
    or (
        n.condcd is null
        and n.vermod is null
        and n.projcd is null
        and n.stacid is null
    )
    or (
        o.condtp <> n.condtp
        or o.condna <> n.condna
        or o.desctx <> n.desctx
        or o.module <> n.module
        or o.formul <> n.formul
        or o.formna <> n.formna
        or o.fumodu <> n.fumodu
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_cond_cl(
            condcd -- 条件码
            ,condtp -- 条件码类型
            ,condna -- 条件名称
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 模块
            ,projcd -- 项目编号
            ,formul -- 执行条件公式
            ,formna -- 执行条件公式名称
            ,stacid -- 账套
            ,fumodu -- 所属功能模块,0：会计引擎1：会计计量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_cond_op(
            condcd -- 条件码
            ,condtp -- 条件码类型
            ,condna -- 条件名称
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 模块
            ,projcd -- 项目编号
            ,formul -- 执行条件公式
            ,formna -- 执行条件公式名称
            ,stacid -- 账套
            ,fumodu -- 所属功能模块,0：会计引擎1：会计计量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.condcd -- 条件码
    ,o.condtp -- 条件码类型
    ,o.condna -- 条件名称
    ,o.desctx -- 说明
    ,o.vermod -- 版本模式
    ,o.module -- 模块
    ,o.projcd -- 项目编号
    ,o.formul -- 执行条件公式
    ,o.formna -- 执行条件公式名称
    ,o.stacid -- 账套
    ,o.fumodu -- 所属功能模块,0：会计引擎1：会计计量
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
from ${iol_schema}.tgls_sys_cond_bk o
    left join ${iol_schema}.tgls_sys_cond_op n
        on
            o.condcd = n.condcd
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_sys_cond_cl d
        on
            o.condcd = d.condcd
            and o.vermod = d.vermod
            and o.projcd = d.projcd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_sys_cond;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_sys_cond') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_sys_cond drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_sys_cond add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_sys_cond exchange partition p_${batch_date} with table ${iol_schema}.tgls_sys_cond_cl;
alter table ${iol_schema}.tgls_sys_cond exchange partition p_20991231 with table ${iol_schema}.tgls_sys_cond_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_sys_cond to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_cond_op purge;
drop table ${iol_schema}.tgls_sys_cond_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_sys_cond_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_sys_cond',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
