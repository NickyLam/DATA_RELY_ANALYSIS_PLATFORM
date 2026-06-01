/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_delay_pay_int
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
create table ${iol_schema}.ncbs_rb_delay_pay_int_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_delay_pay_int
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_delay_pay_int_op purge;
drop table ${iol_schema}.ncbs_rb_delay_pay_int_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_delay_pay_int_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_delay_pay_int where 0=1;

create table ${iol_schema}.ncbs_rb_delay_pay_int_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_delay_pay_int where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_delay_pay_int_cl(
            internal_key -- 账户内部键值
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,spec_rate -- 指定收益率
            ,delay_pay_int_type -- 延迟付息时间类型
            ,spec_day -- 指定日
            ,calc_days -- 算息天数
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,client_no -- 客户编号
            ,delay_pay_int_amt -- 延期付息利息
            ,delay_total_amt -- 延迟付息累计金额
            ,delay_int_amt_diff -- 延迟付息昨日今日值差额
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,past_interest -- 累计已付利息
            ,user_id -- 交易柜员编号
            ,tran_branch -- 核心交易机构编号
            ,status -- 状态
            ,pay_interest -- 应付利息
            ,calc_delay_int_amt -- 当日累计延期付息计算金额
            ,acct_type -- 账户类型
            ,oth_internal_key -- 对手账户内部键
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_prod_type -- 对方账户产品类型
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_acct_ccy -- 对方账户币种
            ,reference -- 交易参考号
            ,min_deposit_amt -- 起点存款金额
            ,min_deposit_term -- 起点存款期限
            ,merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
            ,max_amt -- 最大金额
            ,approval_no -- 审批单号
            ,idep_agreement_flag -- 智能存款签约标志
            ,int_float_point -- 利息浮动点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_delay_pay_int_op(
            internal_key -- 账户内部键值
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,spec_rate -- 指定收益率
            ,delay_pay_int_type -- 延迟付息时间类型
            ,spec_day -- 指定日
            ,calc_days -- 算息天数
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,client_no -- 客户编号
            ,delay_pay_int_amt -- 延期付息利息
            ,delay_total_amt -- 延迟付息累计金额
            ,delay_int_amt_diff -- 延迟付息昨日今日值差额
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,past_interest -- 累计已付利息
            ,user_id -- 交易柜员编号
            ,tran_branch -- 核心交易机构编号
            ,status -- 状态
            ,pay_interest -- 应付利息
            ,calc_delay_int_amt -- 当日累计延期付息计算金额
            ,acct_type -- 账户类型
            ,oth_internal_key -- 对手账户内部键
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_prod_type -- 对方账户产品类型
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_acct_ccy -- 对方账户币种
            ,reference -- 交易参考号
            ,min_deposit_amt -- 起点存款金额
            ,min_deposit_term -- 起点存款期限
            ,merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
            ,max_amt -- 最大金额
            ,approval_no -- 审批单号
            ,idep_agreement_flag -- 智能存款签约标志
            ,int_float_point -- 利息浮动点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.spec_rate, o.spec_rate) as spec_rate -- 指定收益率
    ,nvl(n.delay_pay_int_type, o.delay_pay_int_type) as delay_pay_int_type -- 延迟付息时间类型
    ,nvl(n.spec_day, o.spec_day) as spec_day -- 指定日
    ,nvl(n.calc_days, o.calc_days) as calc_days -- 算息天数
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.delay_pay_int_amt, o.delay_pay_int_amt) as delay_pay_int_amt -- 延期付息利息
    ,nvl(n.delay_total_amt, o.delay_total_amt) as delay_total_amt -- 延迟付息累计金额
    ,nvl(n.delay_int_amt_diff, o.delay_int_amt_diff) as delay_int_amt_diff -- 延迟付息昨日今日值差额
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.last_cycle_date, o.last_cycle_date) as last_cycle_date -- 上一结息日
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.past_interest, o.past_interest) as past_interest -- 累计已付利息
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.calc_delay_int_amt, o.calc_delay_int_amt) as calc_delay_int_amt -- 当日累计延期付息计算金额
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.oth_internal_key, o.oth_internal_key) as oth_internal_key -- 对手账户内部键
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 对方账号/卡号
    ,nvl(n.oth_prod_type, o.oth_prod_type) as oth_prod_type -- 对方账户产品类型
    ,nvl(n.oth_acct_seq_no, o.oth_acct_seq_no) as oth_acct_seq_no -- 对方账户序列号
    ,nvl(n.oth_acct_ccy, o.oth_acct_ccy) as oth_acct_ccy -- 对方账户币种
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.min_deposit_amt, o.min_deposit_amt) as min_deposit_amt -- 起点存款金额
    ,nvl(n.min_deposit_term, o.min_deposit_term) as min_deposit_term -- 起点存款期限
    ,nvl(n.merge_cycle_flag, o.merge_cycle_flag) as merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
    ,nvl(n.max_amt, o.max_amt) as max_amt -- 最大金额
    ,nvl(n.approval_no, o.approval_no) as approval_no -- 审批单号
    ,nvl(n.idep_agreement_flag, o.idep_agreement_flag) as idep_agreement_flag -- 智能存款签约标志
    ,nvl(n.int_float_point, o.int_float_point) as int_float_point -- 利息浮动点
    ,case when
            n.internal_key is null
            and n.approval_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.approval_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.approval_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_delay_pay_int_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_delay_pay_int where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.approval_no = n.approval_no
