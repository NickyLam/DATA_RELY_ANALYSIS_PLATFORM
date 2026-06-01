/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pcp_inner_price
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
create table ${iol_schema}.ncbs_rb_pcp_inner_price_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pcp_inner_price
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_inner_price_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_inner_price where 0=1;

create table ${iol_schema}.ncbs_rb_pcp_inner_price_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_inner_price where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_inner_price_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,day_expense_diff -- 当日应付差额
            ,day_income_diff -- 当日应收差额
            ,int_calc_bal -- 计息方式
            ,pcp_group_id -- 资金池账户组id
            ,transfer_cnt -- 周期内已划拨次数
            ,last_price_date -- 上一计价日
            ,next_price_date -- 下一计价日
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,day_int_expense -- 当日应付利息
            ,day_int_income -- 当日应收利息
            ,dr_rate -- 借方利率
            ,now_balance_agg -- 当前余额积数
            ,now_down_agg -- 当前下拨积数
            ,now_up_agg -- 当前归集积数
            ,period_int_expense -- 当期累计利息支出
            ,period_int_income -- 当期累计利息收入
            ,total_arre_expense -- 欠付
            ,total_arre_income -- 欠收
            ,total_int_expense -- 累计利息支出
            ,total_int_income -- 累计利息收入
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_inner_price_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,day_expense_diff -- 当日应付差额
            ,day_income_diff -- 当日应收差额
            ,int_calc_bal -- 计息方式
            ,pcp_group_id -- 资金池账户组id
            ,transfer_cnt -- 周期内已划拨次数
            ,last_price_date -- 上一计价日
            ,next_price_date -- 下一计价日
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,day_int_expense -- 当日应付利息
            ,day_int_income -- 当日应收利息
            ,dr_rate -- 借方利率
            ,now_balance_agg -- 当前余额积数
            ,now_down_agg -- 当前下拨积数
            ,now_up_agg -- 当前归集积数
            ,period_int_expense -- 当期累计利息支出
            ,period_int_income -- 当期累计利息收入
            ,total_arre_expense -- 欠付
            ,total_arre_income -- 欠收
            ,total_int_expense -- 累计利息支出
            ,total_int_income -- 累计利息收入
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.day_expense_diff, o.day_expense_diff) as day_expense_diff -- 当日应付差额
    ,nvl(n.day_income_diff, o.day_income_diff) as day_income_diff -- 当日应收差额
    ,nvl(n.int_calc_bal, o.int_calc_bal) as int_calc_bal -- 计息方式
    ,nvl(n.pcp_group_id, o.pcp_group_id) as pcp_group_id -- 资金池账户组id
    ,nvl(n.transfer_cnt, o.transfer_cnt) as transfer_cnt -- 周期内已划拨次数
    ,nvl(n.last_price_date, o.last_price_date) as last_price_date -- 上一计价日
    ,nvl(n.next_price_date, o.next_price_date) as next_price_date -- 下一计价日
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.cr_rate, o.cr_rate) as cr_rate -- 贷方利率
    ,nvl(n.day_int_expense, o.day_int_expense) as day_int_expense -- 当日应付利息
    ,nvl(n.day_int_income, o.day_int_income) as day_int_income -- 当日应收利息
    ,nvl(n.dr_rate, o.dr_rate) as dr_rate -- 借方利率
    ,nvl(n.now_balance_agg, o.now_balance_agg) as now_balance_agg -- 当前余额积数
    ,nvl(n.now_down_agg, o.now_down_agg) as now_down_agg -- 当前下拨积数
    ,nvl(n.now_up_agg, o.now_up_agg) as now_up_agg -- 当前归集积数
    ,nvl(n.period_int_expense, o.period_int_expense) as period_int_expense -- 当期累计利息支出
    ,nvl(n.period_int_income, o.period_int_income) as period_int_income -- 当期累计利息收入
    ,nvl(n.total_arre_expense, o.total_arre_expense) as total_arre_expense -- 欠付
    ,nvl(n.total_arre_income, o.total_arre_income) as total_arre_income -- 欠收
    ,nvl(n.total_int_expense, o.total_int_expense) as total_int_expense -- 累计利息支出
    ,nvl(n.total_int_income, o.total_int_income) as total_int_income -- 累计利息收入
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.pcp_group_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.pcp_group_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.pcp_group_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pcp_inner_price_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pcp_inner_price where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.pcp_group_id = n.pcp_group_id
where (
        o.client_no is null
        and o.internal_key is null
        and o.pcp_group_id is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
        and n.pcp_group_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.day_expense_diff <> n.day_expense_diff
        or o.day_income_diff <> n.day_income_diff
        or o.int_calc_bal <> n.int_calc_bal
        or o.transfer_cnt <> n.transfer_cnt
        or o.last_price_date <> n.last_price_date
        or o.next_price_date <> n.next_price_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.cr_rate <> n.cr_rate
        or o.day_int_expense <> n.day_int_expense
        or o.day_int_income <> n.day_int_income
        or o.dr_rate <> n.dr_rate
        or o.now_balance_agg <> n.now_balance_agg
        or o.now_down_agg <> n.now_down_agg
        or o.now_up_agg <> n.now_up_agg
        or o.period_int_expense <> n.period_int_expense
        or o.period_int_income <> n.period_int_income
        or o.total_arre_expense <> n.total_arre_expense
        or o.total_arre_income <> n.total_arre_income
        or o.total_int_expense <> n.total_int_expense
        or o.total_int_income <> n.total_int_income
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_inner_price_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,day_expense_diff -- 当日应付差额
            ,day_income_diff -- 当日应收差额
            ,int_calc_bal -- 计息方式
            ,pcp_group_id -- 资金池账户组id
            ,transfer_cnt -- 周期内已划拨次数
            ,last_price_date -- 上一计价日
            ,next_price_date -- 下一计价日
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,day_int_expense -- 当日应付利息
            ,day_int_income -- 当日应收利息
            ,dr_rate -- 借方利率
            ,now_balance_agg -- 当前余额积数
            ,now_down_agg -- 当前下拨积数
            ,now_up_agg -- 当前归集积数
            ,period_int_expense -- 当期累计利息支出
            ,period_int_income -- 当期累计利息收入
            ,total_arre_expense -- 欠付
            ,total_arre_income -- 欠收
            ,total_int_expense -- 累计利息支出
            ,total_int_income -- 累计利息收入
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_inner_price_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,day_expense_diff -- 当日应付差额
            ,day_income_diff -- 当日应收差额
            ,int_calc_bal -- 计息方式
            ,pcp_group_id -- 资金池账户组id
            ,transfer_cnt -- 周期内已划拨次数
            ,last_price_date -- 上一计价日
            ,next_price_date -- 下一计价日
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,day_int_expense -- 当日应付利息
            ,day_int_income -- 当日应收利息
            ,dr_rate -- 借方利率
            ,now_balance_agg -- 当前余额积数
            ,now_down_agg -- 当前下拨积数
            ,now_up_agg -- 当前归集积数
            ,period_int_expense -- 当期累计利息支出
            ,period_int_income -- 当期累计利息收入
            ,total_arre_expense -- 欠付
            ,total_arre_income -- 欠收
            ,total_int_expense -- 累计利息支出
            ,total_int_income -- 累计利息收入
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.day_expense_diff -- 当日应付差额
    ,o.day_income_diff -- 当日应收差额
    ,o.int_calc_bal -- 计息方式
    ,o.pcp_group_id -- 资金池账户组id
    ,o.transfer_cnt -- 周期内已划拨次数
    ,o.last_price_date -- 上一计价日
    ,o.next_price_date -- 下一计价日
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.cr_rate -- 贷方利率
    ,o.day_int_expense -- 当日应付利息
    ,o.day_int_income -- 当日应收利息
    ,o.dr_rate -- 借方利率
    ,o.now_balance_agg -- 当前余额积数
    ,o.now_down_agg -- 当前下拨积数
    ,o.now_up_agg -- 当前归集积数
    ,o.period_int_expense -- 当期累计利息支出
    ,o.period_int_income -- 当期累计利息收入
    ,o.total_arre_expense -- 欠付
    ,o.total_arre_income -- 欠收
    ,o.total_int_expense -- 累计利息支出
    ,o.total_int_income -- 累计利息收入
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
from ${iol_schema}.ncbs_rb_pcp_inner_price_bk o
    left join ${iol_schema}.ncbs_rb_pcp_inner_price_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.pcp_group_id = n.pcp_group_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pcp_inner_price_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
            and o.pcp_group_id = d.pcp_group_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pcp_inner_price;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pcp_inner_price') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pcp_inner_price drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pcp_inner_price add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pcp_inner_price exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pcp_inner_price_cl;
alter table ${iol_schema}.ncbs_rb_pcp_inner_price exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pcp_inner_price_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pcp_inner_price to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pcp_inner_price',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
