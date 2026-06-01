/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_lrbxx
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
create table ${iol_schema}.icms_sxd_company_lrbxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_lrbxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_lrbxx_op purge;
drop table ${iol_schema}.icms_sxd_company_lrbxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_lrbxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_lrbxx where 0=1;

create table ${iol_schema}.icms_sxd_company_lrbxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_lrbxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_lrbxx_cl(
            id -- 主键
            ,bqje -- 本年累计金额
            ,bblx -- 版本类型
            ,sqje -- 上期金额
            ,xm -- 科目名称
            ,mc -- 序号
            ,sbrq -- 申报日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sssqq -- 所属时间起
            ,serno -- 业务流水号
            ,sssqz -- 所属时间止
            ,bys -- 本月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_lrbxx_op(
            id -- 主键
            ,bqje -- 本年累计金额
            ,bblx -- 版本类型
            ,sqje -- 上期金额
            ,xm -- 科目名称
            ,mc -- 序号
            ,sbrq -- 申报日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sssqq -- 所属时间起
            ,serno -- 业务流水号
            ,sssqz -- 所属时间止
            ,bys -- 本月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.bqje, o.bqje) as bqje -- 本年累计金额
    ,nvl(n.bblx, o.bblx) as bblx -- 版本类型
    ,nvl(n.sqje, o.sqje) as sqje -- 上期金额
    ,nvl(n.xm, o.xm) as xm -- 科目名称
    ,nvl(n.mc, o.mc) as mc -- 序号
    ,nvl(n.sbrq, o.sbrq) as sbrq -- 申报日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.sssqq, o.sssqq) as sssqq -- 所属时间起
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.sssqz, o.sssqz) as sssqz -- 所属时间止
    ,nvl(n.bys, o.bys) as bys -- 本月数
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
from (select * from ${iol_schema}.icms_sxd_company_lrbxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_lrbxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bqje <> n.bqje
        or o.bblx <> n.bblx
        or o.sqje <> n.sqje
        or o.xm <> n.xm
        or o.mc <> n.mc
        or o.sbrq <> n.sbrq
        or o.migtflag <> n.migtflag
        or o.sssqq <> n.sssqq
        or o.serno <> n.serno
        or o.sssqz <> n.sssqz
        or o.bys <> n.bys
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_lrbxx_cl(
            id -- 主键
            ,bqje -- 本年累计金额
            ,bblx -- 版本类型
            ,sqje -- 上期金额
            ,xm -- 科目名称
            ,mc -- 序号
            ,sbrq -- 申报日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sssqq -- 所属时间起
            ,serno -- 业务流水号
            ,sssqz -- 所属时间止
            ,bys -- 本月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_lrbxx_op(
            id -- 主键
            ,bqje -- 本年累计金额
            ,bblx -- 版本类型
            ,sqje -- 上期金额
            ,xm -- 科目名称
            ,mc -- 序号
            ,sbrq -- 申报日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,sssqq -- 所属时间起
            ,serno -- 业务流水号
            ,sssqz -- 所属时间止
            ,bys -- 本月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.bqje -- 本年累计金额
    ,o.bblx -- 版本类型
    ,o.sqje -- 上期金额
    ,o.xm -- 科目名称
    ,o.mc -- 序号
    ,o.sbrq -- 申报日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.sssqq -- 所属时间起
    ,o.serno -- 业务流水号
    ,o.sssqz -- 所属时间止
    ,o.bys -- 本月数
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
from ${iol_schema}.icms_sxd_company_lrbxx_bk o
    left join ${iol_schema}.icms_sxd_company_lrbxx_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_lrbxx_cl d
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
--truncate table ${iol_schema}.icms_sxd_company_lrbxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_lrbxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_lrbxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_lrbxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_lrbxx exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_lrbxx_cl;
alter table ${iol_schema}.icms_sxd_company_lrbxx exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_lrbxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_lrbxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_lrbxx_op purge;
drop table ${iol_schema}.icms_sxd_company_lrbxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_lrbxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_lrbxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
