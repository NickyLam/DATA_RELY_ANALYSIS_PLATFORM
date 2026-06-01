/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scrm_sys_user
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
create table ${iol_schema}.scrm_sys_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scrm_sys_user
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_sys_user_op purge;
drop table ${iol_schema}.scrm_sys_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_sys_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_sys_user where 0=1;

create table ${iol_schema}.scrm_sys_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_sys_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_sys_user_cl(
            user_id -- 用户ID
            ,qw_user_id -- 企微用户ID。开通企微后有值
            ,dept_id -- 部门ID
            ,user_name -- 用户名称
            ,user_alias -- 别名
            ,user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
            ,email -- 用户邮箱
            ,mobile -- 手机号码
            ,gender -- 用户性别（1男 2女 3未知）
            ,avatar -- 头像地址
            ,join_date -- 入职时间
            ,id_card -- 身份证号
            ,qrcode -- 个人二维码
            ,wx_account -- 个人微信号
            ,qq_account -- QQ号
            ,telephone -- 座机
            ,addr -- 地址
            ,dimission_date -- 离职日期
            ,birthday -- 生日
            ,remark -- 备注
            ,is_allocate -- 离职是否分配(1:已分配;0:未分配;)
            ,isopenchat -- 是否开启会话存档 0：关闭 1：开启
            ,corp_id -- 归属企业
            ,corp_name -- 归属企业名称
            ,status -- 状态（1正常 0停用）
            ,qw_status -- 企微状态：1启用，0停用，-1删除(离职)
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,user_no -- 员工编号
            ,shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
            ,auth_flag -- 是否已核验：0-未核验 1-已核验
            ,sop_flag -- 客户是否提醒，0是，1否
            ,config_id -- 二维码配置id
            ,is_dept_leader -- 是否部门领导。0-否；1-是
            ,direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
            ,post_name -- 职务
            ,dist_line -- 是否已分配条线。1：已分配；0：未分配
            ,user_ticket -- 成员票据。员工授权后可获取敏感信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_sys_user_op(
            user_id -- 用户ID
            ,qw_user_id -- 企微用户ID。开通企微后有值
            ,dept_id -- 部门ID
            ,user_name -- 用户名称
            ,user_alias -- 别名
            ,user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
            ,email -- 用户邮箱
            ,mobile -- 手机号码
            ,gender -- 用户性别（1男 2女 3未知）
            ,avatar -- 头像地址
            ,join_date -- 入职时间
            ,id_card -- 身份证号
            ,qrcode -- 个人二维码
            ,wx_account -- 个人微信号
            ,qq_account -- QQ号
            ,telephone -- 座机
            ,addr -- 地址
            ,dimission_date -- 离职日期
            ,birthday -- 生日
            ,remark -- 备注
            ,is_allocate -- 离职是否分配(1:已分配;0:未分配;)
            ,isopenchat -- 是否开启会话存档 0：关闭 1：开启
            ,corp_id -- 归属企业
            ,corp_name -- 归属企业名称
            ,status -- 状态（1正常 0停用）
            ,qw_status -- 企微状态：1启用，0停用，-1删除(离职)
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,user_no -- 员工编号
            ,shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
            ,auth_flag -- 是否已核验：0-未核验 1-已核验
            ,sop_flag -- 客户是否提醒，0是，1否
            ,config_id -- 二维码配置id
            ,is_dept_leader -- 是否部门领导。0-否；1-是
            ,direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
            ,post_name -- 职务
            ,dist_line -- 是否已分配条线。1：已分配；0：未分配
            ,user_ticket -- 成员票据。员工授权后可获取敏感信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 用户ID
    ,nvl(n.qw_user_id, o.qw_user_id) as qw_user_id -- 企微用户ID。开通企微后有值
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门ID
    ,nvl(n.user_name, o.user_name) as user_name -- 用户名称
    ,nvl(n.user_alias, o.user_alias) as user_alias -- 别名
    ,nvl(n.user_type, o.user_type) as user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
    ,nvl(n.email, o.email) as email -- 用户邮箱
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.gender, o.gender) as gender -- 用户性别（1男 2女 3未知）
    ,nvl(n.avatar, o.avatar) as avatar -- 头像地址
    ,nvl(n.join_date, o.join_date) as join_date -- 入职时间
    ,nvl(n.id_card, o.id_card) as id_card -- 身份证号
    ,nvl(n.qrcode, o.qrcode) as qrcode -- 个人二维码
    ,nvl(n.wx_account, o.wx_account) as wx_account -- 个人微信号
    ,nvl(n.qq_account, o.qq_account) as qq_account -- QQ号
    ,nvl(n.telephone, o.telephone) as telephone -- 座机
    ,nvl(n.addr, o.addr) as addr -- 地址
    ,nvl(n.dimission_date, o.dimission_date) as dimission_date -- 离职日期
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.is_allocate, o.is_allocate) as is_allocate -- 离职是否分配(1:已分配;0:未分配;)
    ,nvl(n.isopenchat, o.isopenchat) as isopenchat -- 是否开启会话存档 0：关闭 1：开启
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 归属企业
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 归属企业名称
    ,nvl(n.status, o.status) as status -- 状态（1正常 0停用）
    ,nvl(n.qw_status, o.qw_status) as qw_status -- 企微状态：1启用，0停用，-1删除(离职)
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_modi_by, o.last_modi_by) as last_modi_by -- 最后修改人
    ,nvl(n.last_modi_time, o.last_modi_time) as last_modi_time -- 最后修改时间
    ,nvl(n.user_no, o.user_no) as user_no -- 员工编号
    ,nvl(n.shop_status, o.shop_status) as shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
    ,nvl(n.auth_flag, o.auth_flag) as auth_flag -- 是否已核验：0-未核验 1-已核验
    ,nvl(n.sop_flag, o.sop_flag) as sop_flag -- 客户是否提醒，0是，1否
    ,nvl(n.config_id, o.config_id) as config_id -- 二维码配置id
    ,nvl(n.is_dept_leader, o.is_dept_leader) as is_dept_leader -- 是否部门领导。0-否；1-是
    ,nvl(n.direct_leader, o.direct_leader) as direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
    ,nvl(n.post_name, o.post_name) as post_name -- 职务
    ,nvl(n.dist_line, o.dist_line) as dist_line -- 是否已分配条线。1：已分配；0：未分配
    ,nvl(n.user_ticket, o.user_ticket) as user_ticket -- 成员票据。员工授权后可获取敏感信息
    ,case when
            n.user_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.user_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.user_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scrm_sys_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scrm_sys_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.user_id = n.user_id
