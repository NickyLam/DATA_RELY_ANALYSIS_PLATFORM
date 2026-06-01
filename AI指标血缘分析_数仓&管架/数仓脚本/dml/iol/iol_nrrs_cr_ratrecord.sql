/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_cr_ratrecord
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
create table ${iol_schema}.nrrs_cr_ratrecord_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_cr_ratrecord
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_cr_ratrecord_op purge;
drop table ${iol_schema}.nrrs_cr_ratrecord_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_cr_ratrecord_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_cr_ratrecord where 0=1;

create table ${iol_schema}.nrrs_cr_ratrecord_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_cr_ratrecord where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_cr_ratrecord_cl(
            lsh -- 评级流水号
            ,custid -- 客户号
            ,ratdate -- 评级日期
            ,operatorid -- 评级人
            ,reportno -- 基准报表期次
            ,modelcode -- 选用的财务模型
            ,conmodelcode -- 确认级别
            ,modelselcond1 -- 模型选择条件1
            ,modelselcond2 -- 模型选择条件2
            ,modelselcond3 -- 模型选择条件3
            ,modelselcond4 -- 模型选择条件4
            ,modelselcond5 -- 模型选择条件5
            ,modelselcond6 -- 模型选择条件6
            ,financelevel -- 评级财务级别
            ,nonfinancelevel -- 非财务控制级别
            ,confirmlevel -- 确认级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_cr_ratrecord_op(
            lsh -- 评级流水号
            ,custid -- 客户号
            ,ratdate -- 评级日期
            ,operatorid -- 评级人
            ,reportno -- 基准报表期次
            ,modelcode -- 选用的财务模型
            ,conmodelcode -- 确认级别
            ,modelselcond1 -- 模型选择条件1
            ,modelselcond2 -- 模型选择条件2
            ,modelselcond3 -- 模型选择条件3
            ,modelselcond4 -- 模型选择条件4
            ,modelselcond5 -- 模型选择条件5
            ,modelselcond6 -- 模型选择条件6
            ,financelevel -- 评级财务级别
            ,nonfinancelevel -- 非财务控制级别
            ,confirmlevel -- 确认级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lsh, o.lsh) as lsh -- 评级流水号
    ,nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.ratdate, o.ratdate) as ratdate -- 评级日期
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 评级人
    ,nvl(n.reportno, o.reportno) as reportno -- 基准报表期次
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 选用的财务模型
    ,nvl(n.conmodelcode, o.conmodelcode) as conmodelcode -- 确认级别
    ,nvl(n.modelselcond1, o.modelselcond1) as modelselcond1 -- 模型选择条件1
    ,nvl(n.modelselcond2, o.modelselcond2) as modelselcond2 -- 模型选择条件2
    ,nvl(n.modelselcond3, o.modelselcond3) as modelselcond3 -- 模型选择条件3
    ,nvl(n.modelselcond4, o.modelselcond4) as modelselcond4 -- 模型选择条件4
    ,nvl(n.modelselcond5, o.modelselcond5) as modelselcond5 -- 模型选择条件5
    ,nvl(n.modelselcond6, o.modelselcond6) as modelselcond6 -- 模型选择条件6
    ,nvl(n.financelevel, o.financelevel) as financelevel -- 评级财务级别
    ,nvl(n.nonfinancelevel, o.nonfinancelevel) as nonfinancelevel -- 非财务控制级别
    ,nvl(n.confirmlevel, o.confirmlevel) as confirmlevel -- 确认级别
    ,case when
            n.lsh is null
            and n.custid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lsh is null
            and n.custid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lsh is null
            and n.custid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_cr_ratrecord_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_cr_ratrecord where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.lsh = n.lsh
            and o.custid = n.custid
