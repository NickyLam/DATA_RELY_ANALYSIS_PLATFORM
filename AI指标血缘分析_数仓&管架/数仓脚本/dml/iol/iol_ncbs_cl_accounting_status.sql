/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_accounting_status
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
create table ${iol_schema}.ncbs_cl_accounting_status_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_accounting_status
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_accounting_status_op purge;
drop table ${iol_schema}.ncbs_cl_accounting_status_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_accounting_status_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_accounting_status where 0=1;

create table ${iol_schema}.ncbs_cl_accounting_status_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_accounting_status where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_accounting_status_cl(
            period_freq -- 频率id
            ,accounting_status_desc -- 核算状态描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,auto_change_flag -- 自动变化标志
            ,available -- 是否可交易标识
            ,change_type -- 变化类型
            ,company -- 法人
            ,grace_day_flag -- 是否考虑宽限期
            ,non_performing_flag -- 是否涉及利息
            ,non_performing_pri_flag -- 是否涉及本金
            ,suspend_ind -- 是否久悬
            ,terminate_ind -- 是否终止
            ,wrn_flag -- 贷款核销标志
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,hunting_status -- 持续扣款标志
            ,tran_timestamp -- 交易时间戳
            ,period_type -- 敞口期限类型
            ,effect_priority -- 核算状态生效优先级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_accounting_status_op(
            period_freq -- 频率id
            ,accounting_status_desc -- 核算状态描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,auto_change_flag -- 自动变化标志
            ,available -- 是否可交易标识
            ,change_type -- 变化类型
            ,company -- 法人
            ,grace_day_flag -- 是否考虑宽限期
            ,non_performing_flag -- 是否涉及利息
            ,non_performing_pri_flag -- 是否涉及本金
            ,suspend_ind -- 是否久悬
            ,terminate_ind -- 是否终止
            ,wrn_flag -- 贷款核销标志
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,hunting_status -- 持续扣款标志
            ,tran_timestamp -- 交易时间戳
            ,period_type -- 敞口期限类型
            ,effect_priority -- 核算状态生效优先级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.accounting_status_desc, o.accounting_status_desc) as accounting_status_desc -- 核算状态描述
    ,nvl(n.alloc_seq_fee, o.alloc_seq_fee) as alloc_seq_fee -- 贷款费用还款顺序
    ,nvl(n.alloc_seq_int, o.alloc_seq_int) as alloc_seq_int -- 贷款利息还款顺序
    ,nvl(n.alloc_seq_odi, o.alloc_seq_odi) as alloc_seq_odi -- 贷款复利还款顺序
    ,nvl(n.alloc_seq_odp, o.alloc_seq_odp) as alloc_seq_odp -- 贷款罚息还款顺序
    ,nvl(n.alloc_seq_pri, o.alloc_seq_pri) as alloc_seq_pri -- 贷款本金还款顺序
    ,nvl(n.alloc_seq_type, o.alloc_seq_type) as alloc_seq_type -- 贷款自动还款类型
    ,nvl(n.auto_change_flag, o.auto_change_flag) as auto_change_flag -- 自动变化标志
    ,nvl(n.available, o.available) as available -- 是否可交易标识
    ,nvl(n.change_type, o.change_type) as change_type -- 变化类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.grace_day_flag, o.grace_day_flag) as grace_day_flag -- 是否考虑宽限期
    ,nvl(n.non_performing_flag, o.non_performing_flag) as non_performing_flag -- 是否涉及利息
    ,nvl(n.non_performing_pri_flag, o.non_performing_pri_flag) as non_performing_pri_flag -- 是否涉及本金
    ,nvl(n.suspend_ind, o.suspend_ind) as suspend_ind -- 是否久悬
    ,nvl(n.terminate_ind, o.terminate_ind) as terminate_ind -- 是否终止
    ,nvl(n.wrn_flag, o.wrn_flag) as wrn_flag -- 贷款核销标志
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.hunting_status, o.hunting_status) as hunting_status -- 持续扣款标志
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.period_type, o.period_type) as period_type -- 敞口期限类型
    ,nvl(n.effect_priority, o.effect_priority) as effect_priority -- 核算状态生效优先级
    ,case when
            n.accounting_status is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accounting_status is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accounting_status is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_accounting_status_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_accounting_status where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accounting_status = n.accounting_status
