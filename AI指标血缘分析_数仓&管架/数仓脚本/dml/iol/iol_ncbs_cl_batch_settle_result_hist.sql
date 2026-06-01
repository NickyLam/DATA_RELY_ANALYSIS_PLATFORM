/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_settle_result_hist
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
create table ${iol_schema}.ncbs_cl_batch_settle_result_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_batch_settle_result_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist_op purge;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_settle_result_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_settle_result_hist where 0=1;

create table ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_settle_result_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl(
            amt_type -- 金额类型
            ,batch_no -- 批次号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,restraint_seq_no -- 冻结编号
            ,scene_id -- 场景id
            ,settle_no -- 结算编号
            ,tran_timestamp -- 交易时间戳
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_settle_result_hist_op(
            amt_type -- 金额类型
            ,batch_no -- 批次号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,restraint_seq_no -- 冻结编号
            ,scene_id -- 场景id
            ,settle_no -- 结算编号
            ,tran_timestamp -- 交易时间戳
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_seq_no, o.batch_seq_no) as batch_seq_no -- 批次明细序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.restraint_seq_no, o.restraint_seq_no) as restraint_seq_no -- 冻结编号
    ,nvl(n.scene_id, o.scene_id) as scene_id -- 场景id
    ,nvl(n.settle_no, o.settle_no) as settle_no -- 结算编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,case when
            n.batch_no is null
            and n.batch_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
            and n.batch_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
            and n.batch_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_batch_settle_result_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_batch_settle_result_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
            and o.batch_seq_no = n.batch_seq_no
where (
        o.batch_no is null
        and o.batch_seq_no is null
    )
    or (
        n.batch_no is null
        and n.batch_seq_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.company <> n.company
        or o.restraint_seq_no <> n.restraint_seq_no
        or o.scene_id <> n.scene_id
        or o.settle_no <> n.settle_no
        or o.tran_timestamp <> n.tran_timestamp
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_amt <> n.settle_amt
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_prod_type <> n.settle_prod_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl(
            amt_type -- 金额类型
            ,batch_no -- 批次号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,restraint_seq_no -- 冻结编号
            ,scene_id -- 场景id
            ,settle_no -- 结算编号
            ,tran_timestamp -- 交易时间戳
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_settle_result_hist_op(
            amt_type -- 金额类型
            ,batch_no -- 批次号
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,restraint_seq_no -- 冻结编号
            ,scene_id -- 场景id
            ,settle_no -- 结算编号
            ,tran_timestamp -- 交易时间戳
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.batch_no -- 批次号
    ,o.batch_seq_no -- 批次明细序号
    ,o.company -- 法人
    ,o.restraint_seq_no -- 冻结编号
    ,o.scene_id -- 场景id
    ,o.settle_no -- 结算编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_amt -- 结算金额
    ,o.settle_base_acct_no -- 结算账号
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
from ${iol_schema}.ncbs_cl_batch_settle_result_hist_bk o
    left join ${iol_schema}.ncbs_cl_batch_settle_result_hist_op n
        on
            o.batch_no = n.batch_no
            and o.batch_seq_no = n.batch_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl d
        on
            o.batch_no = d.batch_no
            and o.batch_seq_no = d.batch_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_batch_settle_result_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_batch_settle_result_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_batch_settle_result_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_batch_settle_result_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_batch_settle_result_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl;
alter table ${iol_schema}.ncbs_cl_batch_settle_result_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_batch_settle_result_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_settle_result_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist_op purge;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_batch_settle_result_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_settle_result_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
