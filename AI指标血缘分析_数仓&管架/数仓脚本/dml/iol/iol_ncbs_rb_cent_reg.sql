/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_cent_reg
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
create table ${iol_schema}.ncbs_rb_cent_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_cent_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_cent_reg_op purge;
drop table ${iol_schema}.ncbs_rb_cent_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cent_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_cent_reg where 0=1;

create table ${iol_schema}.ncbs_rb_cent_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_cent_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_cent_reg_cl(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,orig_channel_seq_no -- 原渠道流水号
            ,orig_sub_seq_no -- 原渠道子流水号
            ,close_acct_ind -- 销户标志
            ,cent_deal_type -- 分位处理方式
            ,cent_amt -- 分位金额
            ,ccy -- 币种
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_date -- 交易日期
            ,status -- 状态
            ,tran_type -- 交易类型
            ,event_type -- 事件类型
            ,reversal_flag -- 交易是否已冲正
            ,reversal_seq_no -- 冲正序号
            ,reversal_tran_type -- 冲正交易类型
            ,reversal_tran_date -- 冲正交易日期
            ,reversal_user_id -- 冲正柜员
            ,wipe_account -- 冲正和抹账标识
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,reversal_reason -- 冲正原因
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,orig_tran_amt -- 原交易金额
            ,orig_tran_date -- 原交易时间
            ,main_source_module -- 主模块
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_cent_reg_op(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,orig_channel_seq_no -- 原渠道流水号
            ,orig_sub_seq_no -- 原渠道子流水号
            ,close_acct_ind -- 销户标志
            ,cent_deal_type -- 分位处理方式
            ,cent_amt -- 分位金额
            ,ccy -- 币种
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_date -- 交易日期
            ,status -- 状态
            ,tran_type -- 交易类型
            ,event_type -- 事件类型
            ,reversal_flag -- 交易是否已冲正
            ,reversal_seq_no -- 冲正序号
            ,reversal_tran_type -- 冲正交易类型
            ,reversal_tran_date -- 冲正交易日期
            ,reversal_user_id -- 冲正柜员
            ,wipe_account -- 冲正和抹账标识
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,reversal_reason -- 冲正原因
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,orig_tran_amt -- 原交易金额
            ,orig_tran_date -- 原交易时间
            ,main_source_module -- 主模块
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统子流水号
    ,nvl(n.orig_channel_seq_no, o.orig_channel_seq_no) as orig_channel_seq_no -- 原渠道流水号
    ,nvl(n.orig_sub_seq_no, o.orig_sub_seq_no) as orig_sub_seq_no -- 原渠道子流水号
    ,nvl(n.close_acct_ind, o.close_acct_ind) as close_acct_ind -- 销户标志
    ,nvl(n.cent_deal_type, o.cent_deal_type) as cent_deal_type -- 分位处理方式
    ,nvl(n.cent_amt, o.cent_amt) as cent_amt -- 分位金额
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.reversal_flag, o.reversal_flag) as reversal_flag -- 交易是否已冲正
    ,nvl(n.reversal_seq_no, o.reversal_seq_no) as reversal_seq_no -- 冲正序号
    ,nvl(n.reversal_tran_type, o.reversal_tran_type) as reversal_tran_type -- 冲正交易类型
    ,nvl(n.reversal_tran_date, o.reversal_tran_date) as reversal_tran_date -- 冲正交易日期
    ,nvl(n.reversal_user_id, o.reversal_user_id) as reversal_user_id -- 冲正柜员
    ,nvl(n.wipe_account, o.wipe_account) as wipe_account -- 冲正和抹账标识
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.reversal_reason, o.reversal_reason) as reversal_reason -- 冲正原因
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.orig_tran_amt, o.orig_tran_amt) as orig_tran_amt -- 原交易金额
    ,nvl(n.orig_tran_date, o.orig_tran_date) as orig_tran_date -- 原交易时间
    ,nvl(n.main_source_module, o.main_source_module) as main_source_module -- 主模块
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_cent_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_cent_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.reference <> n.reference
        or o.channel_seq_no <> n.channel_seq_no
        or o.sub_seq_no <> n.sub_seq_no
        or o.orig_channel_seq_no <> n.orig_channel_seq_no
        or o.orig_sub_seq_no <> n.orig_sub_seq_no
        or o.close_acct_ind <> n.close_acct_ind
        or o.cent_deal_type <> n.cent_deal_type
        or o.cent_amt <> n.cent_amt
        or o.ccy <> n.ccy
        or o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.tran_date <> n.tran_date
        or o.status <> n.status
        or o.tran_type <> n.tran_type
        or o.event_type <> n.event_type
        or o.reversal_flag <> n.reversal_flag
        or o.reversal_seq_no <> n.reversal_seq_no
        or o.reversal_tran_type <> n.reversal_tran_type
        or o.reversal_tran_date <> n.reversal_tran_date
        or o.reversal_user_id <> n.reversal_user_id
        or o.wipe_account <> n.wipe_account
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.reversal_reason <> n.reversal_reason
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_branch <> n.tran_branch
        or o.orig_tran_amt <> n.orig_tran_amt
        or o.orig_tran_date <> n.orig_tran_date
        or o.main_source_module <> n.main_source_module
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_cent_reg_cl(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,orig_channel_seq_no -- 原渠道流水号
            ,orig_sub_seq_no -- 原渠道子流水号
            ,close_acct_ind -- 销户标志
            ,cent_deal_type -- 分位处理方式
            ,cent_amt -- 分位金额
            ,ccy -- 币种
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_date -- 交易日期
            ,status -- 状态
            ,tran_type -- 交易类型
            ,event_type -- 事件类型
            ,reversal_flag -- 交易是否已冲正
            ,reversal_seq_no -- 冲正序号
            ,reversal_tran_type -- 冲正交易类型
            ,reversal_tran_date -- 冲正交易日期
            ,reversal_user_id -- 冲正柜员
            ,wipe_account -- 冲正和抹账标识
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,reversal_reason -- 冲正原因
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,orig_tran_amt -- 原交易金额
            ,orig_tran_date -- 原交易时间
            ,main_source_module -- 主模块
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_cent_reg_op(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,orig_channel_seq_no -- 原渠道流水号
            ,orig_sub_seq_no -- 原渠道子流水号
            ,close_acct_ind -- 销户标志
            ,cent_deal_type -- 分位处理方式
            ,cent_amt -- 分位金额
            ,ccy -- 币种
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_date -- 交易日期
            ,status -- 状态
            ,tran_type -- 交易类型
            ,event_type -- 事件类型
            ,reversal_flag -- 交易是否已冲正
            ,reversal_seq_no -- 冲正序号
            ,reversal_tran_type -- 冲正交易类型
            ,reversal_tran_date -- 冲正交易日期
            ,reversal_user_id -- 冲正柜员
            ,wipe_account -- 冲正和抹账标识
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,reversal_reason -- 冲正原因
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,orig_tran_amt -- 原交易金额
            ,orig_tran_date -- 原交易时间
            ,main_source_module -- 主模块
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_no -- 序号
    ,o.reference -- 交易参考号
    ,o.channel_seq_no -- 全局流水号
    ,o.sub_seq_no -- 系统子流水号
    ,o.orig_channel_seq_no -- 原渠道流水号
    ,o.orig_sub_seq_no -- 原渠道子流水号
    ,o.close_acct_ind -- 销户标志
    ,o.cent_deal_type -- 分位处理方式
    ,o.cent_amt -- 分位金额
    ,o.ccy -- 币种
    ,o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.tran_date -- 交易日期
    ,o.status -- 状态
    ,o.tran_type -- 交易类型
    ,o.event_type -- 事件类型
    ,o.reversal_flag -- 交易是否已冲正
    ,o.reversal_seq_no -- 冲正序号
    ,o.reversal_tran_type -- 冲正交易类型
    ,o.reversal_tran_date -- 冲正交易日期
    ,o.reversal_user_id -- 冲正柜员
    ,o.wipe_account -- 冲正和抹账标识
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.reversal_reason -- 冲正原因
    ,o.tran_timestamp -- 交易时间戳
    ,o.tran_branch -- 核心交易机构编号
    ,o.orig_tran_amt -- 原交易金额
    ,o.orig_tran_date -- 原交易时间
    ,o.main_source_module -- 主模块
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
from ${iol_schema}.ncbs_rb_cent_reg_bk o
    left join ${iol_schema}.ncbs_rb_cent_reg_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_cent_reg_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_cent_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_cent_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_cent_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_cent_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_cent_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_cent_reg_cl;
alter table ${iol_schema}.ncbs_rb_cent_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_cent_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_cent_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_cent_reg_op purge;
drop table ${iol_schema}.ncbs_rb_cent_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_cent_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_cent_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
