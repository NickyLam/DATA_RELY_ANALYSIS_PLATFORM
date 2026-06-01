/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_breach_result
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
create table ${iol_schema}.icms_customer_breach_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_breach_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_breach_result_op purge;
drop table ${iol_schema}.icms_customer_breach_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_breach_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_breach_result where 0=1;

create table ${iol_schema}.icms_customer_breach_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_breach_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_breach_result_cl(
            customerid -- 客户号
            ,processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
            ,iscanrelive -- 能否违约重生:yes-可以no-不可以
            ,enddate -- 评级到期日
            ,breachdate -- 违约认定日期
            ,breachrelivedate -- 违约重生日期
            ,taskno -- 内评系统任务流水号
            ,begindate -- 评级核定日期
            ,breachflag -- 违约标志:0不违约1违约
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
            ,breachoverturndate -- 违约推翻日期
            ,rateflag -- 流程类型
            ,updatetime -- 更新时间
            ,risklevel -- 调整后级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_breach_result_op(
            customerid -- 客户号
            ,processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
            ,iscanrelive -- 能否违约重生:yes-可以no-不可以
            ,enddate -- 评级到期日
            ,breachdate -- 违约认定日期
            ,breachrelivedate -- 违约重生日期
            ,taskno -- 内评系统任务流水号
            ,begindate -- 评级核定日期
            ,breachflag -- 违约标志:0不违约1违约
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
            ,breachoverturndate -- 违约推翻日期
            ,rateflag -- 流程类型
            ,updatetime -- 更新时间
            ,risklevel -- 调整后级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.processtype, o.processtype) as processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
    ,nvl(n.iscanrelive, o.iscanrelive) as iscanrelive -- 能否违约重生:yes-可以no-不可以
    ,nvl(n.enddate, o.enddate) as enddate -- 评级到期日
    ,nvl(n.breachdate, o.breachdate) as breachdate -- 违约认定日期
    ,nvl(n.breachrelivedate, o.breachrelivedate) as breachrelivedate -- 违约重生日期
    ,nvl(n.taskno, o.taskno) as taskno -- 内评系统任务流水号
    ,nvl(n.begindate, o.begindate) as begindate -- 评级核定日期
    ,nvl(n.breachflag, o.breachflag) as breachflag -- 违约标志:0不违约1违约
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.flag, o.flag) as flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
    ,nvl(n.breachoverturndate, o.breachoverturndate) as breachoverturndate -- 违约推翻日期
    ,nvl(n.rateflag, o.rateflag) as rateflag -- 流程类型
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 调整后级别
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_breach_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_breach_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.processtype <> n.processtype
        or o.iscanrelive <> n.iscanrelive
        or o.enddate <> n.enddate
        or o.breachdate <> n.breachdate
        or o.breachrelivedate <> n.breachrelivedate
        or o.taskno <> n.taskno
        or o.begindate <> n.begindate
        or o.breachflag <> n.breachflag
        or o.migtflag <> n.migtflag
        or o.flag <> n.flag
        or o.breachoverturndate <> n.breachoverturndate
        or o.rateflag <> n.rateflag
        or o.updatetime <> n.updatetime
        or o.risklevel <> n.risklevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_breach_result_cl(
            customerid -- 客户号
            ,processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
            ,iscanrelive -- 能否违约重生:yes-可以no-不可以
            ,enddate -- 评级到期日
            ,breachdate -- 违约认定日期
            ,breachrelivedate -- 违约重生日期
            ,taskno -- 内评系统任务流水号
            ,begindate -- 评级核定日期
            ,breachflag -- 违约标志:0不违约1违约
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
            ,breachoverturndate -- 违约推翻日期
            ,rateflag -- 流程类型
            ,updatetime -- 更新时间
            ,risklevel -- 调整后级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_breach_result_op(
            customerid -- 客户号
            ,processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
            ,iscanrelive -- 能否违约重生:yes-可以no-不可以
            ,enddate -- 评级到期日
            ,breachdate -- 违约认定日期
            ,breachrelivedate -- 违约重生日期
            ,taskno -- 内评系统任务流水号
            ,begindate -- 评级核定日期
            ,breachflag -- 违约标志:0不违约1违约
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
            ,breachoverturndate -- 违约推翻日期
            ,rateflag -- 流程类型
            ,updatetime -- 更新时间
            ,risklevel -- 调整后级别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户号
    ,o.processtype -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
    ,o.iscanrelive -- 能否违约重生:yes-可以no-不可以
    ,o.enddate -- 评级到期日
    ,o.breachdate -- 违约认定日期
    ,o.breachrelivedate -- 违约重生日期
    ,o.taskno -- 内评系统任务流水号
    ,o.begindate -- 评级核定日期
    ,o.breachflag -- 违约标志:0不违约1违约
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.flag -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
    ,o.breachoverturndate -- 违约推翻日期
    ,o.rateflag -- 流程类型
    ,o.updatetime -- 更新时间
    ,o.risklevel -- 调整后级别
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
from ${iol_schema}.icms_customer_breach_result_bk o
    left join ${iol_schema}.icms_customer_breach_result_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_breach_result_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_breach_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_breach_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_breach_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_breach_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_breach_result exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_breach_result_cl;
alter table ${iol_schema}.icms_customer_breach_result exchange partition p_20991231 with table ${iol_schema}.icms_customer_breach_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_breach_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_breach_result_op purge;
drop table ${iol_schema}.icms_customer_breach_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_breach_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_breach_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
