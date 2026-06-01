/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ptl_trade
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
create table ${iol_schema}.fams_ptl_trade_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ptl_trade
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_trade_op purge;
drop table ${iol_schema}.fams_ptl_trade_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_trade_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_trade where 0=1;

create table ${iol_schema}.fams_ptl_trade_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_trade where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_trade_cl(
            portfolio_id -- 组合代码
            ,busi_no -- 业务编号
            ,busi_table -- 业务表，交易表、结算指令等
            ,busi_id -- 业务明细代码，金融产品代码、资金账号等
            ,busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
            ,inv_aim -- 投资目的
            ,sec_manage_acct_id -- 证券托管户代码
            ,settle_date -- 实际发生日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_trade_op(
            portfolio_id -- 组合代码
            ,busi_no -- 业务编号
            ,busi_table -- 业务表，交易表、结算指令等
            ,busi_id -- 业务明细代码，金融产品代码、资金账号等
            ,busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
            ,inv_aim -- 投资目的
            ,sec_manage_acct_id -- 证券托管户代码
            ,settle_date -- 实际发生日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 组合代码
    ,nvl(n.busi_no, o.busi_no) as busi_no -- 业务编号
    ,nvl(n.busi_table, o.busi_table) as busi_table -- 业务表，交易表、结算指令等
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务明细代码，金融产品代码、资金账号等
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
    ,nvl(n.inv_aim, o.inv_aim) as inv_aim -- 投资目的
    ,nvl(n.sec_manage_acct_id, o.sec_manage_acct_id) as sec_manage_acct_id -- 证券托管户代码
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 实际发生日
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.portfolio_id is null
            and n.busi_no is null
            and n.busi_table is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.portfolio_id is null
            and n.busi_no is null
            and n.busi_table is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.portfolio_id is null
            and n.busi_no is null
            and n.busi_table is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ptl_trade_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ptl_trade where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.portfolio_id = n.portfolio_id
            and o.busi_no = n.busi_no
            and o.busi_table = n.busi_table
where (
        o.portfolio_id is null
        and o.busi_no is null
        and o.busi_table is null
    )
    or (
        n.portfolio_id is null
        and n.busi_no is null
        and n.busi_table is null
    )
    or (
        o.busi_id <> n.busi_id
        or o.busi_type <> n.busi_type
        or o.inv_aim <> n.inv_aim
        or o.sec_manage_acct_id <> n.sec_manage_acct_id
        or o.settle_date <> n.settle_date
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_trade_cl(
            portfolio_id -- 组合代码
            ,busi_no -- 业务编号
            ,busi_table -- 业务表，交易表、结算指令等
            ,busi_id -- 业务明细代码，金融产品代码、资金账号等
            ,busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
            ,inv_aim -- 投资目的
            ,sec_manage_acct_id -- 证券托管户代码
            ,settle_date -- 实际发生日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_trade_op(
            portfolio_id -- 组合代码
            ,busi_no -- 业务编号
            ,busi_table -- 业务表，交易表、结算指令等
            ,busi_id -- 业务明细代码，金融产品代码、资金账号等
            ,busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
            ,inv_aim -- 投资目的
            ,sec_manage_acct_id -- 证券托管户代码
            ,settle_date -- 实际发生日
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.portfolio_id -- 组合代码
    ,o.busi_no -- 业务编号
    ,o.busi_table -- 业务表，交易表、结算指令等
    ,o.busi_id -- 业务明细代码，金融产品代码、资金账号等
    ,o.busi_type -- 业务类型，债券交易、债券存续交易、基金交易、收划款等
    ,o.inv_aim -- 投资目的
    ,o.sec_manage_acct_id -- 证券托管户代码
    ,o.settle_date -- 实际发生日
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_ptl_trade_bk o
    left join ${iol_schema}.fams_ptl_trade_op n
        on
            o.portfolio_id = n.portfolio_id
            and o.busi_no = n.busi_no
            and o.busi_table = n.busi_table
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ptl_trade_cl d
        on
            o.portfolio_id = d.portfolio_id
            and o.busi_no = d.busi_no
            and o.busi_table = d.busi_table
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ptl_trade;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ptl_trade') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ptl_trade drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ptl_trade add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ptl_trade exchange partition p_${batch_date} with table ${iol_schema}.fams_ptl_trade_cl;
alter table ${iol_schema}.fams_ptl_trade exchange partition p_20991231 with table ${iol_schema}.fams_ptl_trade_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ptl_trade to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_trade_op purge;
drop table ${iol_schema}.fams_ptl_trade_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ptl_trade_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ptl_trade',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
