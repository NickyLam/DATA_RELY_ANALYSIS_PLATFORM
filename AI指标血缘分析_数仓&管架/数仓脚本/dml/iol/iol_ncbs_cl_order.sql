/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_order
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
create table ${iol_schema}.ncbs_cl_order_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_order
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_order_op purge;
drop table ${iol_schema}.ncbs_cl_order_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order_op nologging
for exchange with table
${iol_schema}.ncbs_cl_order;

create table ${iol_schema}.ncbs_cl_order_cl nologging
for exchange with table
${iol_schema}.ncbs_cl_order;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_order_cl(
            order_seq_no -- 预约登记号
            ,order_no -- 预约编号
            ,order_effect_date -- 贷款预约生效日期
            ,order_type -- 预约项目类型
            ,order_status -- 预约状态
            ,client_no -- 客户编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,dd_no -- 发放号
            ,tran_branch -- 核心交易机构编号
            ,tran_date -- 交易日期
            ,order_exec_status -- 预约执行状态
            ,failure_reason -- 失败原因
            ,source_module -- 源模块
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_order_op(
            order_seq_no -- 预约登记号
            ,order_no -- 预约编号
            ,order_effect_date -- 贷款预约生效日期
            ,order_type -- 预约项目类型
            ,order_status -- 预约状态
            ,client_no -- 客户编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,dd_no -- 发放号
            ,tran_branch -- 核心交易机构编号
            ,tran_date -- 交易日期
            ,order_exec_status -- 预约执行状态
            ,failure_reason -- 失败原因
            ,source_module -- 源模块
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.order_seq_no, o.order_seq_no) as order_seq_no -- 预约登记号
    ,nvl(n.order_no, o.order_no) as order_no -- 预约编号
    ,nvl(n.order_effect_date, o.order_effect_date) as order_effect_date -- 贷款预约生效日期
    ,nvl(n.order_type, o.order_type) as order_type -- 预约项目类型
    ,nvl(n.order_status, o.order_status) as order_status -- 预约状态
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.order_exec_status, o.order_exec_status) as order_exec_status -- 预约执行状态
    ,nvl(n.failure_reason, o.failure_reason) as failure_reason -- 失败原因
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.order_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.order_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.order_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_order_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_order where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_seq_no = n.order_seq_no
where (
        o.order_seq_no is null
    )
    or (
        n.order_seq_no is null
    )
    or (
        o.order_no <> n.order_no
        or o.order_effect_date <> n.order_effect_date
        or o.order_type <> n.order_type
        or o.order_status <> n.order_status
        or o.client_no <> n.client_no
        or o.loan_no <> n.loan_no
        or o.prod_type <> n.prod_type
        or o.acct_ccy <> n.acct_ccy
        or o.dd_no <> n.dd_no
        or o.tran_branch <> n.tran_branch
        or o.tran_date <> n.tran_date
        or o.order_exec_status <> n.order_exec_status
        or o.failure_reason <> n.failure_reason
        or o.source_module <> n.source_module
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_order_cl(
            order_seq_no -- 预约登记号
            ,order_no -- 预约编号
            ,order_effect_date -- 贷款预约生效日期
            ,order_type -- 预约项目类型
            ,order_status -- 预约状态
            ,client_no -- 客户编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,dd_no -- 发放号
            ,tran_branch -- 核心交易机构编号
            ,tran_date -- 交易日期
            ,order_exec_status -- 预约执行状态
            ,failure_reason -- 失败原因
            ,source_module -- 源模块
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_order_op(
            order_seq_no -- 预约登记号
            ,order_no -- 预约编号
            ,order_effect_date -- 贷款预约生效日期
            ,order_type -- 预约项目类型
            ,order_status -- 预约状态
            ,client_no -- 客户编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,dd_no -- 发放号
            ,tran_branch -- 核心交易机构编号
            ,tran_date -- 交易日期
            ,order_exec_status -- 预约执行状态
            ,failure_reason -- 失败原因
            ,source_module -- 源模块
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.order_seq_no -- 预约登记号
    ,o.order_no -- 预约编号
    ,o.order_effect_date -- 贷款预约生效日期
    ,o.order_type -- 预约项目类型
    ,o.order_status -- 预约状态
    ,o.client_no -- 客户编号
    ,o.loan_no -- 贷款号
    ,o.prod_type -- 产品编号
    ,o.acct_ccy -- 账户币种
    ,o.dd_no -- 发放号
    ,o.tran_branch -- 核心交易机构编号
    ,o.tran_date -- 交易日期
    ,o.order_exec_status -- 预约执行状态
    ,o.failure_reason -- 失败原因
    ,o.source_module -- 源模块
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
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
from ${iol_schema}.ncbs_cl_order_bk o
    left join ${iol_schema}.ncbs_cl_order_op n
        on
            o.order_seq_no = n.order_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_order_cl d
        on
            o.order_seq_no = d.order_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_order;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_order') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_order drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_order add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_order exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_order_cl;
alter table ${iol_schema}.ncbs_cl_order exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_order_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_order to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_order_op purge;
drop table ${iol_schema}.ncbs_cl_order_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_order_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_order',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
