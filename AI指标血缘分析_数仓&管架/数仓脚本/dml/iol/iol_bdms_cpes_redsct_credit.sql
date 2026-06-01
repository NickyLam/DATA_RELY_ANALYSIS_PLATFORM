/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_redsct_credit
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
create table ${iol_schema}.bdms_cpes_redsct_credit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_redsct_credit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_credit_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_credit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_credit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_credit where 0=1;

create table ${iol_schema}.bdms_cpes_redsct_credit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_credit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_credit_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,credit_sum_amt -- 再贴现授信总额的
            ,credit_balance_amt -- 再贴现授信余额
            ,credit_occurred_amt -- 再贴现授信累计发生额
            ,is_valid -- 是否有效： 0 否 1 是
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
            ,credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_credit_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,credit_sum_amt -- 再贴现授信总额的
            ,credit_balance_amt -- 再贴现授信余额
            ,credit_occurred_amt -- 再贴现授信累计发生额
            ,is_valid -- 是否有效： 0 否 1 是
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
            ,credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.credit_sum_amt, o.credit_sum_amt) as credit_sum_amt -- 再贴现授信总额的
    ,nvl(n.credit_balance_amt, o.credit_balance_amt) as credit_balance_amt -- 再贴现授信余额
    ,nvl(n.credit_occurred_amt, o.credit_occurred_amt) as credit_occurred_amt -- 再贴现授信累计发生额
    ,nvl(n.is_valid, o.is_valid) as is_valid -- 是否有效： 0 否 1 是
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.credit_balance_flag, o.credit_balance_flag) as credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
    ,nvl(n.credit_occurred_flag, o.credit_occurred_flag) as credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_redsct_credit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_redsct_credit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.credit_sum_amt <> n.credit_sum_amt
        or o.credit_balance_amt <> n.credit_balance_amt
        or o.credit_occurred_amt <> n.credit_occurred_amt
        or o.is_valid <> n.is_valid
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.credit_balance_flag <> n.credit_balance_flag
        or o.credit_occurred_flag <> n.credit_occurred_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_credit_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,credit_sum_amt -- 再贴现授信总额的
            ,credit_balance_amt -- 再贴现授信余额
            ,credit_occurred_amt -- 再贴现授信累计发生额
            ,is_valid -- 是否有效： 0 否 1 是
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
            ,credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_credit_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,credit_sum_amt -- 再贴现授信总额的
            ,credit_balance_amt -- 再贴现授信余额
            ,credit_occurred_amt -- 再贴现授信累计发生额
            ,is_valid -- 是否有效： 0 否 1 是
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
            ,credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.credit_sum_amt -- 再贴现授信总额的
    ,o.credit_balance_amt -- 再贴现授信余额
    ,o.credit_occurred_amt -- 再贴现授信累计发生额
    ,o.is_valid -- 是否有效： 0 否 1 是
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.credit_balance_flag -- 再贴现余额有效标识： 0 否 1 是
    ,o.credit_occurred_flag -- 再贴现发生额有效标识： 0 否 1 是
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_redsct_credit_bk o
    left join ${iol_schema}.bdms_cpes_redsct_credit_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_redsct_credit_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdms_cpes_redsct_credit;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_redsct_credit exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_redsct_credit_cl;
alter table ${iol_schema}.bdms_cpes_redsct_credit exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_redsct_credit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_redsct_credit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_credit_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_credit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_redsct_credit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_redsct_credit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
