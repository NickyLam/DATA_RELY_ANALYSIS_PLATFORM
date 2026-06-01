/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_reserve_info
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
create table ${iol_schema}.ncbs_rb_batch_reserve_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_reserve_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info_op purge;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_reserve_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_reserve_info where 0=1;

create table ${iol_schema}.ncbs_rb_batch_reserve_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_reserve_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_reserve_info_cl(
            reference -- 交易参考号
            ,close_acct_flag -- 是否可销户
            ,advanced_amt -- 保函垫款金额
            ,new_settle_base_acct_no -- 新利息入账账号
            ,register_date -- 登记日期
            ,ext_trade_no -- 原业务编号
            ,advanced_next_cycle_date -- 垫款下一结息日
            ,advanced_branch -- 垫款发放机构
            ,advanced_int_day -- 垫款结息日
            ,advanced_cycle_freq -- 垫款结息频率
            ,ext_ref_no -- 来单编号
            ,advanced_real_rate -- 垫款执行利率
            ,reserve_amt -- 核心备款金额
            ,trade_type -- 业务类型
            ,reserve_date -- 备款日期
            ,advanced_sched_mode -- 垫款还款方式
            ,from_channel -- 记录来源
            ,reserve_status -- 备款状态
            ,advanced_cmisloan_no -- 垫款借据号
            ,error_desc -- 错误描述
            ,corp_size -- 企业规模
            ,econ_department_type -- 国民经济部门类型
            ,deal_date -- 处理日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_reserve_info_op(
            reference -- 交易参考号
            ,close_acct_flag -- 是否可销户
            ,advanced_amt -- 保函垫款金额
            ,new_settle_base_acct_no -- 新利息入账账号
            ,register_date -- 登记日期
            ,ext_trade_no -- 原业务编号
            ,advanced_next_cycle_date -- 垫款下一结息日
            ,advanced_branch -- 垫款发放机构
            ,advanced_int_day -- 垫款结息日
            ,advanced_cycle_freq -- 垫款结息频率
            ,ext_ref_no -- 来单编号
            ,advanced_real_rate -- 垫款执行利率
            ,reserve_amt -- 核心备款金额
            ,trade_type -- 业务类型
            ,reserve_date -- 备款日期
            ,advanced_sched_mode -- 垫款还款方式
            ,from_channel -- 记录来源
            ,reserve_status -- 备款状态
            ,advanced_cmisloan_no -- 垫款借据号
            ,error_desc -- 错误描述
            ,corp_size -- 企业规模
            ,econ_department_type -- 国民经济部门类型
            ,deal_date -- 处理日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.close_acct_flag, o.close_acct_flag) as close_acct_flag -- 是否可销户
    ,nvl(n.advanced_amt, o.advanced_amt) as advanced_amt -- 保函垫款金额
    ,nvl(n.new_settle_base_acct_no, o.new_settle_base_acct_no) as new_settle_base_acct_no -- 新利息入账账号
    ,nvl(n.register_date, o.register_date) as register_date -- 登记日期
    ,nvl(n.ext_trade_no, o.ext_trade_no) as ext_trade_no -- 原业务编号
    ,nvl(n.advanced_next_cycle_date, o.advanced_next_cycle_date) as advanced_next_cycle_date -- 垫款下一结息日
    ,nvl(n.advanced_branch, o.advanced_branch) as advanced_branch -- 垫款发放机构
    ,nvl(n.advanced_int_day, o.advanced_int_day) as advanced_int_day -- 垫款结息日
    ,nvl(n.advanced_cycle_freq, o.advanced_cycle_freq) as advanced_cycle_freq -- 垫款结息频率
    ,nvl(n.ext_ref_no, o.ext_ref_no) as ext_ref_no -- 来单编号
    ,nvl(n.advanced_real_rate, o.advanced_real_rate) as advanced_real_rate -- 垫款执行利率
    ,nvl(n.reserve_amt, o.reserve_amt) as reserve_amt -- 核心备款金额
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 业务类型
    ,nvl(n.reserve_date, o.reserve_date) as reserve_date -- 备款日期
    ,nvl(n.advanced_sched_mode, o.advanced_sched_mode) as advanced_sched_mode -- 垫款还款方式
    ,nvl(n.from_channel, o.from_channel) as from_channel -- 记录来源
    ,nvl(n.reserve_status, o.reserve_status) as reserve_status -- 备款状态
    ,nvl(n.advanced_cmisloan_no, o.advanced_cmisloan_no) as advanced_cmisloan_no -- 垫款借据号
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.corp_size, o.corp_size) as corp_size -- 企业规模
    ,nvl(n.econ_department_type, o.econ_department_type) as econ_department_type -- 国民经济部门类型
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 处理日期
    ,case when
            n.ext_ref_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ext_ref_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ext_ref_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_batch_reserve_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_reserve_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ext_ref_no = n.ext_ref_no
