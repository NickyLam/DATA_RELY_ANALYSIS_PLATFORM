/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_inter_bank_balance
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
create table ${iol_schema}.ncbs_cl_inter_bank_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_inter_bank_balance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance_op purge;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_inter_bank_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_inter_bank_balance where 0=1;

create table ${iol_schema}.ncbs_cl_inter_bank_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_inter_bank_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_inter_bank_balance_cl(
            sum_pay_agent_pri -- 累计已代付本金
            ,sum_pay_agent_odp -- 累计已代付罚息
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,cr_int -- 当日计提利息
            ,pre_cr_int -- 上日计提利息
            ,sum_int_accrued -- 累计计提利息
            ,sum_pay_agent_int -- 累计已代付利息
            ,pay_agent_pri -- 代付本金
            ,cr_odp -- 当日计提罚息
            ,sum_odp -- 累计计提罚息
            ,sum_odp_adj_amt -- 累计罚息调整金额
            ,sum_interest_adj_amt -- 累计利息调整金额
            ,pre_cr_odp -- 上日计提罚息
            ,inter_bank_busi_no -- 同业代付业务编号
            ,is_last_pay_agent -- 是否最后一次代付
            ,timestamp -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_inter_bank_balance_op(
            sum_pay_agent_pri -- 累计已代付本金
            ,sum_pay_agent_odp -- 累计已代付罚息
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,cr_int -- 当日计提利息
            ,pre_cr_int -- 上日计提利息
            ,sum_int_accrued -- 累计计提利息
            ,sum_pay_agent_int -- 累计已代付利息
            ,pay_agent_pri -- 代付本金
            ,cr_odp -- 当日计提罚息
            ,sum_odp -- 累计计提罚息
            ,sum_odp_adj_amt -- 累计罚息调整金额
            ,sum_interest_adj_amt -- 累计利息调整金额
            ,pre_cr_odp -- 上日计提罚息
            ,inter_bank_busi_no -- 同业代付业务编号
            ,is_last_pay_agent -- 是否最后一次代付
            ,timestamp -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sum_pay_agent_pri, o.sum_pay_agent_pri) as sum_pay_agent_pri -- 累计已代付本金
    ,nvl(n.sum_pay_agent_odp, o.sum_pay_agent_odp) as sum_pay_agent_odp -- 累计已代付罚息
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.cr_int, o.cr_int) as cr_int -- 当日计提利息
    ,nvl(n.pre_cr_int, o.pre_cr_int) as pre_cr_int -- 上日计提利息
    ,nvl(n.sum_int_accrued, o.sum_int_accrued) as sum_int_accrued -- 累计计提利息
    ,nvl(n.sum_pay_agent_int, o.sum_pay_agent_int) as sum_pay_agent_int -- 累计已代付利息
    ,nvl(n.pay_agent_pri, o.pay_agent_pri) as pay_agent_pri -- 代付本金
    ,nvl(n.cr_odp, o.cr_odp) as cr_odp -- 当日计提罚息
    ,nvl(n.sum_odp, o.sum_odp) as sum_odp -- 累计计提罚息
    ,nvl(n.sum_odp_adj_amt, o.sum_odp_adj_amt) as sum_odp_adj_amt -- 累计罚息调整金额
    ,nvl(n.sum_interest_adj_amt, o.sum_interest_adj_amt) as sum_interest_adj_amt -- 累计利息调整金额
    ,nvl(n.pre_cr_odp, o.pre_cr_odp) as pre_cr_odp -- 上日计提罚息
    ,nvl(n.inter_bank_busi_no, o.inter_bank_busi_no) as inter_bank_busi_no -- 同业代付业务编号
    ,nvl(n.is_last_pay_agent, o.is_last_pay_agent) as is_last_pay_agent -- 是否最后一次代付
    ,nvl(n.timestamp, o.timestamp) as timestamp -- 时间戳
    ,case when
            n.cmisloan_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cmisloan_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cmisloan_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_inter_bank_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_inter_bank_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cmisloan_no = n.cmisloan_no
