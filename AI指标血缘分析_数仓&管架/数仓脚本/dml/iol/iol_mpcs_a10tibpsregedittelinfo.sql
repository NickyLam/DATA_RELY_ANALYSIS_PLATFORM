/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a10tibpsregedittelinfo
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
create table ${iol_schema}.mpcs_a10tibpsregedittelinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a10tibpsregedittelinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo_op purge;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a10tibpsregedittelinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a10tibpsregedittelinfo where 0=1;

create table ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a10tibpsregedittelinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl(
            tel -- 手机号
            ,idtype -- 证件类型
            ,idcode -- 证件号
            ,acctno -- 账号
            ,acctname -- 户名
            ,dftaccttp -- 账号注册属性
            ,rejectbank -- 开户行所属网银系统行号
            ,acctopenbrn -- 账户开户行
            ,sdficode -- 账户清算行
            ,regedittm -- 登记时间
            ,status -- 状态：0_已注销，1_已注册
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a10tibpsregedittelinfo_op(
            tel -- 手机号
            ,idtype -- 证件类型
            ,idcode -- 证件号
            ,acctno -- 账号
            ,acctname -- 户名
            ,dftaccttp -- 账号注册属性
            ,rejectbank -- 开户行所属网银系统行号
            ,acctopenbrn -- 账户开户行
            ,sdficode -- 账户清算行
            ,regedittm -- 登记时间
            ,status -- 状态：0_已注销，1_已注册
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tel, o.tel) as tel -- 手机号
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号
    ,nvl(n.acctno, o.acctno) as acctno -- 账号
    ,nvl(n.acctname, o.acctname) as acctname -- 户名
    ,nvl(n.dftaccttp, o.dftaccttp) as dftaccttp -- 账号注册属性
    ,nvl(n.rejectbank, o.rejectbank) as rejectbank -- 开户行所属网银系统行号
    ,nvl(n.acctopenbrn, o.acctopenbrn) as acctopenbrn -- 账户开户行
    ,nvl(n.sdficode, o.sdficode) as sdficode -- 账户清算行
    ,nvl(n.regedittm, o.regedittm) as regedittm -- 登记时间
    ,nvl(n.status, o.status) as status -- 状态：0_已注销，1_已注册
    ,case when
            n.tel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a10tibpsregedittelinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a10tibpsregedittelinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tel = n.tel
where (
        o.tel is null
    )
    or (
        n.tel is null
    )
    or (
        o.idtype <> n.idtype
        or o.idcode <> n.idcode
        or o.acctno <> n.acctno
        or o.acctname <> n.acctname
        or o.dftaccttp <> n.dftaccttp
        or o.rejectbank <> n.rejectbank
        or o.acctopenbrn <> n.acctopenbrn
        or o.sdficode <> n.sdficode
        or o.regedittm <> n.regedittm
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl(
            tel -- 手机号
            ,idtype -- 证件类型
            ,idcode -- 证件号
            ,acctno -- 账号
            ,acctname -- 户名
            ,dftaccttp -- 账号注册属性
            ,rejectbank -- 开户行所属网银系统行号
            ,acctopenbrn -- 账户开户行
            ,sdficode -- 账户清算行
            ,regedittm -- 登记时间
            ,status -- 状态：0_已注销，1_已注册
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a10tibpsregedittelinfo_op(
            tel -- 手机号
            ,idtype -- 证件类型
            ,idcode -- 证件号
            ,acctno -- 账号
            ,acctname -- 户名
            ,dftaccttp -- 账号注册属性
            ,rejectbank -- 开户行所属网银系统行号
            ,acctopenbrn -- 账户开户行
            ,sdficode -- 账户清算行
            ,regedittm -- 登记时间
            ,status -- 状态：0_已注销，1_已注册
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tel -- 手机号
    ,o.idtype -- 证件类型
    ,o.idcode -- 证件号
    ,o.acctno -- 账号
    ,o.acctname -- 户名
    ,o.dftaccttp -- 账号注册属性
    ,o.rejectbank -- 开户行所属网银系统行号
    ,o.acctopenbrn -- 账户开户行
    ,o.sdficode -- 账户清算行
    ,o.regedittm -- 登记时间
    ,o.status -- 状态：0_已注销，1_已注册
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a10tibpsregedittelinfo_bk o
    left join ${iol_schema}.mpcs_a10tibpsregedittelinfo_op n
        on
            o.tel = n.tel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl d
        on
            o.tel = d.tel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a10tibpsregedittelinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a10tibpsregedittelinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl;
alter table ${iol_schema}.mpcs_a10tibpsregedittelinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a10tibpsregedittelinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a10tibpsregedittelinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo_op purge;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a10tibpsregedittelinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
