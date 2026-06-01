/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zfldspd_zjb_cksy_xy
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
create table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op purge;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy where 0=1;

create table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,cksybl -- 存款收益比例(%)
            ,khmc -- 对应客户名称
            ,jbr -- 经办人
            ,cjrq -- 创建日期
            ,jlsj -- 记录时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,cksybl -- 存款收益比例(%)
            ,khmc -- 对应客户名称
            ,jbr -- 经办人
            ,cjrq -- 创建日期
            ,jlsj -- 记录时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.cksybl, o.cksybl) as cksybl -- 存款收益比例(%)
    ,nvl(n.khmc, o.khmc) as khmc -- 对应客户名称
    ,nvl(n.jbr, o.jbr) as jbr -- 经办人
    ,nvl(n.cjrq, o.cjrq) as cjrq -- 创建日期
    ,nvl(n.jlsj, o.jlsj) as jlsj -- 记录时间
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_zfldspd_zjb_cksy_xy where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tjrq = n.tjrq
            and o.jxdxdh = n.jxdxdh
            and o.khh = n.khh
where (
        o.tjrq is null
        and o.jxdxdh is null
        and o.khh is null
    )
    or (
        n.tjrq is null
        and n.jxdxdh is null
        and n.khh is null
    )
    or (
        o.cksybl <> n.cksybl
        or o.khmc <> n.khmc
        or o.jbr <> n.jbr
        or o.cjrq <> n.cjrq
        or o.jlsj <> n.jlsj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,cksybl -- 存款收益比例(%)
            ,khmc -- 对应客户名称
            ,jbr -- 经办人
            ,cjrq -- 创建日期
            ,jlsj -- 记录时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,cksybl -- 存款收益比例(%)
            ,khmc -- 对应客户名称
            ,jbr -- 经办人
            ,cjrq -- 创建日期
            ,jlsj -- 记录时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tjrq -- 统计日期
    ,o.jxdxdh -- 绩效对象代号
    ,o.khh -- 客户号
    ,o.cksybl -- 存款收益比例(%)
    ,o.khmc -- 对应客户名称
    ,o.jbr -- 经办人
    ,o.cjrq -- 创建日期
    ,o.jlsj -- 记录时间
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
from ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_bk o
    left join ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op n
        on
            o.tjrq = n.tjrq
            and o.jxdxdh = n.jxdxdh
            and o.khh = n.khh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl d
        on
            o.tjrq = d.tjrq
            and o.jxdxdh = d.jxdxdh
            and o.khh = d.khh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_zfldspd_zjb_cksy_xy') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl;
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_op purge;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zfldspd_zjb_cksy_xy',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
