/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_sm_user
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
create table ${iol_schema}.iers_sm_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_sm_user
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_sm_user_op purge;
drop table ${iol_schema}.iers_sm_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_sm_user_op nologging
for exchange with table
${iol_schema}.iers_sm_user;

create table ${iol_schema}.iers_sm_user_cl nologging
for exchange with table
${iol_schema}.iers_sm_user;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_sm_user_cl(
            abledate -- 生效日期
            ,agreementstatus -- 协议版本
            ,base_doc_type -- 身份类型
            ,contentlang -- 内容语种
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,cuserid -- 用户主键
            ,dataoriginflag -- 分布式
            ,disabledate -- 失效日期
            ,dr -- 删除标志
            ,email -- 电子邮件地址
            ,enablestate -- 启用状态
            ,format -- 数据格式
            ,identityverifycode -- 认证类型
            ,isca -- CA用户
            ,islocked -- 锁定
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,pk_base_doc -- 身份
            ,pk_customer -- 
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 身份_人员信息
            ,pk_supplier -- 
            ,pk_usergroupforcreate -- 所属用户组
            ,pwderrorcount -- 密码错误次数
            ,pwdlevelcode -- 密码安全级别
            ,pwdparam -- 密码参数
            ,secondverify -- 
            ,systype -- 所属系统
            ,ts -- 时间戳
            ,user_code -- 用户编码
            ,user_code_q -- 用户编码（查询）
            ,user_name -- 用户名称
            ,user_name2 -- 用户名称2
            ,user_name3 -- 用户名称3
            ,user_name4 -- 用户名称4
            ,user_name5 -- 用户名称5
            ,user_name6 -- 用户名称6
            ,user_note -- 备注
            ,user_password -- 用户密码
            ,user_type -- 用户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_sm_user_op(
            abledate -- 生效日期
            ,agreementstatus -- 协议版本
            ,base_doc_type -- 身份类型
            ,contentlang -- 内容语种
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,cuserid -- 用户主键
            ,dataoriginflag -- 分布式
            ,disabledate -- 失效日期
            ,dr -- 删除标志
            ,email -- 电子邮件地址
            ,enablestate -- 启用状态
            ,format -- 数据格式
            ,identityverifycode -- 认证类型
            ,isca -- CA用户
            ,islocked -- 锁定
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,pk_base_doc -- 身份
            ,pk_customer -- 
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 身份_人员信息
            ,pk_supplier -- 
            ,pk_usergroupforcreate -- 所属用户组
            ,pwderrorcount -- 密码错误次数
            ,pwdlevelcode -- 密码安全级别
            ,pwdparam -- 密码参数
            ,secondverify -- 
            ,systype -- 所属系统
            ,ts -- 时间戳
            ,user_code -- 用户编码
            ,user_code_q -- 用户编码（查询）
            ,user_name -- 用户名称
            ,user_name2 -- 用户名称2
            ,user_name3 -- 用户名称3
            ,user_name4 -- 用户名称4
            ,user_name5 -- 用户名称5
            ,user_name6 -- 用户名称6
            ,user_note -- 备注
            ,user_password -- 用户密码
            ,user_type -- 用户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.abledate, o.abledate) as abledate -- 生效日期
    ,nvl(n.agreementstatus, o.agreementstatus) as agreementstatus -- 协议版本
    ,nvl(n.base_doc_type, o.base_doc_type) as base_doc_type -- 身份类型
    ,nvl(n.contentlang, o.contentlang) as contentlang -- 内容语种
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.cuserid, o.cuserid) as cuserid -- 用户主键
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 分布式
    ,nvl(n.disabledate, o.disabledate) as disabledate -- 失效日期
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.email, o.email) as email -- 电子邮件地址
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.format, o.format) as format -- 数据格式
    ,nvl(n.identityverifycode, o.identityverifycode) as identityverifycode -- 认证类型
    ,nvl(n.isca, o.isca) as isca -- CA用户
    ,nvl(n.islocked, o.islocked) as islocked -- 锁定
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.pk_base_doc, o.pk_base_doc) as pk_base_doc -- 身份
    ,nvl(n.pk_customer, o.pk_customer) as pk_customer -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 身份_人员信息
    ,nvl(n.pk_supplier, o.pk_supplier) as pk_supplier -- 
    ,nvl(n.pk_usergroupforcreate, o.pk_usergroupforcreate) as pk_usergroupforcreate -- 所属用户组
    ,nvl(n.pwderrorcount, o.pwderrorcount) as pwderrorcount -- 密码错误次数
    ,nvl(n.pwdlevelcode, o.pwdlevelcode) as pwdlevelcode -- 密码安全级别
    ,nvl(n.pwdparam, o.pwdparam) as pwdparam -- 密码参数
    ,nvl(n.secondverify, o.secondverify) as secondverify -- 
    ,nvl(n.systype, o.systype) as systype -- 所属系统
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.user_code, o.user_code) as user_code -- 用户编码
    ,nvl(n.user_code_q, o.user_code_q) as user_code_q -- 用户编码（查询）
    ,nvl(n.user_name, o.user_name) as user_name -- 用户名称
    ,nvl(n.user_name2, o.user_name2) as user_name2 -- 用户名称2
    ,nvl(n.user_name3, o.user_name3) as user_name3 -- 用户名称3
    ,nvl(n.user_name4, o.user_name4) as user_name4 -- 用户名称4
    ,nvl(n.user_name5, o.user_name5) as user_name5 -- 用户名称5
    ,nvl(n.user_name6, o.user_name6) as user_name6 -- 用户名称6
    ,nvl(n.user_note, o.user_note) as user_note -- 备注
    ,nvl(n.user_password, o.user_password) as user_password -- 用户密码
    ,nvl(n.user_type, o.user_type) as user_type -- 用户类型
    ,case when
            n.cuserid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cuserid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cuserid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_sm_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_sm_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cuserid = n.cuserid
