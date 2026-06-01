/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scrm_we_customer
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
create table ${iol_schema}.scrm_we_customer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scrm_we_customer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_we_customer_op purge;
drop table ${iol_schema}.scrm_we_customer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_we_customer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_we_customer where 0=1;

create table ${iol_schema}.scrm_we_customer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_we_customer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_we_customer_cl(
            external_userid -- 外部联系人的USERID
            ,customer_name -- 客户昵称
            ,avatar -- 外部联系人头像
            ,customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
            ,gender -- 外部联系人性别0-未知1-男性2-女性
            ,unionid -- 
            ,position_ora -- 职位
            ,corp_name -- 企业的简称
            ,corp_full_name -- 企业的主体名称
            ,external_profile -- 自定义展示信息
            ,is_bank_customer -- 是否银行客户1：是0：否
            ,ident_no -- 身份证编号
            ,birth -- 备注生日
            ,mobile -- 客户电话
            ,cust_id -- 客户编号
            ,cust_name -- 客户姓名
            ,ident_flg -- 0未识别，1已识别行内  2已识别非行内
            ,create_by -- 创建者
            ,create_time -- 创建时间
            ,last_modi_by -- 更新者
            ,last_modi_time -- 更新时间
            ,email -- 邮箱
            ,address -- 地址
            ,customer_initial -- 首字母
            ,line_id -- 条线ID
            ,corp_id -- 企微ID
            ,auth_dt -- 认证日期和时间
            ,auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
            ,auth_user_id -- 认证人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_we_customer_op(
            external_userid -- 外部联系人的USERID
            ,customer_name -- 客户昵称
            ,avatar -- 外部联系人头像
            ,customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
            ,gender -- 外部联系人性别0-未知1-男性2-女性
            ,unionid -- 
            ,position_ora -- 职位
            ,corp_name -- 企业的简称
            ,corp_full_name -- 企业的主体名称
            ,external_profile -- 自定义展示信息
            ,is_bank_customer -- 是否银行客户1：是0：否
            ,ident_no -- 身份证编号
            ,birth -- 备注生日
            ,mobile -- 客户电话
            ,cust_id -- 客户编号
            ,cust_name -- 客户姓名
            ,ident_flg -- 0未识别，1已识别行内  2已识别非行内
            ,create_by -- 创建者
            ,create_time -- 创建时间
            ,last_modi_by -- 更新者
            ,last_modi_time -- 更新时间
            ,email -- 邮箱
            ,address -- 地址
            ,customer_initial -- 首字母
            ,line_id -- 条线ID
            ,corp_id -- 企微ID
            ,auth_dt -- 认证日期和时间
            ,auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
            ,auth_user_id -- 认证人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.external_userid, o.external_userid) as external_userid -- 外部联系人的USERID
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户昵称
    ,nvl(n.avatar, o.avatar) as avatar -- 外部联系人头像
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
    ,nvl(n.gender, o.gender) as gender -- 外部联系人性别0-未知1-男性2-女性
    ,nvl(n.unionid, o.unionid) as unionid -- 
    ,nvl(n.position_ora, o.position_ora) as position_ora -- 职位
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业的简称
    ,nvl(n.corp_full_name, o.corp_full_name) as corp_full_name -- 企业的主体名称
    ,nvl(n.external_profile, o.external_profile) as external_profile -- 自定义展示信息
    ,nvl(n.is_bank_customer, o.is_bank_customer) as is_bank_customer -- 是否银行客户1：是0：否
    ,nvl(n.ident_no, o.ident_no) as ident_no -- 身份证编号
    ,nvl(n.birth, o.birth) as birth -- 备注生日
    ,nvl(n.mobile, o.mobile) as mobile -- 客户电话
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户姓名
    ,nvl(n.ident_flg, o.ident_flg) as ident_flg -- 0未识别，1已识别行内  2已识别非行内
    ,nvl(n.create_by, o.create_by) as create_by -- 创建者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_modi_by, o.last_modi_by) as last_modi_by -- 更新者
    ,nvl(n.last_modi_time, o.last_modi_time) as last_modi_time -- 更新时间
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.customer_initial, o.customer_initial) as customer_initial -- 首字母
    ,nvl(n.line_id, o.line_id) as line_id -- 条线ID
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 企微ID
    ,nvl(n.auth_dt, o.auth_dt) as auth_dt -- 认证日期和时间
    ,nvl(n.auth_mode, o.auth_mode) as auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 认证人
    ,case when
            n.external_userid is null
            and n.corp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.external_userid is null
            and n.corp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.external_userid is null
            and n.corp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scrm_we_customer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scrm_we_customer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.external_userid = n.external_userid
            and o.corp_id = n.corp_id
