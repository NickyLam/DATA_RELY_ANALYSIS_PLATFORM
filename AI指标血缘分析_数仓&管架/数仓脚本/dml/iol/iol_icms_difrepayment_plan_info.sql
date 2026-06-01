/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_difrepayment_plan_info
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
create table ${iol_schema}.icms_difrepayment_plan_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_difrepayment_plan_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_difrepayment_plan_info_op purge;
drop table ${iol_schema}.icms_difrepayment_plan_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_difrepayment_plan_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_difrepayment_plan_info where 0=1;

create table ${iol_schema}.icms_difrepayment_plan_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_difrepayment_plan_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_difrepayment_plan_info_cl(
            duebillserialno -- 借据号
            ,executiondate -- 执行日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,startdate -- 起息日期
            ,normalsum -- 应计正常本金
            ,periodsum -- 本期应收本金
            ,businesscurrency -- 币种
            ,periodinterestsum -- 本期应收利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_difrepayment_plan_info_op(
            duebillserialno -- 借据号
            ,executiondate -- 执行日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,startdate -- 起息日期
            ,normalsum -- 应计正常本金
            ,periodsum -- 本期应收本金
            ,businesscurrency -- 币种
            ,periodinterestsum -- 本期应收利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号
    ,nvl(n.executiondate, o.executiondate) as executiondate -- 执行日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.startdate, o.startdate) as startdate -- 起息日期
    ,nvl(n.normalsum, o.normalsum) as normalsum -- 应计正常本金
    ,nvl(n.periodsum, o.periodsum) as periodsum -- 本期应收本金
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.periodinterestsum, o.periodinterestsum) as periodinterestsum -- 本期应收利息
    ,case when
            n.duebillserialno is null
            and n.executiondate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.duebillserialno is null
            and n.executiondate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.duebillserialno is null
            and n.executiondate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_difrepayment_plan_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_difrepayment_plan_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.duebillserialno = n.duebillserialno
            and o.executiondate = n.executiondate
where (
        o.duebillserialno is null
        and o.executiondate is null
    )
    or (
        n.duebillserialno is null
        and n.executiondate is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.startdate <> n.startdate
        or o.normalsum <> n.normalsum
        or o.periodsum <> n.periodsum
        or o.businesscurrency <> n.businesscurrency
        or o.periodinterestsum <> n.periodinterestsum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_difrepayment_plan_info_cl(
            duebillserialno -- 借据号
            ,executiondate -- 执行日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,startdate -- 起息日期
            ,normalsum -- 应计正常本金
            ,periodsum -- 本期应收本金
            ,businesscurrency -- 币种
            ,periodinterestsum -- 本期应收利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_difrepayment_plan_info_op(
            duebillserialno -- 借据号
            ,executiondate -- 执行日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,startdate -- 起息日期
            ,normalsum -- 应计正常本金
            ,periodsum -- 本期应收本金
            ,businesscurrency -- 币种
            ,periodinterestsum -- 本期应收利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.duebillserialno -- 借据号
    ,o.executiondate -- 执行日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.startdate -- 起息日期
    ,o.normalsum -- 应计正常本金
    ,o.periodsum -- 本期应收本金
    ,o.businesscurrency -- 币种
    ,o.periodinterestsum -- 本期应收利息
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
from ${iol_schema}.icms_difrepayment_plan_info_bk o
    left join ${iol_schema}.icms_difrepayment_plan_info_op n
        on
            o.duebillserialno = n.duebillserialno
            and o.executiondate = n.executiondate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_difrepayment_plan_info_cl d
        on
            o.duebillserialno = d.duebillserialno
            and o.executiondate = d.executiondate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_difrepayment_plan_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_difrepayment_plan_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_difrepayment_plan_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_difrepayment_plan_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_difrepayment_plan_info exchange partition p_${batch_date} with table ${iol_schema}.icms_difrepayment_plan_info_cl;
alter table ${iol_schema}.icms_difrepayment_plan_info exchange partition p_20991231 with table ${iol_schema}.icms_difrepayment_plan_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_difrepayment_plan_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_difrepayment_plan_info_op purge;
drop table ${iol_schema}.icms_difrepayment_plan_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_difrepayment_plan_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_difrepayment_plan_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
