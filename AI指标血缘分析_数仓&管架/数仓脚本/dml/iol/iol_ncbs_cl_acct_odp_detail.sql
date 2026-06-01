/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_odp_detail
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
create table ${iol_schema}.ncbs_cl_acct_odp_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_odp_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_odp_detail_op purge;
drop table ${iol_schema}.ncbs_cl_acct_odp_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_odp_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_odp_detail where 0=1;

create table ${iol_schema}.ncbs_cl_acct_odp_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_odp_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_odp_detail_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_odp_detail_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.int_accrued_diff, o.int_accrued_diff) as int_accrued_diff -- 计提金额差额
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.stage_no, o.stage_no) as stage_no -- 期次
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 税种
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.calc_begin_date, o.calc_begin_date) as calc_begin_date -- 利息计算起始日
    ,nvl(n.calc_end_date, o.calc_end_date) as calc_end_date -- 利息计算截止日
    ,nvl(n.last_accrual_date, o.last_accrual_date) as last_accrual_date -- 上一利息计提日
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_cycle_date, o.last_cycle_date) as last_cycle_date -- 上一结息日
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_accrued_calc_ctd, o.int_accrued_calc_ctd) as int_accrued_calc_ctd -- 计提日计提实际金额
    ,nvl(n.int_accrued_ctd, o.int_accrued_ctd) as int_accrued_ctd -- 计提日计提利息
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调增金额
    ,nvl(n.int_adj_ctd, o.int_adj_ctd) as int_adj_ctd -- 计提日利息调整
    ,nvl(n.int_adj_prev, o.int_adj_prev) as int_adj_prev -- 上日利息调整(累计)
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.int_posted, o.int_posted) as int_posted -- 结息金额
    ,nvl(n.int_posted_ctd, o.int_posted_ctd) as int_posted_ctd -- 结息日利息金额
    ,nvl(n.tax_posted, o.tax_posted) as tax_posted -- 利息税累计金额
    ,nvl(n.tax_posted_ctd, o.tax_posted_ctd) as tax_posted_ctd -- 结息日利息税
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.wrn_amt, o.wrn_amt) as wrn_amt -- 贷款核销本金
    ,nvl(n.int_accrued_prev, o.int_accrued_prev) as int_accrued_prev -- 上日累计计提利息|上日累计计提利息
    ,nvl(n.last_bal_upd_date, o.last_bal_upd_date) as last_bal_upd_date -- 上次动户日期
    ,nvl(n.last_int_accrued_prev, o.last_int_accrued_prev) as last_int_accrued_prev -- 上上日累计计提利息
    ,nvl(n.last_int_adj_prev, o.last_int_adj_prev) as last_int_adj_prev -- 上上日利息累计计提调整
    ,case when
            n.internal_key is null
            and n.stage_no is null
            and n.int_class is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.stage_no is null
            and n.int_class is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.stage_no is null
            and n.int_class is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_acct_odp_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_odp_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.stage_no = n.stage_no
            and o.int_class = n.int_class
where (
        o.internal_key is null
        and o.stage_no is null
        and o.int_class is null
    )
    or (
        n.internal_key is null
        and n.stage_no is null
        and n.int_class is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.int_accrued_diff <> n.int_accrued_diff
        or o.narrative <> n.narrative
        or o.tax_type <> n.tax_type
        or o.calc_begin_date <> n.calc_begin_date
        or o.calc_end_date <> n.calc_end_date
        or o.last_accrual_date <> n.last_accrual_date
        or o.last_change_date <> n.last_change_date
        or o.last_cycle_date <> n.last_cycle_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.int_accrued <> n.int_accrued
        or o.int_accrued_calc_ctd <> n.int_accrued_calc_ctd
        or o.int_accrued_ctd <> n.int_accrued_ctd
        or o.int_adj <> n.int_adj
        or o.int_adj_ctd <> n.int_adj_ctd
        or o.int_adj_prev <> n.int_adj_prev
        or o.int_amt <> n.int_amt
        or o.int_posted <> n.int_posted
        or o.int_posted_ctd <> n.int_posted_ctd
        or o.tax_posted <> n.tax_posted
        or o.tax_posted_ctd <> n.tax_posted_ctd
        or o.tax_rate <> n.tax_rate
        or o.wrn_amt <> n.wrn_amt
        or o.int_accrued_prev <> n.int_accrued_prev
        or o.last_bal_upd_date <> n.last_bal_upd_date
        or o.last_int_accrued_prev <> n.last_int_accrued_prev
        or o.last_int_adj_prev <> n.last_int_adj_prev
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_odp_detail_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_odp_detail_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,int_accrued_diff -- 计提金额差额
            ,narrative -- 摘要
            ,stage_no -- 期次
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_accrual_date -- 上一利息计提日
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,next_cycle_date -- 下一结息日
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,wrn_amt -- 贷款核销本金
            ,int_accrued_prev -- 上日累计计提利息|上日累计计提利息
            ,last_bal_upd_date -- 上次动户日期
            ,last_int_accrued_prev -- 上上日累计计提利息
            ,last_int_adj_prev -- 上上日利息累计计提调整
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.int_accrued_diff -- 计提金额差额
    ,o.narrative -- 摘要
    ,o.stage_no -- 期次
    ,o.tax_type -- 税种
    ,o.int_class -- 利息分类
    ,o.calc_begin_date -- 利息计算起始日
    ,o.calc_end_date -- 利息计算截止日
    ,o.last_accrual_date -- 上一利息计提日
    ,o.last_change_date -- 最后修改日期
    ,o.last_cycle_date -- 上一结息日
    ,o.next_cycle_date -- 下一结息日
    ,o.tran_timestamp -- 交易时间戳
    ,o.int_accrued -- 累计计提
    ,o.int_accrued_calc_ctd -- 计提日计提实际金额
    ,o.int_accrued_ctd -- 计提日计提利息
    ,o.int_adj -- 利息调增金额
    ,o.int_adj_ctd -- 计提日利息调整
    ,o.int_adj_prev -- 上日利息调整(累计)
    ,o.int_amt -- 利息金额
    ,o.int_posted -- 结息金额
    ,o.int_posted_ctd -- 结息日利息金额
    ,o.tax_posted -- 利息税累计金额
    ,o.tax_posted_ctd -- 结息日利息税
    ,o.tax_rate -- 税率
    ,o.wrn_amt -- 贷款核销本金
    ,o.int_accrued_prev -- 上日累计计提利息|上日累计计提利息
    ,o.last_bal_upd_date -- 上次动户日期
    ,o.last_int_accrued_prev -- 上上日累计计提利息
    ,o.last_int_adj_prev -- 上上日利息累计计提调整
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
from ${iol_schema}.ncbs_cl_acct_odp_detail_bk o
    left join ${iol_schema}.ncbs_cl_acct_odp_detail_op n
        on
            o.internal_key = n.internal_key
            and o.stage_no = n.stage_no
            and o.int_class = n.int_class
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_odp_detail_cl d
        on
            o.internal_key = d.internal_key
            and o.stage_no = d.stage_no
            and o.int_class = d.int_class
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_odp_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_odp_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_odp_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_odp_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_odp_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_odp_detail_cl;
alter table ${iol_schema}.ncbs_cl_acct_odp_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_odp_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_odp_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_odp_detail_op purge;
drop table ${iol_schema}.ncbs_cl_acct_odp_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_odp_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_odp_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
