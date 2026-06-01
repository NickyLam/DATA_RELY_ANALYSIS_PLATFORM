/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_check_cardinfo
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
create table ${iol_schema}.ncbs_rb_batch_check_cardinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_check_cardinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo_op purge;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_check_cardinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_check_cardinfo where 0=1;

create table ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_check_cardinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl(
            acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,card_no -- 卡号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,acct_class -- 账户等级
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,error_msg -- 错误代码
            ,job_run_id -- 批处理任务id
            ,pass_flag -- 通过标记
            ,phone_no -- 固定电话
            ,phone_no1 -- 电话号码1
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,credit_card_no -- 信用卡号
            ,document_id1 -- 证件号1
            ,document_type1 -- 证件类型1
            ,out_acct_name -- 转出账户名称
            ,remark1 -- 备注1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_check_cardinfo_op(
            acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,card_no -- 卡号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,acct_class -- 账户等级
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,error_msg -- 错误代码
            ,job_run_id -- 批处理任务id
            ,pass_flag -- 通过标记
            ,phone_no -- 固定电话
            ,phone_no1 -- 电话号码1
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,credit_card_no -- 信用卡号
            ,document_id1 -- 证件号1
            ,document_type1 -- 证件类型1
            ,out_acct_name -- 转出账户名称
            ,remark1 -- 备注1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账户等级
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误代码
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.pass_flag, o.pass_flag) as pass_flag -- 通过标记
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 固定电话
    ,nvl(n.phone_no1, o.phone_no1) as phone_no1 -- 电话号码1
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.credit_card_no, o.credit_card_no) as credit_card_no -- 信用卡号
    ,nvl(n.document_id1, o.document_id1) as document_id1 -- 证件号1
    ,nvl(n.document_type1, o.document_type1) as document_type1 -- 证件类型1
    ,nvl(n.out_acct_name, o.out_acct_name) as out_acct_name -- 转出账户名称
    ,nvl(n.remark1, o.remark1) as remark1 -- 备注1
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_batch_check_cardinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_check_cardinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_status <> n.acct_status
        or o.acct_type <> n.acct_type
        or o.card_no <> n.card_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.acct_class <> n.acct_class
        or o.batch_no <> n.batch_no
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.error_msg <> n.error_msg
        or o.job_run_id <> n.job_run_id
        or o.pass_flag <> n.pass_flag
        or o.phone_no <> n.phone_no
        or o.phone_no1 <> n.phone_no1
        or o.ret_msg <> n.ret_msg
        or o.credit_card_no <> n.credit_card_no
        or o.document_id1 <> n.document_id1
        or o.document_type1 <> n.document_type1
        or o.out_acct_name <> n.out_acct_name
        or o.remark1 <> n.remark1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl(
            acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,card_no -- 卡号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,acct_class -- 账户等级
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,error_msg -- 错误代码
            ,job_run_id -- 批处理任务id
            ,pass_flag -- 通过标记
            ,phone_no -- 固定电话
            ,phone_no1 -- 电话号码1
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,credit_card_no -- 信用卡号
            ,document_id1 -- 证件号1
            ,document_type1 -- 证件类型1
            ,out_acct_name -- 转出账户名称
            ,remark1 -- 备注1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_check_cardinfo_op(
            acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,card_no -- 卡号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,acct_class -- 账户等级
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,error_msg -- 错误代码
            ,job_run_id -- 批处理任务id
            ,pass_flag -- 通过标记
            ,phone_no -- 固定电话
            ,phone_no1 -- 电话号码1
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,credit_card_no -- 信用卡号
            ,document_id1 -- 证件号1
            ,document_type1 -- 证件类型1
            ,out_acct_name -- 转出账户名称
            ,remark1 -- 备注1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_status -- 账户状态
    ,o.acct_type -- 账户类型
    ,o.card_no -- 卡号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.acct_class -- 账户等级
    ,o.batch_no -- 批次号
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.error_msg -- 错误代码
    ,o.job_run_id -- 批处理任务id
    ,o.pass_flag -- 通过标记
    ,o.phone_no -- 固定电话
    ,o.phone_no1 -- 电话号码1
    ,o.ret_msg -- 服务状态描述
    ,o.seq_no -- 序号
    ,o.credit_card_no -- 信用卡号
    ,o.document_id1 -- 证件号1
    ,o.document_type1 -- 证件类型1
    ,o.out_acct_name -- 转出账户名称
    ,o.remark1 -- 备注1
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
from ${iol_schema}.ncbs_rb_batch_check_cardinfo_bk o
    left join ${iol_schema}.ncbs_rb_batch_check_cardinfo_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_batch_check_cardinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_check_cardinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_check_cardinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_check_cardinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_check_cardinfo exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl;
alter table ${iol_schema}.ncbs_rb_batch_check_cardinfo exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_check_cardinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_check_cardinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo_op purge;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_check_cardinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
