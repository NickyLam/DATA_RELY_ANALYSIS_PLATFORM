/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_rate_form_msg
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
create table ${iol_schema}.ncbs_rb_int_rate_form_msg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_int_rate_form_msg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg_op purge;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_rate_form_msg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_rate_form_msg where 0=1;

create table ${iol_schema}.ncbs_rb_int_rate_form_msg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_rate_form_msg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_rate_form_msg_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,diff_quote_rate -- 差异化利率
            ,keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_rate_form_msg_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,diff_quote_rate -- 差异化利率
            ,keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.valid_from_date, o.valid_from_date) as valid_from_date -- 有效期起始日期
    ,nvl(n.valid_thru_date, o.valid_thru_date) as valid_thru_date -- 有效期截止日期
    ,nvl(n.disc_base_rate, o.disc_base_rate) as disc_base_rate -- 基准利率1
    ,nvl(n.float_point, o.float_point) as float_point -- 浮动点差
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.int_rate_term, o.int_rate_term) as int_rate_term -- 利率协议期限
    ,nvl(n.add_agreement_flag, o.add_agreement_flag) as add_agreement_flag -- 新增协议标志
    ,nvl(n.pre_int_rate_form_no, o.pre_int_rate_form_no) as pre_int_rate_form_no -- 原审批单号
    ,nvl(n.auth_client_flag, o.auth_client_flag) as auth_client_flag -- 是否为我行授信客户
    ,nvl(n.pri_amt_limit, o.pri_amt_limit) as pri_amt_limit -- 申请本金金额上限
    ,nvl(n.int_valid_from_date, o.int_valid_from_date) as int_valid_from_date -- 利率优惠有效期起始日期
    ,nvl(n.int_valid_thru_date, o.int_valid_thru_date) as int_valid_thru_date -- 利率优惠有效期截止日期
    ,nvl(n.int_agreement_status, o.int_agreement_status) as int_agreement_status -- 利率协议状态
    ,nvl(n.int_rate_form_apply_type, o.int_rate_form_apply_type) as int_rate_form_apply_type -- 利率审批申请类别
    ,nvl(n.auth_client_payment, o.auth_client_payment) as auth_client_payment -- 授信客户的综合收益请款
    ,nvl(n.new_acct_no_flag, o.new_acct_no_flag) as new_acct_no_flag -- 是否为新账号
    ,nvl(n.rb_prod_term, o.rb_prod_term) as rb_prod_term -- 存款期限
    ,nvl(n.int_rate_rb_prod_type, o.int_rate_rb_prod_type) as int_rate_rb_prod_type -- 利率审批单存款品种
    ,nvl(n.int_rate_form_no, o.int_rate_form_no) as int_rate_form_no -- 利率审批单单号
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.diff_quote_rate, o.diff_quote_rate) as diff_quote_rate -- 差异化利率
    ,nvl(n.keep_min_bal, o.keep_min_bal) as keep_min_bal -- 最小留存金额
    ,case when
            n.base_acct_no is null
            and n.int_rate_form_no is null
            and n.acct_seq_no is null
            and n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_acct_no is null
            and n.int_rate_form_no is null
            and n.acct_seq_no is null
            and n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_acct_no is null
            and n.int_rate_form_no is null
            and n.acct_seq_no is null
            and n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_int_rate_form_msg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_int_rate_form_msg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_acct_no = n.base_acct_no
            and o.int_rate_form_no = n.int_rate_form_no
            and o.acct_seq_no = n.acct_seq_no
            and o.internal_key = n.internal_key
