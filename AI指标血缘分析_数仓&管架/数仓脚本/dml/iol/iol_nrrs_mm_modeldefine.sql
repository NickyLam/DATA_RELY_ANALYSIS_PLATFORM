/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_mm_modeldefine
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
create table ${iol_schema}.nrrs_mm_modeldefine_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_mm_modeldefine;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_mm_modeldefine_op purge;
drop table ${iol_schema}.nrrs_mm_modeldefine_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_mm_modeldefine_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_mm_modeldefine where 0=1;

create table ${iol_schema}.nrrs_mm_modeldefine_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_mm_modeldefine where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_mm_modeldefine_cl(
            lsh -- 模型标识
            ,modelcode -- 模型编号
            ,modelname -- 模型名称
            ,version -- 版本号
            ,modelstate -- 模型状态
            ,operatorid -- 操作员
            ,createdate -- 创建日期
            ,issuedate -- 发布日期
            ,adjustflag -- 调整逻辑标志
            ,constraintflag -- 约束逻辑标志
            ,modeltype -- 模型类型
            ,reportid -- 报告编号
            ,adjustmodelcode -- 调整模型
            ,mark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_mm_modeldefine_op(
            lsh -- 模型标识
            ,modelcode -- 模型编号
            ,modelname -- 模型名称
            ,version -- 版本号
            ,modelstate -- 模型状态
            ,operatorid -- 操作员
            ,createdate -- 创建日期
            ,issuedate -- 发布日期
            ,adjustflag -- 调整逻辑标志
            ,constraintflag -- 约束逻辑标志
            ,modeltype -- 模型类型
            ,reportid -- 报告编号
            ,adjustmodelcode -- 调整模型
            ,mark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lsh, o.lsh) as lsh -- 模型标识
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 模型编号
    ,nvl(n.modelname, o.modelname) as modelname -- 模型名称
    ,nvl(n.version, o.version) as version -- 版本号
    ,nvl(n.modelstate, o.modelstate) as modelstate -- 模型状态
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 操作员
    ,nvl(n.createdate, o.createdate) as createdate -- 创建日期
    ,nvl(n.issuedate, o.issuedate) as issuedate -- 发布日期
    ,nvl(n.adjustflag, o.adjustflag) as adjustflag -- 调整逻辑标志
    ,nvl(n.constraintflag, o.constraintflag) as constraintflag -- 约束逻辑标志
    ,nvl(n.modeltype, o.modeltype) as modeltype -- 模型类型
    ,nvl(n.reportid, o.reportid) as reportid -- 报告编号
    ,nvl(n.adjustmodelcode, o.adjustmodelcode) as adjustmodelcode -- 调整模型
    ,nvl(n.mark, o.mark) as mark -- 备注
    ,case when
            n.lsh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lsh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lsh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_mm_modeldefine_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_mm_modeldefine where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.lsh = n.lsh
where (
        o.lsh is null
    )
    or (
        n.lsh is null
    )
    or (
        o.modelcode <> n.modelcode
        or o.modelname <> n.modelname
        or o.version <> n.version
        or o.modelstate <> n.modelstate
        or o.operatorid <> n.operatorid
        or o.createdate <> n.createdate
        or o.issuedate <> n.issuedate
        or o.adjustflag <> n.adjustflag
        or o.constraintflag <> n.constraintflag
        or o.modeltype <> n.modeltype
        or o.reportid <> n.reportid
        or o.adjustmodelcode <> n.adjustmodelcode
        or o.mark <> n.mark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_mm_modeldefine_cl(
            lsh -- 模型标识
            ,modelcode -- 模型编号
            ,modelname -- 模型名称
            ,version -- 版本号
            ,modelstate -- 模型状态
            ,operatorid -- 操作员
            ,createdate -- 创建日期
            ,issuedate -- 发布日期
            ,adjustflag -- 调整逻辑标志
            ,constraintflag -- 约束逻辑标志
            ,modeltype -- 模型类型
            ,reportid -- 报告编号
            ,adjustmodelcode -- 调整模型
            ,mark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_mm_modeldefine_op(
            lsh -- 模型标识
            ,modelcode -- 模型编号
            ,modelname -- 模型名称
            ,version -- 版本号
            ,modelstate -- 模型状态
            ,operatorid -- 操作员
            ,createdate -- 创建日期
            ,issuedate -- 发布日期
            ,adjustflag -- 调整逻辑标志
            ,constraintflag -- 约束逻辑标志
            ,modeltype -- 模型类型
            ,reportid -- 报告编号
            ,adjustmodelcode -- 调整模型
            ,mark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lsh -- 模型标识
    ,o.modelcode -- 模型编号
    ,o.modelname -- 模型名称
    ,o.version -- 版本号
    ,o.modelstate -- 模型状态
    ,o.operatorid -- 操作员
    ,o.createdate -- 创建日期
    ,o.issuedate -- 发布日期
    ,o.adjustflag -- 调整逻辑标志
    ,o.constraintflag -- 约束逻辑标志
    ,o.modeltype -- 模型类型
    ,o.reportid -- 报告编号
    ,o.adjustmodelcode -- 调整模型
    ,o.mark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_mm_modeldefine_bk o
    left join ${iol_schema}.nrrs_mm_modeldefine_op n
        on
            o.lsh = n.lsh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_mm_modeldefine_cl d
        on
            o.lsh = d.lsh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_mm_modeldefine;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_mm_modeldefine exchange partition p_19000101 with table ${iol_schema}.nrrs_mm_modeldefine_cl;
alter table ${iol_schema}.nrrs_mm_modeldefine exchange partition p_20991231 with table ${iol_schema}.nrrs_mm_modeldefine_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_mm_modeldefine to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_mm_modeldefine_op purge;
drop table ${iol_schema}.nrrs_mm_modeldefine_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_mm_modeldefine_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_mm_modeldefine',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
