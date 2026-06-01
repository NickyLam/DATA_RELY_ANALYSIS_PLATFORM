/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_otc_trade_extend
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
create table ${iol_schema}.ibms_ttrd_otc_trade_extend_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_otc_trade_extend
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_trade_extend_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_trade_extend where 0=1;

create table ${iol_schema}.ibms_ttrd_otc_trade_extend_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_trade_extend where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_trade_extend_cl(
            extend_id -- 主键id
            ,trd_id -- 交易单id
            ,u_i_code -- 标的i_code
            ,u_a_type -- 标的a_type
            ,u_m_type -- 标的m_type
            ,fst_set_amount -- 首期金额
            ,end_set_amount -- 到期金额
            ,fst_set_aiamount -- 首期总应计利息
            ,end_set_aiamount -- 到期总应计利息
            ,u_secu_acc_id -- 标的内部证券id
            ,u_grpid -- 
            ,u_secu_ext_acc_id -- 外部证券账户
            ,end_set_days -- 到期交易的清算速度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_trade_extend_op(
            extend_id -- 主键id
            ,trd_id -- 交易单id
            ,u_i_code -- 标的i_code
            ,u_a_type -- 标的a_type
            ,u_m_type -- 标的m_type
            ,fst_set_amount -- 首期金额
            ,end_set_amount -- 到期金额
            ,fst_set_aiamount -- 首期总应计利息
            ,end_set_aiamount -- 到期总应计利息
            ,u_secu_acc_id -- 标的内部证券id
            ,u_grpid -- 
            ,u_secu_ext_acc_id -- 外部证券账户
            ,end_set_days -- 到期交易的清算速度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.extend_id, o.extend_id) as extend_id -- 主键id
    ,nvl(n.trd_id, o.trd_id) as trd_id -- 交易单id
    ,nvl(n.u_i_code, o.u_i_code) as u_i_code -- 标的i_code
    ,nvl(n.u_a_type, o.u_a_type) as u_a_type -- 标的a_type
    ,nvl(n.u_m_type, o.u_m_type) as u_m_type -- 标的m_type
    ,nvl(n.fst_set_amount, o.fst_set_amount) as fst_set_amount -- 首期金额
    ,nvl(n.end_set_amount, o.end_set_amount) as end_set_amount -- 到期金额
    ,nvl(n.fst_set_aiamount, o.fst_set_aiamount) as fst_set_aiamount -- 首期总应计利息
    ,nvl(n.end_set_aiamount, o.end_set_aiamount) as end_set_aiamount -- 到期总应计利息
    ,nvl(n.u_secu_acc_id, o.u_secu_acc_id) as u_secu_acc_id -- 标的内部证券id
    ,nvl(n.u_grpid, o.u_grpid) as u_grpid -- 
    ,nvl(n.u_secu_ext_acc_id, o.u_secu_ext_acc_id) as u_secu_ext_acc_id -- 外部证券账户
    ,nvl(n.end_set_days, o.end_set_days) as end_set_days -- 到期交易的清算速度
    ,case when
            n.extend_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.extend_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.extend_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_otc_trade_extend_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_otc_trade_extend where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.extend_id = n.extend_id
where (
        o.extend_id is null
    )
    or (
        n.extend_id is null
    )
    or (
        o.trd_id <> n.trd_id
        or o.u_i_code <> n.u_i_code
        or o.u_a_type <> n.u_a_type
        or o.u_m_type <> n.u_m_type
        or o.fst_set_amount <> n.fst_set_amount
        or o.end_set_amount <> n.end_set_amount
        or o.fst_set_aiamount <> n.fst_set_aiamount
        or o.end_set_aiamount <> n.end_set_aiamount
        or o.u_secu_acc_id <> n.u_secu_acc_id
        or o.u_grpid <> n.u_grpid
        or o.u_secu_ext_acc_id <> n.u_secu_ext_acc_id
        or o.end_set_days <> n.end_set_days
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_trade_extend_cl(
            extend_id -- 主键id
            ,trd_id -- 交易单id
            ,u_i_code -- 标的i_code
            ,u_a_type -- 标的a_type
            ,u_m_type -- 标的m_type
            ,fst_set_amount -- 首期金额
            ,end_set_amount -- 到期金额
            ,fst_set_aiamount -- 首期总应计利息
            ,end_set_aiamount -- 到期总应计利息
            ,u_secu_acc_id -- 标的内部证券id
            ,u_grpid -- 
            ,u_secu_ext_acc_id -- 外部证券账户
            ,end_set_days -- 到期交易的清算速度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_trade_extend_op(
            extend_id -- 主键id
            ,trd_id -- 交易单id
            ,u_i_code -- 标的i_code
            ,u_a_type -- 标的a_type
            ,u_m_type -- 标的m_type
            ,fst_set_amount -- 首期金额
            ,end_set_amount -- 到期金额
            ,fst_set_aiamount -- 首期总应计利息
            ,end_set_aiamount -- 到期总应计利息
            ,u_secu_acc_id -- 标的内部证券id
            ,u_grpid -- 
            ,u_secu_ext_acc_id -- 外部证券账户
            ,end_set_days -- 到期交易的清算速度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.extend_id -- 主键id
    ,o.trd_id -- 交易单id
    ,o.u_i_code -- 标的i_code
    ,o.u_a_type -- 标的a_type
    ,o.u_m_type -- 标的m_type
    ,o.fst_set_amount -- 首期金额
    ,o.end_set_amount -- 到期金额
    ,o.fst_set_aiamount -- 首期总应计利息
    ,o.end_set_aiamount -- 到期总应计利息
    ,o.u_secu_acc_id -- 标的内部证券id
    ,o.u_grpid -- 
    ,o.u_secu_ext_acc_id -- 外部证券账户
    ,o.end_set_days -- 到期交易的清算速度
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
from ${iol_schema}.ibms_ttrd_otc_trade_extend_bk o
    left join ${iol_schema}.ibms_ttrd_otc_trade_extend_op n
        on
            o.extend_id = n.extend_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_otc_trade_extend_cl d
        on
            o.extend_id = d.extend_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_otc_trade_extend;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_otc_trade_extend') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_otc_trade_extend drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_otc_trade_extend add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_otc_trade_extend exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_otc_trade_extend_cl;
alter table ${iol_schema}.ibms_ttrd_otc_trade_extend exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_otc_trade_extend_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_otc_trade_extend to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_otc_trade_extend_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_otc_trade_extend',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