where (
        o.ext_ref_no is null
    )
    or (
        n.ext_ref_no is null
    )
    or (
        o.reference <> n.reference
        or o.close_acct_flag <> n.close_acct_flag
        or o.advanced_amt <> n.advanced_amt
        or o.new_settle_base_acct_no <> n.new_settle_base_acct_no
        or o.register_date <> n.register_date
        or o.ext_trade_no <> n.ext_trade_no
        or o.advanced_next_cycle_date <> n.advanced_next_cycle_date
        or o.advanced_branch <> n.advanced_branch
        or o.advanced_int_day <> n.advanced_int_day
        or o.advanced_cycle_freq <> n.advanced_cycle_freq
        or o.advanced_real_rate <> n.advanced_real_rate
        or o.reserve_amt <> n.reserve_amt
        or o.trade_type <> n.trade_type
        or o.reserve_date <> n.reserve_date
        or o.advanced_sched_mode <> n.advanced_sched_mode
        or o.from_channel <> n.from_channel
        or o.reserve_status <> n.reserve_status
        or o.advanced_cmisloan_no <> n.advanced_cmisloan_no
        or o.error_desc <> n.error_desc
        or o.corp_size <> n.corp_size
        or o.econ_department_type <> n.econ_department_type
        or o.deal_date <> n.deal_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_reserve_info_cl(
            reference -- 交易参考号
            ,close_acct_flag -- 是否可销户
            ,advanced_amt -- 保函垫款金额
            ,new_settle_base_acct_no -- 新利息入账账号
            ,register_date -- 登记日期
            ,ext_trade_no -- 原业务编号
            ,advanced_next_cycle_date -- 垫款下一结息日
            ,advanced_branch -- 垫款发放机构
            ,advanced_int_day -- 垫款结息日
            ,advanced_cycle_freq -- 垫款结息频率
            ,ext_ref_no -- 来单编号
            ,advanced_real_rate -- 垫款执行利率
            ,reserve_amt -- 核心备款金额
            ,trade_type -- 业务类型
            ,reserve_date -- 备款日期
            ,advanced_sched_mode -- 垫款还款方式
            ,from_channel -- 记录来源
            ,reserve_status -- 备款状态
            ,advanced_cmisloan_no -- 垫款借据号
            ,error_desc -- 错误描述
            ,corp_size -- 企业规模
            ,econ_department_type -- 国民经济部门类型
            ,deal_date -- 处理日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_reserve_info_op(
            reference -- 交易参考号
            ,close_acct_flag -- 是否可销户
            ,advanced_amt -- 保函垫款金额
            ,new_settle_base_acct_no -- 新利息入账账号
            ,register_date -- 登记日期
            ,ext_trade_no -- 原业务编号
            ,advanced_next_cycle_date -- 垫款下一结息日
            ,advanced_branch -- 垫款发放机构
            ,advanced_int_day -- 垫款结息日
            ,advanced_cycle_freq -- 垫款结息频率
            ,ext_ref_no -- 来单编号
            ,advanced_real_rate -- 垫款执行利率
            ,reserve_amt -- 核心备款金额
            ,trade_type -- 业务类型
            ,reserve_date -- 备款日期
            ,advanced_sched_mode -- 垫款还款方式
            ,from_channel -- 记录来源
            ,reserve_status -- 备款状态
            ,advanced_cmisloan_no -- 垫款借据号
            ,error_desc -- 错误描述
            ,corp_size -- 企业规模
            ,econ_department_type -- 国民经济部门类型
            ,deal_date -- 处理日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reference -- 交易参考号
    ,o.close_acct_flag -- 是否可销户
    ,o.advanced_amt -- 保函垫款金额
    ,o.new_settle_base_acct_no -- 新利息入账账号
    ,o.register_date -- 登记日期
    ,o.ext_trade_no -- 原业务编号
    ,o.advanced_next_cycle_date -- 垫款下一结息日
    ,o.advanced_branch -- 垫款发放机构
    ,o.advanced_int_day -- 垫款结息日
    ,o.advanced_cycle_freq -- 垫款结息频率
    ,o.ext_ref_no -- 来单编号
    ,o.advanced_real_rate -- 垫款执行利率
    ,o.reserve_amt -- 核心备款金额
    ,o.trade_type -- 业务类型
    ,o.reserve_date -- 备款日期
    ,o.advanced_sched_mode -- 垫款还款方式
    ,o.from_channel -- 记录来源
    ,o.reserve_status -- 备款状态
    ,o.advanced_cmisloan_no -- 垫款借据号
    ,o.error_desc -- 错误描述
    ,o.corp_size -- 企业规模
    ,o.econ_department_type -- 国民经济部门类型
    ,o.deal_date -- 处理日期
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
from ${iol_schema}.ncbs_rb_batch_reserve_info_bk o
    left join ${iol_schema}.ncbs_rb_batch_reserve_info_op n
        on
            o.ext_ref_no = n.ext_ref_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_reserve_info_cl d
        on
            o.ext_ref_no = d.ext_ref_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_batch_reserve_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_reserve_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_reserve_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_reserve_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_reserve_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_reserve_info_cl;
alter table ${iol_schema}.ncbs_rb_batch_reserve_info exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_reserve_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_reserve_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info_op purge;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_reserve_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
