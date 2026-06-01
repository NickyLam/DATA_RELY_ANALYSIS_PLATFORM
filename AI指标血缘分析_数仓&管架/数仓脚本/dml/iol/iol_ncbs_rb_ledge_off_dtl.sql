/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_ledge_off_dtl
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
create table ${iol_schema}.ncbs_rb_ledge_off_dtl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_ledge_off_dtl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl_op purge;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_ledge_off_dtl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_ledge_off_dtl where 0=1;

create table ${iol_schema}.ncbs_rb_ledge_off_dtl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_ledge_off_dtl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_ledge_off_dtl_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,user_id -- 交易柜员编号
            ,batch_file_status -- 批处理文件处理状态
            ,batch_no -- 批次号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,create_date -- 创建日期
            ,last_change_date -- 最后修改日期
            ,run_date -- 运行日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_ledge_off_dtl_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,user_id -- 交易柜员编号
            ,batch_file_status -- 批处理文件处理状态
            ,batch_no -- 批次号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,create_date -- 创建日期
            ,last_change_date -- 最后修改日期
            ,run_date -- 运行日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.batch_file_status, o.batch_file_status) as batch_file_status -- 批处理文件处理状态
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误代码
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.run_date, o.run_date) as run_date -- 运行日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
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
from (select * from ${iol_schema}.ncbs_rb_ledge_off_dtl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_ledge_off_dtl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.contract_no <> n.contract_no
        or o.user_id <> n.user_id
        or o.batch_file_status <> n.batch_file_status
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.error_msg <> n.error_msg
        or o.res_seq_no <> n.res_seq_no
        or o.create_date <> n.create_date
        or o.last_change_date <> n.last_change_date
        or o.run_date <> n.run_date
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_ledge_off_dtl_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,user_id -- 交易柜员编号
            ,batch_file_status -- 批处理文件处理状态
            ,batch_no -- 批次号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,create_date -- 创建日期
            ,last_change_date -- 最后修改日期
            ,run_date -- 运行日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_ledge_off_dtl_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,user_id -- 交易柜员编号
            ,batch_file_status -- 批处理文件处理状态
            ,batch_no -- 批次号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,create_date -- 创建日期
            ,last_change_date -- 最后修改日期
            ,run_date -- 运行日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.contract_no -- 合同编号
    ,o.user_id -- 交易柜员编号
    ,o.batch_file_status -- 批处理文件处理状态
    ,o.batch_no -- 批次号
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.error_msg -- 错误代码
    ,o.res_seq_no -- 限制编号
    ,o.seq_no -- 序号
    ,o.create_date -- 创建日期
    ,o.last_change_date -- 最后修改日期
    ,o.run_date -- 运行日期
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_rb_ledge_off_dtl_bk o
    left join ${iol_schema}.ncbs_rb_ledge_off_dtl_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_ledge_off_dtl_cl d
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
--truncate table ${iol_schema}.ncbs_rb_ledge_off_dtl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_ledge_off_dtl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_ledge_off_dtl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_ledge_off_dtl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_ledge_off_dtl exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_ledge_off_dtl_cl;
alter table ${iol_schema}.ncbs_rb_ledge_off_dtl exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_ledge_off_dtl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_ledge_off_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl_op purge;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_ledge_off_dtl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_ledge_off_dtl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
