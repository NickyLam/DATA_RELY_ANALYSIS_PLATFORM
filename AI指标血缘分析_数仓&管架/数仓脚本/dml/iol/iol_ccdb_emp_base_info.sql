/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_emp_base_info
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
create table ${iol_schema}.ccdb_emp_base_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_emp_base_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_emp_base_info_op purge;
drop table ${iol_schema}.ccdb_emp_base_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_emp_base_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_emp_base_info where 0=1;

create table ${iol_schema}.ccdb_emp_base_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_emp_base_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_emp_base_info_cl(
            code -- 员工编号
            ,name -- 员工姓名
            ,idcard_type -- 员工证件类型
            ,idcard -- 员工证件号
            ,gender -- 性别
            ,birthday -- 生日日期
            ,org_code -- 组织机构二级code
            ,brithplace -- 出生地
            ,national -- 籍贯
            ,home_tel -- 家庭电话
            ,office_tel -- 办公电话
            ,phone -- 手机
            ,email -- 电子邮箱
            ,duty_id -- 职务id
            ,create_date -- 创建日期
            ,update_date -- 更新日期
            ,leave_date -- 离职日期
            ,status -- 状态
            ,is_real_name -- 是否真实名字 0:no 1:yes
            ,bg_img_path -- 个人信息板块背景图路径
            ,personal_motto -- 个性签名
            ,org_id -- 组织机构id(使用orgcode代替)
            ,remark -- 备注
            ,is_lead -- 是否领导(1:否 2:是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_emp_base_info_op(
            code -- 员工编号
            ,name -- 员工姓名
            ,idcard_type -- 员工证件类型
            ,idcard -- 员工证件号
            ,gender -- 性别
            ,birthday -- 生日日期
            ,org_code -- 组织机构二级code
            ,brithplace -- 出生地
            ,national -- 籍贯
            ,home_tel -- 家庭电话
            ,office_tel -- 办公电话
            ,phone -- 手机
            ,email -- 电子邮箱
            ,duty_id -- 职务id
            ,create_date -- 创建日期
            ,update_date -- 更新日期
            ,leave_date -- 离职日期
            ,status -- 状态
            ,is_real_name -- 是否真实名字 0:no 1:yes
            ,bg_img_path -- 个人信息板块背景图路径
            ,personal_motto -- 个性签名
            ,org_id -- 组织机构id(使用orgcode代替)
            ,remark -- 备注
            ,is_lead -- 是否领导(1:否 2:是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.code, o.code) as code -- 员工编号
    ,nvl(n.name, o.name) as name -- 员工姓名
    ,nvl(n.idcard_type, o.idcard_type) as idcard_type -- 员工证件类型
    ,nvl(n.idcard, o.idcard) as idcard -- 员工证件号
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.birthday, o.birthday) as birthday -- 生日日期
    ,nvl(n.org_code, o.org_code) as org_code -- 组织机构二级code
    ,nvl(n.brithplace, o.brithplace) as brithplace -- 出生地
    ,nvl(n.national, o.national) as national -- 籍贯
    ,nvl(n.home_tel, o.home_tel) as home_tel -- 家庭电话
    ,nvl(n.office_tel, o.office_tel) as office_tel -- 办公电话
    ,nvl(n.phone, o.phone) as phone -- 手机
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.duty_id, o.duty_id) as duty_id -- 职务id
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.leave_date, o.leave_date) as leave_date -- 离职日期
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.is_real_name, o.is_real_name) as is_real_name -- 是否真实名字 0:no 1:yes
    ,nvl(n.bg_img_path, o.bg_img_path) as bg_img_path -- 个人信息板块背景图路径
    ,nvl(n.personal_motto, o.personal_motto) as personal_motto -- 个性签名
    ,nvl(n.org_id, o.org_id) as org_id -- 组织机构id(使用orgcode代替)
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.is_lead, o.is_lead) as is_lead -- 是否领导(1:否 2:是)
    ,case when
            n.code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_emp_base_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ccdb_emp_base_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.code = n.code
