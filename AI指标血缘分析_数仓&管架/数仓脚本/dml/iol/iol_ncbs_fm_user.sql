/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_user
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
create table ${iol_schema}.ncbs_fm_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_user
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_user_op purge;
drop table ${iol_schema}.ncbs_fm_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_user where 0=1;

create table ${iol_schema}.ncbs_fm_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_user_cl(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,application_user_flag -- 是否应用柜员
            ,auth_level -- 授权级别
            ,company -- 法人
            ,department -- 部门
            ,eod_sod_enabled_flag -- 是否批处理用户
            ,inter_branch_cl -- 是否贷款业务机构
            ,inter_branch_ind -- 是否为内部银行
            ,role_id -- 角色
            ,source_type -- 渠道编号
            ,tbook -- 账薄
            ,user_desc -- 柜员描述信息
            ,user_lang -- 柜员语言
            ,user_level -- 柜员级别
            ,user_name -- 柜员名称
            ,user_type -- 柜员类别
            ,check_date -- 检查日期
            ,make_date -- 柜员创建日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,creation_user_id -- 创建柜员
            ,account_status -- 柜员状态a:有效,d:删除
            ,user_sub_type -- 柜员细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_user_op(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,application_user_flag -- 是否应用柜员
            ,auth_level -- 授权级别
            ,company -- 法人
            ,department -- 部门
            ,eod_sod_enabled_flag -- 是否批处理用户
            ,inter_branch_cl -- 是否贷款业务机构
            ,inter_branch_ind -- 是否为内部银行
            ,role_id -- 角色
            ,source_type -- 渠道编号
            ,tbook -- 账薄
            ,user_desc -- 柜员描述信息
            ,user_lang -- 柜员语言
            ,user_level -- 柜员级别
            ,user_name -- 柜员名称
            ,user_type -- 柜员类别
            ,check_date -- 检查日期
            ,make_date -- 柜员创建日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,creation_user_id -- 创建柜员
            ,account_status -- 柜员状态a:有效,d:删除
            ,user_sub_type -- 柜员细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.application_user_flag, o.application_user_flag) as application_user_flag -- 是否应用柜员
    ,nvl(n.auth_level, o.auth_level) as auth_level -- 授权级别
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.department, o.department) as department -- 部门
    ,nvl(n.eod_sod_enabled_flag, o.eod_sod_enabled_flag) as eod_sod_enabled_flag -- 是否批处理用户
    ,nvl(n.inter_branch_cl, o.inter_branch_cl) as inter_branch_cl -- 是否贷款业务机构
    ,nvl(n.inter_branch_ind, o.inter_branch_ind) as inter_branch_ind -- 是否为内部银行
    ,nvl(n.role_id, o.role_id) as role_id -- 角色
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tbook, o.tbook) as tbook -- 账薄
    ,nvl(n.user_desc, o.user_desc) as user_desc -- 柜员描述信息
    ,nvl(n.user_lang, o.user_lang) as user_lang -- 柜员语言
    ,nvl(n.user_level, o.user_level) as user_level -- 柜员级别
    ,nvl(n.user_name, o.user_name) as user_name -- 柜员名称
    ,nvl(n.user_type, o.user_type) as user_type -- 柜员类别
    ,nvl(n.check_date, o.check_date) as check_date -- 检查日期
    ,nvl(n.make_date, o.make_date) as make_date -- 柜员创建日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.creation_user_id, o.creation_user_id) as creation_user_id -- 创建柜员
    ,nvl(n.account_status, o.account_status) as account_status -- 柜员状态a:有效,d:删除
    ,nvl(n.user_sub_type, o.user_sub_type) as user_sub_type -- 柜员细类
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
from (select * from ${iol_schema}.ncbs_fm_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.user_id = n.user_id
where (
        o.user_id is null
    )
    or (
        n.user_id is null
    )
    or (
        o.branch <> n.branch
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.profit_center <> n.profit_center
        or o.acct_exec <> n.acct_exec
        or o.application_user_flag <> n.application_user_flag
        or o.auth_level <> n.auth_level
        or o.company <> n.company
        or o.department <> n.department
        or o.eod_sod_enabled_flag <> n.eod_sod_enabled_flag
        or o.inter_branch_cl <> n.inter_branch_cl
        or o.inter_branch_ind <> n.inter_branch_ind
        or o.role_id <> n.role_id
        or o.source_type <> n.source_type
        or o.tbook <> n.tbook
        or o.user_desc <> n.user_desc
        or o.user_lang <> n.user_lang
        or o.user_level <> n.user_level
        or o.user_name <> n.user_name
        or o.user_type <> n.user_type
        or o.check_date <> n.check_date
        or o.make_date <> n.make_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.creation_user_id <> n.creation_user_id
        or o.account_status <> n.account_status
        or o.user_sub_type <> n.user_sub_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_user_cl(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,application_user_flag -- 是否应用柜员
            ,auth_level -- 授权级别
            ,company -- 法人
            ,department -- 部门
            ,eod_sod_enabled_flag -- 是否批处理用户
            ,inter_branch_cl -- 是否贷款业务机构
            ,inter_branch_ind -- 是否为内部银行
            ,role_id -- 角色
            ,source_type -- 渠道编号
            ,tbook -- 账薄
            ,user_desc -- 柜员描述信息
            ,user_lang -- 柜员语言
            ,user_level -- 柜员级别
            ,user_name -- 柜员名称
            ,user_type -- 柜员类别
            ,check_date -- 检查日期
            ,make_date -- 柜员创建日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,creation_user_id -- 创建柜员
            ,account_status -- 柜员状态a:有效,d:删除
            ,user_sub_type -- 柜员细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_user_op(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,application_user_flag -- 是否应用柜员
            ,auth_level -- 授权级别
            ,company -- 法人
            ,department -- 部门
            ,eod_sod_enabled_flag -- 是否批处理用户
            ,inter_branch_cl -- 是否贷款业务机构
            ,inter_branch_ind -- 是否为内部银行
            ,role_id -- 角色
            ,source_type -- 渠道编号
            ,tbook -- 账薄
            ,user_desc -- 柜员描述信息
            ,user_lang -- 柜员语言
            ,user_level -- 柜员级别
            ,user_name -- 柜员名称
            ,user_type -- 柜员类别
            ,check_date -- 检查日期
            ,make_date -- 柜员创建日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,creation_user_id -- 创建柜员
            ,account_status -- 柜员状态a:有效,d:删除
            ,user_sub_type -- 柜员细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.profit_center -- 利润中心
    ,o.user_id -- 交易柜员编号
    ,o.acct_exec -- 银行客户经理编号
    ,o.application_user_flag -- 是否应用柜员
    ,o.auth_level -- 授权级别
    ,o.company -- 法人
    ,o.department -- 部门
    ,o.eod_sod_enabled_flag -- 是否批处理用户
    ,o.inter_branch_cl -- 是否贷款业务机构
    ,o.inter_branch_ind -- 是否为内部银行
    ,o.role_id -- 角色
    ,o.source_type -- 渠道编号
    ,o.tbook -- 账薄
    ,o.user_desc -- 柜员描述信息
    ,o.user_lang -- 柜员语言
    ,o.user_level -- 柜员级别
    ,o.user_name -- 柜员名称
    ,o.user_type -- 柜员类别
    ,o.check_date -- 检查日期
    ,o.make_date -- 柜员创建日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.creation_user_id -- 创建柜员
    ,o.account_status -- 柜员状态a:有效,d:删除
    ,o.user_sub_type -- 柜员细类
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
from ${iol_schema}.ncbs_fm_user_bk o
    left join ${iol_schema}.ncbs_fm_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_user_cl d
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
--truncate table ${iol_schema}.ncbs_fm_user;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_user') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_user drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_user add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_user exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_user_cl;
alter table ${iol_schema}.ncbs_fm_user exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_user_op purge;
drop table ${iol_schema}.ncbs_fm_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
