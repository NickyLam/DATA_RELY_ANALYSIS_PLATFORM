/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gca_aeuv
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
create table ${iol_schema}.tgls_gca_aeuv_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gca_aeuv
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gca_aeuv_op purge;
drop table ${iol_schema}.tgls_gca_aeuv_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gca_aeuv_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gca_aeuv where 0=1;

create table ${iol_schema}.tgls_gca_aeuv_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gca_aeuv where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gca_aeuv_cl(
            stacid -- 账套标识
            ,systid -- 系统标识
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水号
            ,tranbr -- 交易机构编号
            ,acetna -- 分录名称
            ,usercd -- 用户代码
            ,psauus -- 复核用户
            ,remark -- 备注
            ,prcscd -- 处理码
            ,transt -- 处理状态（1已入账0登记8流程审批中9已作废）
            ,trandt -- 交易日期（入账日期）
            ,transq -- 交易流水（入账流水）
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odbsdt -- 原业务日期
            ,odbssq -- 原业务流水号
            ,wkflid -- 工作流id
            ,trantp -- 交易类型(1-手工账，2-系统账)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gca_aeuv_op(
            stacid -- 账套标识
            ,systid -- 系统标识
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水号
            ,tranbr -- 交易机构编号
            ,acetna -- 分录名称
            ,usercd -- 用户代码
            ,psauus -- 复核用户
            ,remark -- 备注
            ,prcscd -- 处理码
            ,transt -- 处理状态（1已入账0登记8流程审批中9已作废）
            ,trandt -- 交易日期（入账日期）
            ,transq -- 交易流水（入账流水）
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odbsdt -- 原业务日期
            ,odbssq -- 原业务流水号
            ,wkflid -- 工作流id
            ,trantp -- 交易类型(1-手工账，2-系统账)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标识
    ,nvl(n.systid, o.systid) as systid -- 系统标识
    ,nvl(n.bsnsdt, o.bsnsdt) as bsnsdt -- 业务日期
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 业务流水号
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构编号
    ,nvl(n.acetna, o.acetna) as acetna -- 分录名称
    ,nvl(n.usercd, o.usercd) as usercd -- 用户代码
    ,nvl(n.psauus, o.psauus) as psauus -- 复核用户
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 处理码
    ,nvl(n.transt, o.transt) as transt -- 处理状态（1已入账0登记8流程审批中9已作废）
    ,nvl(n.trandt, o.trandt) as trandt -- 交易日期（入账日期）
    ,nvl(n.transq, o.transq) as transq -- 交易流水（入账流水）
    ,nvl(n.strkst, o.strkst) as strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,nvl(n.odbsdt, o.odbsdt) as odbsdt -- 原业务日期
    ,nvl(n.odbssq, o.odbssq) as odbssq -- 原业务流水号
    ,nvl(n.wkflid, o.wkflid) as wkflid -- 工作流id
    ,nvl(n.trantp, o.trantp) as trantp -- 交易类型(1-手工账，2-系统账)
    ,case when
            n.stacid is null
            and n.systid is null
            and n.bsnsdt is null
            and n.bsnssq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.bsnsdt is null
            and n.bsnssq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.bsnsdt is null
            and n.bsnssq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gca_aeuv_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gca_aeuv where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.bsnsdt = n.bsnsdt
            and o.bsnssq = n.bsnssq
where (
        o.stacid is null
        and o.systid is null
        and o.bsnsdt is null
        and o.bsnssq is null
    )
    or (
        n.stacid is null
        and n.systid is null
        and n.bsnsdt is null
        and n.bsnssq is null
    )
    or (
        o.tranbr <> n.tranbr
        or o.acetna <> n.acetna
        or o.usercd <> n.usercd
        or o.psauus <> n.psauus
        or o.remark <> n.remark
        or o.prcscd <> n.prcscd
        or o.transt <> n.transt
        or o.trandt <> n.trandt
        or o.transq <> n.transq
        or o.strkst <> n.strkst
        or o.odbsdt <> n.odbsdt
        or o.odbssq <> n.odbssq
        or o.wkflid <> n.wkflid
        or o.trantp <> n.trantp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gca_aeuv_cl(
            stacid -- 账套标识
            ,systid -- 系统标识
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水号
            ,tranbr -- 交易机构编号
            ,acetna -- 分录名称
            ,usercd -- 用户代码
            ,psauus -- 复核用户
            ,remark -- 备注
            ,prcscd -- 处理码
            ,transt -- 处理状态（1已入账0登记8流程审批中9已作废）
            ,trandt -- 交易日期（入账日期）
            ,transq -- 交易流水（入账流水）
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odbsdt -- 原业务日期
            ,odbssq -- 原业务流水号
            ,wkflid -- 工作流id
            ,trantp -- 交易类型(1-手工账，2-系统账)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gca_aeuv_op(
            stacid -- 账套标识
            ,systid -- 系统标识
            ,bsnsdt -- 业务日期
            ,bsnssq -- 业务流水号
            ,tranbr -- 交易机构编号
            ,acetna -- 分录名称
            ,usercd -- 用户代码
            ,psauus -- 复核用户
            ,remark -- 备注
            ,prcscd -- 处理码
            ,transt -- 处理状态（1已入账0登记8流程审批中9已作废）
            ,trandt -- 交易日期（入账日期）
            ,transq -- 交易流水（入账流水）
            ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
            ,odbsdt -- 原业务日期
            ,odbssq -- 原业务流水号
            ,wkflid -- 工作流id
            ,trantp -- 交易类型(1-手工账，2-系统账)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标识
    ,o.systid -- 系统标识
    ,o.bsnsdt -- 业务日期
    ,o.bsnssq -- 业务流水号
    ,o.tranbr -- 交易机构编号
    ,o.acetna -- 分录名称
    ,o.usercd -- 用户代码
    ,o.psauus -- 复核用户
    ,o.remark -- 备注
    ,o.prcscd -- 处理码
    ,o.transt -- 处理状态（1已入账0登记8流程审批中9已作废）
    ,o.trandt -- 交易日期（入账日期）
    ,o.transq -- 交易流水（入账流水）
    ,o.strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,o.odbsdt -- 原业务日期
    ,o.odbssq -- 原业务流水号
    ,o.wkflid -- 工作流id
    ,o.trantp -- 交易类型(1-手工账，2-系统账)
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
from ${iol_schema}.tgls_gca_aeuv_bk o
    left join ${iol_schema}.tgls_gca_aeuv_op n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.bsnsdt = n.bsnsdt
            and o.bsnssq = n.bsnssq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gca_aeuv_cl d
        on
            o.stacid = d.stacid
            and o.systid = d.systid
            and o.bsnsdt = d.bsnsdt
            and o.bsnssq = d.bsnssq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gca_aeuv;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gca_aeuv') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gca_aeuv drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gca_aeuv add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gca_aeuv exchange partition p_${batch_date} with table ${iol_schema}.tgls_gca_aeuv_cl;
alter table ${iol_schema}.tgls_gca_aeuv exchange partition p_20991231 with table ${iol_schema}.tgls_gca_aeuv_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gca_aeuv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gca_aeuv_op purge;
drop table ${iol_schema}.tgls_gca_aeuv_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gca_aeuv_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gca_aeuv',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
