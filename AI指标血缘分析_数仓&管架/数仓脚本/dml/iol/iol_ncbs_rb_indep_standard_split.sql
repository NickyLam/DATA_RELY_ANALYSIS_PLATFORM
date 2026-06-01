/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_indep_standard_split
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
create table ${iol_schema}.ncbs_rb_indep_standard_split_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_indep_standard_split
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_indep_standard_split_op purge;
drop table ${iol_schema}.ncbs_rb_indep_standard_split_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_indep_standard_split_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_indep_standard_split where 0=1;

create table ${iol_schema}.ncbs_rb_indep_standard_split_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_indep_standard_split where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_indep_standard_split_cl(
            agg -- 积数
            ,client_no -- 客户编号
            ,days -- 天数
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,retry_flag -- 是否重算
            ,int_class -- 利息分类
            ,accr_date -- 计提日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,real_rate -- 执行利率
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_indep_standard_split_op(
            agg -- 积数
            ,client_no -- 客户编号
            ,days -- 天数
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,retry_flag -- 是否重算
            ,int_class -- 利息分类
            ,accr_date -- 计提日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,real_rate -- 执行利率
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agg, o.agg) as agg -- 积数
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.days, o.days) as days -- 天数
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.retry_flag, o.retry_flag) as retry_flag -- 是否重算
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.accr_date, o.accr_date) as accr_date -- 计提日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_accrued_ctd, o.int_accrued_ctd) as int_accrued_ctd -- 计提日计提利息
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调增金额
    ,nvl(n.int_adj_ctd, o.int_adj_ctd) as int_adj_ctd -- 计提日利息调整
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.agreement_id is null
            and n.int_class is null
            and n.start_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
            and n.int_class is null
            and n.start_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
            and n.int_class is null
            and n.start_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_indep_standard_split_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_indep_standard_split where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
            and o.int_class = n.int_class
            and o.start_date = n.start_date
where (
        o.agreement_id is null
        and o.int_class is null
        and o.start_date is null
    )
    or (
        n.agreement_id is null
        and n.int_class is null
        and n.start_date is null
    )
    or (
        o.agg <> n.agg
        or o.client_no <> n.client_no
        or o.days <> n.days
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.retry_flag <> n.retry_flag
        or o.accr_date <> n.accr_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.int_accrued <> n.int_accrued
        or o.int_accrued_ctd <> n.int_accrued_ctd
        or o.int_adj <> n.int_adj
        or o.int_adj_ctd <> n.int_adj_ctd
        or o.real_rate <> n.real_rate
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_indep_standard_split_cl(
            agg -- 积数
            ,client_no -- 客户编号
            ,days -- 天数
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,retry_flag -- 是否重算
            ,int_class -- 利息分类
            ,accr_date -- 计提日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,real_rate -- 执行利率
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_indep_standard_split_op(
            agg -- 积数
            ,client_no -- 客户编号
            ,days -- 天数
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,retry_flag -- 是否重算
            ,int_class -- 利息分类
            ,accr_date -- 计提日期
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,int_accrued -- 累计计提
            ,int_accrued_ctd -- 计提日计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,real_rate -- 执行利率
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agg -- 积数
    ,o.client_no -- 客户编号
    ,o.days -- 天数
    ,o.user_id -- 交易柜员编号
    ,o.agreement_id -- 协议编号
    ,o.company -- 法人
    ,o.retry_flag -- 是否重算
    ,o.int_class -- 利息分类
    ,o.accr_date -- 计提日期
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.int_accrued -- 累计计提
    ,o.int_accrued_ctd -- 计提日计提利息
    ,o.int_adj -- 利息调增金额
    ,o.int_adj_ctd -- 计提日利息调整
    ,o.real_rate -- 执行利率
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
from ${iol_schema}.ncbs_rb_indep_standard_split_bk o
    left join ${iol_schema}.ncbs_rb_indep_standard_split_op n
        on
            o.agreement_id = n.agreement_id
            and o.int_class = n.int_class
            and o.start_date = n.start_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_indep_standard_split_cl d
        on
            o.agreement_id = d.agreement_id
            and o.int_class = d.int_class
            and o.start_date = d.start_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_indep_standard_split;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_indep_standard_split') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_indep_standard_split drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_indep_standard_split add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_indep_standard_split exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_indep_standard_split_cl;
alter table ${iol_schema}.ncbs_rb_indep_standard_split exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_indep_standard_split_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_indep_standard_split to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_indep_standard_split_op purge;
drop table ${iol_schema}.ncbs_rb_indep_standard_split_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_indep_standard_split_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_indep_standard_split',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
