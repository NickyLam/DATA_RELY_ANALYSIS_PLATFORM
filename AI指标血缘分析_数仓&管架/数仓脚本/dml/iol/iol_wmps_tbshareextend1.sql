/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wmps_tbshareextend1
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
create table ${iol_schema}.wmps_tbshareextend1_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wmps_tbshareextend1
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wmps_tbshareextend1_op purge;
drop table ${iol_schema}.wmps_tbshareextend1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wmps_tbshareextend1_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wmps_tbshareextend1 where 0=1;

create table ${iol_schema}.wmps_tbshareextend1_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wmps_tbshareextend1 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wmps_tbshareextend1_cl(
            in_client_no -- 内部客户编号
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,seller_code -- 销售商代码
            ,client_no -- 银行客户号
            ,bank_acc -- 资金账号
            ,ta_code -- ta代码
            ,prd_code -- 产品代码
            ,buy_amt_onway -- 在途申购金额
            ,red_exp_amt -- 已导出赎回金额
            ,red_income -- 已赎回未付收益
            ,income_prev_date -- 未付收益(上一日)
            ,income_upd_date -- 收益更新日期
            ,last_date -- 最后更新日期
            ,incomeonway_flag -- 未付收益正负
            ,redall_flag -- 全额赎回标志
            ,redall_trans_date -- 全额赎回交易日期
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,integer3 -- 备用整型3
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,amt4 -- 备用金额4
            ,amt5 -- 备用金额5
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,reserve4 -- 保留字段4
            ,reserve5 -- 保留字段5
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wmps_tbshareextend1_op(
            in_client_no -- 内部客户编号
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,seller_code -- 销售商代码
            ,client_no -- 银行客户号
            ,bank_acc -- 资金账号
            ,ta_code -- ta代码
            ,prd_code -- 产品代码
            ,buy_amt_onway -- 在途申购金额
            ,red_exp_amt -- 已导出赎回金额
            ,red_income -- 已赎回未付收益
            ,income_prev_date -- 未付收益(上一日)
            ,income_upd_date -- 收益更新日期
            ,last_date -- 最后更新日期
            ,incomeonway_flag -- 未付收益正负
            ,redall_flag -- 全额赎回标志
            ,redall_trans_date -- 全额赎回交易日期
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,integer3 -- 备用整型3
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,amt4 -- 备用金额4
            ,amt5 -- 备用金额5
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,reserve4 -- 保留字段4
            ,reserve5 -- 保留字段5
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行代码:租户编号(多租户模式用)
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 销售商代码
    ,nvl(n.client_no, o.client_no) as client_no -- 银行客户号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 资金账号
    ,nvl(n.ta_code, o.ta_code) as ta_code -- ta代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.buy_amt_onway, o.buy_amt_onway) as buy_amt_onway -- 在途申购金额
    ,nvl(n.red_exp_amt, o.red_exp_amt) as red_exp_amt -- 已导出赎回金额
    ,nvl(n.red_income, o.red_income) as red_income -- 已赎回未付收益
    ,nvl(n.income_prev_date, o.income_prev_date) as income_prev_date -- 未付收益(上一日)
    ,nvl(n.income_upd_date, o.income_upd_date) as income_upd_date -- 收益更新日期
    ,nvl(n.last_date, o.last_date) as last_date -- 最后更新日期
    ,nvl(n.incomeonway_flag, o.incomeonway_flag) as incomeonway_flag -- 未付收益正负
    ,nvl(n.redall_flag, o.redall_flag) as redall_flag -- 全额赎回标志
    ,nvl(n.redall_trans_date, o.redall_trans_date) as redall_trans_date -- 全额赎回交易日期
    ,nvl(n.integer1, o.integer1) as integer1 -- 备用整型1
    ,nvl(n.integer2, o.integer2) as integer2 -- 备用整型2
    ,nvl(n.integer3, o.integer3) as integer3 -- 备用整型3
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 备用金额3
    ,nvl(n.amt4, o.amt4) as amt4 -- 备用金额4
    ,nvl(n.amt5, o.amt5) as amt5 -- 备用金额5
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 保留字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 保留字段5
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,case when
            n.in_client_no is null
            and n.bank_no is null
            and n.seller_code is null
            and n.bank_acc is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.bank_no is null
            and n.seller_code is null
            and n.bank_acc is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.bank_no is null
            and n.seller_code is null
            and n.bank_acc is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wmps_tbshareextend1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wmps_tbshareextend1 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.bank_no = n.bank_no
            and o.seller_code = n.seller_code
            and o.bank_acc = n.bank_acc
            and o.prd_code = n.prd_code
where (
        o.in_client_no is null
        and o.bank_no is null
        and o.seller_code is null
        and o.bank_acc is null
        and o.prd_code is null
    )
    or (
        n.in_client_no is null
        and n.bank_no is null
        and n.seller_code is null
        and n.bank_acc is null
        and n.prd_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.ta_code <> n.ta_code
        or o.buy_amt_onway <> n.buy_amt_onway
        or o.red_exp_amt <> n.red_exp_amt
        or o.red_income <> n.red_income
        or o.income_prev_date <> n.income_prev_date
        or o.income_upd_date <> n.income_upd_date
        or o.last_date <> n.last_date
        or o.incomeonway_flag <> n.incomeonway_flag
        or o.redall_flag <> n.redall_flag
        or o.redall_trans_date <> n.redall_trans_date
        or o.integer1 <> n.integer1
        or o.integer2 <> n.integer2
        or o.integer3 <> n.integer3
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.amt4 <> n.amt4
        or o.amt5 <> n.amt5
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.batch_no <> n.batch_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wmps_tbshareextend1_cl(
            in_client_no -- 内部客户编号
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,seller_code -- 销售商代码
            ,client_no -- 银行客户号
            ,bank_acc -- 资金账号
            ,ta_code -- ta代码
            ,prd_code -- 产品代码
            ,buy_amt_onway -- 在途申购金额
            ,red_exp_amt -- 已导出赎回金额
            ,red_income -- 已赎回未付收益
            ,income_prev_date -- 未付收益(上一日)
            ,income_upd_date -- 收益更新日期
            ,last_date -- 最后更新日期
            ,incomeonway_flag -- 未付收益正负
            ,redall_flag -- 全额赎回标志
            ,redall_trans_date -- 全额赎回交易日期
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,integer3 -- 备用整型3
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,amt4 -- 备用金额4
            ,amt5 -- 备用金额5
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,reserve4 -- 保留字段4
            ,reserve5 -- 保留字段5
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wmps_tbshareextend1_op(
            in_client_no -- 内部客户编号
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,seller_code -- 销售商代码
            ,client_no -- 银行客户号
            ,bank_acc -- 资金账号
            ,ta_code -- ta代码
            ,prd_code -- 产品代码
            ,buy_amt_onway -- 在途申购金额
            ,red_exp_amt -- 已导出赎回金额
            ,red_income -- 已赎回未付收益
            ,income_prev_date -- 未付收益(上一日)
            ,income_upd_date -- 收益更新日期
            ,last_date -- 最后更新日期
            ,incomeonway_flag -- 未付收益正负
            ,redall_flag -- 全额赎回标志
            ,redall_trans_date -- 全额赎回交易日期
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,integer3 -- 备用整型3
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,amt4 -- 备用金额4
            ,amt5 -- 备用金额5
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,reserve4 -- 保留字段4
            ,reserve5 -- 保留字段5
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 内部客户编号
    ,o.bank_no -- 银行代码:租户编号(多租户模式用)
    ,o.seller_code -- 销售商代码
    ,o.client_no -- 银行客户号
    ,o.bank_acc -- 资金账号
    ,o.ta_code -- ta代码
    ,o.prd_code -- 产品代码
    ,o.buy_amt_onway -- 在途申购金额
    ,o.red_exp_amt -- 已导出赎回金额
    ,o.red_income -- 已赎回未付收益
    ,o.income_prev_date -- 未付收益(上一日)
    ,o.income_upd_date -- 收益更新日期
    ,o.last_date -- 最后更新日期
    ,o.incomeonway_flag -- 未付收益正负
    ,o.redall_flag -- 全额赎回标志
    ,o.redall_trans_date -- 全额赎回交易日期
    ,o.integer1 -- 备用整型1
    ,o.integer2 -- 备用整型2
    ,o.integer3 -- 备用整型3
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.amt3 -- 备用金额3
    ,o.amt4 -- 备用金额4
    ,o.amt5 -- 备用金额5
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.reserve4 -- 保留字段4
    ,o.reserve5 -- 保留字段5
    ,o.batch_no -- 批次号
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
from ${iol_schema}.wmps_tbshareextend1_bk o
    left join ${iol_schema}.wmps_tbshareextend1_op n
        on
            o.in_client_no = n.in_client_no
            and o.bank_no = n.bank_no
            and o.seller_code = n.seller_code
            and o.bank_acc = n.bank_acc
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wmps_tbshareextend1_cl d
        on
            o.in_client_no = d.in_client_no
            and o.bank_no = d.bank_no
            and o.seller_code = d.seller_code
            and o.bank_acc = d.bank_acc
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wmps_tbshareextend1;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wmps_tbshareextend1') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wmps_tbshareextend1 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wmps_tbshareextend1 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wmps_tbshareextend1 exchange partition p_${batch_date} with table ${iol_schema}.wmps_tbshareextend1_cl;
alter table ${iol_schema}.wmps_tbshareextend1 exchange partition p_20991231 with table ${iol_schema}.wmps_tbshareextend1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wmps_tbshareextend1 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wmps_tbshareextend1_op purge;
drop table ${iol_schema}.wmps_tbshareextend1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wmps_tbshareextend1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wmps_tbshareextend1',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
