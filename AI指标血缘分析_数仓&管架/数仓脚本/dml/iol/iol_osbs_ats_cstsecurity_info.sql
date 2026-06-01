/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ats_cstsecurity_info
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
create table ${iol_schema}.osbs_ats_cstsecurity_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_ats_cstsecurity_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_cstsecurity_info_op purge;
drop table ${iol_schema}.osbs_ats_cstsecurity_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_cstsecurity_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_cstsecurity_info where 0=1;

create table ${iol_schema}.osbs_ats_cstsecurity_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_cstsecurity_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_cstsecurity_info_cl(
            aci_cstno -- 客户号
            ,aci_userno -- 用户号
            ,aci_securityno -- 安全工具编号
            ,aci_securityname -- 安全工具名称
            ,aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
            ,aci_securitylevel -- 安全等级
            ,aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
            ,aci_createtime -- 创建时间
            ,aci_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_cstsecurity_info_op(
            aci_cstno -- 客户号
            ,aci_userno -- 用户号
            ,aci_securityno -- 安全工具编号
            ,aci_securityname -- 安全工具名称
            ,aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
            ,aci_securitylevel -- 安全等级
            ,aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
            ,aci_createtime -- 创建时间
            ,aci_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.aci_cstno, o.aci_cstno) as aci_cstno -- 客户号
    ,nvl(n.aci_userno, o.aci_userno) as aci_userno -- 用户号
    ,nvl(n.aci_securityno, o.aci_securityno) as aci_securityno -- 安全工具编号
    ,nvl(n.aci_securityname, o.aci_securityname) as aci_securityname -- 安全工具名称
    ,nvl(n.aci_security, o.aci_security) as aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
    ,nvl(n.aci_securitylevel, o.aci_securitylevel) as aci_securitylevel -- 安全等级
    ,nvl(n.aci_status, o.aci_status) as aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
    ,nvl(n.aci_createtime, o.aci_createtime) as aci_createtime -- 创建时间
    ,nvl(n.aci_updatetime, o.aci_updatetime) as aci_updatetime -- 修改时间
    ,case when
            n.aci_cstno is null
            and n.aci_securityno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.aci_cstno is null
            and n.aci_securityno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.aci_cstno is null
            and n.aci_securityno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_ats_cstsecurity_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_ats_cstsecurity_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.aci_cstno = n.aci_cstno
            and o.aci_securityno = n.aci_securityno
where (
        o.aci_cstno is null
        and o.aci_securityno is null
    )
    or (
        n.aci_cstno is null
        and n.aci_securityno is null
    )
    or (
        o.aci_userno <> n.aci_userno
        or o.aci_securityname <> n.aci_securityname
        or o.aci_security <> n.aci_security
        or o.aci_securitylevel <> n.aci_securitylevel
        or o.aci_status <> n.aci_status
        or o.aci_createtime <> n.aci_createtime
        or o.aci_updatetime <> n.aci_updatetime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_cstsecurity_info_cl(
            aci_cstno -- 客户号
            ,aci_userno -- 用户号
            ,aci_securityno -- 安全工具编号
            ,aci_securityname -- 安全工具名称
            ,aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
            ,aci_securitylevel -- 安全等级
            ,aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
            ,aci_createtime -- 创建时间
            ,aci_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_cstsecurity_info_op(
            aci_cstno -- 客户号
            ,aci_userno -- 用户号
            ,aci_securityno -- 安全工具编号
            ,aci_securityname -- 安全工具名称
            ,aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
            ,aci_securitylevel -- 安全等级
            ,aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
            ,aci_createtime -- 创建时间
            ,aci_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.aci_cstno -- 客户号
    ,o.aci_userno -- 用户号
    ,o.aci_securityno -- 安全工具编号
    ,o.aci_securityname -- 安全工具名称
    ,o.aci_security -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
    ,o.aci_securitylevel -- 安全等级
    ,o.aci_status -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
    ,o.aci_createtime -- 创建时间
    ,o.aci_updatetime -- 修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_ats_cstsecurity_info_bk o
    left join ${iol_schema}.osbs_ats_cstsecurity_info_op n
        on
            o.aci_cstno = n.aci_cstno
            and o.aci_securityno = n.aci_securityno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_ats_cstsecurity_info_cl d
        on
            o.aci_cstno = d.aci_cstno
            and o.aci_securityno = d.aci_securityno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_ats_cstsecurity_info;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_ats_cstsecurity_info exchange partition p_19000101 with table ${iol_schema}.osbs_ats_cstsecurity_info_cl;
alter table ${iol_schema}.osbs_ats_cstsecurity_info exchange partition p_20991231 with table ${iol_schema}.osbs_ats_cstsecurity_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ats_cstsecurity_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_cstsecurity_info_op purge;
drop table ${iol_schema}.osbs_ats_cstsecurity_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_ats_cstsecurity_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ats_cstsecurity_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