where (
        o.internal_key is null
        and o.approval_no is null
    )
    or (
        n.internal_key is null
        and n.approval_no is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.prod_type <> n.prod_type
        or o.acct_ccy <> n.acct_ccy
        or o.acct_seq_no <> n.acct_seq_no
        or o.spec_rate <> n.spec_rate
        or o.delay_pay_int_type <> n.delay_pay_int_type
        or o.spec_day <> n.spec_day
        or o.calc_days <> n.calc_days
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.client_no <> n.client_no
        or o.delay_pay_int_amt <> n.delay_pay_int_amt
        or o.delay_total_amt <> n.delay_total_amt
        or o.delay_int_amt_diff <> n.delay_int_amt_diff
        or o.next_cycle_date <> n.next_cycle_date
        or o.last_cycle_date <> n.last_cycle_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.past_interest <> n.past_interest
        or o.user_id <> n.user_id
        or o.tran_branch <> n.tran_branch
        or o.status <> n.status
        or o.pay_interest <> n.pay_interest
        or o.calc_delay_int_amt <> n.calc_delay_int_amt
        or o.acct_type <> n.acct_type
        or o.oth_internal_key <> n.oth_internal_key
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.oth_prod_type <> n.oth_prod_type
        or o.oth_acct_seq_no <> n.oth_acct_seq_no
        or o.oth_acct_ccy <> n.oth_acct_ccy
        or o.reference <> n.reference
        or o.min_deposit_amt <> n.min_deposit_amt
        or o.min_deposit_term <> n.min_deposit_term
        or o.merge_cycle_flag <> n.merge_cycle_flag
        or o.max_amt <> n.max_amt
        or o.idep_agreement_flag <> n.idep_agreement_flag
        or o.int_float_point <> n.int_float_point
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_delay_pay_int_cl(
            internal_key -- 账户内部键值
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,spec_rate -- 指定收益率
            ,delay_pay_int_type -- 延迟付息时间类型
            ,spec_day -- 指定日
            ,calc_days -- 算息天数
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,client_no -- 客户编号
            ,delay_pay_int_amt -- 延期付息利息
            ,delay_total_amt -- 延迟付息累计金额
            ,delay_int_amt_diff -- 延迟付息昨日今日值差额
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,past_interest -- 累计已付利息
            ,user_id -- 交易柜员编号
            ,tran_branch -- 核心交易机构编号
            ,status -- 状态
            ,pay_interest -- 应付利息
            ,calc_delay_int_amt -- 当日累计延期付息计算金额
            ,acct_type -- 账户类型
            ,oth_internal_key -- 对手账户内部键
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_prod_type -- 对方账户产品类型
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_acct_ccy -- 对方账户币种
            ,reference -- 交易参考号
            ,min_deposit_amt -- 起点存款金额
            ,min_deposit_term -- 起点存款期限
            ,merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
            ,max_amt -- 最大金额
            ,approval_no -- 审批单号
            ,idep_agreement_flag -- 智能存款签约标志
            ,int_float_point -- 利息浮动点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_delay_pay_int_op(
            internal_key -- 账户内部键值
            ,base_acct_no -- 交易账号/卡号
            ,prod_type -- 产品编号
            ,acct_ccy -- 账户币种
            ,acct_seq_no -- 账户子账号
            ,spec_rate -- 指定收益率
            ,delay_pay_int_type -- 延迟付息时间类型
            ,spec_day -- 指定日
            ,calc_days -- 算息天数
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,client_no -- 客户编号
            ,delay_pay_int_amt -- 延期付息利息
            ,delay_total_amt -- 延迟付息累计金额
            ,delay_int_amt_diff -- 延迟付息昨日今日值差额
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,past_interest -- 累计已付利息
            ,user_id -- 交易柜员编号
            ,tran_branch -- 核心交易机构编号
            ,status -- 状态
            ,pay_interest -- 应付利息
            ,calc_delay_int_amt -- 当日累计延期付息计算金额
            ,acct_type -- 账户类型
            ,oth_internal_key -- 对手账户内部键
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_prod_type -- 对方账户产品类型
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_acct_ccy -- 对方账户币种
            ,reference -- 交易参考号
            ,min_deposit_amt -- 起点存款金额
            ,min_deposit_term -- 起点存款期限
            ,merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
            ,max_amt -- 最大金额
            ,approval_no -- 审批单号
            ,idep_agreement_flag -- 智能存款签约标志
            ,int_float_point -- 利息浮动点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_key -- 账户内部键值
    ,o.base_acct_no -- 交易账号/卡号
    ,o.prod_type -- 产品编号
    ,o.acct_ccy -- 账户币种
    ,o.acct_seq_no -- 账户子账号
    ,o.spec_rate -- 指定收益率
    ,o.delay_pay_int_type -- 延迟付息时间类型
    ,o.spec_day -- 指定日
    ,o.calc_days -- 算息天数
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.client_no -- 客户编号
    ,o.delay_pay_int_amt -- 延期付息利息
    ,o.delay_total_amt -- 延迟付息累计金额
    ,o.delay_int_amt_diff -- 延迟付息昨日今日值差额
    ,o.next_cycle_date -- 下一结息日
    ,o.last_cycle_date -- 上一结息日
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.past_interest -- 累计已付利息
    ,o.user_id -- 交易柜员编号
    ,o.tran_branch -- 核心交易机构编号
    ,o.status -- 状态
    ,o.pay_interest -- 应付利息
    ,o.calc_delay_int_amt -- 当日累计延期付息计算金额
    ,o.acct_type -- 账户类型
    ,o.oth_internal_key -- 对手账户内部键
    ,o.oth_base_acct_no -- 对方账号/卡号
    ,o.oth_prod_type -- 对方账户产品类型
    ,o.oth_acct_seq_no -- 对方账户序列号
    ,o.oth_acct_ccy -- 对方账户币种
    ,o.reference -- 交易参考号
    ,o.min_deposit_amt -- 起点存款金额
    ,o.min_deposit_term -- 起点存款期限
    ,o.merge_cycle_flag -- 合并结息标识 Y-合并  N-不合并
    ,o.max_amt -- 最大金额
    ,o.approval_no -- 审批单号
    ,o.idep_agreement_flag -- 智能存款签约标志
    ,o.int_float_point -- 利息浮动点
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
from ${iol_schema}.ncbs_rb_delay_pay_int_bk o
    left join ${iol_schema}.ncbs_rb_delay_pay_int_op n
        on
            o.internal_key = n.internal_key
            and o.approval_no = n.approval_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_delay_pay_int_cl d
        on
            o.internal_key = d.internal_key
            and o.approval_no = d.approval_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_delay_pay_int;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_delay_pay_int') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_delay_pay_int drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_delay_pay_int add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_delay_pay_int exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_delay_pay_int_cl;
alter table ${iol_schema}.ncbs_rb_delay_pay_int exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_delay_pay_int_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_delay_pay_int to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_delay_pay_int_op purge;
drop table ${iol_schema}.ncbs_rb_delay_pay_int_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_delay_pay_int_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_delay_pay_int',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