where (
        o.cmisloan_no is null
    )
    or (
        n.cmisloan_no is null
    )
    or (
        o.sum_pay_agent_pri <> n.sum_pay_agent_pri
        or o.sum_pay_agent_odp <> n.sum_pay_agent_odp
        or o.client_no <> n.client_no
        or o.cr_int <> n.cr_int
        or o.pre_cr_int <> n.pre_cr_int
        or o.sum_int_accrued <> n.sum_int_accrued
        or o.sum_pay_agent_int <> n.sum_pay_agent_int
        or o.pay_agent_pri <> n.pay_agent_pri
        or o.cr_odp <> n.cr_odp
        or o.sum_odp <> n.sum_odp
        or o.sum_odp_adj_amt <> n.sum_odp_adj_amt
        or o.sum_interest_adj_amt <> n.sum_interest_adj_amt
        or o.pre_cr_odp <> n.pre_cr_odp
        or o.inter_bank_busi_no <> n.inter_bank_busi_no
        or o.is_last_pay_agent <> n.is_last_pay_agent
        or o.timestamp <> n.timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_inter_bank_balance_cl(
            sum_pay_agent_pri -- 累计已代付本金
            ,sum_pay_agent_odp -- 累计已代付罚息
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,cr_int -- 当日计提利息
            ,pre_cr_int -- 上日计提利息
            ,sum_int_accrued -- 累计计提利息
            ,sum_pay_agent_int -- 累计已代付利息
            ,pay_agent_pri -- 代付本金
            ,cr_odp -- 当日计提罚息
            ,sum_odp -- 累计计提罚息
            ,sum_odp_adj_amt -- 累计罚息调整金额
            ,sum_interest_adj_amt -- 累计利息调整金额
            ,pre_cr_odp -- 上日计提罚息
            ,inter_bank_busi_no -- 同业代付业务编号
            ,is_last_pay_agent -- 是否最后一次代付
            ,timestamp -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_inter_bank_balance_op(
            sum_pay_agent_pri -- 累计已代付本金
            ,sum_pay_agent_odp -- 累计已代付罚息
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,cr_int -- 当日计提利息
            ,pre_cr_int -- 上日计提利息
            ,sum_int_accrued -- 累计计提利息
            ,sum_pay_agent_int -- 累计已代付利息
            ,pay_agent_pri -- 代付本金
            ,cr_odp -- 当日计提罚息
            ,sum_odp -- 累计计提罚息
            ,sum_odp_adj_amt -- 累计罚息调整金额
            ,sum_interest_adj_amt -- 累计利息调整金额
            ,pre_cr_odp -- 上日计提罚息
            ,inter_bank_busi_no -- 同业代付业务编号
            ,is_last_pay_agent -- 是否最后一次代付
            ,timestamp -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sum_pay_agent_pri -- 累计已代付本金
    ,o.sum_pay_agent_odp -- 累计已代付罚息
    ,o.client_no -- 客户编号
    ,o.cmisloan_no -- 客户借据编号
    ,o.cr_int -- 当日计提利息
    ,o.pre_cr_int -- 上日计提利息
    ,o.sum_int_accrued -- 累计计提利息
    ,o.sum_pay_agent_int -- 累计已代付利息
    ,o.pay_agent_pri -- 代付本金
    ,o.cr_odp -- 当日计提罚息
    ,o.sum_odp -- 累计计提罚息
    ,o.sum_odp_adj_amt -- 累计罚息调整金额
    ,o.sum_interest_adj_amt -- 累计利息调整金额
    ,o.pre_cr_odp -- 上日计提罚息
    ,o.inter_bank_busi_no -- 同业代付业务编号
    ,o.is_last_pay_agent -- 是否最后一次代付
    ,o.timestamp -- 时间戳
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
from ${iol_schema}.ncbs_cl_inter_bank_balance_bk o
    left join ${iol_schema}.ncbs_cl_inter_bank_balance_op n
        on
            o.cmisloan_no = n.cmisloan_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_inter_bank_balance_cl d
        on
            o.cmisloan_no = d.cmisloan_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_inter_bank_balance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_inter_bank_balance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_inter_bank_balance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_inter_bank_balance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_inter_bank_balance exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_inter_bank_balance_cl;
alter table ${iol_schema}.ncbs_cl_inter_bank_balance exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_inter_bank_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_inter_bank_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance_op purge;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_inter_bank_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
