/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0hfamidinfo
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
create table ${iol_schema}.mpcs_a0hfamidinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0hfamidinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hfamidinfo_op purge;
drop table ${iol_schema}.mpcs_a0hfamidinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hfamidinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hfamidinfo where 0=1;

create table ${iol_schema}.mpcs_a0hfamidinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hfamidinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hfamidinfo_cl(
            familyid -- 家庭号
            ,custacc -- 家长卡号
            ,familystate -- 家庭状态 0-生效 1-失效
            ,createdate -- 创建时间
            ,effectivedate -- 生效时间
            ,abatedate -- 废弃时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hfamidinfo_op(
            familyid -- 家庭号
            ,custacc -- 家长卡号
            ,familystate -- 家庭状态 0-生效 1-失效
            ,createdate -- 创建时间
            ,effectivedate -- 生效时间
            ,abatedate -- 废弃时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.familyid, o.familyid) as familyid -- 家庭号
    ,nvl(n.custacc, o.custacc) as custacc -- 家长卡号
    ,nvl(n.familystate, o.familystate) as familystate -- 家庭状态 0-生效 1-失效
    ,nvl(n.createdate, o.createdate) as createdate -- 创建时间
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效时间
    ,nvl(n.abatedate, o.abatedate) as abatedate -- 废弃时间
    ,case when
            n.familyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.familyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.familyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0hfamidinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0hfamidinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.familyid = n.familyid
where (
        o.familyid is null
    )
    or (
        n.familyid is null
    )
    or (
        o.custacc <> n.custacc
        or o.familystate <> n.familystate
        or o.createdate <> n.createdate
        or o.effectivedate <> n.effectivedate
        or o.abatedate <> n.abatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hfamidinfo_cl(
            familyid -- 家庭号
            ,custacc -- 家长卡号
            ,familystate -- 家庭状态 0-生效 1-失效
            ,createdate -- 创建时间
            ,effectivedate -- 生效时间
            ,abatedate -- 废弃时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hfamidinfo_op(
            familyid -- 家庭号
            ,custacc -- 家长卡号
            ,familystate -- 家庭状态 0-生效 1-失效
            ,createdate -- 创建时间
            ,effectivedate -- 生效时间
            ,abatedate -- 废弃时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.familyid -- 家庭号
    ,o.custacc -- 家长卡号
    ,o.familystate -- 家庭状态 0-生效 1-失效
    ,o.createdate -- 创建时间
    ,o.effectivedate -- 生效时间
    ,o.abatedate -- 废弃时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0hfamidinfo_bk o
    left join ${iol_schema}.mpcs_a0hfamidinfo_op n
        on
            o.familyid = n.familyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0hfamidinfo_cl d
        on
            o.familyid = d.familyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0hfamidinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0hfamidinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a0hfamidinfo_cl;
alter table ${iol_schema}.mpcs_a0hfamidinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0hfamidinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0hfamidinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hfamidinfo_op purge;
drop table ${iol_schema}.mpcs_a0hfamidinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0hfamidinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0hfamidinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
