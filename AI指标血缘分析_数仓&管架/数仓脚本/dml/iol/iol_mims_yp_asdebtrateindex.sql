/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_asdebtrateindex
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
create table ${iol_schema}.mims_yp_asdebtrateindex_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_asdebtrateindex;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_asdebtrateindex_op purge;
drop table ${iol_schema}.mims_yp_asdebtrateindex_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_asdebtrateindex_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_asdebtrateindex where 0=1;

create table ${iol_schema}.mims_yp_asdebtrateindex_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_asdebtrateindex where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_asdebtrateindex_cl(
            workdate -- 供数日期
            ,custid -- 保证人编号
            ,qualification -- 保证合格性(1-合格 0-不合格)
            ,independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_asdebtrateindex_op(
            workdate -- 供数日期
            ,custid -- 保证人编号
            ,qualification -- 保证合格性(1-合格 0-不合格)
            ,independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.workdate, o.workdate) as workdate -- 供数日期
    ,nvl(n.custid, o.custid) as custid -- 保证人编号
    ,nvl(n.qualification, o.qualification) as qualification -- 保证合格性(1-合格 0-不合格)
    ,nvl(n.independence, o.independence) as independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
    ,case when
            n.workdate is null
            and n.custid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.workdate is null
            and n.custid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.workdate is null
            and n.custid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_asdebtrateindex_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_asdebtrateindex where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.workdate = n.workdate
            and o.custid = n.custid
where (
        o.workdate is null
        and o.custid is null
    )
    or (
        n.workdate is null
        and n.custid is null
    )
    or (
        o.qualification <> n.qualification
        or o.independence <> n.independence
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_asdebtrateindex_cl(
            workdate -- 供数日期
            ,custid -- 保证人编号
            ,qualification -- 保证合格性(1-合格 0-不合格)
            ,independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_asdebtrateindex_op(
            workdate -- 供数日期
            ,custid -- 保证人编号
            ,qualification -- 保证合格性(1-合格 0-不合格)
            ,independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.workdate -- 供数日期
    ,o.custid -- 保证人编号
    ,o.qualification -- 保证合格性(1-合格 0-不合格)
    ,o.independence -- 保证人独立性(01-专业担保公司,02-与借款人无关联关系,03-借款人被控制的上级或其他关联人,04-借款人控制的下级)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_yp_asdebtrateindex_bk o
    left join ${iol_schema}.mims_yp_asdebtrateindex_op n
        on
            o.workdate = n.workdate
            and o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_asdebtrateindex_cl d
        on
            o.workdate = d.workdate
            and o.custid = d.custid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_yp_asdebtrateindex;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_yp_asdebtrateindex exchange partition p_19000101 with table ${iol_schema}.mims_yp_asdebtrateindex_cl;
alter table ${iol_schema}.mims_yp_asdebtrateindex exchange partition p_20991231 with table ${iol_schema}.mims_yp_asdebtrateindex_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_asdebtrateindex to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_asdebtrateindex_op purge;
drop table ${iol_schema}.mims_yp_asdebtrateindex_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_asdebtrateindex_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_asdebtrateindex',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