where (
        o.lsh is null
        and o.custid is null
    )
    or (
        n.lsh is null
        and n.custid is null
    )
    or (
        o.ratdate <> n.ratdate
        or o.operatorid <> n.operatorid
        or o.reportno <> n.reportno
        or o.modelcode <> n.modelcode
        or o.conmodelcode <> n.conmodelcode
        or o.modelselcond1 <> n.modelselcond1
        or o.modelselcond2 <> n.modelselcond2
        or o.modelselcond3 <> n.modelselcond3
        or o.modelselcond4 <> n.modelselcond4
        or o.modelselcond5 <> n.modelselcond5
        or o.modelselcond6 <> n.modelselcond6
        or o.financelevel <> n.financelevel
        or o.nonfinancelevel <> n.nonfinancelevel
        or o.confirmlevel <> n.confirmlevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_cr_ratrecord_cl(
            lsh -- 评级流水号
            ,custid -- 客户号
            ,ratdate -- 评级日期
            ,operatorid -- 评级人
            ,reportno -- 基准报表期次
            ,modelcode -- 选用的财务模型
            ,conmodelcode -- 确认级别
            ,modelselcond1 -- 模型选择条件1
            ,modelselcond2 -- 模型选择条件2
            ,modelselcond3 -- 模型选择条件3
            ,modelselcond4 -- 模型选择条件4
            ,modelselcond5 -- 模型选择条件5
            ,modelselcond6 -- 模型选择条件6
            ,financelevel -- 评级财务级别
            ,nonfinancelevel -- 非财务控制级别
            ,confirmlevel -- 确认级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_cr_ratrecord_op(
            lsh -- 评级流水号
            ,custid -- 客户号
            ,ratdate -- 评级日期
            ,operatorid -- 评级人
            ,reportno -- 基准报表期次
            ,modelcode -- 选用的财务模型
            ,conmodelcode -- 确认级别
            ,modelselcond1 -- 模型选择条件1
            ,modelselcond2 -- 模型选择条件2
            ,modelselcond3 -- 模型选择条件3
            ,modelselcond4 -- 模型选择条件4
            ,modelselcond5 -- 模型选择条件5
            ,modelselcond6 -- 模型选择条件6
            ,financelevel -- 评级财务级别
            ,nonfinancelevel -- 非财务控制级别
            ,confirmlevel -- 确认级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lsh -- 评级流水号
    ,o.custid -- 客户号
    ,o.ratdate -- 评级日期
    ,o.operatorid -- 评级人
    ,o.reportno -- 基准报表期次
    ,o.modelcode -- 选用的财务模型
    ,o.conmodelcode -- 确认级别
    ,o.modelselcond1 -- 模型选择条件1
    ,o.modelselcond2 -- 模型选择条件2
    ,o.modelselcond3 -- 模型选择条件3
    ,o.modelselcond4 -- 模型选择条件4
    ,o.modelselcond5 -- 模型选择条件5
    ,o.modelselcond6 -- 模型选择条件6
    ,o.financelevel -- 评级财务级别
    ,o.nonfinancelevel -- 非财务控制级别
    ,o.confirmlevel -- 确认级别
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
from ${iol_schema}.nrrs_cr_ratrecord_bk o
    left join ${iol_schema}.nrrs_cr_ratrecord_op n
        on
            o.lsh = n.lsh
            and o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_cr_ratrecord_cl d
        on
            o.lsh = d.lsh
            and o.custid = d.custid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nrrs_cr_ratrecord;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nrrs_cr_ratrecord') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nrrs_cr_ratrecord drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nrrs_cr_ratrecord add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nrrs_cr_ratrecord exchange partition p_${batch_date} with table ${iol_schema}.nrrs_cr_ratrecord_cl;
alter table ${iol_schema}.nrrs_cr_ratrecord exchange partition p_20991231 with table ${iol_schema}.nrrs_cr_ratrecord_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_cr_ratrecord to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_cr_ratrecord_op purge;
drop table ${iol_schema}.nrrs_cr_ratrecord_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_cr_ratrecord_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_cr_ratrecord',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
