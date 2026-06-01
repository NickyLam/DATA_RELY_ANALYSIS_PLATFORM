/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_accr_adj_hist
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
create table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_accr_adj_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op purge;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_accr_adj_hist where 0=1;

create table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_accr_adj_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl(
            branch -- 机构编号
            ,business_unit -- 账套
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,adj_counter -- 计提调整次数
            ,adj_seq_no -- 计提调整序号
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,tran_source -- 交易发起方
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,adjust_date -- 调整日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,adj_reason -- 计提调整原因
            ,int_adj_ctd -- 计提日利息调整
            ,accr_adj_type -- 计提调整类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op(
            branch -- 机构编号
            ,business_unit -- 账套
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,adj_counter -- 计提调整次数
            ,adj_seq_no -- 计提调整序号
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,tran_source -- 交易发起方
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,adjust_date -- 调整日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,adj_reason -- 计提调整原因
            ,int_adj_ctd -- 计提日利息调整
            ,accr_adj_type -- 计提调整类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.business_unit, o.business_unit) as business_unit -- 账套
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.adj_counter, o.adj_counter) as adj_counter -- 计提调整次数
    ,nvl(n.adj_seq_no, o.adj_seq_no) as adj_seq_no -- 计提调整序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.gl_posted_flag, o.gl_posted_flag) as gl_posted_flag -- 过账标记
    ,nvl(n.reversal, o.reversal) as reversal -- 是否冲正标志
    ,nvl(n.tran_source, o.tran_source) as tran_source -- 交易发起方
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.adjust_date, o.adjust_date) as adjust_date -- 调整日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.adj_reason, o.adj_reason) as adj_reason -- 计提调整原因
    ,nvl(n.int_adj_ctd, o.int_adj_ctd) as int_adj_ctd -- 计提日利息调整
    ,nvl(n.accr_adj_type, o.accr_adj_type) as accr_adj_type -- 计提调整类型
    ,case when
            n.adj_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.adj_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.adj_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_acct_accr_adj_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_accr_adj_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.adj_seq_no = n.adj_seq_no
where (
        o.adj_seq_no is null
    )
    or (
        n.adj_seq_no is null
    )
    or (
        o.branch <> n.branch
        or o.business_unit <> n.business_unit
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.profit_center <> n.profit_center
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.adj_counter <> n.adj_counter
        or o.company <> n.company
        or o.gl_posted_flag <> n.gl_posted_flag
        or o.reversal <> n.reversal
        or o.tran_source <> n.tran_source
        or o.int_class <> n.int_class
        or o.accounting_status <> n.accounting_status
        or o.adjust_date <> n.adjust_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.adj_reason <> n.adj_reason
        or o.int_adj_ctd <> n.int_adj_ctd
        or o.accr_adj_type <> n.accr_adj_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl(
            branch -- 机构编号
            ,business_unit -- 账套
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,adj_counter -- 计提调整次数
            ,adj_seq_no -- 计提调整序号
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,tran_source -- 交易发起方
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,adjust_date -- 调整日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,adj_reason -- 计提调整原因
            ,int_adj_ctd -- 计提日利息调整
            ,accr_adj_type -- 计提调整类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op(
            branch -- 机构编号
            ,business_unit -- 账套
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,adj_counter -- 计提调整次数
            ,adj_seq_no -- 计提调整序号
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,tran_source -- 交易发起方
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,adjust_date -- 调整日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,adj_reason -- 计提调整原因
            ,int_adj_ctd -- 计提日利息调整
            ,accr_adj_type -- 计提调整类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.business_unit -- 账套
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.profit_center -- 利润中心
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.adj_counter -- 计提调整次数
    ,o.adj_seq_no -- 计提调整序号
    ,o.company -- 法人
    ,o.gl_posted_flag -- 过账标记
    ,o.reversal -- 是否冲正标志
    ,o.tran_source -- 交易发起方
    ,o.int_class -- 利息分类
    ,o.accounting_status -- 核算状态
    ,o.adjust_date -- 调整日期
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.adj_reason -- 计提调整原因
    ,o.int_adj_ctd -- 计提日利息调整
    ,o.accr_adj_type -- 计提调整类型
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
from ${iol_schema}.ncbs_cl_acct_accr_adj_hist_bk o
    left join ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op n
        on
            o.adj_seq_no = n.adj_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl d
        on
            o.adj_seq_no = d.adj_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_accr_adj_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_accr_adj_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_accr_adj_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_accr_adj_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_accr_adj_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl;
alter table ${iol_schema}.ncbs_cl_acct_accr_adj_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_accr_adj_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_op purge;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_accr_adj_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_accr_adj_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
