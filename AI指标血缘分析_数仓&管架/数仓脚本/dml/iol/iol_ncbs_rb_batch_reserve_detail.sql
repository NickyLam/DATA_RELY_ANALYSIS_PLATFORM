/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_reserve_detail
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
create table ${iol_schema}.ncbs_rb_batch_reserve_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_reserve_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail_op purge;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_reserve_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_reserve_detail where 0=1;

create table ${iol_schema}.ncbs_rb_batch_reserve_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_reserve_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_reserve_detail_cl(
            acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,restraint_type -- 限制类型
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,available_amt -- 可用余额
            ,pledged_amt -- 限制金额
            ,sub_acct_seq_no -- 子账户序号
            ,ext_ref_no -- 来单编号
            ,pay_out_amt -- 备款扣划金额
            ,pay_out_status -- 扣款状态
            ,actual_pay_out_amt -- 实际扣划金额
            ,close_acct_flag -- 是否可销户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_reserve_detail_op(
            acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,restraint_type -- 限制类型
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,available_amt -- 可用余额
            ,pledged_amt -- 限制金额
            ,sub_acct_seq_no -- 子账户序号
            ,ext_ref_no -- 来单编号
            ,pay_out_amt -- 备款扣划金额
            ,pay_out_status -- 扣款状态
            ,actual_pay_out_amt -- 实际扣划金额
            ,close_acct_flag -- 是否可销户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.available_amt, o.available_amt) as available_amt -- 可用余额
    ,nvl(n.pledged_amt, o.pledged_amt) as pledged_amt -- 限制金额
    ,nvl(n.sub_acct_seq_no, o.sub_acct_seq_no) as sub_acct_seq_no -- 子账户序号
    ,nvl(n.ext_ref_no, o.ext_ref_no) as ext_ref_no -- 来单编号
    ,nvl(n.pay_out_amt, o.pay_out_amt) as pay_out_amt -- 备款扣划金额
    ,nvl(n.pay_out_status, o.pay_out_status) as pay_out_status -- 扣款状态
    ,nvl(n.actual_pay_out_amt, o.actual_pay_out_amt) as actual_pay_out_amt -- 实际扣划金额
    ,nvl(n.close_acct_flag, o.close_acct_flag) as close_acct_flag -- 是否可销户
    ,case when
            n.seq_no is null
            and n.ext_ref_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.ext_ref_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.ext_ref_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_batch_reserve_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_reserve_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.ext_ref_no = n.ext_ref_no
where (
        o.seq_no is null
        and o.ext_ref_no is null
    )
    or (
        n.seq_no is null
        and n.ext_ref_no is null
    )
    or (
        o.acct_type <> n.acct_type
        or o.base_acct_no <> n.base_acct_no
        or o.restraint_type <> n.restraint_type
        or o.res_seq_no <> n.res_seq_no
        or o.available_amt <> n.available_amt
        or o.pledged_amt <> n.pledged_amt
        or o.sub_acct_seq_no <> n.sub_acct_seq_no
        or o.pay_out_amt <> n.pay_out_amt
        or o.pay_out_status <> n.pay_out_status
        or o.actual_pay_out_amt <> n.actual_pay_out_amt
        or o.close_acct_flag <> n.close_acct_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_reserve_detail_cl(
            acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,restraint_type -- 限制类型
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,available_amt -- 可用余额
            ,pledged_amt -- 限制金额
            ,sub_acct_seq_no -- 子账户序号
            ,ext_ref_no -- 来单编号
            ,pay_out_amt -- 备款扣划金额
            ,pay_out_status -- 扣款状态
            ,actual_pay_out_amt -- 实际扣划金额
            ,close_acct_flag -- 是否可销户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_reserve_detail_op(
            acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,restraint_type -- 限制类型
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,available_amt -- 可用余额
            ,pledged_amt -- 限制金额
            ,sub_acct_seq_no -- 子账户序号
            ,ext_ref_no -- 来单编号
            ,pay_out_amt -- 备款扣划金额
            ,pay_out_status -- 扣款状态
            ,actual_pay_out_amt -- 实际扣划金额
            ,close_acct_flag -- 是否可销户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_type -- 账户类型
    ,o.base_acct_no -- 交易账号/卡号
    ,o.restraint_type -- 限制类型
    ,o.res_seq_no -- 限制编号
    ,o.seq_no -- 序号
    ,o.available_amt -- 可用余额
    ,o.pledged_amt -- 限制金额
    ,o.sub_acct_seq_no -- 子账户序号
    ,o.ext_ref_no -- 来单编号
    ,o.pay_out_amt -- 备款扣划金额
    ,o.pay_out_status -- 扣款状态
    ,o.actual_pay_out_amt -- 实际扣划金额
    ,o.close_acct_flag -- 是否可销户
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
from ${iol_schema}.ncbs_rb_batch_reserve_detail_bk o
    left join ${iol_schema}.ncbs_rb_batch_reserve_detail_op n
        on
            o.seq_no = n.seq_no
            and o.ext_ref_no = n.ext_ref_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_reserve_detail_cl d
        on
            o.seq_no = d.seq_no
            and o.ext_ref_no = d.ext_ref_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_batch_reserve_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_reserve_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_reserve_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_reserve_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_reserve_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_reserve_detail_cl;
alter table ${iol_schema}.ncbs_rb_batch_reserve_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_reserve_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_reserve_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail_op purge;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_reserve_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_reserve_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
