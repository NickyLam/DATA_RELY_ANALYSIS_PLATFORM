/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60cfbranch
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
create table ${iol_schema}.mpcs_a60cfbranch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a60cfbranch;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60cfbranch_op purge;
drop table ${iol_schema}.mpcs_a60cfbranch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60cfbranch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60cfbranch where 0=1;

create table ${iol_schema}.mpcs_a60cfbranch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60cfbranch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60cfbranch_cl(
            brnnbr -- 机构号
            ,brnlevel -- 机构级别
            ,brntype -- 机构属性
            ,deptype -- 部门类别
            ,upperbrn -- 直接上级机构号
            ,citycode -- 机构所在城市码
            ,clearcitycode -- 人行清算业务所属的城市
            ,brnname -- 机构名称
            ,brnexname -- 机构名称扩展
            ,innclt -- 内部客户号
            ,ledgerbrn -- 总账核算机构
            ,actflag -- 明细账机构标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60cfbranch_op(
            brnnbr -- 机构号
            ,brnlevel -- 机构级别
            ,brntype -- 机构属性
            ,deptype -- 部门类别
            ,upperbrn -- 直接上级机构号
            ,citycode -- 机构所在城市码
            ,clearcitycode -- 人行清算业务所属的城市
            ,brnname -- 机构名称
            ,brnexname -- 机构名称扩展
            ,innclt -- 内部客户号
            ,ledgerbrn -- 总账核算机构
            ,actflag -- 明细账机构标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.brnnbr, o.brnnbr) as brnnbr -- 机构号
    ,nvl(n.brnlevel, o.brnlevel) as brnlevel -- 机构级别
    ,nvl(n.brntype, o.brntype) as brntype -- 机构属性
    ,nvl(n.deptype, o.deptype) as deptype -- 部门类别
    ,nvl(n.upperbrn, o.upperbrn) as upperbrn -- 直接上级机构号
    ,nvl(n.citycode, o.citycode) as citycode -- 机构所在城市码
    ,nvl(n.clearcitycode, o.clearcitycode) as clearcitycode -- 人行清算业务所属的城市
    ,nvl(n.brnname, o.brnname) as brnname -- 机构名称
    ,nvl(n.brnexname, o.brnexname) as brnexname -- 机构名称扩展
    ,nvl(n.innclt, o.innclt) as innclt -- 内部客户号
    ,nvl(n.ledgerbrn, o.ledgerbrn) as ledgerbrn -- 总账核算机构
    ,nvl(n.actflag, o.actflag) as actflag -- 明细账机构标志
    ,case when
            n.brnnbr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.brnnbr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.brnnbr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a60cfbranch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a60cfbranch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.brnnbr = n.brnnbr
where (
        o.brnnbr is null
    )
    or (
        n.brnnbr is null
    )
    or (
        o.brnlevel <> n.brnlevel
        or o.brntype <> n.brntype
        or o.deptype <> n.deptype
        or o.upperbrn <> n.upperbrn
        or o.citycode <> n.citycode
        or o.clearcitycode <> n.clearcitycode
        or o.brnname <> n.brnname
        or o.brnexname <> n.brnexname
        or o.innclt <> n.innclt
        or o.ledgerbrn <> n.ledgerbrn
        or o.actflag <> n.actflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60cfbranch_cl(
            brnnbr -- 机构号
            ,brnlevel -- 机构级别
            ,brntype -- 机构属性
            ,deptype -- 部门类别
            ,upperbrn -- 直接上级机构号
            ,citycode -- 机构所在城市码
            ,clearcitycode -- 人行清算业务所属的城市
            ,brnname -- 机构名称
            ,brnexname -- 机构名称扩展
            ,innclt -- 内部客户号
            ,ledgerbrn -- 总账核算机构
            ,actflag -- 明细账机构标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60cfbranch_op(
            brnnbr -- 机构号
            ,brnlevel -- 机构级别
            ,brntype -- 机构属性
            ,deptype -- 部门类别
            ,upperbrn -- 直接上级机构号
            ,citycode -- 机构所在城市码
            ,clearcitycode -- 人行清算业务所属的城市
            ,brnname -- 机构名称
            ,brnexname -- 机构名称扩展
            ,innclt -- 内部客户号
            ,ledgerbrn -- 总账核算机构
            ,actflag -- 明细账机构标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.brnnbr -- 机构号
    ,o.brnlevel -- 机构级别
    ,o.brntype -- 机构属性
    ,o.deptype -- 部门类别
    ,o.upperbrn -- 直接上级机构号
    ,o.citycode -- 机构所在城市码
    ,o.clearcitycode -- 人行清算业务所属的城市
    ,o.brnname -- 机构名称
    ,o.brnexname -- 机构名称扩展
    ,o.innclt -- 内部客户号
    ,o.ledgerbrn -- 总账核算机构
    ,o.actflag -- 明细账机构标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a60cfbranch_bk o
    left join ${iol_schema}.mpcs_a60cfbranch_op n
        on
            o.brnnbr = n.brnnbr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a60cfbranch_cl d
        on
            o.brnnbr = d.brnnbr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a60cfbranch;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a60cfbranch exchange partition p_19000101 with table ${iol_schema}.mpcs_a60cfbranch_cl;
alter table ${iol_schema}.mpcs_a60cfbranch exchange partition p_20991231 with table ${iol_schema}.mpcs_a60cfbranch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60cfbranch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60cfbranch_op purge;
drop table ${iol_schema}.mpcs_a60cfbranch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a60cfbranch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60cfbranch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
