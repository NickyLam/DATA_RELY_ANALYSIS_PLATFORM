/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_mims_scfs_guar_relation
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
create table ${iol_schema}.mims_mims_scfs_guar_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_mims_scfs_guar_relation;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_mims_scfs_guar_relation_op purge;
drop table ${iol_schema}.mims_mims_scfs_guar_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_mims_scfs_guar_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_mims_scfs_guar_relation where 0=1;

create table ${iol_schema}.mims_mims_scfs_guar_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_mims_scfs_guar_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_mims_scfs_guar_relation_cl(
            poolsccode -- 资产池押品编号
            ,cmdtysccode -- 详情押品编号
            ,cmdty_id -- 数据日期
            ,ivnt_id -- 库存编号
            ,plg_id -- 质押编号
            ,bussno -- 担保合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_mims_scfs_guar_relation_op(
            poolsccode -- 资产池押品编号
            ,cmdtysccode -- 详情押品编号
            ,cmdty_id -- 数据日期
            ,ivnt_id -- 库存编号
            ,plg_id -- 质押编号
            ,bussno -- 担保合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.poolsccode, o.poolsccode) as poolsccode -- 资产池押品编号
    ,nvl(n.cmdtysccode, o.cmdtysccode) as cmdtysccode -- 详情押品编号
    ,nvl(n.cmdty_id, o.cmdty_id) as cmdty_id -- 数据日期
    ,nvl(n.ivnt_id, o.ivnt_id) as ivnt_id -- 库存编号
    ,nvl(n.plg_id, o.plg_id) as plg_id -- 质押编号
    ,nvl(n.bussno, o.bussno) as bussno -- 担保合同号
    ,case when
            n.cmdtysccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cmdtysccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cmdtysccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_mims_scfs_guar_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_mims_scfs_guar_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cmdtysccode = n.cmdtysccode
where (
        o.cmdtysccode is null
    )
    or (
        n.cmdtysccode is null
    )
    or (
        o.poolsccode <> n.poolsccode
        or o.cmdty_id <> n.cmdty_id
        or o.ivnt_id <> n.ivnt_id
        or o.plg_id <> n.plg_id
        or o.bussno <> n.bussno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_mims_scfs_guar_relation_cl(
            poolsccode -- 资产池押品编号
            ,cmdtysccode -- 详情押品编号
            ,cmdty_id -- 数据日期
            ,ivnt_id -- 库存编号
            ,plg_id -- 质押编号
            ,bussno -- 担保合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_mims_scfs_guar_relation_op(
            poolsccode -- 资产池押品编号
            ,cmdtysccode -- 详情押品编号
            ,cmdty_id -- 数据日期
            ,ivnt_id -- 库存编号
            ,plg_id -- 质押编号
            ,bussno -- 担保合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.poolsccode -- 资产池押品编号
    ,o.cmdtysccode -- 详情押品编号
    ,o.cmdty_id -- 数据日期
    ,o.ivnt_id -- 库存编号
    ,o.plg_id -- 质押编号
    ,o.bussno -- 担保合同号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_mims_scfs_guar_relation_bk o
    left join ${iol_schema}.mims_mims_scfs_guar_relation_op n
        on
            o.cmdtysccode = n.cmdtysccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_mims_scfs_guar_relation_cl d
        on
            o.cmdtysccode = d.cmdtysccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_mims_scfs_guar_relation;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_mims_scfs_guar_relation exchange partition p_19000101 with table ${iol_schema}.mims_mims_scfs_guar_relation_cl;
alter table ${iol_schema}.mims_mims_scfs_guar_relation exchange partition p_20991231 with table ${iol_schema}.mims_mims_scfs_guar_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_mims_scfs_guar_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_mims_scfs_guar_relation_op purge;
drop table ${iol_schema}.mims_mims_scfs_guar_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_mims_scfs_guar_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_mims_scfs_guar_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