where (
        o.cuserid is null
    )
    or (
        n.cuserid is null
    )
    or (
        o.abledate <> n.abledate
        or o.agreementstatus <> n.agreementstatus
        or o.base_doc_type <> n.base_doc_type
        or o.contentlang <> n.contentlang
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.disabledate <> n.disabledate
        or o.dr <> n.dr
        or o.email <> n.email
        or o.enablestate <> n.enablestate
        or o.format <> n.format
        or o.identityverifycode <> n.identityverifycode
        or o.isca <> n.isca
        or o.islocked <> n.islocked
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_base_doc <> n.pk_base_doc
        or o.pk_customer <> n.pk_customer
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_supplier <> n.pk_supplier
        or o.pk_usergroupforcreate <> n.pk_usergroupforcreate
        or o.pwderrorcount <> n.pwderrorcount
        or o.pwdlevelcode <> n.pwdlevelcode
        or o.pwdparam <> n.pwdparam
        or o.secondverify <> n.secondverify
        or o.systype <> n.systype
        or o.ts <> n.ts
        or o.user_code <> n.user_code
        or o.user_code_q <> n.user_code_q
        or o.user_name <> n.user_name
        or o.user_name2 <> n.user_name2
        or o.user_name3 <> n.user_name3
        or o.user_name4 <> n.user_name4
        or o.user_name5 <> n.user_name5
        or o.user_name6 <> n.user_name6
        or o.user_note <> n.user_note
        or o.user_password <> n.user_password
        or o.user_type <> n.user_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_sm_user_cl(
            abledate -- 生效日期
            ,agreementstatus -- 协议版本
            ,base_doc_type -- 身份类型
            ,contentlang -- 内容语种
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,cuserid -- 用户主键
            ,dataoriginflag -- 分布式
            ,disabledate -- 失效日期
            ,dr -- 删除标志
            ,email -- 电子邮件地址
            ,enablestate -- 启用状态
            ,format -- 数据格式
            ,identityverifycode -- 认证类型
            ,isca -- CA用户
            ,islocked -- 锁定
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,pk_base_doc -- 身份
            ,pk_customer -- 
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 身份_人员信息
            ,pk_supplier -- 
            ,pk_usergroupforcreate -- 所属用户组
            ,pwderrorcount -- 密码错误次数
            ,pwdlevelcode -- 密码安全级别
            ,pwdparam -- 密码参数
            ,secondverify -- 
            ,systype -- 所属系统
            ,ts -- 时间戳
            ,user_code -- 用户编码
            ,user_code_q -- 用户编码（查询）
            ,user_name -- 用户名称
            ,user_name2 -- 用户名称2
            ,user_name3 -- 用户名称3
            ,user_name4 -- 用户名称4
            ,user_name5 -- 用户名称5
            ,user_name6 -- 用户名称6
            ,user_note -- 备注
            ,user_password -- 用户密码
            ,user_type -- 用户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_sm_user_op(
            abledate -- 生效日期
            ,agreementstatus -- 协议版本
            ,base_doc_type -- 身份类型
            ,contentlang -- 内容语种
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,cuserid -- 用户主键
            ,dataoriginflag -- 分布式
            ,disabledate -- 失效日期
            ,dr -- 删除标志
            ,email -- 电子邮件地址
            ,enablestate -- 启用状态
            ,format -- 数据格式
            ,identityverifycode -- 认证类型
            ,isca -- CA用户
            ,islocked -- 锁定
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,pk_base_doc -- 身份
            ,pk_customer -- 
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 身份_人员信息
            ,pk_supplier -- 
            ,pk_usergroupforcreate -- 所属用户组
            ,pwderrorcount -- 密码错误次数
            ,pwdlevelcode -- 密码安全级别
            ,pwdparam -- 密码参数
            ,secondverify -- 
            ,systype -- 所属系统
            ,ts -- 时间戳
            ,user_code -- 用户编码
            ,user_code_q -- 用户编码（查询）
            ,user_name -- 用户名称
            ,user_name2 -- 用户名称2
            ,user_name3 -- 用户名称3
            ,user_name4 -- 用户名称4
            ,user_name5 -- 用户名称5
            ,user_name6 -- 用户名称6
            ,user_note -- 备注
            ,user_password -- 用户密码
            ,user_type -- 用户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.abledate -- 生效日期
    ,o.agreementstatus -- 协议版本
    ,o.base_doc_type -- 身份类型
    ,o.contentlang -- 内容语种
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.cuserid -- 用户主键
    ,o.dataoriginflag -- 分布式
    ,o.disabledate -- 失效日期
    ,o.dr -- 删除标志
    ,o.email -- 电子邮件地址
    ,o.enablestate -- 启用状态
    ,o.format -- 数据格式
    ,o.identityverifycode -- 认证类型
    ,o.isca -- CA用户
    ,o.islocked -- 锁定
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.pk_base_doc -- 身份
    ,o.pk_customer -- 
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_psndoc -- 身份_人员信息
    ,o.pk_supplier -- 
    ,o.pk_usergroupforcreate -- 所属用户组
    ,o.pwderrorcount -- 密码错误次数
    ,o.pwdlevelcode -- 密码安全级别
    ,o.pwdparam -- 密码参数
    ,o.secondverify -- 
    ,o.systype -- 所属系统
    ,o.ts -- 时间戳
    ,o.user_code -- 用户编码
    ,o.user_code_q -- 用户编码（查询）
    ,o.user_name -- 用户名称
    ,o.user_name2 -- 用户名称2
    ,o.user_name3 -- 用户名称3
    ,o.user_name4 -- 用户名称4
    ,o.user_name5 -- 用户名称5
    ,o.user_name6 -- 用户名称6
    ,o.user_note -- 备注
    ,o.user_password -- 用户密码
    ,o.user_type -- 用户类型
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
from ${iol_schema}.iers_sm_user_bk o
    left join ${iol_schema}.iers_sm_user_op n
        on
            o.cuserid = n.cuserid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_sm_user_cl d
        on
            o.cuserid = d.cuserid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_sm_user;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_sm_user') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_sm_user drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_sm_user add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_sm_user exchange partition p_${batch_date} with table ${iol_schema}.iers_sm_user_cl;
alter table ${iol_schema}.iers_sm_user exchange partition p_20991231 with table ${iol_schema}.iers_sm_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_sm_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_sm_user_op purge;
drop table ${iol_schema}.iers_sm_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_sm_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_sm_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
