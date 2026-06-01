/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_sys_dtit_conf
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
create table ${iol_schema}.tgls_sys_dtit_conf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_sys_dtit_conf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_dtit_conf_op purge;
drop table ${iol_schema}.tgls_sys_dtit_conf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_dtit_conf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_dtit_conf where 0=1;

create table ${iol_schema}.tgls_sys_dtit_conf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_dtit_conf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_dtit_conf_cl(
            stacid -- 账套
            ,prodcd -- 产品编号
            ,prodp1 -- 产品属性组1
            ,prodp2 -- 产品属性组2
            ,prodp3 -- 产品属性组3
            ,prodp4 -- 产品属性组4
            ,prodp5 -- 产品属性组5
            ,prodp6 -- 产品属性组6
            ,prodp7 -- 产品属性组7
            ,prodp8 -- 产品属性组8
            ,prodp9 -- 产品属性组9
            ,prodpa -- 产品属性组10
            ,p1tpkd -- 产品属性1
            ,p2tpkd -- 产品属性2
            ,p3tpkd -- 产品属性3
            ,p4tpkd -- 产品属性4
            ,p5tpkd -- 产品属性5
            ,p6tpkd -- 产品属性6
            ,p7tpkd -- 产品属性7
            ,p8tpkd -- 产品属性8
            ,p9tpkd -- 产品属性9
            ,patpkd -- 产品属性10
            ,trprgp -- 余额类型组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_dtit_conf_op(
            stacid -- 账套
            ,prodcd -- 产品编号
            ,prodp1 -- 产品属性组1
            ,prodp2 -- 产品属性组2
            ,prodp3 -- 产品属性组3
            ,prodp4 -- 产品属性组4
            ,prodp5 -- 产品属性组5
            ,prodp6 -- 产品属性组6
            ,prodp7 -- 产品属性组7
            ,prodp8 -- 产品属性组8
            ,prodp9 -- 产品属性组9
            ,prodpa -- 产品属性组10
            ,p1tpkd -- 产品属性1
            ,p2tpkd -- 产品属性2
            ,p3tpkd -- 产品属性3
            ,p4tpkd -- 产品属性4
            ,p5tpkd -- 产品属性5
            ,p6tpkd -- 产品属性6
            ,p7tpkd -- 产品属性7
            ,p8tpkd -- 产品属性8
            ,p9tpkd -- 产品属性9
            ,patpkd -- 产品属性10
            ,trprgp -- 余额类型组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.prodcd, o.prodcd) as prodcd -- 产品编号
    ,nvl(n.prodp1, o.prodp1) as prodp1 -- 产品属性组1
    ,nvl(n.prodp2, o.prodp2) as prodp2 -- 产品属性组2
    ,nvl(n.prodp3, o.prodp3) as prodp3 -- 产品属性组3
    ,nvl(n.prodp4, o.prodp4) as prodp4 -- 产品属性组4
    ,nvl(n.prodp5, o.prodp5) as prodp5 -- 产品属性组5
    ,nvl(n.prodp6, o.prodp6) as prodp6 -- 产品属性组6
    ,nvl(n.prodp7, o.prodp7) as prodp7 -- 产品属性组7
    ,nvl(n.prodp8, o.prodp8) as prodp8 -- 产品属性组8
    ,nvl(n.prodp9, o.prodp9) as prodp9 -- 产品属性组9
    ,nvl(n.prodpa, o.prodpa) as prodpa -- 产品属性组10
    ,nvl(n.p1tpkd, o.p1tpkd) as p1tpkd -- 产品属性1
    ,nvl(n.p2tpkd, o.p2tpkd) as p2tpkd -- 产品属性2
    ,nvl(n.p3tpkd, o.p3tpkd) as p3tpkd -- 产品属性3
    ,nvl(n.p4tpkd, o.p4tpkd) as p4tpkd -- 产品属性4
    ,nvl(n.p5tpkd, o.p5tpkd) as p5tpkd -- 产品属性5
    ,nvl(n.p6tpkd, o.p6tpkd) as p6tpkd -- 产品属性6
    ,nvl(n.p7tpkd, o.p7tpkd) as p7tpkd -- 产品属性7
    ,nvl(n.p8tpkd, o.p8tpkd) as p8tpkd -- 产品属性8
    ,nvl(n.p9tpkd, o.p9tpkd) as p9tpkd -- 产品属性9
    ,nvl(n.patpkd, o.patpkd) as patpkd -- 产品属性10
    ,nvl(n.trprgp, o.trprgp) as trprgp -- 余额类型组
    ,case when
            n.stacid is null
            and n.prodcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.prodcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.prodcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_sys_dtit_conf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_sys_dtit_conf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.prodcd = n.prodcd
where (
        o.stacid is null
        and o.prodcd is null
    )
    or (
        n.stacid is null
        and n.prodcd is null
    )
    or (
        o.prodp1 <> n.prodp1
        or o.prodp2 <> n.prodp2
        or o.prodp3 <> n.prodp3
        or o.prodp4 <> n.prodp4
        or o.prodp5 <> n.prodp5
        or o.prodp6 <> n.prodp6
        or o.prodp7 <> n.prodp7
        or o.prodp8 <> n.prodp8
        or o.prodp9 <> n.prodp9
        or o.prodpa <> n.prodpa
        or o.p1tpkd <> n.p1tpkd
        or o.p2tpkd <> n.p2tpkd
        or o.p3tpkd <> n.p3tpkd
        or o.p4tpkd <> n.p4tpkd
        or o.p5tpkd <> n.p5tpkd
        or o.p6tpkd <> n.p6tpkd
        or o.p7tpkd <> n.p7tpkd
        or o.p8tpkd <> n.p8tpkd
        or o.p9tpkd <> n.p9tpkd
        or o.patpkd <> n.patpkd
        or o.trprgp <> n.trprgp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_dtit_conf_cl(
            stacid -- 账套
            ,prodcd -- 产品编号
            ,prodp1 -- 产品属性组1
            ,prodp2 -- 产品属性组2
            ,prodp3 -- 产品属性组3
            ,prodp4 -- 产品属性组4
            ,prodp5 -- 产品属性组5
            ,prodp6 -- 产品属性组6
            ,prodp7 -- 产品属性组7
            ,prodp8 -- 产品属性组8
            ,prodp9 -- 产品属性组9
            ,prodpa -- 产品属性组10
            ,p1tpkd -- 产品属性1
            ,p2tpkd -- 产品属性2
            ,p3tpkd -- 产品属性3
            ,p4tpkd -- 产品属性4
            ,p5tpkd -- 产品属性5
            ,p6tpkd -- 产品属性6
            ,p7tpkd -- 产品属性7
            ,p8tpkd -- 产品属性8
            ,p9tpkd -- 产品属性9
            ,patpkd -- 产品属性10
            ,trprgp -- 余额类型组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_dtit_conf_op(
            stacid -- 账套
            ,prodcd -- 产品编号
            ,prodp1 -- 产品属性组1
            ,prodp2 -- 产品属性组2
            ,prodp3 -- 产品属性组3
            ,prodp4 -- 产品属性组4
            ,prodp5 -- 产品属性组5
            ,prodp6 -- 产品属性组6
            ,prodp7 -- 产品属性组7
            ,prodp8 -- 产品属性组8
            ,prodp9 -- 产品属性组9
            ,prodpa -- 产品属性组10
            ,p1tpkd -- 产品属性1
            ,p2tpkd -- 产品属性2
            ,p3tpkd -- 产品属性3
            ,p4tpkd -- 产品属性4
            ,p5tpkd -- 产品属性5
            ,p6tpkd -- 产品属性6
            ,p7tpkd -- 产品属性7
            ,p8tpkd -- 产品属性8
            ,p9tpkd -- 产品属性9
            ,patpkd -- 产品属性10
            ,trprgp -- 余额类型组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.prodcd -- 产品编号
    ,o.prodp1 -- 产品属性组1
    ,o.prodp2 -- 产品属性组2
    ,o.prodp3 -- 产品属性组3
    ,o.prodp4 -- 产品属性组4
    ,o.prodp5 -- 产品属性组5
    ,o.prodp6 -- 产品属性组6
    ,o.prodp7 -- 产品属性组7
    ,o.prodp8 -- 产品属性组8
    ,o.prodp9 -- 产品属性组9
    ,o.prodpa -- 产品属性组10
    ,o.p1tpkd -- 产品属性1
    ,o.p2tpkd -- 产品属性2
    ,o.p3tpkd -- 产品属性3
    ,o.p4tpkd -- 产品属性4
    ,o.p5tpkd -- 产品属性5
    ,o.p6tpkd -- 产品属性6
    ,o.p7tpkd -- 产品属性7
    ,o.p8tpkd -- 产品属性8
    ,o.p9tpkd -- 产品属性9
    ,o.patpkd -- 产品属性10
    ,o.trprgp -- 余额类型组
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
from ${iol_schema}.tgls_sys_dtit_conf_bk o
    left join ${iol_schema}.tgls_sys_dtit_conf_op n
        on
            o.stacid = n.stacid
            and o.prodcd = n.prodcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_sys_dtit_conf_cl d
        on
            o.stacid = d.stacid
            and o.prodcd = d.prodcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_sys_dtit_conf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_sys_dtit_conf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_sys_dtit_conf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_sys_dtit_conf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_sys_dtit_conf exchange partition p_${batch_date} with table ${iol_schema}.tgls_sys_dtit_conf_cl;
alter table ${iol_schema}.tgls_sys_dtit_conf exchange partition p_20991231 with table ${iol_schema}.tgls_sys_dtit_conf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_sys_dtit_conf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_dtit_conf_op purge;
drop table ${iol_schema}.tgls_sys_dtit_conf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_sys_dtit_conf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_sys_dtit_conf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
