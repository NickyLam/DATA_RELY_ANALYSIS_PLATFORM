/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_t_corp_info
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
create table ${iol_schema}.tbms_t_corp_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_t_corp_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_corp_info_op purge;
drop table ${iol_schema}.tbms_t_corp_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_corp_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_corp_info where 0=1;

create table ${iol_schema}.tbms_t_corp_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_corp_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_corp_info_cl(
            companyid -- 
            ,orgcode -- 
            ,cname -- 
            ,legalid -- 
            ,adminid -- 
            ,phone -- 
            ,email -- 
            ,address -- 
            ,status -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,logourl -- 
            ,cpytype -- 
            ,summary -- 
            ,website -- 
            ,legal -- 
            ,legalphone -- 
            ,contactinfo -- 
            ,provinces -- 
            ,city -- 
            ,industryid -- 
            ,isfunc -- 
            ,etype -- 
            ,estdate -- 
            ,regcaptial -- 
            ,uscc -- 
            ,companyno -- 
            ,authorgid -- 
            ,authtime -- 
            ,authorgcode -- 
            ,operusercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_corp_info_op(
            companyid -- 
            ,orgcode -- 
            ,cname -- 
            ,legalid -- 
            ,adminid -- 
            ,phone -- 
            ,email -- 
            ,address -- 
            ,status -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,logourl -- 
            ,cpytype -- 
            ,summary -- 
            ,website -- 
            ,legal -- 
            ,legalphone -- 
            ,contactinfo -- 
            ,provinces -- 
            ,city -- 
            ,industryid -- 
            ,isfunc -- 
            ,etype -- 
            ,estdate -- 
            ,regcaptial -- 
            ,uscc -- 
            ,companyno -- 
            ,authorgid -- 
            ,authtime -- 
            ,authorgcode -- 
            ,operusercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.companyid, o.companyid) as companyid -- 
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 
    ,nvl(n.cname, o.cname) as cname -- 
    ,nvl(n.legalid, o.legalid) as legalid -- 
    ,nvl(n.adminid, o.adminid) as adminid -- 
    ,nvl(n.phone, o.phone) as phone -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.sys_ctime, o.sys_ctime) as sys_ctime -- 
    ,nvl(n.sys_utime, o.sys_utime) as sys_utime -- 
    ,nvl(n.sys_valid, o.sys_valid) as sys_valid -- 
    ,nvl(n.logourl, o.logourl) as logourl -- 
    ,nvl(n.cpytype, o.cpytype) as cpytype -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.website, o.website) as website -- 
    ,nvl(n.legal, o.legal) as legal -- 
    ,nvl(n.legalphone, o.legalphone) as legalphone -- 
    ,nvl(n.contactinfo, o.contactinfo) as contactinfo -- 
    ,nvl(n.provinces, o.provinces) as provinces -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.industryid, o.industryid) as industryid -- 
    ,nvl(n.isfunc, o.isfunc) as isfunc -- 
    ,nvl(n.etype, o.etype) as etype -- 
    ,nvl(n.estdate, o.estdate) as estdate -- 
    ,nvl(n.regcaptial, o.regcaptial) as regcaptial -- 
    ,nvl(n.uscc, o.uscc) as uscc -- 
    ,nvl(n.companyno, o.companyno) as companyno -- 
    ,nvl(n.authorgid, o.authorgid) as authorgid -- 
    ,nvl(n.authtime, o.authtime) as authtime -- 
    ,nvl(n.authorgcode, o.authorgcode) as authorgcode -- 
    ,nvl(n.operusercode, o.operusercode) as operusercode -- 
    ,case when
            n.companyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.companyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.companyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_t_corp_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_t_corp_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.companyid = n.companyid
