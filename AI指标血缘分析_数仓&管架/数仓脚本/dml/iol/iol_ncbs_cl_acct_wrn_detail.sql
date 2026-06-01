/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_wrn_detail
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
create table ${iol_schema}.ncbs_cl_acct_wrn_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_wrn_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail_op purge;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_wrn_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_wrn_detail where 0=1;

create table ${iol_schema}.ncbs_cl_acct_wrn_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_wrn_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_wrn_detail_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,seq_no -- 序号
            ,wrn_type -- 核销类型
            ,tran_timestamp -- 交易时间戳
            ,wrn_date -- 贷款核销日期
            ,wrn_amt -- 贷款核销本金
            ,wrn_amt_prev -- 上日核销本金
            ,wrn_int_amt -- 核销正常利息
            ,wrn_int_amt_prev -- 上日核销正常利息
            ,wrn_odi_amt -- 核销复利利息
            ,wrn_odi_amt_prev -- 上日核销复利利息
            ,wrn_ododi_amt -- 核销复利的复利
            ,wrn_ododi_amt_prev -- 上日核销复利的复利
            ,wrn_ododp_amt -- 核销罚息的复利
            ,wrn_ododp_amt_prev -- 上日核销罚息的复利
            ,wrn_odp_amt -- 核销罚息利息
            ,wrn_odp_amt_prev -- 上日核销罚息利息
            ,wrn_time_ododi_amt -- 核销时点复利的复利金额
            ,wrn_time_ododp_amt -- 核销时点罚息的复利金额
            ,wrn_time_odi_amt -- 核销时点复利金额
            ,wrn_time_odp_amt -- 核销时点罚息金额
            ,wrn_time_int_amt -- 核销时点利息金额
            ,wrn_time_amt -- 核销时点金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_wrn_detail_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,seq_no -- 序号
            ,wrn_type -- 核销类型
            ,tran_timestamp -- 交易时间戳
            ,wrn_date -- 贷款核销日期
            ,wrn_amt -- 贷款核销本金
            ,wrn_amt_prev -- 上日核销本金
            ,wrn_int_amt -- 核销正常利息
            ,wrn_int_amt_prev -- 上日核销正常利息
            ,wrn_odi_amt -- 核销复利利息
            ,wrn_odi_amt_prev -- 上日核销复利利息
            ,wrn_ododi_amt -- 核销复利的复利
            ,wrn_ododi_amt_prev -- 上日核销复利的复利
            ,wrn_ododp_amt -- 核销罚息的复利
            ,wrn_ododp_amt_prev -- 上日核销罚息的复利
            ,wrn_odp_amt -- 核销罚息利息
            ,wrn_odp_amt_prev -- 上日核销罚息利息
            ,wrn_time_ododi_amt -- 核销时点复利的复利金额
            ,wrn_time_ododp_amt -- 核销时点罚息的复利金额
            ,wrn_time_odi_amt -- 核销时点复利金额
            ,wrn_time_odp_amt -- 核销时点罚息金额
            ,wrn_time_int_amt -- 核销时点利息金额
            ,wrn_time_amt -- 核销时点金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.wrn_type, o.wrn_type) as wrn_type -- 核销类型
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.wrn_date, o.wrn_date) as wrn_date -- 贷款核销日期
    ,nvl(n.wrn_amt, o.wrn_amt) as wrn_amt -- 贷款核销本金
    ,nvl(n.wrn_amt_prev, o.wrn_amt_prev) as wrn_amt_prev -- 上日核销本金
    ,nvl(n.wrn_int_amt, o.wrn_int_amt) as wrn_int_amt -- 核销正常利息
    ,nvl(n.wrn_int_amt_prev, o.wrn_int_amt_prev) as wrn_int_amt_prev -- 上日核销正常利息
    ,nvl(n.wrn_odi_amt, o.wrn_odi_amt) as wrn_odi_amt -- 核销复利利息
    ,nvl(n.wrn_odi_amt_prev, o.wrn_odi_amt_prev) as wrn_odi_amt_prev -- 上日核销复利利息
    ,nvl(n.wrn_ododi_amt, o.wrn_ododi_amt) as wrn_ododi_amt -- 核销复利的复利
    ,nvl(n.wrn_ododi_amt_prev, o.wrn_ododi_amt_prev) as wrn_ododi_amt_prev -- 上日核销复利的复利
    ,nvl(n.wrn_ododp_amt, o.wrn_ododp_amt) as wrn_ododp_amt -- 核销罚息的复利
    ,nvl(n.wrn_ododp_amt_prev, o.wrn_ododp_amt_prev) as wrn_ododp_amt_prev -- 上日核销罚息的复利
    ,nvl(n.wrn_odp_amt, o.wrn_odp_amt) as wrn_odp_amt -- 核销罚息利息
    ,nvl(n.wrn_odp_amt_prev, o.wrn_odp_amt_prev) as wrn_odp_amt_prev -- 上日核销罚息利息
    ,nvl(n.wrn_time_ododi_amt, o.wrn_time_ododi_amt) as wrn_time_ododi_amt -- 核销时点复利的复利金额
    ,nvl(n.wrn_time_ododp_amt, o.wrn_time_ododp_amt) as wrn_time_ododp_amt -- 核销时点罚息的复利金额
    ,nvl(n.wrn_time_odi_amt, o.wrn_time_odi_amt) as wrn_time_odi_amt -- 核销时点复利金额
    ,nvl(n.wrn_time_odp_amt, o.wrn_time_odp_amt) as wrn_time_odp_amt -- 核销时点罚息金额
    ,nvl(n.wrn_time_int_amt, o.wrn_time_int_amt) as wrn_time_int_amt -- 核销时点利息金额
    ,nvl(n.wrn_time_amt, o.wrn_time_amt) as wrn_time_amt -- 核销时点金额
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
from (select * from ${iol_schema}.ncbs_cl_acct_wrn_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_wrn_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.company <> n.company
        or o.wrn_type <> n.wrn_type
        or o.tran_timestamp <> n.tran_timestamp
        or o.wrn_date <> n.wrn_date
        or o.wrn_amt <> n.wrn_amt
        or o.wrn_amt_prev <> n.wrn_amt_prev
        or o.wrn_int_amt <> n.wrn_int_amt
        or o.wrn_int_amt_prev <> n.wrn_int_amt_prev
        or o.wrn_odi_amt <> n.wrn_odi_amt
        or o.wrn_odi_amt_prev <> n.wrn_odi_amt_prev
        or o.wrn_ododi_amt <> n.wrn_ododi_amt
        or o.wrn_ododi_amt_prev <> n.wrn_ododi_amt_prev
        or o.wrn_ododp_amt <> n.wrn_ododp_amt
        or o.wrn_ododp_amt_prev <> n.wrn_ododp_amt_prev
        or o.wrn_odp_amt <> n.wrn_odp_amt
        or o.wrn_odp_amt_prev <> n.wrn_odp_amt_prev
        or o.wrn_time_ododi_amt <> n.wrn_time_ododi_amt
        or o.wrn_time_ododp_amt <> n.wrn_time_ododp_amt
        or o.wrn_time_odi_amt <> n.wrn_time_odi_amt
        or o.wrn_time_odp_amt <> n.wrn_time_odp_amt
        or o.wrn_time_int_amt <> n.wrn_time_int_amt
        or o.wrn_time_amt <> n.wrn_time_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_wrn_detail_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,seq_no -- 序号
            ,wrn_type -- 核销类型
            ,tran_timestamp -- 交易时间戳
            ,wrn_date -- 贷款核销日期
            ,wrn_amt -- 贷款核销本金
            ,wrn_amt_prev -- 上日核销本金
            ,wrn_int_amt -- 核销正常利息
            ,wrn_int_amt_prev -- 上日核销正常利息
            ,wrn_odi_amt -- 核销复利利息
            ,wrn_odi_amt_prev -- 上日核销复利利息
            ,wrn_ododi_amt -- 核销复利的复利
            ,wrn_ododi_amt_prev -- 上日核销复利的复利
            ,wrn_ododp_amt -- 核销罚息的复利
            ,wrn_ododp_amt_prev -- 上日核销罚息的复利
            ,wrn_odp_amt -- 核销罚息利息
            ,wrn_odp_amt_prev -- 上日核销罚息利息
            ,wrn_time_ododi_amt -- 核销时点复利的复利金额
            ,wrn_time_ododp_amt -- 核销时点罚息的复利金额
            ,wrn_time_odi_amt -- 核销时点复利金额
            ,wrn_time_odp_amt -- 核销时点罚息金额
            ,wrn_time_int_amt -- 核销时点利息金额
            ,wrn_time_amt -- 核销时点金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_wrn_detail_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,seq_no -- 序号
            ,wrn_type -- 核销类型
            ,tran_timestamp -- 交易时间戳
            ,wrn_date -- 贷款核销日期
            ,wrn_amt -- 贷款核销本金
            ,wrn_amt_prev -- 上日核销本金
            ,wrn_int_amt -- 核销正常利息
            ,wrn_int_amt_prev -- 上日核销正常利息
            ,wrn_odi_amt -- 核销复利利息
            ,wrn_odi_amt_prev -- 上日核销复利利息
            ,wrn_ododi_amt -- 核销复利的复利
            ,wrn_ododi_amt_prev -- 上日核销复利的复利
            ,wrn_ododp_amt -- 核销罚息的复利
            ,wrn_ododp_amt_prev -- 上日核销罚息的复利
            ,wrn_odp_amt -- 核销罚息利息
            ,wrn_odp_amt_prev -- 上日核销罚息利息
            ,wrn_time_ododi_amt -- 核销时点复利的复利金额
            ,wrn_time_ododp_amt -- 核销时点罚息的复利金额
            ,wrn_time_odi_amt -- 核销时点复利金额
            ,wrn_time_odp_amt -- 核销时点罚息金额
            ,wrn_time_int_amt -- 核销时点利息金额
            ,wrn_time_amt -- 核销时点金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.seq_no -- 序号
    ,o.wrn_type -- 核销类型
    ,o.tran_timestamp -- 交易时间戳
    ,o.wrn_date -- 贷款核销日期
    ,o.wrn_amt -- 贷款核销本金
    ,o.wrn_amt_prev -- 上日核销本金
    ,o.wrn_int_amt -- 核销正常利息
    ,o.wrn_int_amt_prev -- 上日核销正常利息
    ,o.wrn_odi_amt -- 核销复利利息
    ,o.wrn_odi_amt_prev -- 上日核销复利利息
    ,o.wrn_ododi_amt -- 核销复利的复利
    ,o.wrn_ododi_amt_prev -- 上日核销复利的复利
    ,o.wrn_ododp_amt -- 核销罚息的复利
    ,o.wrn_ododp_amt_prev -- 上日核销罚息的复利
    ,o.wrn_odp_amt -- 核销罚息利息
    ,o.wrn_odp_amt_prev -- 上日核销罚息利息
    ,o.wrn_time_ododi_amt -- 核销时点复利的复利金额
    ,o.wrn_time_ododp_amt -- 核销时点罚息的复利金额
    ,o.wrn_time_odi_amt -- 核销时点复利金额
    ,o.wrn_time_odp_amt -- 核销时点罚息金额
    ,o.wrn_time_int_amt -- 核销时点利息金额
    ,o.wrn_time_amt -- 核销时点金额
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
from ${iol_schema}.ncbs_cl_acct_wrn_detail_bk o
    left join ${iol_schema}.ncbs_cl_acct_wrn_detail_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_wrn_detail_cl d
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
--truncate table ${iol_schema}.ncbs_cl_acct_wrn_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_wrn_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_wrn_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_wrn_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_wrn_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_wrn_detail_cl;
alter table ${iol_schema}.ncbs_cl_acct_wrn_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_wrn_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_wrn_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail_op purge;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_wrn_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
