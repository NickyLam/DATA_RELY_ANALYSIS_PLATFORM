/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_discount
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
create table ${iol_schema}.ncbs_cl_acct_discount_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_discount
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_discount_op purge;
drop table ${iol_schema}.ncbs_cl_acct_discount_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_discount_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_discount where 0=1;

create table ${iol_schema}.ncbs_cl_acct_discount_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_discount where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_discount_cl(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,bill_no -- 票据号码
            ,bill_status -- 票据状态
            ,company -- 法人
            ,payer_bank -- 票据贴现收款人开户行
            ,sell_not_flag -- 是否卖断式
            ,sell_own_draft_flag -- 是否本行票据
            ,discount_date -- 贷款贴现日期
            ,draft_mature_date -- 票面到期日期
            ,issue_date -- 发行日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,bill_amt -- 票面金额
            ,book_branch -- 贷款银行
            ,dd_day -- 增加天数
            ,disc_base_rate -- 基准利率1
            ,int_rate -- 出单利率
            ,issue_acct_no -- 出售账号
            ,issue_client_name -- 出票人全名称
            ,loan_no -- 贷款号
            ,pay_branch -- 缴存机构
            ,payee_acct_name -- 收款人名称
            ,payee_base_acct_no -- 收款人账号
            ,payer_branch_name -- 付款人机构名称
            ,sell_int -- 账户利息支出
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_discount_op(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,bill_no -- 票据号码
            ,bill_status -- 票据状态
            ,company -- 法人
            ,payer_bank -- 票据贴现收款人开户行
            ,sell_not_flag -- 是否卖断式
            ,sell_own_draft_flag -- 是否本行票据
            ,discount_date -- 贷款贴现日期
            ,draft_mature_date -- 票面到期日期
            ,issue_date -- 发行日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,bill_amt -- 票面金额
            ,book_branch -- 贷款银行
            ,dd_day -- 增加天数
            ,disc_base_rate -- 基准利率1
            ,int_rate -- 出单利率
            ,issue_acct_no -- 出售账号
            ,issue_client_name -- 出票人全名称
            ,loan_no -- 贷款号
            ,pay_branch -- 缴存机构
            ,payee_acct_name -- 收款人名称
            ,payee_base_acct_no -- 收款人账号
            ,payer_branch_name -- 付款人机构名称
            ,sell_int -- 账户利息支出
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 票据号码
    ,nvl(n.bill_status, o.bill_status) as bill_status -- 票据状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.payer_bank, o.payer_bank) as payer_bank -- 票据贴现收款人开户行
    ,nvl(n.sell_not_flag, o.sell_not_flag) as sell_not_flag -- 是否卖断式
    ,nvl(n.sell_own_draft_flag, o.sell_own_draft_flag) as sell_own_draft_flag -- 是否本行票据
    ,nvl(n.discount_date, o.discount_date) as discount_date -- 贷款贴现日期
    ,nvl(n.draft_mature_date, o.draft_mature_date) as draft_mature_date -- 票面到期日期
    ,nvl(n.issue_date, o.issue_date) as issue_date -- 发行日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票面金额
    ,nvl(n.book_branch, o.book_branch) as book_branch -- 贷款银行
    ,nvl(n.dd_day, o.dd_day) as dd_day -- 增加天数
    ,nvl(n.disc_base_rate, o.disc_base_rate) as disc_base_rate -- 基准利率1
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 出单利率
    ,nvl(n.issue_acct_no, o.issue_acct_no) as issue_acct_no -- 出售账号
    ,nvl(n.issue_client_name, o.issue_client_name) as issue_client_name -- 出票人全名称
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.pay_branch, o.pay_branch) as pay_branch -- 缴存机构
    ,nvl(n.payee_acct_name, o.payee_acct_name) as payee_acct_name -- 收款人名称
    ,nvl(n.payee_base_acct_no, o.payee_base_acct_no) as payee_base_acct_no -- 收款人账号
    ,nvl(n.payer_branch_name, o.payer_branch_name) as payer_branch_name -- 付款人机构名称
    ,nvl(n.sell_int, o.sell_int) as sell_int -- 账户利息支出
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_acct_discount_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_discount where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.bill_no <> n.bill_no
        or o.bill_status <> n.bill_status
        or o.company <> n.company
        or o.payer_bank <> n.payer_bank
        or o.sell_not_flag <> n.sell_not_flag
        or o.sell_own_draft_flag <> n.sell_own_draft_flag
        or o.discount_date <> n.discount_date
        or o.draft_mature_date <> n.draft_mature_date
        or o.issue_date <> n.issue_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.bill_amt <> n.bill_amt
        or o.book_branch <> n.book_branch
        or o.dd_day <> n.dd_day
        or o.disc_base_rate <> n.disc_base_rate
        or o.int_rate <> n.int_rate
        or o.issue_acct_no <> n.issue_acct_no
        or o.issue_client_name <> n.issue_client_name
        or o.loan_no <> n.loan_no
        or o.pay_branch <> n.pay_branch
        or o.payee_acct_name <> n.payee_acct_name
        or o.payee_base_acct_no <> n.payee_base_acct_no
        or o.payer_branch_name <> n.payer_branch_name
        or o.sell_int <> n.sell_int
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_discount_cl(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,bill_no -- 票据号码
            ,bill_status -- 票据状态
            ,company -- 法人
            ,payer_bank -- 票据贴现收款人开户行
            ,sell_not_flag -- 是否卖断式
            ,sell_own_draft_flag -- 是否本行票据
            ,discount_date -- 贷款贴现日期
            ,draft_mature_date -- 票面到期日期
            ,issue_date -- 发行日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,bill_amt -- 票面金额
            ,book_branch -- 贷款银行
            ,dd_day -- 增加天数
            ,disc_base_rate -- 基准利率1
            ,int_rate -- 出单利率
            ,issue_acct_no -- 出售账号
            ,issue_client_name -- 出票人全名称
            ,loan_no -- 贷款号
            ,pay_branch -- 缴存机构
            ,payee_acct_name -- 收款人名称
            ,payee_base_acct_no -- 收款人账号
            ,payer_branch_name -- 付款人机构名称
            ,sell_int -- 账户利息支出
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_discount_op(
            ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,bill_no -- 票据号码
            ,bill_status -- 票据状态
            ,company -- 法人
            ,payer_bank -- 票据贴现收款人开户行
            ,sell_not_flag -- 是否卖断式
            ,sell_own_draft_flag -- 是否本行票据
            ,discount_date -- 贷款贴现日期
            ,draft_mature_date -- 票面到期日期
            ,issue_date -- 发行日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,bill_amt -- 票面金额
            ,book_branch -- 贷款银行
            ,dd_day -- 增加天数
            ,disc_base_rate -- 基准利率1
            ,int_rate -- 出单利率
            ,issue_acct_no -- 出售账号
            ,issue_client_name -- 出票人全名称
            ,loan_no -- 贷款号
            ,pay_branch -- 缴存机构
            ,payee_acct_name -- 收款人名称
            ,payee_base_acct_no -- 收款人账号
            ,payer_branch_name -- 付款人机构名称
            ,sell_int -- 账户利息支出
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.bill_no -- 票据号码
    ,o.bill_status -- 票据状态
    ,o.company -- 法人
    ,o.payer_bank -- 票据贴现收款人开户行
    ,o.sell_not_flag -- 是否卖断式
    ,o.sell_own_draft_flag -- 是否本行票据
    ,o.discount_date -- 贷款贴现日期
    ,o.draft_mature_date -- 票面到期日期
    ,o.issue_date -- 发行日期
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.bill_amt -- 票面金额
    ,o.book_branch -- 贷款银行
    ,o.dd_day -- 增加天数
    ,o.disc_base_rate -- 基准利率1
    ,o.int_rate -- 出单利率
    ,o.issue_acct_no -- 出售账号
    ,o.issue_client_name -- 出票人全名称
    ,o.loan_no -- 贷款号
    ,o.pay_branch -- 缴存机构
    ,o.payee_acct_name -- 收款人名称
    ,o.payee_base_acct_no -- 收款人账号
    ,o.payer_branch_name -- 付款人机构名称
    ,o.sell_int -- 账户利息支出
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_cl_acct_discount_bk o
    left join ${iol_schema}.ncbs_cl_acct_discount_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_discount_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_discount;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_discount') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_discount drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_discount add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_discount exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_discount_cl;
alter table ${iol_schema}.ncbs_cl_acct_discount exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_discount_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_discount to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_discount_op purge;
drop table ${iol_schema}.ncbs_cl_acct_discount_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_discount_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_discount',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
