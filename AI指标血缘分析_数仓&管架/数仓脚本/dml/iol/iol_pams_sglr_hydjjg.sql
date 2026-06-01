/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_sglr_hydjjg
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
create table ${iol_schema}.pams_sglr_hydjjg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_sglr_hydjjg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_sglr_hydjjg_op purge;
drop table ${iol_schema}.pams_sglr_hydjjg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_sglr_hydjjg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_sglr_hydjjg where 0=1;

create table ${iol_schema}.pams_sglr_hydjjg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_sglr_hydjjg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_sglr_hydjjg_cl(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,fhdh -- 分行代号
            ,fhmc -- 分行名称
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,djbh -- 等级编号
            ,zxmc -- 职衔名称
            ,djmc -- 等级名称
            ,yxqsrq -- 有效起始日期
            ,yxjsrq -- 有效结束日期
            ,czr -- 操作人代号
            ,czsj -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_sglr_hydjjg_op(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,fhdh -- 分行代号
            ,fhmc -- 分行名称
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,djbh -- 等级编号
            ,zxmc -- 职衔名称
            ,djmc -- 等级名称
            ,yxqsrq -- 有效起始日期
            ,yxjsrq -- 有效结束日期
            ,czr -- 操作人代号
            ,czsj -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.hymc, o.hymc) as hymc -- 行员名称
    ,nvl(n.fhdh, o.fhdh) as fhdh -- 分行代号
    ,nvl(n.fhmc, o.fhmc) as fhmc -- 分行名称
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.jgmc, o.jgmc) as jgmc -- 机构名称
    ,nvl(n.djbh, o.djbh) as djbh -- 等级编号
    ,nvl(n.zxmc, o.zxmc) as zxmc -- 职衔名称
    ,nvl(n.djmc, o.djmc) as djmc -- 等级名称
    ,nvl(n.yxqsrq, o.yxqsrq) as yxqsrq -- 有效起始日期
    ,nvl(n.yxjsrq, o.yxjsrq) as yxjsrq -- 有效结束日期
    ,nvl(n.czr, o.czr) as czr -- 操作人代号
    ,nvl(n.czsj, o.czsj) as czsj -- 操作时间
    ,case when
            n.khdxdh is null
            and n.yxqsrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.khdxdh is null
            and n.yxqsrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.khdxdh is null
            and n.yxqsrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_sglr_hydjjg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_sglr_hydjjg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.khdxdh = n.khdxdh
            and o.yxqsrq = n.yxqsrq
where (
        o.khdxdh is null
        and o.yxqsrq is null
    )
    or (
        n.khdxdh is null
        and n.yxqsrq is null
    )
    or (
        o.hydh <> n.hydh
        or o.hymc <> n.hymc
        or o.fhdh <> n.fhdh
        or o.fhmc <> n.fhmc
        or o.jgdh <> n.jgdh
        or o.jgmc <> n.jgmc
        or o.djbh <> n.djbh
        or o.zxmc <> n.zxmc
        or o.djmc <> n.djmc
        or o.yxjsrq <> n.yxjsrq
        or o.czr <> n.czr
        or o.czsj <> n.czsj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_sglr_hydjjg_cl(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,fhdh -- 分行代号
            ,fhmc -- 分行名称
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,djbh -- 等级编号
            ,zxmc -- 职衔名称
            ,djmc -- 等级名称
            ,yxqsrq -- 有效起始日期
            ,yxjsrq -- 有效结束日期
            ,czr -- 操作人代号
            ,czsj -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_sglr_hydjjg_op(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,fhdh -- 分行代号
            ,fhmc -- 分行名称
            ,jgdh -- 机构代号
            ,jgmc -- 机构名称
            ,djbh -- 等级编号
            ,zxmc -- 职衔名称
            ,djmc -- 等级名称
            ,yxqsrq -- 有效起始日期
            ,yxjsrq -- 有效结束日期
            ,czr -- 操作人代号
            ,czsj -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khdxdh -- 考核对象代号
    ,o.hydh -- 行员代号
    ,o.hymc -- 行员名称
    ,o.fhdh -- 分行代号
    ,o.fhmc -- 分行名称
    ,o.jgdh -- 机构代号
    ,o.jgmc -- 机构名称
    ,o.djbh -- 等级编号
    ,o.zxmc -- 职衔名称
    ,o.djmc -- 等级名称
    ,o.yxqsrq -- 有效起始日期
    ,o.yxjsrq -- 有效结束日期
    ,o.czr -- 操作人代号
    ,o.czsj -- 操作时间
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
from ${iol_schema}.pams_sglr_hydjjg_bk o
    left join ${iol_schema}.pams_sglr_hydjjg_op n
        on
            o.khdxdh = n.khdxdh
            and o.yxqsrq = n.yxqsrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_sglr_hydjjg_cl d
        on
            o.khdxdh = d.khdxdh
            and o.yxqsrq = d.yxqsrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_sglr_hydjjg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_sglr_hydjjg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_sglr_hydjjg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_sglr_hydjjg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_sglr_hydjjg exchange partition p_${batch_date} with table ${iol_schema}.pams_sglr_hydjjg_cl;
alter table ${iol_schema}.pams_sglr_hydjjg exchange partition p_20991231 with table ${iol_schema}.pams_sglr_hydjjg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_sglr_hydjjg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_sglr_hydjjg_op purge;
drop table ${iol_schema}.pams_sglr_hydjjg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_sglr_hydjjg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_sglr_hydjjg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