where (
        o.accounting_status is null
    )
    or (
        n.accounting_status is null
    )
    or (
        o.period_freq <> n.period_freq
        or o.accounting_status_desc <> n.accounting_status_desc
        or o.alloc_seq_fee <> n.alloc_seq_fee
        or o.alloc_seq_int <> n.alloc_seq_int
        or o.alloc_seq_odi <> n.alloc_seq_odi
        or o.alloc_seq_odp <> n.alloc_seq_odp
        or o.alloc_seq_pri <> n.alloc_seq_pri
        or o.alloc_seq_type <> n.alloc_seq_type
        or o.auto_change_flag <> n.auto_change_flag
        or o.available <> n.available
        or o.change_type <> n.change_type
        or o.company <> n.company
        or o.grace_day_flag <> n.grace_day_flag
        or o.non_performing_flag <> n.non_performing_flag
        or o.non_performing_pri_flag <> n.non_performing_pri_flag
        or o.suspend_ind <> n.suspend_ind
        or o.terminate_ind <> n.terminate_ind
        or o.wrn_flag <> n.wrn_flag
        or o.libra_op_time <> n.libra_op_time
        or o.hunting_status <> n.hunting_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.period_type <> n.period_type
        or o.effect_priority <> n.effect_priority
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_accounting_status_cl(
            period_freq -- 频率id
            ,accounting_status_desc -- 核算状态描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,auto_change_flag -- 自动变化标志
            ,available -- 是否可交易标识
            ,change_type -- 变化类型
            ,company -- 法人
            ,grace_day_flag -- 是否考虑宽限期
            ,non_performing_flag -- 是否涉及利息
            ,non_performing_pri_flag -- 是否涉及本金
            ,suspend_ind -- 是否久悬
            ,terminate_ind -- 是否终止
            ,wrn_flag -- 贷款核销标志
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,hunting_status -- 持续扣款标志
            ,tran_timestamp -- 交易时间戳
            ,period_type -- 敞口期限类型
            ,effect_priority -- 核算状态生效优先级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_accounting_status_op(
            period_freq -- 频率id
            ,accounting_status_desc -- 核算状态描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,auto_change_flag -- 自动变化标志
            ,available -- 是否可交易标识
            ,change_type -- 变化类型
            ,company -- 法人
            ,grace_day_flag -- 是否考虑宽限期
            ,non_performing_flag -- 是否涉及利息
            ,non_performing_pri_flag -- 是否涉及本金
            ,suspend_ind -- 是否久悬
            ,terminate_ind -- 是否终止
            ,wrn_flag -- 贷款核销标志
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,hunting_status -- 持续扣款标志
            ,tran_timestamp -- 交易时间戳
            ,period_type -- 敞口期限类型
            ,effect_priority -- 核算状态生效优先级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.period_freq -- 频率id
    ,o.accounting_status_desc -- 核算状态描述
    ,o.alloc_seq_fee -- 贷款费用还款顺序
    ,o.alloc_seq_int -- 贷款利息还款顺序
    ,o.alloc_seq_odi -- 贷款复利还款顺序
    ,o.alloc_seq_odp -- 贷款罚息还款顺序
    ,o.alloc_seq_pri -- 贷款本金还款顺序
    ,o.alloc_seq_type -- 贷款自动还款类型
    ,o.auto_change_flag -- 自动变化标志
    ,o.available -- 是否可交易标识
    ,o.change_type -- 变化类型
    ,o.company -- 法人
    ,o.grace_day_flag -- 是否考虑宽限期
    ,o.non_performing_flag -- 是否涉及利息
    ,o.non_performing_pri_flag -- 是否涉及本金
    ,o.suspend_ind -- 是否久悬
    ,o.terminate_ind -- 是否终止
    ,o.wrn_flag -- 贷款核销标志
    ,o.libra_op_time -- libra执行次数
    ,o.accounting_status -- 核算状态
    ,o.hunting_status -- 持续扣款标志
    ,o.tran_timestamp -- 交易时间戳
    ,o.period_type -- 敞口期限类型
    ,o.effect_priority -- 核算状态生效优先级
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
from ${iol_schema}.ncbs_cl_accounting_status_bk o
    left join ${iol_schema}.ncbs_cl_accounting_status_op n
        on
            o.accounting_status = n.accounting_status
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_accounting_status_cl d
        on
            o.accounting_status = d.accounting_status
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_accounting_status;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_accounting_status') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_accounting_status drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_accounting_status add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_accounting_status exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_accounting_status_cl;
alter table ${iol_schema}.ncbs_cl_accounting_status exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_accounting_status_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_accounting_status to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_accounting_status_op purge;
drop table ${iol_schema}.ncbs_cl_accounting_status_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_accounting_status_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_accounting_status',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
