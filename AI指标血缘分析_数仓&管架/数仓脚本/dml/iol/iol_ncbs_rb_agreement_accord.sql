/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_accord
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
create table ${iol_schema}.ncbs_rb_agreement_accord_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_accord
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_accord_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_accord_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_accord_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_accord where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_accord_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_accord where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_accord_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_accord_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.accord_prod_type, o.accord_prod_type) as accord_prod_type -- 协定协议产品类型
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.near_amt, o.near_amt) as near_amt -- 靠档金额
    ,nvl(n.int_rate_form_no, o.int_rate_form_no) as int_rate_form_no -- 利率审批单单号
    ,nvl(n.last_start_date, o.last_start_date) as last_start_date -- 上一开始日
    ,nvl(n.last_end_date, o.last_end_date) as last_end_date -- 上一结束日
    ,case when
            n.agreement_id is null
            and n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
            and n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
            and n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_accord_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_accord where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
            and o.seq_no = n.seq_no
where (
        o.agreement_id is null
        and o.seq_no is null
    )
    or (
        n.agreement_id is null
        and n.seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.agreement_status <> n.agreement_status
        or o.company <> n.company
        or o.month_basis <> n.month_basis
        or o.year_basis <> n.year_basis
        or o.int_class <> n.int_class
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.accord_prod_type <> n.accord_prod_type
        or o.acct_ccy <> n.acct_ccy
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.float_rate <> n.float_rate
        or o.near_amt <> n.near_amt
        or o.int_rate_form_no <> n.int_rate_form_no
        or o.last_start_date <> n.last_start_date
        or o.last_end_date <> n.last_end_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_accord_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_accord_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,month_basis -- 月基准
            ,seq_no -- 序号
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accord_prod_type -- 协定协议产品类型
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,int_rate_form_no -- 利率审批单单号
            ,last_start_date -- 上一开始日
            ,last_end_date -- 上一结束日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.company -- 法人
    ,o.month_basis -- 月基准
    ,o.seq_no -- 序号
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.accord_prod_type -- 协定协议产品类型
    ,o.acct_ccy -- 账户币种
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.float_rate -- 浮动利率
    ,o.near_amt -- 靠档金额
    ,o.int_rate_form_no -- 利率审批单单号
    ,o.last_start_date -- 上一开始日
    ,o.last_end_date -- 上一结束日
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
from ${iol_schema}.ncbs_rb_agreement_accord_bk o
    left join ${iol_schema}.ncbs_rb_agreement_accord_op n
        on
            o.agreement_id = n.agreement_id
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_accord_cl d
        on
            o.agreement_id = d.agreement_id
            and o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_accord;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_accord') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_accord drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_accord add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_accord exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_accord_cl;
alter table ${iol_schema}.ncbs_rb_agreement_accord exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_accord_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_accord to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_accord_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_accord_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_accord_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_accord',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
