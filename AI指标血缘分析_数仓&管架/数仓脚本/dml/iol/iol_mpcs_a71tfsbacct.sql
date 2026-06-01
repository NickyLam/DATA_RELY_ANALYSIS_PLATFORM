/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a71tfsbacct
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
create table ${iol_schema}.mpcs_a71tfsbacct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a71tfsbacct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a71tfsbacct_op purge;
drop table ${iol_schema}.mpcs_a71tfsbacct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a71tfsbacct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a71tfsbacct where 0=1;

create table ${iol_schema}.mpcs_a71tfsbacct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a71tfsbacct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a71tfsbacct_cl(
            jshacctno -- 结算账号
            ,jshacctname -- 结算户名
            ,bzjacctno -- 保证金账户
            ,times -- 子户个数
            ,ordernum -- 同一结算户下保证金账户序号
            ,flag -- 是否允许建立子户标志：0-不允许 1-允许
            ,bzjaccnum -- 同一结算户下保证金账户个数
            ,dtitcd -- 核算科目
            ,magebrn -- 开户机构
            ,status -- 状态 0失效 1生效
            ,instdttm -- 入库时间
            ,prezzhacct -- 随机子账户前缀
            ,projname -- 项目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a71tfsbacct_op(
            jshacctno -- 结算账号
            ,jshacctname -- 结算户名
            ,bzjacctno -- 保证金账户
            ,times -- 子户个数
            ,ordernum -- 同一结算户下保证金账户序号
            ,flag -- 是否允许建立子户标志：0-不允许 1-允许
            ,bzjaccnum -- 同一结算户下保证金账户个数
            ,dtitcd -- 核算科目
            ,magebrn -- 开户机构
            ,status -- 状态 0失效 1生效
            ,instdttm -- 入库时间
            ,prezzhacct -- 随机子账户前缀
            ,projname -- 项目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jshacctno, o.jshacctno) as jshacctno -- 结算账号
    ,nvl(n.jshacctname, o.jshacctname) as jshacctname -- 结算户名
    ,nvl(n.bzjacctno, o.bzjacctno) as bzjacctno -- 保证金账户
    ,nvl(n.times, o.times) as times -- 子户个数
    ,nvl(n.ordernum, o.ordernum) as ordernum -- 同一结算户下保证金账户序号
    ,nvl(n.flag, o.flag) as flag -- 是否允许建立子户标志：0-不允许 1-允许
    ,nvl(n.bzjaccnum, o.bzjaccnum) as bzjaccnum -- 同一结算户下保证金账户个数
    ,nvl(n.dtitcd, o.dtitcd) as dtitcd -- 核算科目
    ,nvl(n.magebrn, o.magebrn) as magebrn -- 开户机构
    ,nvl(n.status, o.status) as status -- 状态 0失效 1生效
    ,nvl(n.instdttm, o.instdttm) as instdttm -- 入库时间
    ,nvl(n.prezzhacct, o.prezzhacct) as prezzhacct -- 随机子账户前缀
    ,nvl(n.projname, o.projname) as projname -- 项目名称
    ,case when
            n.jshacctno is null
            and n.prezzhacct is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jshacctno is null
            and n.prezzhacct is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jshacctno is null
            and n.prezzhacct is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a71tfsbacct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a71tfsbacct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jshacctno = n.jshacctno
            and o.prezzhacct = n.prezzhacct
where (
        o.jshacctno is null
        and o.prezzhacct is null
    )
    or (
        n.jshacctno is null
        and n.prezzhacct is null
    )
    or (
        o.jshacctname <> n.jshacctname
        or o.bzjacctno <> n.bzjacctno
        or o.times <> n.times
        or o.ordernum <> n.ordernum
        or o.flag <> n.flag
        or o.bzjaccnum <> n.bzjaccnum
        or o.dtitcd <> n.dtitcd
        or o.magebrn <> n.magebrn
        or o.status <> n.status
        or o.instdttm <> n.instdttm
        or o.projname <> n.projname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a71tfsbacct_cl(
            jshacctno -- 结算账号
            ,jshacctname -- 结算户名
            ,bzjacctno -- 保证金账户
            ,times -- 子户个数
            ,ordernum -- 同一结算户下保证金账户序号
            ,flag -- 是否允许建立子户标志：0-不允许 1-允许
            ,bzjaccnum -- 同一结算户下保证金账户个数
            ,dtitcd -- 核算科目
            ,magebrn -- 开户机构
            ,status -- 状态 0失效 1生效
            ,instdttm -- 入库时间
            ,prezzhacct -- 随机子账户前缀
            ,projname -- 项目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a71tfsbacct_op(
            jshacctno -- 结算账号
            ,jshacctname -- 结算户名
            ,bzjacctno -- 保证金账户
            ,times -- 子户个数
            ,ordernum -- 同一结算户下保证金账户序号
            ,flag -- 是否允许建立子户标志：0-不允许 1-允许
            ,bzjaccnum -- 同一结算户下保证金账户个数
            ,dtitcd -- 核算科目
            ,magebrn -- 开户机构
            ,status -- 状态 0失效 1生效
            ,instdttm -- 入库时间
            ,prezzhacct -- 随机子账户前缀
            ,projname -- 项目名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jshacctno -- 结算账号
    ,o.jshacctname -- 结算户名
    ,o.bzjacctno -- 保证金账户
    ,o.times -- 子户个数
    ,o.ordernum -- 同一结算户下保证金账户序号
    ,o.flag -- 是否允许建立子户标志：0-不允许 1-允许
    ,o.bzjaccnum -- 同一结算户下保证金账户个数
    ,o.dtitcd -- 核算科目
    ,o.magebrn -- 开户机构
    ,o.status -- 状态 0失效 1生效
    ,o.instdttm -- 入库时间
    ,o.prezzhacct -- 随机子账户前缀
    ,o.projname -- 项目名称
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
from ${iol_schema}.mpcs_a71tfsbacct_bk o
    left join ${iol_schema}.mpcs_a71tfsbacct_op n
        on
            o.jshacctno = n.jshacctno
            and o.prezzhacct = n.prezzhacct
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a71tfsbacct_cl d
        on
            o.jshacctno = d.jshacctno
            and o.prezzhacct = d.prezzhacct
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a71tfsbacct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a71tfsbacct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a71tfsbacct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a71tfsbacct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a71tfsbacct exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a71tfsbacct_cl;
alter table ${iol_schema}.mpcs_a71tfsbacct exchange partition p_20991231 with table ${iol_schema}.mpcs_a71tfsbacct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a71tfsbacct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a71tfsbacct_op purge;
drop table ${iol_schema}.mpcs_a71tfsbacct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a71tfsbacct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a71tfsbacct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