where (
        o.external_userid is null
        and o.corp_id is null
    )
    or (
        n.external_userid is null
        and n.corp_id is null
    )
    or (
        o.customer_name <> n.customer_name
        or o.avatar <> n.avatar
        or o.customer_type <> n.customer_type
        or o.gender <> n.gender
        or o.unionid <> n.unionid
        or o.position_ora <> n.position_ora
        or o.corp_name <> n.corp_name
        or o.corp_full_name <> n.corp_full_name
        or o.external_profile <> n.external_profile
        or o.is_bank_customer <> n.is_bank_customer
        or o.ident_no <> n.ident_no
        or o.birth <> n.birth
        or o.mobile <> n.mobile
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.ident_flg <> n.ident_flg
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
        or o.last_modi_by <> n.last_modi_by
        or o.last_modi_time <> n.last_modi_time
        or o.email <> n.email
        or o.address <> n.address
        or o.customer_initial <> n.customer_initial
        or o.line_id <> n.line_id
        or o.auth_dt <> n.auth_dt
        or o.auth_mode <> n.auth_mode
        or o.auth_user_id <> n.auth_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_we_customer_cl(
            external_userid -- 外部联系人的USERID
            ,customer_name -- 客户昵称
            ,avatar -- 外部联系人头像
            ,customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
            ,gender -- 外部联系人性别0-未知1-男性2-女性
            ,unionid -- 
            ,position_ora -- 职位
            ,corp_name -- 企业的简称
            ,corp_full_name -- 企业的主体名称
            ,external_profile -- 自定义展示信息
            ,is_bank_customer -- 是否银行客户1：是0：否
            ,ident_no -- 身份证编号
            ,birth -- 备注生日
            ,mobile -- 客户电话
            ,cust_id -- 客户编号
            ,cust_name -- 客户姓名
            ,ident_flg -- 0未识别，1已识别行内  2已识别非行内
            ,create_by -- 创建者
            ,create_time -- 创建时间
            ,last_modi_by -- 更新者
            ,last_modi_time -- 更新时间
            ,email -- 邮箱
            ,address -- 地址
            ,customer_initial -- 首字母
            ,line_id -- 条线ID
            ,corp_id -- 企微ID
            ,auth_dt -- 认证日期和时间
            ,auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
            ,auth_user_id -- 认证人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_we_customer_op(
            external_userid -- 外部联系人的USERID
            ,customer_name -- 客户昵称
            ,avatar -- 外部联系人头像
            ,customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
            ,gender -- 外部联系人性别0-未知1-男性2-女性
            ,unionid -- 
            ,position_ora -- 职位
            ,corp_name -- 企业的简称
            ,corp_full_name -- 企业的主体名称
            ,external_profile -- 自定义展示信息
            ,is_bank_customer -- 是否银行客户1：是0：否
            ,ident_no -- 身份证编号
            ,birth -- 备注生日
            ,mobile -- 客户电话
            ,cust_id -- 客户编号
            ,cust_name -- 客户姓名
            ,ident_flg -- 0未识别，1已识别行内  2已识别非行内
            ,create_by -- 创建者
            ,create_time -- 创建时间
            ,last_modi_by -- 更新者
            ,last_modi_time -- 更新时间
            ,email -- 邮箱
            ,address -- 地址
            ,customer_initial -- 首字母
            ,line_id -- 条线ID
            ,corp_id -- 企微ID
            ,auth_dt -- 认证日期和时间
            ,auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
            ,auth_user_id -- 认证人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.external_userid -- 外部联系人的USERID
    ,o.customer_name -- 客户昵称
    ,o.avatar -- 外部联系人头像
    ,o.customer_type -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
    ,o.gender -- 外部联系人性别0-未知1-男性2-女性
    ,o.unionid -- 
    ,o.position_ora -- 职位
    ,o.corp_name -- 企业的简称
    ,o.corp_full_name -- 企业的主体名称
    ,o.external_profile -- 自定义展示信息
    ,o.is_bank_customer -- 是否银行客户1：是0：否
    ,o.ident_no -- 身份证编号
    ,o.birth -- 备注生日
    ,o.mobile -- 客户电话
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户姓名
    ,o.ident_flg -- 0未识别，1已识别行内  2已识别非行内
    ,o.create_by -- 创建者
    ,o.create_time -- 创建时间
    ,o.last_modi_by -- 更新者
    ,o.last_modi_time -- 更新时间
    ,o.email -- 邮箱
    ,o.address -- 地址
    ,o.customer_initial -- 首字母
    ,o.line_id -- 条线ID
    ,o.corp_id -- 企微ID
    ,o.auth_dt -- 认证日期和时间
    ,o.auth_mode -- 认证方式 1：自动认证 2：自助认证 3：手工认证
    ,o.auth_user_id -- 认证人
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
from ${iol_schema}.scrm_we_customer_bk o
    left join ${iol_schema}.scrm_we_customer_op n
        on
            o.external_userid = n.external_userid
            and o.corp_id = n.corp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scrm_we_customer_cl d
        on
            o.external_userid = d.external_userid
            and o.corp_id = d.corp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scrm_we_customer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scrm_we_customer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scrm_we_customer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scrm_we_customer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scrm_we_customer exchange partition p_${batch_date} with table ${iol_schema}.scrm_we_customer_cl;
alter table ${iol_schema}.scrm_we_customer exchange partition p_20991231 with table ${iol_schema}.scrm_we_customer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scrm_we_customer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_we_customer_op purge;
drop table ${iol_schema}.scrm_we_customer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scrm_we_customer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scrm_we_customer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
