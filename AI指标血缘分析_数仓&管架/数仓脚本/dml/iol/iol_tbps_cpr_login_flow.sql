/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_login_flow
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
create table ${iol_schema}.tbps_cpr_login_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_login_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_login_flow_op purge;
drop table ${iol_schema}.tbps_cpr_login_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_login_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_login_flow where 0=1;

create table ${iol_schema}.tbps_cpr_login_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_login_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_login_flow_cl(
            clf_logno -- 访问流水号
            ,clf_userno -- 用户顺序号
            ,clf_ecifno -- 全行统一客户号
            ,clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
            ,clf_date -- 日期
            ,clf_time -- 时间
            ,clf_customerip -- 客户IP
            ,clf_channel -- 客户渠道标识(PC)
            ,clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
            ,clf_returncode -- 返回码
            ,clf_returnmsg -- 返回信息
            ,clf_ifp_sid -- sessionId
            ,clf_hostip -- 服务IP
            ,clf_wxcode -- 微信号
            ,clf_useragent -- 客户浏览器类型
            ,clf_token -- 跳转登录token
            ,clf_globalflow -- 全局流水
            ,clf_clientmac -- 客户MAC地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_login_flow_op(
            clf_logno -- 访问流水号
            ,clf_userno -- 用户顺序号
            ,clf_ecifno -- 全行统一客户号
            ,clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
            ,clf_date -- 日期
            ,clf_time -- 时间
            ,clf_customerip -- 客户IP
            ,clf_channel -- 客户渠道标识(PC)
            ,clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
            ,clf_returncode -- 返回码
            ,clf_returnmsg -- 返回信息
            ,clf_ifp_sid -- sessionId
            ,clf_hostip -- 服务IP
            ,clf_wxcode -- 微信号
            ,clf_useragent -- 客户浏览器类型
            ,clf_token -- 跳转登录token
            ,clf_globalflow -- 全局流水
            ,clf_clientmac -- 客户MAC地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clf_logno, o.clf_logno) as clf_logno -- 访问流水号
    ,nvl(n.clf_userno, o.clf_userno) as clf_userno -- 用户顺序号
    ,nvl(n.clf_ecifno, o.clf_ecifno) as clf_ecifno -- 全行统一客户号
    ,nvl(n.clf_state, o.clf_state) as clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
    ,nvl(n.clf_date, o.clf_date) as clf_date -- 日期
    ,nvl(n.clf_time, o.clf_time) as clf_time -- 时间
    ,nvl(n.clf_customerip, o.clf_customerip) as clf_customerip -- 客户IP
    ,nvl(n.clf_channel, o.clf_channel) as clf_channel -- 客户渠道标识(PC)
    ,nvl(n.clf_logintype, o.clf_logintype) as clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
    ,nvl(n.clf_returncode, o.clf_returncode) as clf_returncode -- 返回码
    ,nvl(n.clf_returnmsg, o.clf_returnmsg) as clf_returnmsg -- 返回信息
    ,nvl(n.clf_ifp_sid, o.clf_ifp_sid) as clf_ifp_sid -- sessionId
    ,nvl(n.clf_hostip, o.clf_hostip) as clf_hostip -- 服务IP
    ,nvl(n.clf_wxcode, o.clf_wxcode) as clf_wxcode -- 微信号
    ,nvl(n.clf_useragent, o.clf_useragent) as clf_useragent -- 客户浏览器类型
    ,nvl(n.clf_token, o.clf_token) as clf_token -- 跳转登录token
    ,nvl(n.clf_globalflow, o.clf_globalflow) as clf_globalflow -- 全局流水
    ,nvl(n.clf_clientmac, o.clf_clientmac) as clf_clientmac -- 客户MAC地址
    ,case when
            n.clf_logno is null
            and n.clf_state is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clf_logno is null
            and n.clf_state is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clf_logno is null
            and n.clf_state is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_login_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_login_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clf_logno = n.clf_logno
            and o.clf_state = n.clf_state
where (
        o.clf_logno is null
        and o.clf_state is null
    )
    or (
        n.clf_logno is null
        and n.clf_state is null
    )
    or (
        o.clf_userno <> n.clf_userno
        or o.clf_ecifno <> n.clf_ecifno
        or o.clf_date <> n.clf_date
        or o.clf_time <> n.clf_time
        or o.clf_customerip <> n.clf_customerip
        or o.clf_channel <> n.clf_channel
        or o.clf_logintype <> n.clf_logintype
        or o.clf_returncode <> n.clf_returncode
        or o.clf_returnmsg <> n.clf_returnmsg
        or o.clf_ifp_sid <> n.clf_ifp_sid
        or o.clf_hostip <> n.clf_hostip
        or o.clf_wxcode <> n.clf_wxcode
        or o.clf_useragent <> n.clf_useragent
        or o.clf_token <> n.clf_token
        or o.clf_globalflow <> n.clf_globalflow
        or o.clf_clientmac <> n.clf_clientmac
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_login_flow_cl(
            clf_logno -- 访问流水号
            ,clf_userno -- 用户顺序号
            ,clf_ecifno -- 全行统一客户号
            ,clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
            ,clf_date -- 日期
            ,clf_time -- 时间
            ,clf_customerip -- 客户IP
            ,clf_channel -- 客户渠道标识(PC)
            ,clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
            ,clf_returncode -- 返回码
            ,clf_returnmsg -- 返回信息
            ,clf_ifp_sid -- sessionId
            ,clf_hostip -- 服务IP
            ,clf_wxcode -- 微信号
            ,clf_useragent -- 客户浏览器类型
            ,clf_token -- 跳转登录token
            ,clf_globalflow -- 全局流水
            ,clf_clientmac -- 客户MAC地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_login_flow_op(
            clf_logno -- 访问流水号
            ,clf_userno -- 用户顺序号
            ,clf_ecifno -- 全行统一客户号
            ,clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
            ,clf_date -- 日期
            ,clf_time -- 时间
            ,clf_customerip -- 客户IP
            ,clf_channel -- 客户渠道标识(PC)
            ,clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
            ,clf_returncode -- 返回码
            ,clf_returnmsg -- 返回信息
            ,clf_ifp_sid -- sessionId
            ,clf_hostip -- 服务IP
            ,clf_wxcode -- 微信号
            ,clf_useragent -- 客户浏览器类型
            ,clf_token -- 跳转登录token
            ,clf_globalflow -- 全局流水
            ,clf_clientmac -- 客户MAC地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clf_logno -- 访问流水号
    ,o.clf_userno -- 用户顺序号
    ,o.clf_ecifno -- 全行统一客户号
    ,o.clf_state -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
    ,o.clf_date -- 日期
    ,o.clf_time -- 时间
    ,o.clf_customerip -- 客户IP
    ,o.clf_channel -- 客户渠道标识(PC)
    ,o.clf_logintype -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
    ,o.clf_returncode -- 返回码
    ,o.clf_returnmsg -- 返回信息
    ,o.clf_ifp_sid -- sessionId
    ,o.clf_hostip -- 服务IP
    ,o.clf_wxcode -- 微信号
    ,o.clf_useragent -- 客户浏览器类型
    ,o.clf_token -- 跳转登录token
    ,o.clf_globalflow -- 全局流水
    ,o.clf_clientmac -- 客户MAC地址
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
from ${iol_schema}.tbps_cpr_login_flow_bk o
    left join ${iol_schema}.tbps_cpr_login_flow_op n
        on
            o.clf_logno = n.clf_logno
            and o.clf_state = n.clf_state
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_login_flow_cl d
        on
            o.clf_logno = d.clf_logno
            and o.clf_state = d.clf_state
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tbps_cpr_login_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tbps_cpr_login_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tbps_cpr_login_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tbps_cpr_login_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tbps_cpr_login_flow exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_login_flow_cl;
alter table ${iol_schema}.tbps_cpr_login_flow exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_login_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_login_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_login_flow_op purge;
drop table ${iol_schema}.tbps_cpr_login_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_login_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_login_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
