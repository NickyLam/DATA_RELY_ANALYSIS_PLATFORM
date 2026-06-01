/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_domain
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
create table ${iol_schema}.uuss_uus_domain_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_uus_domain;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_domain_op purge;
drop table ${iol_schema}.uuss_uus_domain_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_domain_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_domain where 0=1;

create table ${iol_schema}.uuss_uus_domain_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_domain where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_domain_cl(
            domainid -- 域帐号
            ,employeeid -- 员工编号
            ,name -- 姓名
            ,sysstatus -- 员工系统状态 1-正常 2-锁定
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,mobile -- 移动电话
            ,post -- 邮政编码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_domain_op(
            domainid -- 域帐号
            ,employeeid -- 员工编号
            ,name -- 姓名
            ,sysstatus -- 员工系统状态 1-正常 2-锁定
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,mobile -- 移动电话
            ,post -- 邮政编码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.domainid, o.domainid) as domainid -- 域帐号
    ,nvl(n.employeeid, o.employeeid) as employeeid -- 员工编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.sysstatus, o.sysstatus) as sysstatus -- 员工系统状态 1-正常 2-锁定
    ,nvl(n.companycountrycode, o.companycountrycode) as companycountrycode -- 单位电话国际区号
    ,nvl(n.companyareacode, o.companyareacode) as companyareacode -- 单位电话国内区号
    ,nvl(n.companyphone, o.companyphone) as companyphone -- 单位电话
    ,nvl(n.companysubphone, o.companysubphone) as companysubphone -- 单位电话分机号
    ,nvl(n.mobile, o.mobile) as mobile -- 移动电话
    ,nvl(n.post, o.post) as post -- 邮政编码
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,case when
            n.domainid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.domainid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.domainid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_uus_domain_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_uus_domain where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.domainid = n.domainid
where (
        o.domainid is null
    )
    or (
        n.domainid is null
    )
    or (
        o.employeeid <> n.employeeid
        or o.name <> n.name
        or o.sysstatus <> n.sysstatus
        or o.companycountrycode <> n.companycountrycode
        or o.companyareacode <> n.companyareacode
        or o.companyphone <> n.companyphone
        or o.companysubphone <> n.companysubphone
        or o.mobile <> n.mobile
        or o.post <> n.post
        or o.address <> n.address
        or o.email <> n.email
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_domain_cl(
            domainid -- 域帐号
            ,employeeid -- 员工编号
            ,name -- 姓名
            ,sysstatus -- 员工系统状态 1-正常 2-锁定
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,mobile -- 移动电话
            ,post -- 邮政编码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_domain_op(
            domainid -- 域帐号
            ,employeeid -- 员工编号
            ,name -- 姓名
            ,sysstatus -- 员工系统状态 1-正常 2-锁定
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,mobile -- 移动电话
            ,post -- 邮政编码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.domainid -- 域帐号
    ,o.employeeid -- 员工编号
    ,o.name -- 姓名
    ,o.sysstatus -- 员工系统状态 1-正常 2-锁定
    ,o.companycountrycode -- 单位电话国际区号
    ,o.companyareacode -- 单位电话国内区号
    ,o.companyphone -- 单位电话
    ,o.companysubphone -- 单位电话分机号
    ,o.mobile -- 移动电话
    ,o.post -- 邮政编码
    ,o.address -- 详细地址
    ,o.email -- 电子邮箱
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_uus_domain_bk o
    left join ${iol_schema}.uuss_uus_domain_op n
        on
            o.domainid = n.domainid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_uus_domain_cl d
        on
            o.domainid = d.domainid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.uuss_uus_domain;

-- 4.2 exchange partition
alter table ${iol_schema}.uuss_uus_domain exchange partition p_19000101 with table ${iol_schema}.uuss_uus_domain_cl;
alter table ${iol_schema}.uuss_uus_domain exchange partition p_20991231 with table ${iol_schema}.uuss_uus_domain_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_uus_domain to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_domain_op purge;
drop table ${iol_schema}.uuss_uus_domain_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_uus_domain_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_uus_domain',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
