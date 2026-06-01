/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_sys_user
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
whenever sqlerror continue none ;
create table ${iol_schema}.fams_sys_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_sys_user;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_sys_user_op purge;
drop table ${iol_schema}.fams_sys_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_sys_user_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fams_sys_user where 0=1;

create table ${iol_schema}.fams_sys_user_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fams_sys_user where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.fams_sys_user_op(
        user_id -- 用户代码
        ,system_code -- 系统代码
        ,user_name -- 用户名称
        ,real_name -- 真实姓名
        ,mail_addr -- 邮件地址
        ,phone_num -- 电话
        ,password -- 密码
        ,salt -- 密码盐
        ,dept_code -- 部门代码（有部门是部门，没有部门是机构）
        ,sso_user_id -- sso用户名
        ,mob_num -- 手机号
        ,wechat_num -- 微信号
        ,admin_flag -- 管理员标识
        ,last_pass_date -- 上次密码修改时间
        ,is_frozen -- 是否冻结
        ,remark -- 备注
        ,create_user -- 创建人
        ,create_dept -- 创建部门
        ,create_time -- 创建时间
        ,update_user -- 更新人
        ,update_time -- 更新时间
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.user_id -- 用户代码
    ,n.system_code -- 系统代码
    ,n.user_name -- 用户名称
    ,n.real_name -- 真实姓名
    ,n.mail_addr -- 邮件地址
    ,n.phone_num -- 电话
    ,n.password -- 密码
    ,n.salt -- 密码盐
    ,n.dept_code -- 部门代码（有部门是部门，没有部门是机构）
    ,n.sso_user_id -- sso用户名
    ,n.mob_num -- 手机号
    ,n.wechat_num -- 微信号
    ,n.admin_flag -- 管理员标识
    ,n.last_pass_date -- 上次密码修改时间
    ,n.is_frozen -- 是否冻结
    ,n.remark -- 备注
    ,n.create_user -- 创建人
    ,n.create_dept -- 创建部门
    ,n.create_time -- 创建时间
    ,n.update_user -- 更新人
    ,n.update_time -- 更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_sys_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.fams_sys_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.user_id = n.user_id
where (
        o.user_id is null
    )
    or (
        o.system_code <> n.system_code
        or o.user_name <> n.user_name
        or o.real_name <> n.real_name
        or o.mail_addr <> n.mail_addr
        or o.phone_num <> n.phone_num
        or o.password <> n.password
        or o.salt <> n.salt
        or o.dept_code <> n.dept_code
        or o.sso_user_id <> n.sso_user_id
        or o.mob_num <> n.mob_num
        or o.wechat_num <> n.wechat_num
        or o.admin_flag <> n.admin_flag
        or o.last_pass_date <> n.last_pass_date
        or o.is_frozen <> n.is_frozen
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_sys_user_cl(
            user_id -- 用户代码
        ,system_code -- 系统代码
        ,user_name -- 用户名称
        ,real_name -- 真实姓名
        ,mail_addr -- 邮件地址
        ,phone_num -- 电话
        ,password -- 密码
        ,salt -- 密码盐
        ,dept_code -- 部门代码（有部门是部门，没有部门是机构）
        ,sso_user_id -- sso用户名
        ,mob_num -- 手机号
        ,wechat_num -- 微信号
        ,admin_flag -- 管理员标识
        ,last_pass_date -- 上次密码修改时间
        ,is_frozen -- 是否冻结
        ,remark -- 备注
        ,create_user -- 创建人
        ,create_dept -- 创建部门
        ,create_time -- 创建时间
        ,update_user -- 更新人
        ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_sys_user_op(
            user_id -- 用户代码
        ,system_code -- 系统代码
        ,user_name -- 用户名称
        ,real_name -- 真实姓名
        ,mail_addr -- 邮件地址
        ,phone_num -- 电话
        ,password -- 密码
        ,salt -- 密码盐
        ,dept_code -- 部门代码（有部门是部门，没有部门是机构）
        ,sso_user_id -- sso用户名
        ,mob_num -- 手机号
        ,wechat_num -- 微信号
        ,admin_flag -- 管理员标识
        ,last_pass_date -- 上次密码修改时间
        ,is_frozen -- 是否冻结
        ,remark -- 备注
        ,create_user -- 创建人
        ,create_dept -- 创建部门
        ,create_time -- 创建时间
        ,update_user -- 更新人
        ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 用户代码
    ,o.system_code -- 系统代码
    ,o.user_name -- 用户名称
    ,o.real_name -- 真实姓名
    ,o.mail_addr -- 邮件地址
    ,o.phone_num -- 电话
    ,o.password -- 密码
    ,o.salt -- 密码盐
    ,o.dept_code -- 部门代码（有部门是部门，没有部门是机构）
    ,o.sso_user_id -- sso用户名
    ,o.mob_num -- 手机号
    ,o.wechat_num -- 微信号
    ,o.admin_flag -- 管理员标识
    ,o.last_pass_date -- 上次密码修改时间
    ,o.is_frozen -- 是否冻结
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_sys_user_bk o
    left join ${iol_schema}.fams_sys_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_sys_user;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_sys_user exchange partition p_19000101 with table ${iol_schema}.fams_sys_user_cl;
alter table ${iol_schema}.fams_sys_user exchange partition p_20991231 with table ${iol_schema}.fams_sys_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_sys_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_sys_user_op purge;
drop table ${iol_schema}.fams_sys_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_sys_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_sys_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
