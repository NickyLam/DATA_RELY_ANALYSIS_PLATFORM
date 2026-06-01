/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icrw_t_sys_user
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
create table ${iol_schema}.icrw_t_sys_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icrw_t_sys_user
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icrw_t_sys_user_op purge;
drop table ${iol_schema}.icrw_t_sys_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icrw_t_sys_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icrw_t_sys_user where 0=1;

create table ${iol_schema}.icrw_t_sys_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icrw_t_sys_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icrw_t_sys_user_cl(
            user_id -- 用户ID
            ,user_name -- 用户姓名
            ,login_name -- 登陆名
            ,tel -- 手机号
            ,landline -- 座机号码
            ,password -- 密码
            ,sex -- 性别
            ,org_id -- 所属机构
            ,role_id -- 当前角色
            ,role_ids -- 拥有的全部角色
            ,status -- 用户状态
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,law_org_id -- 法人机构号
            ,id_card_no -- 身份证号码
            ,addr -- 联系地址
            ,email -- 邮箱地址
            ,teller_no -- 柜员号
            ,working_years -- 工作年限
            ,wechat_no -- 微信号
            ,org_addr -- 机构地址
            ,is_sta_login -- 是否不统计登录率1=是0=否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icrw_t_sys_user_op(
            user_id -- 用户ID
            ,user_name -- 用户姓名
            ,login_name -- 登陆名
            ,tel -- 手机号
            ,landline -- 座机号码
            ,password -- 密码
            ,sex -- 性别
            ,org_id -- 所属机构
            ,role_id -- 当前角色
            ,role_ids -- 拥有的全部角色
            ,status -- 用户状态
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,law_org_id -- 法人机构号
            ,id_card_no -- 身份证号码
            ,addr -- 联系地址
            ,email -- 邮箱地址
            ,teller_no -- 柜员号
            ,working_years -- 工作年限
            ,wechat_no -- 微信号
            ,org_addr -- 机构地址
            ,is_sta_login -- 是否不统计登录率1=是0=否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 用户ID
    ,nvl(n.user_name, o.user_name) as user_name -- 用户姓名
    ,nvl(n.login_name, o.login_name) as login_name -- 登陆名
    ,nvl(n.tel, o.tel) as tel -- 手机号
    ,nvl(n.landline, o.landline) as landline -- 座机号码
    ,nvl(n.password, o.password) as password -- 密码
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.org_id, o.org_id) as org_id -- 所属机构
    ,nvl(n.role_id, o.role_id) as role_id -- 当前角色
    ,nvl(n.role_ids, o.role_ids) as role_ids -- 拥有的全部角色
    ,nvl(n.status, o.status) as status -- 用户状态
    ,nvl(n.sort_no, o.sort_no) as sort_no -- 排序号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.ver, o.ver) as ver -- 数据版本
    ,nvl(n.law_org_id, o.law_org_id) as law_org_id -- 法人机构号
    ,nvl(n.id_card_no, o.id_card_no) as id_card_no -- 身份证号码
    ,nvl(n.addr, o.addr) as addr -- 联系地址
    ,nvl(n.email, o.email) as email -- 邮箱地址
    ,nvl(n.teller_no, o.teller_no) as teller_no -- 柜员号
    ,nvl(n.working_years, o.working_years) as working_years -- 工作年限
    ,nvl(n.wechat_no, o.wechat_no) as wechat_no -- 微信号
    ,nvl(n.org_addr, o.org_addr) as org_addr -- 机构地址
    ,nvl(n.is_sta_login, o.is_sta_login) as is_sta_login -- 是否不统计登录率1=是0=否
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
from (select * from ${iol_schema}.icrw_t_sys_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icrw_t_sys_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.login_name <> n.login_name
        or o.tel <> n.tel
        or o.landline <> n.landline
        or o.password <> n.password
        or o.sex <> n.sex
        or o.org_id <> n.org_id
        or o.role_id <> n.role_id
        or o.role_ids <> n.role_ids
        or o.status <> n.status
        or o.sort_no <> n.sort_no
        or o.remark <> n.remark
        or o.ver <> n.ver
        or o.law_org_id <> n.law_org_id
        or o.id_card_no <> n.id_card_no
        or o.addr <> n.addr
        or o.email <> n.email
        or o.teller_no <> n.teller_no
        or o.working_years <> n.working_years
        or o.wechat_no <> n.wechat_no
        or o.org_addr <> n.org_addr
        or o.is_sta_login <> n.is_sta_login
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icrw_t_sys_user_cl(
            user_id -- 用户ID
            ,user_name -- 用户姓名
            ,login_name -- 登陆名
            ,tel -- 手机号
            ,landline -- 座机号码
            ,password -- 密码
            ,sex -- 性别
            ,org_id -- 所属机构
            ,role_id -- 当前角色
            ,role_ids -- 拥有的全部角色
            ,status -- 用户状态
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,law_org_id -- 法人机构号
            ,id_card_no -- 身份证号码
            ,addr -- 联系地址
            ,email -- 邮箱地址
            ,teller_no -- 柜员号
            ,working_years -- 工作年限
            ,wechat_no -- 微信号
            ,org_addr -- 机构地址
            ,is_sta_login -- 是否不统计登录率1=是0=否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icrw_t_sys_user_op(
            user_id -- 用户ID
            ,user_name -- 用户姓名
            ,login_name -- 登陆名
            ,tel -- 手机号
            ,landline -- 座机号码
            ,password -- 密码
            ,sex -- 性别
            ,org_id -- 所属机构
            ,role_id -- 当前角色
            ,role_ids -- 拥有的全部角色
            ,status -- 用户状态
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,law_org_id -- 法人机构号
            ,id_card_no -- 身份证号码
            ,addr -- 联系地址
            ,email -- 邮箱地址
            ,teller_no -- 柜员号
            ,working_years -- 工作年限
            ,wechat_no -- 微信号
            ,org_addr -- 机构地址
            ,is_sta_login -- 是否不统计登录率1=是0=否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 用户ID
    ,o.user_name -- 用户姓名
    ,o.login_name -- 登陆名
    ,o.tel -- 手机号
    ,o.landline -- 座机号码
    ,o.password -- 密码
    ,o.sex -- 性别
    ,o.org_id -- 所属机构
    ,o.role_id -- 当前角色
    ,o.role_ids -- 拥有的全部角色
    ,o.status -- 用户状态
    ,o.sort_no -- 排序号
    ,o.remark -- 备注
    ,o.ver -- 数据版本
    ,o.law_org_id -- 法人机构号
    ,o.id_card_no -- 身份证号码
    ,o.addr -- 联系地址
    ,o.email -- 邮箱地址
    ,o.teller_no -- 柜员号
    ,o.working_years -- 工作年限
    ,o.wechat_no -- 微信号
    ,o.org_addr -- 机构地址
    ,o.is_sta_login -- 是否不统计登录率1=是0=否
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
from ${iol_schema}.icrw_t_sys_user_bk o
    left join ${iol_schema}.icrw_t_sys_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icrw_t_sys_user_cl d
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
--truncate table ${iol_schema}.icrw_t_sys_user;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icrw_t_sys_user') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icrw_t_sys_user drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icrw_t_sys_user add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icrw_t_sys_user exchange partition p_${batch_date} with table ${iol_schema}.icrw_t_sys_user_cl;
alter table ${iol_schema}.icrw_t_sys_user exchange partition p_20991231 with table ${iol_schema}.icrw_t_sys_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icrw_t_sys_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icrw_t_sys_user_op purge;
drop table ${iol_schema}.icrw_t_sys_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icrw_t_sys_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icrw_t_sys_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
