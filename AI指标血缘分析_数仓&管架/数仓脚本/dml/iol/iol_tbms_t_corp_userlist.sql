/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_t_corp_userlist
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
create table ${iol_schema}.tbms_t_corp_userlist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_t_corp_userlist;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_corp_userlist_op purge;
drop table ${iol_schema}.tbms_t_corp_userlist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_corp_userlist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_corp_userlist where 0=1;

create table ${iol_schema}.tbms_t_corp_userlist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_corp_userlist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_corp_userlist_cl(
            companyid -- 企业ID
            ,uaid -- 用户ID
            ,username -- 用户名
            ,userphone -- 用户手机号
            ,sex -- 性别,性别 0:女  1:男
            ,birthdate -- 生日
            ,workphone -- 公司座机
            ,workextension -- 分机号
            ,workemail -- 企业邮箱
            ,workno -- 工号
            ,status -- 成员状态,0:未激活,1:已激活,2拒绝加入
            ,iconid -- 头像ID
            ,usercustom -- 用户自定义信息
            ,relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
            ,friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
            ,usertype -- 用户类型：默认1个人,2 银企通
            ,certificatetype -- 证件类型：默认1身份证,2护照
            ,certificatenum -- 证件号
            ,versions -- 通讯录版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,applystate -- 申请状态
            ,applyreason -- 申请原因
            ,last_request_ip -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_corp_userlist_op(
            companyid -- 企业ID
            ,uaid -- 用户ID
            ,username -- 用户名
            ,userphone -- 用户手机号
            ,sex -- 性别,性别 0:女  1:男
            ,birthdate -- 生日
            ,workphone -- 公司座机
            ,workextension -- 分机号
            ,workemail -- 企业邮箱
            ,workno -- 工号
            ,status -- 成员状态,0:未激活,1:已激活,2拒绝加入
            ,iconid -- 头像ID
            ,usercustom -- 用户自定义信息
            ,relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
            ,friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
            ,usertype -- 用户类型：默认1个人,2 银企通
            ,certificatetype -- 证件类型：默认1身份证,2护照
            ,certificatenum -- 证件号
            ,versions -- 通讯录版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,applystate -- 申请状态
            ,applyreason -- 申请原因
            ,last_request_ip -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.companyid, o.companyid) as companyid -- 企业ID
    ,nvl(n.uaid, o.uaid) as uaid -- 用户ID
    ,nvl(n.username, o.username) as username -- 用户名
    ,nvl(n.userphone, o.userphone) as userphone -- 用户手机号
    ,nvl(n.sex, o.sex) as sex -- 性别,性别 0:女  1:男
    ,nvl(n.birthdate, o.birthdate) as birthdate -- 生日
    ,nvl(n.workphone, o.workphone) as workphone -- 公司座机
    ,nvl(n.workextension, o.workextension) as workextension -- 分机号
    ,nvl(n.workemail, o.workemail) as workemail -- 企业邮箱
    ,nvl(n.workno, o.workno) as workno -- 工号
    ,nvl(n.status, o.status) as status -- 成员状态,0:未激活,1:已激活,2拒绝加入
    ,nvl(n.iconid, o.iconid) as iconid -- 头像ID
    ,nvl(n.usercustom, o.usercustom) as usercustom -- 用户自定义信息
    ,nvl(n.relationstatus, o.relationstatus) as relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
    ,nvl(n.friendstatus, o.friendstatus) as friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
    ,nvl(n.usertype, o.usertype) as usertype -- 用户类型：默认1个人,2 银企通
    ,nvl(n.certificatetype, o.certificatetype) as certificatetype -- 证件类型：默认1身份证,2护照
    ,nvl(n.certificatenum, o.certificatenum) as certificatenum -- 证件号
    ,nvl(n.versions, o.versions) as versions -- 通讯录版本号
    ,nvl(n.sys_ctime, o.sys_ctime) as sys_ctime -- 系统-创建时间
    ,nvl(n.sys_utime, o.sys_utime) as sys_utime -- 系统-修改时间
    ,nvl(n.sys_valid, o.sys_valid) as sys_valid -- 系统-有效状态
    ,nvl(n.applystate, o.applystate) as applystate -- 申请状态
    ,nvl(n.applyreason, o.applyreason) as applyreason -- 申请原因
    ,nvl(n.last_request_ip, o.last_request_ip) as last_request_ip -- 
    ,case when
            n.companyid is null
            and n.uaid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.companyid is null
            and n.uaid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.companyid is null
            and n.uaid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_t_corp_userlist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_t_corp_userlist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.companyid = n.companyid
            and o.uaid = n.uaid
where (
        o.companyid is null
        and o.uaid is null
    )
    or (
        n.companyid is null
        and n.uaid is null
    )
    or (
        o.username <> n.username
        or o.userphone <> n.userphone
        or o.sex <> n.sex
        or o.birthdate <> n.birthdate
        or o.workphone <> n.workphone
        or o.workextension <> n.workextension
        or o.workemail <> n.workemail
        or o.workno <> n.workno
        or o.status <> n.status
        or o.iconid <> n.iconid
        or o.usercustom <> n.usercustom
        or o.relationstatus <> n.relationstatus
        or o.friendstatus <> n.friendstatus
        or o.usertype <> n.usertype
        or o.certificatetype <> n.certificatetype
        or o.certificatenum <> n.certificatenum
        or o.versions <> n.versions
        or o.sys_ctime <> n.sys_ctime
        or o.sys_utime <> n.sys_utime
        or o.sys_valid <> n.sys_valid
        or o.applystate <> n.applystate
        or o.applyreason <> n.applyreason
        or o.last_request_ip <> n.last_request_ip
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_corp_userlist_cl(
            companyid -- 企业ID
            ,uaid -- 用户ID
            ,username -- 用户名
            ,userphone -- 用户手机号
            ,sex -- 性别,性别 0:女  1:男
            ,birthdate -- 生日
            ,workphone -- 公司座机
            ,workextension -- 分机号
            ,workemail -- 企业邮箱
            ,workno -- 工号
            ,status -- 成员状态,0:未激活,1:已激活,2拒绝加入
            ,iconid -- 头像ID
            ,usercustom -- 用户自定义信息
            ,relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
            ,friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
            ,usertype -- 用户类型：默认1个人,2 银企通
            ,certificatetype -- 证件类型：默认1身份证,2护照
            ,certificatenum -- 证件号
            ,versions -- 通讯录版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,applystate -- 申请状态
            ,applyreason -- 申请原因
            ,last_request_ip -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_corp_userlist_op(
            companyid -- 企业ID
            ,uaid -- 用户ID
            ,username -- 用户名
            ,userphone -- 用户手机号
            ,sex -- 性别,性别 0:女  1:男
            ,birthdate -- 生日
            ,workphone -- 公司座机
            ,workextension -- 分机号
            ,workemail -- 企业邮箱
            ,workno -- 工号
            ,status -- 成员状态,0:未激活,1:已激活,2拒绝加入
            ,iconid -- 头像ID
            ,usercustom -- 用户自定义信息
            ,relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
            ,friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
            ,usertype -- 用户类型：默认1个人,2 银企通
            ,certificatetype -- 证件类型：默认1身份证,2护照
            ,certificatenum -- 证件号
            ,versions -- 通讯录版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,applystate -- 申请状态
            ,applyreason -- 申请原因
            ,last_request_ip -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.companyid -- 企业ID
    ,o.uaid -- 用户ID
    ,o.username -- 用户名
    ,o.userphone -- 用户手机号
    ,o.sex -- 性别,性别 0:女  1:男
    ,o.birthdate -- 生日
    ,o.workphone -- 公司座机
    ,o.workextension -- 分机号
    ,o.workemail -- 企业邮箱
    ,o.workno -- 工号
    ,o.status -- 成员状态,0:未激活,1:已激活,2拒绝加入
    ,o.iconid -- 头像ID
    ,o.usercustom -- 用户自定义信息
    ,o.relationstatus -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
    ,o.friendstatus -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
    ,o.usertype -- 用户类型：默认1个人,2 银企通
    ,o.certificatetype -- 证件类型：默认1身份证,2护照
    ,o.certificatenum -- 证件号
    ,o.versions -- 通讯录版本号
    ,o.sys_ctime -- 系统-创建时间
    ,o.sys_utime -- 系统-修改时间
    ,o.sys_valid -- 系统-有效状态
    ,o.applystate -- 申请状态
    ,o.applyreason -- 申请原因
    ,o.last_request_ip -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_t_corp_userlist_bk o
    left join ${iol_schema}.tbms_t_corp_userlist_op n
        on
            o.companyid = n.companyid
            and o.uaid = n.uaid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_t_corp_userlist_cl d
        on
            o.companyid = d.companyid
            and o.uaid = d.uaid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_t_corp_userlist;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_t_corp_userlist exchange partition p_19000101 with table ${iol_schema}.tbms_t_corp_userlist_cl;
alter table ${iol_schema}.tbms_t_corp_userlist exchange partition p_20991231 with table ${iol_schema}.tbms_t_corp_userlist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_t_corp_userlist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_corp_userlist_op purge;
drop table ${iol_schema}.tbms_t_corp_userlist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_t_corp_userlist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_t_corp_userlist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
