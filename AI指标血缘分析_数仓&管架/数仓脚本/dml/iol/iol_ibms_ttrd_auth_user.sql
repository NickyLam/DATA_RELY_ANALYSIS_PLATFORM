/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_auth_user
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
create table ${iol_schema}.ibms_ttrd_auth_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_auth_user;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_auth_user_op purge;
drop table ${iol_schema}.ibms_ttrd_auth_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_auth_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_auth_user where 0=1;

create table ${iol_schema}.ibms_ttrd_auth_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_auth_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_auth_user_cl(
            user_id -- 用户id
            ,user_name -- 姓名
            ,i_id -- 组织机构id
            ,email -- 邮箱
            ,tel_num -- 座机号码
            ,mobile_num -- 手机号码
            ,employee_card_no -- 工牌号
            ,full_chinese_spell -- 姓名拼音
            ,password -- 密码的MD5值
            ,account -- 登录帐号
            ,birth_day -- 出生日期
            ,flag -- 0:普通用户，1:系统管理员
            ,status -- 帐号状态(0:启用,-1:停用,1:未启用)
            ,head_chinese_spell -- 姓名拼音头字母
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,is_first_login -- 是否首次登陆：1是，0否
            ,pwd_update_date -- 密码修改日期
            ,input_pwd_error_times -- 密码输入错误次数
            ,password_history -- 注销额度
            ,state -- 记录状态（已生效1、未生效0）
            ,update_user -- 修改用户id
            ,qq_number -- qq号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_auth_user_op(
            user_id -- 用户id
            ,user_name -- 姓名
            ,i_id -- 组织机构id
            ,email -- 邮箱
            ,tel_num -- 座机号码
            ,mobile_num -- 手机号码
            ,employee_card_no -- 工牌号
            ,full_chinese_spell -- 姓名拼音
            ,password -- 密码的MD5值
            ,account -- 登录帐号
            ,birth_day -- 出生日期
            ,flag -- 0:普通用户，1:系统管理员
            ,status -- 帐号状态(0:启用,-1:停用,1:未启用)
            ,head_chinese_spell -- 姓名拼音头字母
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,is_first_login -- 是否首次登陆：1是，0否
            ,pwd_update_date -- 密码修改日期
            ,input_pwd_error_times -- 密码输入错误次数
            ,password_history -- 注销额度
            ,state -- 记录状态（已生效1、未生效0）
            ,update_user -- 修改用户id
            ,qq_number -- qq号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 用户id
    ,nvl(n.user_name, o.user_name) as user_name -- 姓名
    ,nvl(n.i_id, o.i_id) as i_id -- 组织机构id
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 座机号码
    ,nvl(n.mobile_num, o.mobile_num) as mobile_num -- 手机号码
    ,nvl(n.employee_card_no, o.employee_card_no) as employee_card_no -- 工牌号
    ,nvl(n.full_chinese_spell, o.full_chinese_spell) as full_chinese_spell -- 姓名拼音
    ,nvl(n.password, o.password) as password -- 密码的MD5值
    ,nvl(n.account, o.account) as account -- 登录帐号
    ,nvl(n.birth_day, o.birth_day) as birth_day -- 出生日期
    ,nvl(n.flag, o.flag) as flag -- 0:普通用户，1:系统管理员
    ,nvl(n.status, o.status) as status -- 帐号状态(0:启用,-1:停用,1:未启用)
    ,nvl(n.head_chinese_spell, o.head_chinese_spell) as head_chinese_spell -- 姓名拼音头字母
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,nvl(n.is_first_login, o.is_first_login) as is_first_login -- 是否首次登陆：1是，0否
    ,nvl(n.pwd_update_date, o.pwd_update_date) as pwd_update_date -- 密码修改日期
    ,nvl(n.input_pwd_error_times, o.input_pwd_error_times) as input_pwd_error_times -- 密码输入错误次数
    ,nvl(n.password_history, o.password_history) as password_history -- 注销额度
    ,nvl(n.state, o.state) as state -- 记录状态（已生效1、未生效0）
    ,nvl(n.update_user, o.update_user) as update_user -- 修改用户id
    ,nvl(n.qq_number, o.qq_number) as qq_number -- qq号码
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
from (select * from ${iol_schema}.ibms_ttrd_auth_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_auth_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.user_id = n.user_id
where (
        o.user_id is null
    )
    or (
        n.user_id is null
    )
    or (
        o.user_name <> n.user_name
        or o.i_id <> n.i_id
        or o.email <> n.email
        or o.tel_num <> n.tel_num
        or o.mobile_num <> n.mobile_num
        or o.employee_card_no <> n.employee_card_no
        or o.full_chinese_spell <> n.full_chinese_spell
        or o.password <> n.password
        or o.account <> n.account
        or o.birth_day <> n.birth_day
        or o.flag <> n.flag
        or o.status <> n.status
        or o.head_chinese_spell <> n.head_chinese_spell
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.is_first_login <> n.is_first_login
        or o.pwd_update_date <> n.pwd_update_date
        or o.input_pwd_error_times <> n.input_pwd_error_times
        or o.password_history <> n.password_history
        or o.state <> n.state
        or o.update_user <> n.update_user
        or o.qq_number <> n.qq_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_auth_user_cl(
            user_id -- 用户id
            ,user_name -- 姓名
            ,i_id -- 组织机构id
            ,email -- 邮箱
            ,tel_num -- 座机号码
            ,mobile_num -- 手机号码
            ,employee_card_no -- 工牌号
            ,full_chinese_spell -- 姓名拼音
            ,password -- 密码的MD5值
            ,account -- 登录帐号
            ,birth_day -- 出生日期
            ,flag -- 0:普通用户，1:系统管理员
            ,status -- 帐号状态(0:启用,-1:停用,1:未启用)
            ,head_chinese_spell -- 姓名拼音头字母
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,is_first_login -- 是否首次登陆：1是，0否
            ,pwd_update_date -- 密码修改日期
            ,input_pwd_error_times -- 密码输入错误次数
            ,password_history -- 注销额度
            ,state -- 记录状态（已生效1、未生效0）
            ,update_user -- 修改用户id
            ,qq_number -- qq号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_auth_user_op(
            user_id -- 用户id
            ,user_name -- 姓名
            ,i_id -- 组织机构id
            ,email -- 邮箱
            ,tel_num -- 座机号码
            ,mobile_num -- 手机号码
            ,employee_card_no -- 工牌号
            ,full_chinese_spell -- 姓名拼音
            ,password -- 密码的MD5值
            ,account -- 登录帐号
            ,birth_day -- 出生日期
            ,flag -- 0:普通用户，1:系统管理员
            ,status -- 帐号状态(0:启用,-1:停用,1:未启用)
            ,head_chinese_spell -- 姓名拼音头字母
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,is_first_login -- 是否首次登陆：1是，0否
            ,pwd_update_date -- 密码修改日期
            ,input_pwd_error_times -- 密码输入错误次数
            ,password_history -- 注销额度
            ,state -- 记录状态（已生效1、未生效0）
            ,update_user -- 修改用户id
            ,qq_number -- qq号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 用户id
    ,o.user_name -- 姓名
    ,o.i_id -- 组织机构id
    ,o.email -- 邮箱
    ,o.tel_num -- 座机号码
    ,o.mobile_num -- 手机号码
    ,o.employee_card_no -- 工牌号
    ,o.full_chinese_spell -- 姓名拼音
    ,o.password -- 密码的MD5值
    ,o.account -- 登录帐号
    ,o.birth_day -- 出生日期
    ,o.flag -- 0:普通用户，1:系统管理员
    ,o.status -- 帐号状态(0:启用,-1:停用,1:未启用)
    ,o.head_chinese_spell -- 姓名拼音头字母
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
    ,o.is_first_login -- 是否首次登陆：1是，0否
    ,o.pwd_update_date -- 密码修改日期
    ,o.input_pwd_error_times -- 密码输入错误次数
    ,o.password_history -- 注销额度
    ,o.state -- 记录状态（已生效1、未生效0）
    ,o.update_user -- 修改用户id
    ,o.qq_number -- qq号码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_auth_user_bk o
    left join ${iol_schema}.ibms_ttrd_auth_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_auth_user_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_auth_user;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_auth_user exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_auth_user_cl;
alter table ${iol_schema}.ibms_ttrd_auth_user exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_auth_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_auth_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_auth_user_op purge;
drop table ${iol_schema}.ibms_ttrd_auth_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_auth_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_auth_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
