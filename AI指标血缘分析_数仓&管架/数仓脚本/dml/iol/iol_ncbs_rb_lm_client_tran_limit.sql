/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_lm_client_tran_limit
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
create table ${iol_schema}.ncbs_rb_lm_client_tran_limit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_lm_client_tran_limit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit_op purge;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_client_tran_limit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_lm_client_tran_limit where 0=1;

create table ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_lm_client_tran_limit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl(
            base_acct_no -- 交易账号/卡号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,prod_type -- 产品编号
            ,client_no -- 客户编号
            ,limit_ref -- 限额编码
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_max_num -- 限额最大笔数
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,seq_no -- 序号
            ,limit_main_type -- 限额大类
            ,limit_reason -- 限额设置原因|限额设置原因
            ,tran_limit_due_date -- 交易限额有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_lm_client_tran_limit_op(
            base_acct_no -- 交易账号/卡号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,prod_type -- 产品编号
            ,client_no -- 客户编号
            ,limit_ref -- 限额编码
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_max_num -- 限额最大笔数
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,seq_no -- 序号
            ,limit_main_type -- 限额大类
            ,limit_reason -- 限额设置原因|限额设置原因
            ,tran_limit_due_date -- 交易限额有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.limit_ref, o.limit_ref) as limit_ref -- 限额编码
    ,nvl(n.limit_max_amt, o.limit_max_amt) as limit_max_amt -- 最大限额
    ,nvl(n.limit_min_amt, o.limit_min_amt) as limit_min_amt -- 限额最小金额
    ,nvl(n.limit_max_num, o.limit_max_num) as limit_max_num -- 限额最大笔数
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.limit_main_type, o.limit_main_type) as limit_main_type -- 限额大类
    ,nvl(n.limit_reason, o.limit_reason) as limit_reason -- 限额设置原因|限额设置原因
    ,nvl(n.tran_limit_due_date, o.tran_limit_due_date) as tran_limit_due_date -- 交易限额有效期
    ,case when
            n.base_acct_no is null
            and n.acct_seq_no is null
            and n.client_no is null
            and n.limit_ref is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_acct_no is null
            and n.acct_seq_no is null
            and n.client_no is null
            and n.limit_ref is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_acct_no is null
            and n.acct_seq_no is null
            and n.client_no is null
            and n.limit_ref is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_lm_client_tran_limit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_lm_client_tran_limit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_acct_no = n.base_acct_no
            and o.acct_seq_no = n.acct_seq_no
            and o.client_no = n.client_no
            and o.limit_ref = n.limit_ref
where (
        o.base_acct_no is null
        and o.acct_seq_no is null
        and o.client_no is null
        and o.limit_ref is null
    )
    or (
        n.base_acct_no is null
        and n.acct_seq_no is null
        and n.client_no is null
        and n.limit_ref is null
    )
    or (
        o.acct_ccy <> n.acct_ccy
        or o.prod_type <> n.prod_type
        or o.limit_max_amt <> n.limit_max_amt
        or o.limit_min_amt <> n.limit_min_amt
        or o.limit_max_num <> n.limit_max_num
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.seq_no <> n.seq_no
        or o.limit_main_type <> n.limit_main_type
        or o.limit_reason <> n.limit_reason
        or o.tran_limit_due_date <> n.tran_limit_due_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl(
            base_acct_no -- 交易账号/卡号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,prod_type -- 产品编号
            ,client_no -- 客户编号
            ,limit_ref -- 限额编码
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_max_num -- 限额最大笔数
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,seq_no -- 序号
            ,limit_main_type -- 限额大类
            ,limit_reason -- 限额设置原因|限额设置原因
            ,tran_limit_due_date -- 交易限额有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_lm_client_tran_limit_op(
            base_acct_no -- 交易账号/卡号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,prod_type -- 产品编号
            ,client_no -- 客户编号
            ,limit_ref -- 限额编码
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_max_num -- 限额最大笔数
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,seq_no -- 序号
            ,limit_main_type -- 限额大类
            ,limit_reason -- 限额设置原因|限额设置原因
            ,tran_limit_due_date -- 交易限额有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.acct_ccy -- 账户币种
    ,o.acct_seq_no -- 账户子账号
    ,o.prod_type -- 产品编号
    ,o.client_no -- 客户编号
    ,o.limit_ref -- 限额编码
    ,o.limit_max_amt -- 最大限额
    ,o.limit_min_amt -- 限额最小金额
    ,o.limit_max_num -- 限额最大笔数
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.seq_no -- 序号
    ,o.limit_main_type -- 限额大类
    ,o.limit_reason -- 限额设置原因|限额设置原因
    ,o.tran_limit_due_date -- 交易限额有效期
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
from ${iol_schema}.ncbs_rb_lm_client_tran_limit_bk o
    left join ${iol_schema}.ncbs_rb_lm_client_tran_limit_op n
        on
            o.base_acct_no = n.base_acct_no
            and o.acct_seq_no = n.acct_seq_no
            and o.client_no = n.client_no
            and o.limit_ref = n.limit_ref
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl d
        on
            o.base_acct_no = d.base_acct_no
            and o.acct_seq_no = d.acct_seq_no
            and o.client_no = d.client_no
            and o.limit_ref = d.limit_ref
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_lm_client_tran_limit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_lm_client_tran_limit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_lm_client_tran_limit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_lm_client_tran_limit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_lm_client_tran_limit exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl;
alter table ${iol_schema}.ncbs_rb_lm_client_tran_limit exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_lm_client_tran_limit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_lm_client_tran_limit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit_op purge;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_lm_client_tran_limit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
