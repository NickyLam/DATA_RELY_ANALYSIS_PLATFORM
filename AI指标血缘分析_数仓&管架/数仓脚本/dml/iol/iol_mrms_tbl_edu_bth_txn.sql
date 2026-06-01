/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_edu_bth_txn
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
create table ${iol_schema}.mrms_tbl_edu_bth_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_edu_bth_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn_op purge;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_edu_bth_txn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_edu_bth_txn where 0=1;

create table ${iol_schema}.mrms_tbl_edu_bth_txn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_edu_bth_txn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_edu_bth_txn_cl(
            order_num -- 第三方订单号
            ,merch_num -- 商户号
            ,merch_name -- 商户名称
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,pay_acct -- 付款账号
            ,pay_acct_name -- 付款账户名称
            ,rcv_acct -- 收款账号
            ,recv_acct_name -- 收款账号名称
            ,order_amt -- 订单金额
            ,fee_amt -- 手续费金额
            ,tran_type -- 交易类型 1手续费垫资、2批量代付
            ,post -- 附言
            ,bank_id -- 银行标识
            ,ret_code -- 响应码
            ,ret_msg -- 响应信息
            ,platf_seq_num -- 银行业务流水号
            ,txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,chn_bat_seq_num -- 第三方批次流水号
            ,seq -- 银行流水号（批次号）
            ,pay_seq_num -- 支付流水号
            ,core_seq_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_edu_bth_txn_op(
            order_num -- 第三方订单号
            ,merch_num -- 商户号
            ,merch_name -- 商户名称
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,pay_acct -- 付款账号
            ,pay_acct_name -- 付款账户名称
            ,rcv_acct -- 收款账号
            ,recv_acct_name -- 收款账号名称
            ,order_amt -- 订单金额
            ,fee_amt -- 手续费金额
            ,tran_type -- 交易类型 1手续费垫资、2批量代付
            ,post -- 附言
            ,bank_id -- 银行标识
            ,ret_code -- 响应码
            ,ret_msg -- 响应信息
            ,platf_seq_num -- 银行业务流水号
            ,txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,chn_bat_seq_num -- 第三方批次流水号
            ,seq -- 银行流水号（批次号）
            ,pay_seq_num -- 支付流水号
            ,core_seq_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.order_num, o.order_num) as order_num -- 第三方订单号
    ,nvl(n.merch_num, o.merch_num) as merch_num -- 商户号
    ,nvl(n.merch_name, o.merch_name) as merch_name -- 商户名称
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_time, o.tran_time) as tran_time -- 交易时间
    ,nvl(n.pay_acct, o.pay_acct) as pay_acct -- 付款账号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 付款账户名称
    ,nvl(n.rcv_acct, o.rcv_acct) as rcv_acct -- 收款账号
    ,nvl(n.recv_acct_name, o.recv_acct_name) as recv_acct_name -- 收款账号名称
    ,nvl(n.order_amt, o.order_amt) as order_amt -- 订单金额
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 手续费金额
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型 1手续费垫资、2批量代付
    ,nvl(n.post, o.post) as post -- 附言
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行标识
    ,nvl(n.ret_code, o.ret_code) as ret_code -- 响应码
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 响应信息
    ,nvl(n.platf_seq_num, o.platf_seq_num) as platf_seq_num -- 银行业务流水号
    ,nvl(n.txn_status, o.txn_status) as txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
    ,nvl(n.created_time, o.created_time) as created_time -- 创建时间
    ,nvl(n.updated_time, o.updated_time) as updated_time -- 修改时间
    ,nvl(n.reserved1, o.reserved1) as reserved1 -- 保留字段
    ,nvl(n.reserved2, o.reserved2) as reserved2 -- 保留字段
    ,nvl(n.reserved3, o.reserved3) as reserved3 -- 保留字段
    ,nvl(n.reserved4, o.reserved4) as reserved4 -- 保留字段
    ,nvl(n.reserved5, o.reserved5) as reserved5 -- 保留字段
    ,nvl(n.chn_bat_seq_num, o.chn_bat_seq_num) as chn_bat_seq_num -- 第三方批次流水号
    ,nvl(n.seq, o.seq) as seq -- 银行流水号（批次号）
    ,nvl(n.pay_seq_num, o.pay_seq_num) as pay_seq_num -- 支付流水号
    ,nvl(n.core_seq_num, o.core_seq_num) as core_seq_num -- 核心流水号
    ,case when
            n.order_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.order_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.order_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_edu_bth_txn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_edu_bth_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_num = n.order_num
