/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_dxgx_hyyjgx_tyffzck
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
create table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_dxgx_hyyjgx_tyffzck
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op purge;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_dxgx_hyyjgx_tyffzck where 0=1;

create table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_dxgx_hyyjgx_tyffzck where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl(
            jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,fpjs -- 分配角色
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,gxhslx -- 关系函数类型
            ,yz -- 阈值
            ,clbl -- 存量比例
            ,zlbl -- 增量比例
            ,gxly -- 关系来源
            ,yylsh -- 预约流水号
            ,gxzt -- 关系状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op(
            jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,fpjs -- 分配角色
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,gxhslx -- 关系函数类型
            ,yz -- 阈值
            ,clbl -- 存量比例
            ,zlbl -- 增量比例
            ,gxly -- 关系来源
            ,yylsh -- 预约流水号
            ,gxzt -- 关系状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.fpjs, o.fpjs) as fpjs -- 分配角色
    ,nvl(n.qsrq, o.qsrq) as qsrq -- 起始日期
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 结束日期
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.yz, o.yz) as yz -- 阈值
    ,nvl(n.clbl, o.clbl) as clbl -- 存量比例
    ,nvl(n.zlbl, o.zlbl) as zlbl -- 增量比例
    ,nvl(n.gxly, o.gxly) as gxly -- 关系来源
    ,nvl(n.yylsh, o.yylsh) as yylsh -- 预约流水号
    ,nvl(n.gxzt, o.gxzt) as gxzt -- 关系状态
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
            and n.khdxdh is null
            and n.fpjs is null
            and n.qsrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_dxgx_hyyjgx_tyffzck where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.fpjs = n.fpjs
            and o.qsrq = n.qsrq
where (
        o.jxdxdh is null
        and o.khdxdh is null
        and o.fpjs is null
        and o.qsrq is null
    )
    or (
        n.jxdxdh is null
        and n.khdxdh is null
        and n.fpjs is null
        and n.qsrq is null
    )
    or (
        o.jsrq <> n.jsrq
        or o.gxhslx <> n.gxhslx
        or o.yz <> n.yz
        or o.clbl <> n.clbl
        or o.zlbl <> n.zlbl
        or o.gxly <> n.gxly
        or o.yylsh <> n.yylsh
        or o.gxzt <> n.gxzt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl(
            jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,fpjs -- 分配角色
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,gxhslx -- 关系函数类型
            ,yz -- 阈值
            ,clbl -- 存量比例
            ,zlbl -- 增量比例
            ,gxly -- 关系来源
            ,yylsh -- 预约流水号
            ,gxzt -- 关系状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op(
            jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,fpjs -- 分配角色
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,gxhslx -- 关系函数类型
            ,yz -- 阈值
            ,clbl -- 存量比例
            ,zlbl -- 增量比例
            ,gxly -- 关系来源
            ,yylsh -- 预约流水号
            ,gxzt -- 关系状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.khdxdh -- 考核对象代号
    ,o.fpjs -- 分配角色
    ,o.qsrq -- 起始日期
    ,o.jsrq -- 结束日期
    ,o.gxhslx -- 关系函数类型
    ,o.yz -- 阈值
    ,o.clbl -- 存量比例
    ,o.zlbl -- 增量比例
    ,o.gxly -- 关系来源
    ,o.yylsh -- 预约流水号
    ,o.gxzt -- 关系状态
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
from ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_bk o
    left join ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.fpjs = n.fpjs
            and o.qsrq = n.qsrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl d
        on
            o.jxdxdh = d.jxdxdh
            and o.khdxdh = d.khdxdh
            and o.fpjs = d.fpjs
            and o.qsrq = d.qsrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_dxgx_hyyjgx_tyffzck') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck exchange partition p_${batch_date} with table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl;
alter table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck exchange partition p_20991231 with table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_dxgx_hyyjgx_tyffzck to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_op purge;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_dxgx_hyyjgx_tyffzck_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_dxgx_hyyjgx_tyffzck',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