where (
        o.code is null
    )
    or (
        n.code is null
    )
    or (
        o.name <> n.name
        or o.idcard_type <> n.idcard_type
        or o.idcard <> n.idcard
        or o.gender <> n.gender
        or o.birthday <> n.birthday
        or o.org_code <> n.org_code
        or o.brithplace <> n.brithplace
        or o.national <> n.national
        or o.home_tel <> n.home_tel
        or o.office_tel <> n.office_tel
        or o.phone <> n.phone
        or o.email <> n.email
        or o.duty_id <> n.duty_id
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.leave_date <> n.leave_date
        or o.status <> n.status
        or o.is_real_name <> n.is_real_name
        or o.bg_img_path <> n.bg_img_path
        or o.personal_motto <> n.personal_motto
        or o.org_id <> n.org_id
        or o.remark <> n.remark
        or o.is_lead <> n.is_lead
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_emp_base_info_cl(
            code -- 员工编号
            ,name -- 员工姓名
            ,idcard_type -- 员工证件类型
            ,idcard -- 员工证件号
            ,gender -- 性别
            ,birthday -- 生日日期
            ,org_code -- 组织机构二级code
            ,brithplace -- 出生地
            ,national -- 籍贯
            ,home_tel -- 家庭电话
            ,office_tel -- 办公电话
            ,phone -- 手机
            ,email -- 电子邮箱
            ,duty_id -- 职务id
            ,create_date -- 创建日期
            ,update_date -- 更新日期
            ,leave_date -- 离职日期
            ,status -- 状态
            ,is_real_name -- 是否真实名字 0:no 1:yes
            ,bg_img_path -- 个人信息板块背景图路径
            ,personal_motto -- 个性签名
            ,org_id -- 组织机构id(使用orgcode代替)
            ,remark -- 备注
            ,is_lead -- 是否领导(1:否 2:是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_emp_base_info_op(
            code -- 员工编号
            ,name -- 员工姓名
            ,idcard_type -- 员工证件类型
            ,idcard -- 员工证件号
            ,gender -- 性别
            ,birthday -- 生日日期
            ,org_code -- 组织机构二级code
            ,brithplace -- 出生地
            ,national -- 籍贯
            ,home_tel -- 家庭电话
            ,office_tel -- 办公电话
            ,phone -- 手机
            ,email -- 电子邮箱
            ,duty_id -- 职务id
            ,create_date -- 创建日期
            ,update_date -- 更新日期
            ,leave_date -- 离职日期
            ,status -- 状态
            ,is_real_name -- 是否真实名字 0:no 1:yes
            ,bg_img_path -- 个人信息板块背景图路径
            ,personal_motto -- 个性签名
            ,org_id -- 组织机构id(使用orgcode代替)
            ,remark -- 备注
            ,is_lead -- 是否领导(1:否 2:是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 员工编号
    ,o.name -- 员工姓名
    ,o.idcard_type -- 员工证件类型
    ,o.idcard -- 员工证件号
    ,o.gender -- 性别
    ,o.birthday -- 生日日期
    ,o.org_code -- 组织机构二级code
    ,o.brithplace -- 出生地
    ,o.national -- 籍贯
    ,o.home_tel -- 家庭电话
    ,o.office_tel -- 办公电话
    ,o.phone -- 手机
    ,o.email -- 电子邮箱
    ,o.duty_id -- 职务id
    ,o.create_date -- 创建日期
    ,o.update_date -- 更新日期
    ,o.leave_date -- 离职日期
    ,o.status -- 状态
    ,o.is_real_name -- 是否真实名字 0:no 1:yes
    ,o.bg_img_path -- 个人信息板块背景图路径
    ,o.personal_motto -- 个性签名
    ,o.org_id -- 组织机构id(使用orgcode代替)
    ,o.remark -- 备注
    ,o.is_lead -- 是否领导(1:否 2:是)
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
from ${iol_schema}.ccdb_emp_base_info_bk o
    left join ${iol_schema}.ccdb_emp_base_info_op n
        on
            o.code = n.code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ccdb_emp_base_info_cl d
        on
            o.code = d.code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_emp_base_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ccdb_emp_base_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ccdb_emp_base_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ccdb_emp_base_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ccdb_emp_base_info exchange partition p_${batch_date} with table ${iol_schema}.ccdb_emp_base_info_cl;
alter table ${iol_schema}.ccdb_emp_base_info exchange partition p_20991231 with table ${iol_schema}.ccdb_emp_base_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_emp_base_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_emp_base_info_op purge;
drop table ${iol_schema}.ccdb_emp_base_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_emp_base_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_emp_base_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
