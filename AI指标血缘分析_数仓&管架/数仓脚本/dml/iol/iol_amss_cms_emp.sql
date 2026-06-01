/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_emp
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
create table ${iol_schema}.amss_cms_emp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_emp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_emp_op purge;
drop table ${iol_schema}.amss_cms_emp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_emp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_emp where 0=1;

create table ${iol_schema}.amss_cms_emp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_emp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_emp_cl(
            emp_id -- 员工ID.
            ,emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
            ,emp_name -- 员工姓名.
            ,emp_sex -- 员工性别.1:男;2:女
            ,emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
            ,org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
            ,emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
            ,emp_position -- 员工职务.
            ,mobile -- 手机号码.
            ,id_code -- 身份证.
            ,enabled -- 是否启用.
            ,remark -- 备注.
            ,fld_s1 -- (inviteCode)业务员邀请码
            ,fld_s2 -- (empNo)员工工号
            ,fld_s3 -- (operatorId)操作员id
            ,fld_n1 -- 数值型保留字段1.
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- 数值型保留字段3.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,email -- 邮箱.
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,authority_bit -- 权限位.
            ,emp_serial -- 员工序列
            ,teller_id -- 
            ,admin_flag -- 是否是管理员，0：否，1：是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_emp_op(
            emp_id -- 员工ID.
            ,emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
            ,emp_name -- 员工姓名.
            ,emp_sex -- 员工性别.1:男;2:女
            ,emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
            ,org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
            ,emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
            ,emp_position -- 员工职务.
            ,mobile -- 手机号码.
            ,id_code -- 身份证.
            ,enabled -- 是否启用.
            ,remark -- 备注.
            ,fld_s1 -- (inviteCode)业务员邀请码
            ,fld_s2 -- (empNo)员工工号
            ,fld_s3 -- (operatorId)操作员id
            ,fld_n1 -- 数值型保留字段1.
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- 数值型保留字段3.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,email -- 邮箱.
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,authority_bit -- 权限位.
            ,emp_serial -- 员工序列
            ,teller_id -- 
            ,admin_flag -- 是否是管理员，0：否，1：是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.emp_id, o.emp_id) as emp_id -- 员工ID.
    ,nvl(n.emp_code, o.emp_code) as emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
    ,nvl(n.emp_name, o.emp_name) as emp_name -- 员工姓名.
    ,nvl(n.emp_sex, o.emp_sex) as emp_sex -- 员工性别.1:男;2:女
    ,nvl(n.emp_type, o.emp_type) as emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
    ,nvl(n.org_id, o.org_id) as org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
    ,nvl(n.emp_dept_name, o.emp_dept_name) as emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
    ,nvl(n.emp_position, o.emp_position) as emp_position -- 员工职务.
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码.
    ,nvl(n.id_code, o.id_code) as id_code -- 身份证.
    ,nvl(n.enabled, o.enabled) as enabled -- 是否启用.
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- (inviteCode)业务员邀请码
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- (empNo)员工工号
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- (operatorId)操作员id
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- 数值型保留字段1.
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 数值型保留字段2.
    ,nvl(n.fld_n3, o.fld_n3) as fld_n3 -- 数值型保留字段3.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.email, o.email) as email -- 邮箱.
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常;2:删除
    ,nvl(n.authority_bit, o.authority_bit) as authority_bit -- 权限位.
    ,nvl(n.emp_serial, o.emp_serial) as emp_serial -- 员工序列
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 
    ,nvl(n.admin_flag, o.admin_flag) as admin_flag -- 是否是管理员，0：否，1：是
    ,case when
            n.emp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.emp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.emp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_emp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_emp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.emp_id = n.emp_id