where (
        o.order_num is null
    )
    or (
        n.order_num is null
    )
    or (
        o.merch_num <> n.merch_num
        or o.merch_name <> n.merch_name
        or o.tran_date <> n.tran_date
        or o.tran_time <> n.tran_time
        or o.pay_acct <> n.pay_acct
        or o.pay_acct_name <> n.pay_acct_name
        or o.rcv_acct <> n.rcv_acct
        or o.recv_acct_name <> n.recv_acct_name
        or o.order_amt <> n.order_amt
        or o.fee_amt <> n.fee_amt
        or o.tran_type <> n.tran_type
        or o.post <> n.post
        or o.bank_id <> n.bank_id
        or o.ret_code <> n.ret_code
        or o.ret_msg <> n.ret_msg
        or o.platf_seq_num <> n.platf_seq_num
        or o.txn_status <> n.txn_status
        or o.created_time <> n.created_time
        or o.updated_time <> n.updated_time
        or o.reserved1 <> n.reserved1
        or o.reserved2 <> n.reserved2
        or o.reserved3 <> n.reserved3
        or o.reserved4 <> n.reserved4
        or o.reserved5 <> n.reserved5
        or o.chn_bat_seq_num <> n.chn_bat_seq_num
        or o.seq <> n.seq
        or o.pay_seq_num <> n.pay_seq_num
        or o.core_seq_num <> n.core_seq_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_edu_bth_txn_cl(
            order_num -- 第三方订单号
            ,merch_num -- 商户号
            ,merch_name -- 商户名称
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,pay_acct -- 付款账号
            ,pay_acct_name -- 付款账户名称
            ,rcv_acct -- 收款账号
            ,recv_acct_name -- 收款账号名称
            ,order_amt -- 订单金额
            ,fee_amt -- 手续费金额
            ,tran_type -- 交易类型 1手续费垫资、2批量代付
            ,post -- 附言
            ,bank_id -- 银行标识
            ,ret_code -- 响应码
            ,ret_msg -- 响应信息
            ,platf_seq_num -- 银行业务流水号
            ,txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,chn_bat_seq_num -- 第三方批次流水号
            ,seq -- 银行流水号（批次号）
            ,pay_seq_num -- 支付流水号
            ,core_seq_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_edu_bth_txn_op(
            order_num -- 第三方订单号
            ,merch_num -- 商户号
            ,merch_name -- 商户名称
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,pay_acct -- 付款账号
            ,pay_acct_name -- 付款账户名称
            ,rcv_acct -- 收款账号
            ,recv_acct_name -- 收款账号名称
            ,order_amt -- 订单金额
            ,fee_amt -- 手续费金额
            ,tran_type -- 交易类型 1手续费垫资、2批量代付
            ,post -- 附言
            ,bank_id -- 银行标识
            ,ret_code -- 响应码
            ,ret_msg -- 响应信息
            ,platf_seq_num -- 银行业务流水号
            ,txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
            ,created_time -- 创建时间
            ,updated_time -- 修改时间
            ,reserved1 -- 保留字段
            ,reserved2 -- 保留字段
            ,reserved3 -- 保留字段
            ,reserved4 -- 保留字段
            ,reserved5 -- 保留字段
            ,chn_bat_seq_num -- 第三方批次流水号
            ,seq -- 银行流水号（批次号）
            ,pay_seq_num -- 支付流水号
            ,core_seq_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.order_num -- 第三方订单号
    ,o.merch_num -- 商户号
    ,o.merch_name -- 商户名称
    ,o.tran_date -- 交易日期
    ,o.tran_time -- 交易时间
    ,o.pay_acct -- 付款账号
    ,o.pay_acct_name -- 付款账户名称
    ,o.rcv_acct -- 收款账号
    ,o.recv_acct_name -- 收款账号名称
    ,o.order_amt -- 订单金额
    ,o.fee_amt -- 手续费金额
    ,o.tran_type -- 交易类型 1手续费垫资、2批量代付
    ,o.post -- 附言
    ,o.bank_id -- 银行标识
    ,o.ret_code -- 响应码
    ,o.ret_msg -- 响应信息
    ,o.platf_seq_num -- 银行业务流水号
    ,o.txn_status -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
    ,o.created_time -- 创建时间
    ,o.updated_time -- 修改时间
    ,o.reserved1 -- 保留字段
    ,o.reserved2 -- 保留字段
    ,o.reserved3 -- 保留字段
    ,o.reserved4 -- 保留字段
    ,o.reserved5 -- 保留字段
    ,o.chn_bat_seq_num -- 第三方批次流水号
    ,o.seq -- 银行流水号（批次号）
    ,o.pay_seq_num -- 支付流水号
    ,o.core_seq_num -- 核心流水号
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
from ${iol_schema}.mrms_tbl_edu_bth_txn_bk o
    left join ${iol_schema}.mrms_tbl_edu_bth_txn_op n
        on
            o.order_num = n.order_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_edu_bth_txn_cl d
        on
            o.order_num = d.order_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_edu_bth_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_edu_bth_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_edu_bth_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_edu_bth_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_edu_bth_txn exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_edu_bth_txn_cl;
alter table ${iol_schema}.mrms_tbl_edu_bth_txn exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_edu_bth_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_edu_bth_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn_op purge;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_edu_bth_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
