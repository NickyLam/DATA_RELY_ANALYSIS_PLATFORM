/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_bab_acct_restraint
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
create table ${iol_schema}.ncbs_rb_bab_acct_restraint_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_bab_acct_restraint
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint_op purge;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_acct_restraint_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_bab_acct_restraint where 0=1;

create table ${iol_schema}.ncbs_rb_bab_acct_restraint_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_bab_acct_restraint where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_bab_acct_restraint_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,bab_settle_class -- 绑备款账户类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,res_status -- 保证金冻结状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,accept_contract_no -- 银承合同编号
            ,acct_ccy -- 账户币种
            ,bill_doc_type -- 票据凭证类型
            ,bill_voucher_no -- 票据凭证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_bab_acct_restraint_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,bab_settle_class -- 绑备款账户类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,res_status -- 保证金冻结状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,accept_contract_no -- 银承合同编号
            ,acct_ccy -- 账户币种
            ,bill_doc_type -- 票据凭证类型
            ,bill_voucher_no -- 票据凭证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.bab_settle_class, o.bab_settle_class) as bab_settle_class -- 绑备款账户类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.res_status, o.res_status) as res_status -- 保证金冻结状态
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.accept_contract_no, o.accept_contract_no) as accept_contract_no -- 银承合同编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.bill_doc_type, o.bill_doc_type) as bill_doc_type -- 票据凭证类型
    ,nvl(n.bill_voucher_no, o.bill_voucher_no) as bill_voucher_no -- 票据凭证号码
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
            and n.accept_contract_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
            and n.accept_contract_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
            and n.accept_contract_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_bab_acct_restraint_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_bab_acct_restraint where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.res_seq_no = n.res_seq_no
            and o.accept_contract_no = n.accept_contract_no
where (
        o.internal_key is null
        and o.res_seq_no is null
        and o.accept_contract_no is null
    )
    or (
        n.internal_key is null
        and n.res_seq_no is null
        and n.accept_contract_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.bab_settle_class <> n.bab_settle_class
        or o.company <> n.company
        or o.res_status <> n.res_status
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.bill_doc_type <> n.bill_doc_type
        or o.bill_voucher_no <> n.bill_voucher_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_bab_acct_restraint_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,bab_settle_class -- 绑备款账户类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,res_status -- 保证金冻结状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,accept_contract_no -- 银承合同编号
            ,acct_ccy -- 账户币种
            ,bill_doc_type -- 票据凭证类型
            ,bill_voucher_no -- 票据凭证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_bab_acct_restraint_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,bab_settle_class -- 绑备款账户类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,res_status -- 保证金冻结状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,accept_contract_no -- 银承合同编号
            ,acct_ccy -- 账户币种
            ,bill_doc_type -- 票据凭证类型
            ,bill_voucher_no -- 票据凭证号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.bab_settle_class -- 绑备款账户类型
    ,o.company -- 法人
    ,o.res_seq_no -- 限制编号
    ,o.res_status -- 保证金冻结状态
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.accept_contract_no -- 银承合同编号
    ,o.acct_ccy -- 账户币种
    ,o.bill_doc_type -- 票据凭证类型
    ,o.bill_voucher_no -- 票据凭证号码
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
from ${iol_schema}.ncbs_rb_bab_acct_restraint_bk o
    left join ${iol_schema}.ncbs_rb_bab_acct_restraint_op n
        on
            o.internal_key = n.internal_key
            and o.res_seq_no = n.res_seq_no
            and o.accept_contract_no = n.accept_contract_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_bab_acct_restraint_cl d
        on
            o.internal_key = d.internal_key
            and o.res_seq_no = d.res_seq_no
            and o.accept_contract_no = d.accept_contract_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_bab_acct_restraint;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_bab_acct_restraint') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_bab_acct_restraint drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_bab_acct_restraint add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_bab_acct_restraint exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_bab_acct_restraint_cl;
alter table ${iol_schema}.ncbs_rb_bab_acct_restraint exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_bab_acct_restraint_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_bab_acct_restraint to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint_op purge;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_bab_acct_restraint_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_bab_acct_restraint',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
