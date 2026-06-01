/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_mem_user_info
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
create table ${iol_schema}.bdms_mem_user_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_mem_user_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_mem_user_info_op purge;
drop table ${iol_schema}.bdms_mem_user_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_mem_user_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_mem_user_info where 0=1;

create table ${iol_schema}.bdms_mem_user_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_mem_user_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_mem_user_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,user_id -- 用户ID
            ,user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
            ,user_identi -- 用户身份： UR01 交易员
            ,user_name -- 用户姓名
            ,user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
            ,adress -- 地址
            ,tel -- 座机
            ,is_public -- 手机是否公开
            ,moblie -- 手机
            ,signature -- 个性签名
            ,email -- 邮箱
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后修改人
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_mem_user_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,user_id -- 用户ID
            ,user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
            ,user_identi -- 用户身份： UR01 交易员
            ,user_name -- 用户姓名
            ,user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
            ,adress -- 地址
            ,tel -- 座机
            ,is_public -- 手机是否公开
            ,moblie -- 手机
            ,signature -- 个性签名
            ,email -- 邮箱
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后修改人
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.mem_no, o.mem_no) as mem_no -- 会员代码
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.user_id, o.user_id) as user_id -- 用户ID
    ,nvl(n.user_type, o.user_type) as user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
    ,nvl(n.user_identi, o.user_identi) as user_identi -- 用户身份： UR01 交易员
    ,nvl(n.user_name, o.user_name) as user_name -- 用户姓名
    ,nvl(n.user_status, o.user_status) as user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
    ,nvl(n.adress, o.adress) as adress -- 地址
    ,nvl(n.tel, o.tel) as tel -- 座机
    ,nvl(n.is_public, o.is_public) as is_public -- 手机是否公开
    ,nvl(n.moblie, o.moblie) as moblie -- 手机
    ,nvl(n.signature, o.signature) as signature -- 个性签名
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.remark1, o.remark1) as remark1 -- 备注1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备注2
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_mem_user_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_mem_user_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.mem_no <> n.mem_no
        or o.brh_no <> n.brh_no
        or o.user_id <> n.user_id
        or o.user_type <> n.user_type
        or o.user_identi <> n.user_identi
        or o.user_name <> n.user_name
        or o.user_status <> n.user_status
        or o.adress <> n.adress
        or o.tel <> n.tel
        or o.is_public <> n.is_public
        or o.moblie <> n.moblie
        or o.signature <> n.signature
        or o.email <> n.email
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.last_upd_time <> n.last_upd_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_mem_user_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,user_id -- 用户ID
            ,user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
            ,user_identi -- 用户身份： UR01 交易员
            ,user_name -- 用户姓名
            ,user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
            ,adress -- 地址
            ,tel -- 座机
            ,is_public -- 手机是否公开
            ,moblie -- 手机
            ,signature -- 个性签名
            ,email -- 邮箱
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后修改人
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_mem_user_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,user_id -- 用户ID
            ,user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
            ,user_identi -- 用户身份： UR01 交易员
            ,user_name -- 用户姓名
            ,user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
            ,adress -- 地址
            ,tel -- 座机
            ,is_public -- 手机是否公开
            ,moblie -- 手机
            ,signature -- 个性签名
            ,email -- 邮箱
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,last_upd_time -- 最后修改时间
            ,last_upd_opr -- 最后修改人
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.mem_no -- 会员代码
    ,o.brh_no -- 机构代码
    ,o.user_id -- 用户ID
    ,o.user_type -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
    ,o.user_identi -- 用户身份： UR01 交易员
    ,o.user_name -- 用户姓名
    ,o.user_status -- 用户状态： US01 正常 US02 禁用 US03 锁定
    ,o.adress -- 地址
    ,o.tel -- 座机
    ,o.is_public -- 手机是否公开
    ,o.moblie -- 手机
    ,o.signature -- 个性签名
    ,o.email -- 邮箱
    ,o.remark1 -- 备注1
    ,o.remark2 -- 备注2
    ,o.last_upd_time -- 最后修改时间
    ,o.last_upd_opr -- 最后修改人
    ,o.create_by -- 创建人
    ,o.create_time -- 创建时间
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
from ${iol_schema}.bdms_mem_user_info_bk o
    left join ${iol_schema}.bdms_mem_user_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_mem_user_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_mem_user_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_mem_user_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_mem_user_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_mem_user_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_mem_user_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_mem_user_info_cl;
alter table ${iol_schema}.bdms_mem_user_info exchange partition p_20991231 with table ${iol_schema}.bdms_mem_user_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_mem_user_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_mem_user_info_op purge;
drop table ${iol_schema}.bdms_mem_user_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_mem_user_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_mem_user_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