where (
        o.base_acct_no is null
        and o.int_rate_form_no is null
        and o.acct_seq_no is null
        and o.internal_key is null
    )
    or (
        n.base_acct_no is null
        and n.int_rate_form_no is null
        and n.acct_seq_no is null
        and n.internal_key is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.reason <> n.reason
        or o.company <> n.company
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.valid_from_date <> n.valid_from_date
        or o.valid_thru_date <> n.valid_thru_date
        or o.disc_base_rate <> n.disc_base_rate
        or o.float_point <> n.float_point
        or o.real_rate <> n.real_rate
        or o.int_rate_term <> n.int_rate_term
        or o.add_agreement_flag <> n.add_agreement_flag
        or o.pre_int_rate_form_no <> n.pre_int_rate_form_no
        or o.auth_client_flag <> n.auth_client_flag
        or o.pri_amt_limit <> n.pri_amt_limit
        or o.int_valid_from_date <> n.int_valid_from_date
        or o.int_valid_thru_date <> n.int_valid_thru_date
        or o.int_agreement_status <> n.int_agreement_status
        or o.int_rate_form_apply_type <> n.int_rate_form_apply_type
        or o.auth_client_payment <> n.auth_client_payment
        or o.new_acct_no_flag <> n.new_acct_no_flag
        or o.rb_prod_term <> n.rb_prod_term
        or o.int_rate_rb_prod_type <> n.int_rate_rb_prod_type
        or o.diff_quote_rate <> n.diff_quote_rate
        or o.keep_min_bal <> n.keep_min_bal
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_rate_form_msg_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,diff_quote_rate -- 差异化利率
            ,keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_rate_form_msg_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,reason -- 原因
            ,company -- 法人
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,valid_from_date -- 有效期起始日期
            ,valid_thru_date -- 有效期截止日期
            ,disc_base_rate -- 基准利率1
            ,float_point -- 浮动点差
            ,real_rate -- 执行利率
            ,int_rate_term -- 利率协议期限
            ,add_agreement_flag -- 新增协议标志
            ,pre_int_rate_form_no -- 原审批单号
            ,auth_client_flag -- 是否为我行授信客户
            ,pri_amt_limit -- 申请本金金额上限
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,int_agreement_status -- 利率协议状态
            ,int_rate_form_apply_type -- 利率审批申请类别
            ,auth_client_payment -- 授信客户的综合收益请款
            ,new_acct_no_flag -- 是否为新账号
            ,rb_prod_term -- 存款期限
            ,int_rate_rb_prod_type -- 利率审批单存款品种
            ,int_rate_form_no -- 利率审批单单号
            ,acct_seq_no -- 账户子账号
            ,internal_key -- 账户内部键值
            ,diff_quote_rate -- 差异化利率
            ,keep_min_bal -- 最小留存金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.reason -- 原因
    ,o.company -- 法人
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.valid_from_date -- 有效期起始日期
    ,o.valid_thru_date -- 有效期截止日期
    ,o.disc_base_rate -- 基准利率1
    ,o.float_point -- 浮动点差
    ,o.real_rate -- 执行利率
    ,o.int_rate_term -- 利率协议期限
    ,o.add_agreement_flag -- 新增协议标志
    ,o.pre_int_rate_form_no -- 原审批单号
    ,o.auth_client_flag -- 是否为我行授信客户
    ,o.pri_amt_limit -- 申请本金金额上限
    ,o.int_valid_from_date -- 利率优惠有效期起始日期
    ,o.int_valid_thru_date -- 利率优惠有效期截止日期
    ,o.int_agreement_status -- 利率协议状态
    ,o.int_rate_form_apply_type -- 利率审批申请类别
    ,o.auth_client_payment -- 授信客户的综合收益请款
    ,o.new_acct_no_flag -- 是否为新账号
    ,o.rb_prod_term -- 存款期限
    ,o.int_rate_rb_prod_type -- 利率审批单存款品种
    ,o.int_rate_form_no -- 利率审批单单号
    ,o.acct_seq_no -- 账户子账号
    ,o.internal_key -- 账户内部键值
    ,o.diff_quote_rate -- 差异化利率
    ,o.keep_min_bal -- 最小留存金额
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
from ${iol_schema}.ncbs_rb_int_rate_form_msg_bk o
    left join ${iol_schema}.ncbs_rb_int_rate_form_msg_op n
        on
            o.base_acct_no = n.base_acct_no
            and o.int_rate_form_no = n.int_rate_form_no
            and o.acct_seq_no = n.acct_seq_no
            and o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_int_rate_form_msg_cl d
        on
            o.base_acct_no = d.base_acct_no
            and o.int_rate_form_no = d.int_rate_form_no
            and o.acct_seq_no = d.acct_seq_no
            and o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_int_rate_form_msg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_int_rate_form_msg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_int_rate_form_msg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_int_rate_form_msg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_int_rate_form_msg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_int_rate_form_msg_cl;
alter table ${iol_schema}.ncbs_rb_int_rate_form_msg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_int_rate_form_msg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_int_rate_form_msg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg_op purge;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_int_rate_form_msg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