where (
        o.emp_id is null
    )
    or (
        n.emp_id is null
    )
    or (
        o.emp_code <> n.emp_code
        or o.emp_name <> n.emp_name
        or o.emp_sex <> n.emp_sex
        or o.emp_type <> n.emp_type
        or o.org_id <> n.org_id
        or o.emp_dept_name <> n.emp_dept_name
        or o.emp_position <> n.emp_position
        or o.mobile <> n.mobile
        or o.id_code <> n.id_code
        or o.enabled <> n.enabled
        or o.remark <> n.remark
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_n3 <> n.fld_n3
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.email <> n.email
        or o.physics_flag <> n.physics_flag
        or o.authority_bit <> n.authority_bit
        or o.emp_serial <> n.emp_serial
        or o.teller_id <> n.teller_id
        or o.admin_flag <> n.admin_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_emp_cl(
            emp_id -- 员工ID.
            ,emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
            ,emp_name -- 员工姓名.
            ,emp_sex -- 员工性别.1:男;2:女
            ,emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
            ,org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
            ,emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
            ,emp_position -- 员工职务.
            ,mobile -- 手机号码.
            ,id_code -- 身份证.
            ,enabled -- 是否启用.
            ,remark -- 备注.
            ,fld_s1 -- (inviteCode)业务员邀请码
            ,fld_s2 -- (empNo)员工工号
            ,fld_s3 -- (operatorId)操作员id
            ,fld_n1 -- 数值型保留字段1.
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- 数值型保留字段3.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,email -- 邮箱.
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,authority_bit -- 权限位.
            ,emp_serial -- 员工序列
            ,teller_id -- 
            ,admin_flag -- 是否是管理员，0：否，1：是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_emp_op(
            emp_id -- 员工ID.
            ,emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
            ,emp_name -- 员工姓名.
            ,emp_sex -- 员工性别.1:男;2:女
            ,emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
            ,org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
            ,emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
            ,emp_position -- 员工职务.
            ,mobile -- 手机号码.
            ,id_code -- 身份证.
            ,enabled -- 是否启用.
            ,remark -- 备注.
            ,fld_s1 -- (inviteCode)业务员邀请码
            ,fld_s2 -- (empNo)员工工号
            ,fld_s3 -- (operatorId)操作员id
            ,fld_n1 -- 数值型保留字段1.
            ,fld_n2 -- 数值型保留字段2.
            ,fld_n3 -- 数值型保留字段3.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,email -- 邮箱.
            ,physics_flag -- 物理标识.1:正常;2:删除
            ,authority_bit -- 权限位.
            ,emp_serial -- 员工序列
            ,teller_id -- 
            ,admin_flag -- 是否是管理员，0：否，1：是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.emp_id -- 员工ID.
    ,o.emp_code -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
    ,o.emp_name -- 员工姓名.
    ,o.emp_sex -- 员工性别.1:男;2:女
    ,o.emp_type -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
    ,o.org_id -- 所属机构.机构编号;值为渠道、商户、部门表的主键
    ,o.emp_dept_name -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
    ,o.emp_position -- 员工职务.
    ,o.mobile -- 手机号码.
    ,o.id_code -- 身份证.
    ,o.enabled -- 是否启用.
    ,o.remark -- 备注.
    ,o.fld_s1 -- (inviteCode)业务员邀请码
    ,o.fld_s2 -- (empNo)员工工号
    ,o.fld_s3 -- (operatorId)操作员id
    ,o.fld_n1 -- 数值型保留字段1.
    ,o.fld_n2 -- 数值型保留字段2.
    ,o.fld_n3 -- 数值型保留字段3.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.email -- 邮箱.
    ,o.physics_flag -- 物理标识.1:正常;2:删除
    ,o.authority_bit -- 权限位.
    ,o.emp_serial -- 员工序列
    ,o.teller_id -- 
    ,o.admin_flag -- 是否是管理员，0：否，1：是
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
from ${iol_schema}.amss_cms_emp_bk o
    left join ${iol_schema}.amss_cms_emp_op n
        on
            o.emp_id = n.emp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_emp_cl d
        on
            o.emp_id = d.emp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_emp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_emp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_emp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_emp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_emp exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_emp_cl;
alter table ${iol_schema}.amss_cms_emp exchange partition p_20991231 with table ${iol_schema}.amss_cms_emp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_emp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_emp_op purge;
drop table ${iol_schema}.amss_cms_emp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_emp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_emp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
