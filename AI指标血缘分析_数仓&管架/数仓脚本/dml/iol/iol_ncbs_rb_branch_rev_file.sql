/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_branch_rev_file
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
create table ${iol_schema}.ncbs_rb_branch_rev_file_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_branch_rev_file
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_branch_rev_file_op purge;
drop table ${iol_schema}.ncbs_rb_branch_rev_file_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_branch_rev_file_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_branch_rev_file where 0=1;

create table ${iol_schema}.ncbs_rb_branch_rev_file_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_branch_rev_file where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_branch_rev_file_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,job_run_id -- 批处理任务id
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,tran_status -- 冲补抹标志
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_branch_rev_file_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,job_run_id -- 批处理任务id
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,tran_status -- 冲补抹标志
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 冲补抹标志
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.new_branch, o.new_branch) as new_branch -- 变更后机构
    ,nvl(n.old_branch, o.old_branch) as old_branch -- 变更前机构
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_branch_rev_file_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_branch_rev_file where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
where (
        o.batch_no is null
        and o.seq_no is null
    )
    or (
        n.batch_no is null
        and n.seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.prod_type <> n.prod_type
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.job_run_id <> n.job_run_id
        or o.source_module <> n.source_module
        or o.tran_status <> n.tran_status
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.new_branch <> n.new_branch
        or o.old_branch <> n.old_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_branch_rev_file_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,job_run_id -- 批处理任务id
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,tran_status -- 冲补抹标志
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_branch_rev_file_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,job_run_id -- 批处理任务id
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,tran_status -- 冲补抹标志
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.prod_type -- 产品编号
    ,o.batch_no -- 批次号
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.job_run_id -- 批处理任务id
    ,o.seq_no -- 序号
    ,o.source_module -- 源模块
    ,o.tran_status -- 冲补抹标志
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.new_branch -- 变更后机构
    ,o.old_branch -- 变更前机构
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
from ${iol_schema}.ncbs_rb_branch_rev_file_bk o
    left join ${iol_schema}.ncbs_rb_branch_rev_file_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_branch_rev_file_cl d
        on
            o.batch_no = d.batch_no
            and o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_branch_rev_file;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_branch_rev_file') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_branch_rev_file drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_branch_rev_file add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_branch_rev_file exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_branch_rev_file_cl;
alter table ${iol_schema}.ncbs_rb_branch_rev_file exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_branch_rev_file_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_branch_rev_file to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_branch_rev_file_op purge;
drop table ${iol_schema}.ncbs_rb_branch_rev_file_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_branch_rev_file_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_branch_rev_file',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
