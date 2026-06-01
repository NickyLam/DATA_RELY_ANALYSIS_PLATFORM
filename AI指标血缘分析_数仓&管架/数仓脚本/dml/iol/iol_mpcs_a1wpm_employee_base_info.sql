/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wpm_employee_base_info
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
create table ${iol_schema}.mpcs_a1wpm_employee_base_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wpm_employee_base_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info_op purge;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wpm_employee_base_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wpm_employee_base_info where 0=1;

create table ${iol_schema}.mpcs_a1wpm_employee_base_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wpm_employee_base_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wpm_employee_base_info_cl(
            employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,incumbency_flag -- 在职标识(Y-在职;N-离职)
            ,enable_flag -- 启停用标识(Y-启用;N-停用)
            ,user_id -- 用户ID
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
            ,acct_no -- 银行账号
            ,phone_no -- 电话号码
            ,company_id -- 公司ID
            ,rank_id -- 职级ID
            ,organ_id -- 组织ID
            ,post_id -- 岗位ID
            ,entry_date -- 入职日期
            ,employee_type -- 员工类型(01-正式;02-试用;03-实习)
            ,employee_gender -- 员工性别(01-女;02-男)
            ,employee_no -- 员工编号
            ,quit_company_flag -- 是否退出公司(Y-是;N-否)
            ,syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
            ,recover_flag -- 离职恢复标识(Y-是;N-否)
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,manage_flag -- 是否运管端停用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wpm_employee_base_info_op(
            employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,incumbency_flag -- 在职标识(Y-在职;N-离职)
            ,enable_flag -- 启停用标识(Y-启用;N-停用)
            ,user_id -- 用户ID
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
            ,acct_no -- 银行账号
            ,phone_no -- 电话号码
            ,company_id -- 公司ID
            ,rank_id -- 职级ID
            ,organ_id -- 组织ID
            ,post_id -- 岗位ID
            ,entry_date -- 入职日期
            ,employee_type -- 员工类型(01-正式;02-试用;03-实习)
            ,employee_gender -- 员工性别(01-女;02-男)
            ,employee_no -- 员工编号
            ,quit_company_flag -- 是否退出公司(Y-是;N-否)
            ,syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
            ,recover_flag -- 离职恢复标识(Y-是;N-否)
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,manage_flag -- 是否运管端停用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.employee_id, o.employee_id) as employee_id -- 员工ID
    ,nvl(n.employee_name, o.employee_name) as employee_name -- 员工姓名
    ,nvl(n.incumbency_flag, o.incumbency_flag) as incumbency_flag -- 在职标识(Y-在职;N-离职)
    ,nvl(n.enable_flag, o.enable_flag) as enable_flag -- 启停用标识(Y-启用;N-停用)
    ,nvl(n.user_id, o.user_id) as user_id -- 用户ID
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.leave_status, o.leave_status) as leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 银行账号
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 电话号码
    ,nvl(n.company_id, o.company_id) as company_id -- 公司ID
    ,nvl(n.rank_id, o.rank_id) as rank_id -- 职级ID
    ,nvl(n.organ_id, o.organ_id) as organ_id -- 组织ID
    ,nvl(n.post_id, o.post_id) as post_id -- 岗位ID
    ,nvl(n.entry_date, o.entry_date) as entry_date -- 入职日期
    ,nvl(n.employee_type, o.employee_type) as employee_type -- 员工类型(01-正式;02-试用;03-实习)
    ,nvl(n.employee_gender, o.employee_gender) as employee_gender -- 员工性别(01-女;02-男)
    ,nvl(n.employee_no, o.employee_no) as employee_no -- 员工编号
    ,nvl(n.quit_company_flag, o.quit_company_flag) as quit_company_flag -- 是否退出公司(Y-是;N-否)
    ,nvl(n.syn_source, o.syn_source) as syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
    ,nvl(n.recover_flag, o.recover_flag) as recover_flag -- 离职恢复标识(Y-是;N-否)
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,nvl(n.manage_flag, o.manage_flag) as manage_flag -- 是否运管端停用
    ,case when
            n.employee_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.employee_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.employee_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wpm_employee_base_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wpm_employee_base_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.employee_id = n.employee_id
