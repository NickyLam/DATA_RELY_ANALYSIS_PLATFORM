/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_rate_amend_details
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
create table ${iol_schema}.ncbs_cl_batch_rate_amend_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_batch_rate_amend_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details_op purge;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_rate_amend_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_rate_amend_details where 0=1;

create table ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_rate_amend_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,error_code -- 错误码
            ,int_appl_type -- 利率启用方式
            ,job_run_id -- 批处理任务id
            ,rate_effect_type -- 利率生效方式
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,status -- 状态
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,new_int_type -- 新利率类型
            ,new_real_rate -- 新执行利率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_rate_amend_details_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,error_code -- 错误码
            ,int_appl_type -- 利率启用方式
            ,job_run_id -- 批处理任务id
            ,rate_effect_type -- 利率生效方式
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,status -- 状态
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,new_int_type -- 新利率类型
            ,new_real_rate -- 新执行利率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.calc_by_int, o.calc_by_int) as calc_by_int -- 是否按正常利率浮动
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.int_appl_type, o.int_appl_type) as int_appl_type -- 利率启用方式
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.rate_effect_type, o.rate_effect_type) as rate_effect_type -- 利率生效方式
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.new_next_roll_date, o.new_next_roll_date) as new_next_roll_date -- 新利率变更日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.new_int_type, o.new_int_type) as new_int_type -- 新利率类型
    ,nvl(n.new_real_rate, o.new_real_rate) as new_real_rate -- 新执行利率
    ,nvl(n.new_roll_day, o.new_roll_day) as new_roll_day -- 新利率变更日
    ,nvl(n.new_roll_freq, o.new_roll_freq) as new_roll_freq -- 新利率变更周期
    ,nvl(n.new_spread_percent, o.new_spread_percent) as new_spread_percent -- 新利率浮动百分比
    ,nvl(n.new_spread_rate, o.new_spread_rate) as new_spread_rate -- 新浮动点数
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
from (select * from ${iol_schema}.ncbs_cl_batch_rate_amend_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_batch_rate_amend_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.dd_no <> n.dd_no
        or o.prod_type <> n.prod_type
        or o.calc_by_int <> n.calc_by_int
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.int_appl_type <> n.int_appl_type
        or o.job_run_id <> n.job_run_id
        or o.rate_effect_type <> n.rate_effect_type
        or o.ret_msg <> n.ret_msg
        or o.status <> n.status
        or o.int_class <> n.int_class
        or o.effect_date <> n.effect_date
        or o.new_next_roll_date <> n.new_next_roll_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.loan_no <> n.loan_no
        or o.new_int_type <> n.new_int_type
        or o.new_real_rate <> n.new_real_rate
        or o.new_roll_day <> n.new_roll_day
        or o.new_roll_freq <> n.new_roll_freq
        or o.new_spread_percent <> n.new_spread_percent
        or o.new_spread_rate <> n.new_spread_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,error_code -- 错误码
            ,int_appl_type -- 利率启用方式
            ,job_run_id -- 批处理任务id
            ,rate_effect_type -- 利率生效方式
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,status -- 状态
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,new_int_type -- 新利率类型
            ,new_real_rate -- 新执行利率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_rate_amend_details_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,dd_no -- 发放号
            ,prod_type -- 产品编号
            ,batch_no -- 批次号
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,error_code -- 错误码
            ,int_appl_type -- 利率启用方式
            ,job_run_id -- 批处理任务id
            ,rate_effect_type -- 利率生效方式
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,status -- 状态
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,new_int_type -- 新利率类型
            ,new_real_rate -- 新执行利率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.dd_no -- 发放号
    ,o.prod_type -- 产品编号
    ,o.batch_no -- 批次号
    ,o.calc_by_int -- 是否按正常利率浮动
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.int_appl_type -- 利率启用方式
    ,o.job_run_id -- 批处理任务id
    ,o.rate_effect_type -- 利率生效方式
    ,o.ret_msg -- 服务状态描述
    ,o.seq_no -- 序号
    ,o.status -- 状态
    ,o.int_class -- 利息分类
    ,o.effect_date -- 产品生效日期
    ,o.new_next_roll_date -- 新利率变更日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.loan_no -- 贷款号
    ,o.new_int_type -- 新利率类型
    ,o.new_real_rate -- 新执行利率
    ,o.new_roll_day -- 新利率变更日
    ,o.new_roll_freq -- 新利率变更周期
    ,o.new_spread_percent -- 新利率浮动百分比
    ,o.new_spread_rate -- 新浮动点数
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
from ${iol_schema}.ncbs_cl_batch_rate_amend_details_bk o
    left join ${iol_schema}.ncbs_cl_batch_rate_amend_details_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl d
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
--truncate table ${iol_schema}.ncbs_cl_batch_rate_amend_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_batch_rate_amend_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_batch_rate_amend_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_batch_rate_amend_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_batch_rate_amend_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl;
alter table ${iol_schema}.ncbs_cl_batch_rate_amend_details exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_batch_rate_amend_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_rate_amend_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details_op purge;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_rate_amend_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
