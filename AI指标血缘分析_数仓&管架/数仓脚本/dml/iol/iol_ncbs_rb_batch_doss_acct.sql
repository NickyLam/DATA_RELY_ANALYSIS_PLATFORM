/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_doss_acct
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
create table ${iol_schema}.ncbs_rb_batch_doss_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_doss_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct_op purge;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_doss_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_doss_acct where 0=1;

create table ${iol_schema}.ncbs_rb_batch_doss_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_doss_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_doss_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_type -- 账户类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,import_type -- 导入类型
            ,individual_flag -- 对公对私标志
            ,job_run_id -- 批处理任务id
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,doss_date -- 转久悬日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_amt -- 利息金额
            ,por_int_tot -- 本息合计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_doss_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_type -- 账户类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,import_type -- 导入类型
            ,individual_flag -- 对公对私标志
            ,job_run_id -- 批处理任务id
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,doss_date -- 转久悬日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_amt -- 利息金额
            ,por_int_tot -- 本息合计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次处理状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.doss_operate_type, o.doss_operate_type) as doss_operate_type -- 转久悬操作类型
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.import_type, o.import_type) as import_type -- 导入类型
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.doss_date, o.doss_date) as doss_date -- 转久悬日期
    ,nvl(n.out_date, o.out_date) as out_date -- 出库日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.por_int_tot, o.por_int_tot) as por_int_tot -- 本息合计
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
from (select * from ${iol_schema}.ncbs_rb_batch_doss_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_doss_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_type <> n.acct_type
        or o.balance <> n.balance
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.batch_status <> n.batch_status
        or o.company <> n.company
        or o.doss_operate_type <> n.doss_operate_type
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.import_type <> n.import_type
        or o.individual_flag <> n.individual_flag
        or o.job_run_id <> n.job_run_id
        or o.ret_msg <> n.ret_msg
        or o.doss_date <> n.doss_date
        or o.out_date <> n.out_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.int_amt <> n.int_amt
        or o.por_int_tot <> n.por_int_tot
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_doss_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_type -- 账户类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,import_type -- 导入类型
            ,individual_flag -- 对公对私标志
            ,job_run_id -- 批处理任务id
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,doss_date -- 转久悬日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_amt -- 利息金额
            ,por_int_tot -- 本息合计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_doss_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_type -- 账户类型
            ,balance -- 余额
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,company -- 法人
            ,doss_operate_type -- 转久悬操作类型
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,import_type -- 导入类型
            ,individual_flag -- 对公对私标志
            ,job_run_id -- 批处理任务id
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,doss_date -- 转久悬日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_amt -- 利息金额
            ,por_int_tot -- 本息合计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_type -- 账户类型
    ,o.balance -- 余额
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.batch_no -- 批次号
    ,o.batch_status -- 批次处理状态
    ,o.company -- 法人
    ,o.doss_operate_type -- 转久悬操作类型
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.import_type -- 导入类型
    ,o.individual_flag -- 对公对私标志
    ,o.job_run_id -- 批处理任务id
    ,o.ret_msg -- 服务状态描述
    ,o.seq_no -- 序号
    ,o.doss_date -- 转久悬日期
    ,o.out_date -- 出库日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.int_amt -- 利息金额
    ,o.por_int_tot -- 本息合计
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
from ${iol_schema}.ncbs_rb_batch_doss_acct_bk o
    left join ${iol_schema}.ncbs_rb_batch_doss_acct_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_doss_acct_cl d
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
--truncate table ${iol_schema}.ncbs_rb_batch_doss_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_doss_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_doss_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_doss_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_doss_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_doss_acct_cl;
alter table ${iol_schema}.ncbs_rb_batch_doss_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_doss_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_doss_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct_op purge;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_doss_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_doss_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