where (
        o.employee_id is null
    )
    or (
        n.employee_id is null
    )
    or (
        o.employee_name <> n.employee_name
        or o.incumbency_flag <> n.incumbency_flag
        or o.enable_flag <> n.enable_flag
        or o.user_id <> n.user_id
        or o.cert_type <> n.cert_type
        or o.cert_no <> n.cert_no
        or o.leave_status <> n.leave_status
        or o.acct_no <> n.acct_no
        or o.phone_no <> n.phone_no
        or o.company_id <> n.company_id
        or o.rank_id <> n.rank_id
        or o.organ_id <> n.organ_id
        or o.post_id <> n.post_id
        or o.entry_date <> n.entry_date
        or o.employee_type <> n.employee_type
        or o.employee_gender <> n.employee_gender
        or o.employee_no <> n.employee_no
        or o.quit_company_flag <> n.quit_company_flag
        or o.syn_source <> n.syn_source
        or o.recover_flag <> n.recover_flag
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
        or o.manage_flag <> n.manage_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wpm_employee_base_info_cl(
            employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,incumbency_flag -- 在职标识(Y-在职;N-离职)
            ,enable_flag -- 启停用标识(Y-启用;N-停用)
            ,user_id -- 用户ID
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
            ,acct_no -- 银行账号
            ,phone_no -- 电话号码
            ,company_id -- 公司ID
            ,rank_id -- 职级ID
            ,organ_id -- 组织ID
            ,post_id -- 岗位ID
            ,entry_date -- 入职日期
            ,employee_type -- 员工类型(01-正式;02-试用;03-实习)
            ,employee_gender -- 员工性别(01-女;02-男)
            ,employee_no -- 员工编号
            ,quit_company_flag -- 是否退出公司(Y-是;N-否)
            ,syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
            ,recover_flag -- 离职恢复标识(Y-是;N-否)
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,manage_flag -- 是否运管端停用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wpm_employee_base_info_op(
            employee_id -- 员工ID
            ,employee_name -- 员工姓名
            ,incumbency_flag -- 在职标识(Y-在职;N-离职)
            ,enable_flag -- 启停用标识(Y-启用;N-停用)
            ,user_id -- 用户ID
            ,cert_type -- 证件类型
            ,cert_no -- 证件号码
            ,leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
            ,acct_no -- 银行账号
            ,phone_no -- 电话号码
            ,company_id -- 公司ID
            ,rank_id -- 职级ID
            ,organ_id -- 组织ID
            ,post_id -- 岗位ID
            ,entry_date -- 入职日期
            ,employee_type -- 员工类型(01-正式;02-试用;03-实习)
            ,employee_gender -- 员工性别(01-女;02-男)
            ,employee_no -- 员工编号
            ,quit_company_flag -- 是否退出公司(Y-是;N-否)
            ,syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
            ,recover_flag -- 离职恢复标识(Y-是;N-否)
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,manage_flag -- 是否运管端停用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.employee_id -- 员工ID
    ,o.employee_name -- 员工姓名
    ,o.incumbency_flag -- 在职标识(Y-在职;N-离职)
    ,o.enable_flag -- 启停用标识(Y-启用;N-停用)
    ,o.user_id -- 用户ID
    ,o.cert_type -- 证件类型
    ,o.cert_no -- 证件号码
    ,o.leave_status -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
    ,o.acct_no -- 银行账号
    ,o.phone_no -- 电话号码
    ,o.company_id -- 公司ID
    ,o.rank_id -- 职级ID
    ,o.organ_id -- 组织ID
    ,o.post_id -- 岗位ID
    ,o.entry_date -- 入职日期
    ,o.employee_type -- 员工类型(01-正式;02-试用;03-实习)
    ,o.employee_gender -- 员工性别(01-女;02-男)
    ,o.employee_no -- 员工编号
    ,o.quit_company_flag -- 是否退出公司(Y-是;N-否)
    ,o.syn_source -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
    ,o.recover_flag -- 离职恢复标识(Y-是;N-否)
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.manage_flag -- 是否运管端停用
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
from ${iol_schema}.mpcs_a1wpm_employee_base_info_bk o
    left join ${iol_schema}.mpcs_a1wpm_employee_base_info_op n
        on
            o.employee_id = n.employee_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wpm_employee_base_info_cl d
        on
            o.employee_id = d.employee_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wpm_employee_base_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wpm_employee_base_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wpm_employee_base_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wpm_employee_base_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wpm_employee_base_info exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wpm_employee_base_info_cl;
alter table ${iol_schema}.mpcs_a1wpm_employee_base_info exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wpm_employee_base_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wpm_employee_base_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info_op purge;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wpm_employee_base_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
