/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_t_meet_teleinfo
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
create table ${iol_schema}.tbms_t_meet_teleinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_t_meet_teleinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_meet_teleinfo_op purge;
drop table ${iol_schema}.tbms_t_meet_teleinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_meet_teleinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_meet_teleinfo where 0=1;

create table ${iol_schema}.tbms_t_meet_teleinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_meet_teleinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_meet_teleinfo_cl(
            telemeetid -- 会议ID
            ,hwid -- 华为ID
            ,hwconfid -- 华为会议ID
            ,groupid -- 群组ID
            ,companyid -- 企业ID
            ,convener -- 会议召集人
            ,telemeettime -- 会议召集时间
            ,telemeettitle -- 会议主题
            ,telemeettype -- 会议类型
            ,duration -- 会议持续时长
            ,begintime -- 会议开始时间
            ,mark -- 会议议题
            ,status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
            ,cpwd -- 会议主席密码
            ,upwd -- 会议来宾密码
            ,versions -- 版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,channel -- 会议渠道，1-eSpace  2-VoIP
            ,jobid -- 调度任务ID
            ,chairmanid -- 主持人ID
            ,clientinfo -- 存储客户信息，新增时保存整个请求的json
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_meet_teleinfo_op(
            telemeetid -- 会议ID
            ,hwid -- 华为ID
            ,hwconfid -- 华为会议ID
            ,groupid -- 群组ID
            ,companyid -- 企业ID
            ,convener -- 会议召集人
            ,telemeettime -- 会议召集时间
            ,telemeettitle -- 会议主题
            ,telemeettype -- 会议类型
            ,duration -- 会议持续时长
            ,begintime -- 会议开始时间
            ,mark -- 会议议题
            ,status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
            ,cpwd -- 会议主席密码
            ,upwd -- 会议来宾密码
            ,versions -- 版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,channel -- 会议渠道，1-eSpace  2-VoIP
            ,jobid -- 调度任务ID
            ,chairmanid -- 主持人ID
            ,clientinfo -- 存储客户信息，新增时保存整个请求的json
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.telemeetid, o.telemeetid) as telemeetid -- 会议ID
    ,nvl(n.hwid, o.hwid) as hwid -- 华为ID
    ,nvl(n.hwconfid, o.hwconfid) as hwconfid -- 华为会议ID
    ,nvl(n.groupid, o.groupid) as groupid -- 群组ID
    ,nvl(n.companyid, o.companyid) as companyid -- 企业ID
    ,nvl(n.convener, o.convener) as convener -- 会议召集人
    ,nvl(n.telemeettime, o.telemeettime) as telemeettime -- 会议召集时间
    ,nvl(n.telemeettitle, o.telemeettitle) as telemeettitle -- 会议主题
    ,nvl(n.telemeettype, o.telemeettype) as telemeettype -- 会议类型
    ,nvl(n.duration, o.duration) as duration -- 会议持续时长
    ,nvl(n.begintime, o.begintime) as begintime -- 会议开始时间
    ,nvl(n.mark, o.mark) as mark -- 会议议题
    ,nvl(n.status, o.status) as status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
    ,nvl(n.cpwd, o.cpwd) as cpwd -- 会议主席密码
    ,nvl(n.upwd, o.upwd) as upwd -- 会议来宾密码
    ,nvl(n.versions, o.versions) as versions -- 版本号
    ,nvl(n.sys_ctime, o.sys_ctime) as sys_ctime -- 系统-创建时间
    ,nvl(n.sys_utime, o.sys_utime) as sys_utime -- 系统-修改时间
    ,nvl(n.sys_valid, o.sys_valid) as sys_valid -- 系统-有效状态
    ,nvl(n.channel, o.channel) as channel -- 会议渠道，1-eSpace  2-VoIP
    ,nvl(n.jobid, o.jobid) as jobid -- 调度任务ID
    ,nvl(n.chairmanid, o.chairmanid) as chairmanid -- 主持人ID
    ,nvl(n.clientinfo, o.clientinfo) as clientinfo -- 存储客户信息，新增时保存整个请求的json
    ,case when
            n.telemeetid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.telemeetid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.telemeetid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_t_meet_teleinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_t_meet_teleinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.telemeetid = n.telemeetid
where (
        o.telemeetid is null
    )
    or (
        n.telemeetid is null
    )
    or (
        o.hwid <> n.hwid
        or o.hwconfid <> n.hwconfid
        or o.groupid <> n.groupid
        or o.companyid <> n.companyid
        or o.convener <> n.convener
        or o.telemeettime <> n.telemeettime
        or o.telemeettitle <> n.telemeettitle
        or o.telemeettype <> n.telemeettype
        or o.duration <> n.duration
        or o.begintime <> n.begintime
        or o.mark <> n.mark
        or o.status <> n.status
        or o.cpwd <> n.cpwd
        or o.upwd <> n.upwd
        or o.versions <> n.versions
        or o.sys_ctime <> n.sys_ctime
        or o.sys_utime <> n.sys_utime
        or o.sys_valid <> n.sys_valid
        or o.channel <> n.channel
        or o.jobid <> n.jobid
        or o.chairmanid <> n.chairmanid
        or o.clientinfo <> n.clientinfo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_meet_teleinfo_cl(
            telemeetid -- 会议ID
            ,hwid -- 华为ID
            ,hwconfid -- 华为会议ID
            ,groupid -- 群组ID
            ,companyid -- 企业ID
            ,convener -- 会议召集人
            ,telemeettime -- 会议召集时间
            ,telemeettitle -- 会议主题
            ,telemeettype -- 会议类型
            ,duration -- 会议持续时长
            ,begintime -- 会议开始时间
            ,mark -- 会议议题
            ,status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
            ,cpwd -- 会议主席密码
            ,upwd -- 会议来宾密码
            ,versions -- 版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,channel -- 会议渠道，1-eSpace  2-VoIP
            ,jobid -- 调度任务ID
            ,chairmanid -- 主持人ID
            ,clientinfo -- 存储客户信息，新增时保存整个请求的json
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_meet_teleinfo_op(
            telemeetid -- 会议ID
            ,hwid -- 华为ID
            ,hwconfid -- 华为会议ID
            ,groupid -- 群组ID
            ,companyid -- 企业ID
            ,convener -- 会议召集人
            ,telemeettime -- 会议召集时间
            ,telemeettitle -- 会议主题
            ,telemeettype -- 会议类型
            ,duration -- 会议持续时长
            ,begintime -- 会议开始时间
            ,mark -- 会议议题
            ,status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
            ,cpwd -- 会议主席密码
            ,upwd -- 会议来宾密码
            ,versions -- 版本号
            ,sys_ctime -- 系统-创建时间
            ,sys_utime -- 系统-修改时间
            ,sys_valid -- 系统-有效状态
            ,channel -- 会议渠道，1-eSpace  2-VoIP
            ,jobid -- 调度任务ID
            ,chairmanid -- 主持人ID
            ,clientinfo -- 存储客户信息，新增时保存整个请求的json
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.telemeetid -- 会议ID
    ,o.hwid -- 华为ID
    ,o.hwconfid -- 华为会议ID
    ,o.groupid -- 群组ID
    ,o.companyid -- 企业ID
    ,o.convener -- 会议召集人
    ,o.telemeettime -- 会议召集时间
    ,o.telemeettitle -- 会议主题
    ,o.telemeettype -- 会议类型
    ,o.duration -- 会议持续时长
    ,o.begintime -- 会议开始时间
    ,o.mark -- 会议议题
    ,o.status -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
    ,o.cpwd -- 会议主席密码
    ,o.upwd -- 会议来宾密码
    ,o.versions -- 版本号
    ,o.sys_ctime -- 系统-创建时间
    ,o.sys_utime -- 系统-修改时间
    ,o.sys_valid -- 系统-有效状态
    ,o.channel -- 会议渠道，1-eSpace  2-VoIP
    ,o.jobid -- 调度任务ID
    ,o.chairmanid -- 主持人ID
    ,o.clientinfo -- 存储客户信息，新增时保存整个请求的json
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_t_meet_teleinfo_bk o
    left join ${iol_schema}.tbms_t_meet_teleinfo_op n
        on
            o.telemeetid = n.telemeetid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_t_meet_teleinfo_cl d
        on
            o.telemeetid = d.telemeetid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_t_meet_teleinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_t_meet_teleinfo exchange partition p_19000101 with table ${iol_schema}.tbms_t_meet_teleinfo_cl;
alter table ${iol_schema}.tbms_t_meet_teleinfo exchange partition p_20991231 with table ${iol_schema}.tbms_t_meet_teleinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_t_meet_teleinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_meet_teleinfo_op purge;
drop table ${iol_schema}.tbms_t_meet_teleinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_t_meet_teleinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_t_meet_teleinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
