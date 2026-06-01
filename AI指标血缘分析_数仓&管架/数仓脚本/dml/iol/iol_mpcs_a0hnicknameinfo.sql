/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0hnicknameinfo
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
create table ${iol_schema}.mpcs_a0hnicknameinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0hnicknameinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hnicknameinfo_op purge;
drop table ${iol_schema}.mpcs_a0hnicknameinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hnicknameinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hnicknameinfo where 0=1;

create table ${iol_schema}.mpcs_a0hnicknameinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0hnicknameinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hnicknameinfo_cl(
            familyid -- 家庭号
            ,startcustno -- 发起人客户号
            ,custacc -- 被设置人账号
            ,nickname -- 昵称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hnicknameinfo_op(
            familyid -- 家庭号
            ,startcustno -- 发起人客户号
            ,custacc -- 被设置人账号
            ,nickname -- 昵称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.familyid, o.familyid) as familyid -- 家庭号
    ,nvl(n.startcustno, o.startcustno) as startcustno -- 发起人客户号
    ,nvl(n.custacc, o.custacc) as custacc -- 被设置人账号
    ,nvl(n.nickname, o.nickname) as nickname -- 昵称
    ,case when
            n.familyid is null
            and n.startcustno is null
            and n.custacc is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.familyid is null
            and n.startcustno is null
            and n.custacc is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.familyid is null
            and n.startcustno is null
            and n.custacc is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0hnicknameinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0hnicknameinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.familyid = n.familyid
            and o.startcustno = n.startcustno
            and o.custacc = n.custacc
where (
        o.familyid is null
        and o.startcustno is null
        and o.custacc is null
    )
    or (
        n.familyid is null
        and n.startcustno is null
        and n.custacc is null
    )
    or (
        o.nickname <> n.nickname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0hnicknameinfo_cl(
            familyid -- 家庭号
            ,startcustno -- 发起人客户号
            ,custacc -- 被设置人账号
            ,nickname -- 昵称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0hnicknameinfo_op(
            familyid -- 家庭号
            ,startcustno -- 发起人客户号
            ,custacc -- 被设置人账号
            ,nickname -- 昵称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.familyid -- 家庭号
    ,o.startcustno -- 发起人客户号
    ,o.custacc -- 被设置人账号
    ,o.nickname -- 昵称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0hnicknameinfo_bk o
    left join ${iol_schema}.mpcs_a0hnicknameinfo_op n
        on
            o.familyid = n.familyid
            and o.startcustno = n.startcustno
            and o.custacc = n.custacc
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0hnicknameinfo_cl d
        on
            o.familyid = d.familyid
            and o.startcustno = d.startcustno
            and o.custacc = d.custacc
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0hnicknameinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0hnicknameinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a0hnicknameinfo_cl;
alter table ${iol_schema}.mpcs_a0hnicknameinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0hnicknameinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0hnicknameinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0hnicknameinfo_op purge;
drop table ${iol_schema}.mpcs_a0hnicknameinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0hnicknameinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0hnicknameinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
