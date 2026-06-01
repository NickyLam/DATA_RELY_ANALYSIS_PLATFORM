/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_supplement_sl
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
create table ${iol_schema}.ncbs_rb_agreement_supplement_sl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_supplement_sl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_supplement_sl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_supplement_sl where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_supplement_sl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,receipt_reason_code -- 回收原因
            ,seq_no -- 序号
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,dd_reason_code -- 发放原因
            ,limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
            ,limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
            ,max_dd_amt -- 最大发放金额
            ,min_dd_amt -- 最小发放金额
            ,used_amt_agg -- 转账已用额度
            ,used_amt_cash_agg -- 现金已用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_supplement_sl_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,receipt_reason_code -- 回收原因
            ,seq_no -- 序号
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,dd_reason_code -- 发放原因
            ,limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
            ,limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
            ,max_dd_amt -- 最大发放金额
            ,min_dd_amt -- 最小发放金额
            ,used_amt_agg -- 转账已用额度
            ,used_amt_cash_agg -- 现金已用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.receipt_reason_code, o.receipt_reason_code) as receipt_reason_code -- 回收原因
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.dd_reason_code, o.dd_reason_code) as dd_reason_code -- 发放原因
    ,nvl(n.limit_amt_agg, o.limit_amt_agg) as limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
    ,nvl(n.limit_amt_cash_agg, o.limit_amt_cash_agg) as limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
    ,nvl(n.max_dd_amt, o.max_dd_amt) as max_dd_amt -- 最大发放金额
    ,nvl(n.min_dd_amt, o.min_dd_amt) as min_dd_amt -- 最小发放金额
    ,nvl(n.used_amt_agg, o.used_amt_agg) as used_amt_agg -- 转账已用额度
    ,nvl(n.used_amt_cash_agg, o.used_amt_cash_agg) as used_amt_cash_agg -- 现金已用额度
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
from (select * from ${iol_schema}.ncbs_rb_agreement_supplement_sl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_supplement_sl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.agreement_id <> n.agreement_id
        or o.company <> n.company
        or o.receipt_reason_code <> n.receipt_reason_code
        or o.channel <> n.channel
        or o.tran_timestamp <> n.tran_timestamp
        or o.dd_reason_code <> n.dd_reason_code
        or o.limit_amt_agg <> n.limit_amt_agg
        or o.limit_amt_cash_agg <> n.limit_amt_cash_agg
        or o.max_dd_amt <> n.max_dd_amt
        or o.min_dd_amt <> n.min_dd_amt
        or o.used_amt_agg <> n.used_amt_agg
        or o.used_amt_cash_agg <> n.used_amt_cash_agg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,receipt_reason_code -- 回收原因
            ,seq_no -- 序号
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,dd_reason_code -- 发放原因
            ,limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
            ,limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
            ,max_dd_amt -- 最大发放金额
            ,min_dd_amt -- 最小发放金额
            ,used_amt_agg -- 转账已用额度
            ,used_amt_cash_agg -- 现金已用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_supplement_sl_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,receipt_reason_code -- 回收原因
            ,seq_no -- 序号
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,dd_reason_code -- 发放原因
            ,limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
            ,limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
            ,max_dd_amt -- 最大发放金额
            ,min_dd_amt -- 最小发放金额
            ,used_amt_agg -- 转账已用额度
            ,used_amt_cash_agg -- 现金已用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.agreement_id -- 协议编号
    ,o.company -- 法人
    ,o.receipt_reason_code -- 回收原因
    ,o.seq_no -- 序号
    ,o.channel -- 渠道
    ,o.tran_timestamp -- 交易时间戳
    ,o.dd_reason_code -- 发放原因
    ,o.limit_amt_agg -- 卡易贷放贷(转账)渠道最大额度
    ,o.limit_amt_cash_agg -- 卡易贷放贷(现金)渠道最大额度
    ,o.max_dd_amt -- 最大发放金额
    ,o.min_dd_amt -- 最小发放金额
    ,o.used_amt_agg -- 转账已用额度
    ,o.used_amt_cash_agg -- 现金已用额度
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
from ${iol_schema}.ncbs_rb_agreement_supplement_sl_bk o
    left join ${iol_schema}.ncbs_rb_agreement_supplement_sl_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl d
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
--truncate table ${iol_schema}.ncbs_rb_agreement_supplement_sl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_supplement_sl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_supplement_sl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_supplement_sl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_supplement_sl exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl;
alter table ${iol_schema}.ncbs_rb_agreement_supplement_sl exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_supplement_sl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_supplement_sl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_supplement_sl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