where (
        o.user_id is null
    )
    or (
        n.user_id is null
    )
    or (
        o.qw_user_id <> n.qw_user_id
        or o.dept_id <> n.dept_id
        or o.user_name <> n.user_name
        or o.user_alias <> n.user_alias
        or o.user_type <> n.user_type
        or o.email <> n.email
        or o.mobile <> n.mobile
        or o.gender <> n.gender
        or o.avatar <> n.avatar
        or o.join_date <> n.join_date
        or o.id_card <> n.id_card
        or o.qrcode <> n.qrcode
        or o.wx_account <> n.wx_account
        or o.qq_account <> n.qq_account
        or o.telephone <> n.telephone
        or o.addr <> n.addr
        or o.dimission_date <> n.dimission_date
        or o.birthday <> n.birthday
        or o.remark <> n.remark
        or o.is_allocate <> n.is_allocate
        or o.isopenchat <> n.isopenchat
        or o.corp_id <> n.corp_id
        or o.corp_name <> n.corp_name
        or o.status <> n.status
        or o.qw_status <> n.qw_status
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
        or o.last_modi_by <> n.last_modi_by
        or o.last_modi_time <> n.last_modi_time
        or o.user_no <> n.user_no
        or o.shop_status <> n.shop_status
        or o.auth_flag <> n.auth_flag
        or o.sop_flag <> n.sop_flag
        or o.config_id <> n.config_id
        or o.is_dept_leader <> n.is_dept_leader
        or o.direct_leader <> n.direct_leader
        or o.post_name <> n.post_name
        or o.dist_line <> n.dist_line
        or o.user_ticket <> n.user_ticket
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_sys_user_cl(
            user_id -- 用户ID
            ,qw_user_id -- 企微用户ID。开通企微后有值
            ,dept_id -- 部门ID
            ,user_name -- 用户名称
            ,user_alias -- 别名
            ,user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
            ,email -- 用户邮箱
            ,mobile -- 手机号码
            ,gender -- 用户性别（1男 2女 3未知）
            ,avatar -- 头像地址
            ,join_date -- 入职时间
            ,id_card -- 身份证号
            ,qrcode -- 个人二维码
            ,wx_account -- 个人微信号
            ,qq_account -- QQ号
            ,telephone -- 座机
            ,addr -- 地址
            ,dimission_date -- 离职日期
            ,birthday -- 生日
            ,remark -- 备注
            ,is_allocate -- 离职是否分配(1:已分配;0:未分配;)
            ,isopenchat -- 是否开启会话存档 0：关闭 1：开启
            ,corp_id -- 归属企业
            ,corp_name -- 归属企业名称
            ,status -- 状态（1正常 0停用）
            ,qw_status -- 企微状态：1启用，0停用，-1删除(离职)
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,user_no -- 员工编号
            ,shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
            ,auth_flag -- 是否已核验：0-未核验 1-已核验
            ,sop_flag -- 客户是否提醒，0是，1否
            ,config_id -- 二维码配置id
            ,is_dept_leader -- 是否部门领导。0-否；1-是
            ,direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
            ,post_name -- 职务
            ,dist_line -- 是否已分配条线。1：已分配；0：未分配
            ,user_ticket -- 成员票据。员工授权后可获取敏感信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_sys_user_op(
            user_id -- 用户ID
            ,qw_user_id -- 企微用户ID。开通企微后有值
            ,dept_id -- 部门ID
            ,user_name -- 用户名称
            ,user_alias -- 别名
            ,user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
            ,email -- 用户邮箱
            ,mobile -- 手机号码
            ,gender -- 用户性别（1男 2女 3未知）
            ,avatar -- 头像地址
            ,join_date -- 入职时间
            ,id_card -- 身份证号
            ,qrcode -- 个人二维码
            ,wx_account -- 个人微信号
            ,qq_account -- QQ号
            ,telephone -- 座机
            ,addr -- 地址
            ,dimission_date -- 离职日期
            ,birthday -- 生日
            ,remark -- 备注
            ,is_allocate -- 离职是否分配(1:已分配;0:未分配;)
            ,isopenchat -- 是否开启会话存档 0：关闭 1：开启
            ,corp_id -- 归属企业
            ,corp_name -- 归属企业名称
            ,status -- 状态（1正常 0停用）
            ,qw_status -- 企微状态：1启用，0停用，-1删除(离职)
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,user_no -- 员工编号
            ,shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
            ,auth_flag -- 是否已核验：0-未核验 1-已核验
            ,sop_flag -- 客户是否提醒，0是，1否
            ,config_id -- 二维码配置id
            ,is_dept_leader -- 是否部门领导。0-否；1-是
            ,direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
            ,post_name -- 职务
            ,dist_line -- 是否已分配条线。1：已分配；0：未分配
            ,user_ticket -- 成员票据。员工授权后可获取敏感信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 用户ID
    ,o.qw_user_id -- 企微用户ID。开通企微后有值
    ,o.dept_id -- 部门ID
    ,o.user_name -- 用户名称
    ,o.user_alias -- 别名
    ,o.user_type -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
    ,o.email -- 用户邮箱
    ,o.mobile -- 手机号码
    ,o.gender -- 用户性别（1男 2女 3未知）
    ,o.avatar -- 头像地址
    ,o.join_date -- 入职时间
    ,o.id_card -- 身份证号
    ,o.qrcode -- 个人二维码
    ,o.wx_account -- 个人微信号
    ,o.qq_account -- QQ号
    ,o.telephone -- 座机
    ,o.addr -- 地址
    ,o.dimission_date -- 离职日期
    ,o.birthday -- 生日
    ,o.remark -- 备注
    ,o.is_allocate -- 离职是否分配(1:已分配;0:未分配;)
    ,o.isopenchat -- 是否开启会话存档 0：关闭 1：开启
    ,o.corp_id -- 归属企业
    ,o.corp_name -- 归属企业名称
    ,o.status -- 状态（1正常 0停用）
    ,o.qw_status -- 企微状态：1启用，0停用，-1删除(离职)
    ,o.create_by -- 创建人
    ,o.create_time -- 创建时间
    ,o.last_modi_by -- 最后修改人
    ,o.last_modi_time -- 最后修改时间
    ,o.user_no -- 员工编号
    ,o.shop_status -- 小店状态。1:开启；0：关闭，-1：删除(离职)
    ,o.auth_flag -- 是否已核验：0-未核验 1-已核验
    ,o.sop_flag -- 客户是否提醒，0是，1否
    ,o.config_id -- 二维码配置id
    ,o.is_dept_leader -- 是否部门领导。0-否；1-是
    ,o.direct_leader -- 直属上级。多个以逗号分隔 QW_USER_ID
    ,o.post_name -- 职务
    ,o.dist_line -- 是否已分配条线。1：已分配；0：未分配
    ,o.user_ticket -- 成员票据。员工授权后可获取敏感信息
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
from ${iol_schema}.scrm_sys_user_bk o
    left join ${iol_schema}.scrm_sys_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scrm_sys_user_cl d
        on
            o.user_id = d.user_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scrm_sys_user;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scrm_sys_user') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scrm_sys_user drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scrm_sys_user add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scrm_sys_user exchange partition p_${batch_date} with table ${iol_schema}.scrm_sys_user_cl;
alter table ${iol_schema}.scrm_sys_user exchange partition p_20991231 with table ${iol_schema}.scrm_sys_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scrm_sys_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_sys_user_op purge;
drop table ${iol_schema}.scrm_sys_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scrm_sys_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scrm_sys_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