where (
        o.companyid is null
    )
    or (
        n.companyid is null
    )
    or (
        o.orgcode <> n.orgcode
        or o.cname <> n.cname
        or o.legalid <> n.legalid
        or o.adminid <> n.adminid
        or o.phone <> n.phone
        or o.email <> n.email
        or o.address <> n.address
        or o.status <> n.status
        or o.sys_ctime <> n.sys_ctime
        or o.sys_utime <> n.sys_utime
        or o.sys_valid <> n.sys_valid
        or o.logourl <> n.logourl
        or o.cpytype <> n.cpytype
        or o.summary <> n.summary
        or o.website <> n.website
        or o.legal <> n.legal
        or o.legalphone <> n.legalphone
        or o.contactinfo <> n.contactinfo
        or o.provinces <> n.provinces
        or o.city <> n.city
        or o.industryid <> n.industryid
        or o.isfunc <> n.isfunc
        or o.etype <> n.etype
        or o.estdate <> n.estdate
        or o.regcaptial <> n.regcaptial
        or o.uscc <> n.uscc
        or o.companyno <> n.companyno
        or o.authorgid <> n.authorgid
        or o.authtime <> n.authtime
        or o.authorgcode <> n.authorgcode
        or o.operusercode <> n.operusercode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_corp_info_cl(
            companyid -- 
            ,orgcode -- 
            ,cname -- 
            ,legalid -- 
            ,adminid -- 
            ,phone -- 
            ,email -- 
            ,address -- 
            ,status -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,logourl -- 
            ,cpytype -- 
            ,summary -- 
            ,website -- 
            ,legal -- 
            ,legalphone -- 
            ,contactinfo -- 
            ,provinces -- 
            ,city -- 
            ,industryid -- 
            ,isfunc -- 
            ,etype -- 
            ,estdate -- 
            ,regcaptial -- 
            ,uscc -- 
            ,companyno -- 
            ,authorgid -- 
            ,authtime -- 
            ,authorgcode -- 
            ,operusercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_corp_info_op(
            companyid -- 
            ,orgcode -- 
            ,cname -- 
            ,legalid -- 
            ,adminid -- 
            ,phone -- 
            ,email -- 
            ,address -- 
            ,status -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,logourl -- 
            ,cpytype -- 
            ,summary -- 
            ,website -- 
            ,legal -- 
            ,legalphone -- 
            ,contactinfo -- 
            ,provinces -- 
            ,city -- 
            ,industryid -- 
            ,isfunc -- 
            ,etype -- 
            ,estdate -- 
            ,regcaptial -- 
            ,uscc -- 
            ,companyno -- 
            ,authorgid -- 
            ,authtime -- 
            ,authorgcode -- 
            ,operusercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.companyid -- 
    ,o.orgcode -- 
    ,o.cname -- 
    ,o.legalid -- 
    ,o.adminid -- 
    ,o.phone -- 
    ,o.email -- 
    ,o.address -- 
    ,o.status -- 
    ,o.sys_ctime -- 
    ,o.sys_utime -- 
    ,o.sys_valid -- 
    ,o.logourl -- 
    ,o.cpytype -- 
    ,o.summary -- 
    ,o.website -- 
    ,o.legal -- 
    ,o.legalphone -- 
    ,o.contactinfo -- 
    ,o.provinces -- 
    ,o.city -- 
    ,o.industryid -- 
    ,o.isfunc -- 
    ,o.etype -- 
    ,o.estdate -- 
    ,o.regcaptial -- 
    ,o.uscc -- 
    ,o.companyno -- 
    ,o.authorgid -- 
    ,o.authtime -- 
    ,o.authorgcode -- 
    ,o.operusercode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_t_corp_info_bk o
    left join ${iol_schema}.tbms_t_corp_info_op n
        on
            o.companyid = n.companyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_t_corp_info_cl d
        on
            o.companyid = d.companyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_t_corp_info;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_t_corp_info exchange partition p_19000101 with table ${iol_schema}.tbms_t_corp_info_cl;
alter table ${iol_schema}.tbms_t_corp_info exchange partition p_20991231 with table ${iol_schema}.tbms_t_corp_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_t_corp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_corp_info_op purge;
drop table ${iol_schema}.tbms_t_corp_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_t_corp_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_t_corp_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
