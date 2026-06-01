/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_order_rec_settle
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
create table ${iol_schema}.ncbs_cl_order_rec_settle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_order_rec_settle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_order_rec_settle_op purge;
drop table ${iol_schema}.ncbs_cl_order_rec_settle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order_rec_settle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_order_rec_settle where 0=1;

create table ${iol_schema}.ncbs_cl_order_rec_settle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_order_rec_settle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_order_rec_settle_cl(
            client_no -- 客户编号
            ,order_no -- 预约编号
            ,order_seq_no -- 预约登记号
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_ccy -- 结算币种
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_order_rec_settle_op(
            client_no -- 客户编号
            ,order_no -- 预约编号
            ,order_seq_no -- 预约登记号
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_ccy -- 结算币种
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.order_no, o.order_no) as order_no -- 预约编号
    ,nvl(n.order_seq_no, o.order_seq_no) as order_seq_no -- 预约登记号
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_ccy, o.settle_ccy) as settle_ccy -- 结算币种
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
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
from (select * from ${iol_schema}.ncbs_cl_order_rec_settle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_order_rec_settle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_seq_no = n.order_seq_no
where (
        o.order_seq_no is null
    )
    or (
        n.order_seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.order_no <> n.order_no
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_amt <> n.settle_amt
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_ccy <> n.settle_ccy
        or o.settle_prod_type <> n.settle_prod_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_order_rec_settle_cl(
            client_no -- 客户编号
            ,order_no -- 预约编号
            ,order_seq_no -- 预约登记号
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_ccy -- 结算币种
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_order_rec_settle_op(
            client_no -- 客户编号
            ,order_no -- 预约编号
            ,order_seq_no -- 预约登记号
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_ccy -- 结算币种
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.order_no -- 预约编号
    ,o.order_seq_no -- 预约登记号
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_amt -- 结算金额
    ,o.settle_base_acct_no -- 结算账号
    ,o.settle_ccy -- 结算币种
    ,o.settle_prod_type -- 结算账户产品类型
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
from ${iol_schema}.ncbs_cl_order_rec_settle_bk o
    left join ${iol_schema}.ncbs_cl_order_rec_settle_op n
        on
            o.order_seq_no = n.order_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_order_rec_settle_cl d
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
--truncate table ${iol_schema}.ncbs_cl_order_rec_settle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_order_rec_settle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_order_rec_settle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_order_rec_settle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_order_rec_settle exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_order_rec_settle_cl;
alter table ${iol_schema}.ncbs_cl_order_rec_settle exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_order_rec_settle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_order_rec_settle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_order_rec_settle_op purge;
drop table ${iol_schema}.ncbs_cl_order_rec_settle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_order_rec_settle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_order_rec_settle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
