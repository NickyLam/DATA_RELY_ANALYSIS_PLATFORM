/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_dd_increase
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
create table ${iol_schema}.ncbs_cl_dd_increase_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_dd_increase
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_dd_increase_op purge;
drop table ${iol_schema}.ncbs_cl_dd_increase_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_dd_increase_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_dd_increase where 0=1;

create table ${iol_schema}.ncbs_cl_dd_increase_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_dd_increase where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_dd_increase_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,counter -- 序号
            ,ddi_date -- 增发日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,ddi_amt -- 增发金额
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_dd_increase_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,counter -- 序号
            ,ddi_date -- 增发日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,ddi_amt -- 增发金额
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.counter, o.counter) as counter -- 序号
    ,nvl(n.ddi_date, o.ddi_date) as ddi_date -- 增发日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.ddi_amt, o.ddi_amt) as ddi_amt -- 增发金额
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,case when
            n.counter is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.counter is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.counter is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_dd_increase_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_dd_increase where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.counter = n.counter
where (
        o.counter is null
    )
    or (
        n.counter is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.dd_no <> n.dd_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.appr_flag <> n.appr_flag
        or o.company <> n.company
        or o.ddi_date <> n.ddi_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.ddi_amt <> n.ddi_amt
        or o.loan_no <> n.loan_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_dd_increase_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,counter -- 序号
            ,ddi_date -- 增发日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,ddi_amt -- 增发金额
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_dd_increase_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,counter -- 序号
            ,ddi_date -- 增发日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,ddi_amt -- 增发金额
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.appr_flag -- 复核标志
    ,o.company -- 法人
    ,o.counter -- 序号
    ,o.ddi_date -- 增发日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.ddi_amt -- 增发金额
    ,o.loan_no -- 贷款号
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
from ${iol_schema}.ncbs_cl_dd_increase_bk o
    left join ${iol_schema}.ncbs_cl_dd_increase_op n
        on
            o.counter = n.counter
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_dd_increase_cl d
        on
            o.counter = d.counter
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_dd_increase;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_dd_increase') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_dd_increase drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_dd_increase add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_dd_increase exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_dd_increase_cl;
alter table ${iol_schema}.ncbs_cl_dd_increase exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_dd_increase_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_dd_increase to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_dd_increase_op purge;
drop table ${iol_schema}.ncbs_cl_dd_increase_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_dd_increase_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_dd_increase',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
