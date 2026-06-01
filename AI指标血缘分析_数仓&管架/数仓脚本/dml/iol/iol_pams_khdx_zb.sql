/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khdx_zb
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
create table ${iol_schema}.pams_khdx_zb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_khdx_zb;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_zb_op purge;
drop table ${iol_schema}.pams_khdx_zb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_zb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_zb where 0=1;

create table ${iol_schema}.pams_khdx_zb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_zb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_zb_cl(
            zbdh -- 指标代号
            ,zbmc -- 指标名称
            ,zbdw -- 指标单位
            ,zbjb -- 指标级别
            ,whfs -- 维护方式
            ,sfxs -- 是否显示
            ,ddsx -- 调度顺序
            ,zbpx -- 指标排序
            ,zbcc -- 指标层次
            ,ddlb -- 调度类别
            ,jspl -- 计算频率
            ,sjzb -- 上级指标
            ,zbzt -- 指标状态
            ,dlbz -- 定量标准
            ,xszbdh -- 显示指标代号
            ,kzlx -- 扩展类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_zb_op(
            zbdh -- 指标代号
            ,zbmc -- 指标名称
            ,zbdw -- 指标单位
            ,zbjb -- 指标级别
            ,whfs -- 维护方式
            ,sfxs -- 是否显示
            ,ddsx -- 调度顺序
            ,zbpx -- 指标排序
            ,zbcc -- 指标层次
            ,ddlb -- 调度类别
            ,jspl -- 计算频率
            ,sjzb -- 上级指标
            ,zbzt -- 指标状态
            ,dlbz -- 定量标准
            ,xszbdh -- 显示指标代号
            ,kzlx -- 扩展类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.zbdh, o.zbdh) as zbdh -- 指标代号
    ,nvl(n.zbmc, o.zbmc) as zbmc -- 指标名称
    ,nvl(n.zbdw, o.zbdw) as zbdw -- 指标单位
    ,nvl(n.zbjb, o.zbjb) as zbjb -- 指标级别
    ,nvl(n.whfs, o.whfs) as whfs -- 维护方式
    ,nvl(n.sfxs, o.sfxs) as sfxs -- 是否显示
    ,nvl(n.ddsx, o.ddsx) as ddsx -- 调度顺序
    ,nvl(n.zbpx, o.zbpx) as zbpx -- 指标排序
    ,nvl(n.zbcc, o.zbcc) as zbcc -- 指标层次
    ,nvl(n.ddlb, o.ddlb) as ddlb -- 调度类别
    ,nvl(n.jspl, o.jspl) as jspl -- 计算频率
    ,nvl(n.sjzb, o.sjzb) as sjzb -- 上级指标
    ,nvl(n.zbzt, o.zbzt) as zbzt -- 指标状态
    ,nvl(n.dlbz, o.dlbz) as dlbz -- 定量标准
    ,nvl(n.xszbdh, o.xszbdh) as xszbdh -- 显示指标代号
    ,nvl(n.kzlx, o.kzlx) as kzlx -- 扩展类型
    ,case when
            n.zbdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.zbdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.zbdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_khdx_zb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_khdx_zb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.zbdh = n.zbdh
where (
        o.zbdh is null
    )
    or (
        n.zbdh is null
    )
    or (
        o.zbmc <> n.zbmc
        or o.zbdw <> n.zbdw
        or o.zbjb <> n.zbjb
        or o.whfs <> n.whfs
        or o.sfxs <> n.sfxs
        or o.ddsx <> n.ddsx
        or o.zbpx <> n.zbpx
        or o.zbcc <> n.zbcc
        or o.ddlb <> n.ddlb
        or o.jspl <> n.jspl
        or o.sjzb <> n.sjzb
        or o.zbzt <> n.zbzt
        or o.dlbz <> n.dlbz
        or o.xszbdh <> n.xszbdh
        or o.kzlx <> n.kzlx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_zb_cl(
            zbdh -- 指标代号
            ,zbmc -- 指标名称
            ,zbdw -- 指标单位
            ,zbjb -- 指标级别
            ,whfs -- 维护方式
            ,sfxs -- 是否显示
            ,ddsx -- 调度顺序
            ,zbpx -- 指标排序
            ,zbcc -- 指标层次
            ,ddlb -- 调度类别
            ,jspl -- 计算频率
            ,sjzb -- 上级指标
            ,zbzt -- 指标状态
            ,dlbz -- 定量标准
            ,xszbdh -- 显示指标代号
            ,kzlx -- 扩展类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_zb_op(
            zbdh -- 指标代号
            ,zbmc -- 指标名称
            ,zbdw -- 指标单位
            ,zbjb -- 指标级别
            ,whfs -- 维护方式
            ,sfxs -- 是否显示
            ,ddsx -- 调度顺序
            ,zbpx -- 指标排序
            ,zbcc -- 指标层次
            ,ddlb -- 调度类别
            ,jspl -- 计算频率
            ,sjzb -- 上级指标
            ,zbzt -- 指标状态
            ,dlbz -- 定量标准
            ,xszbdh -- 显示指标代号
            ,kzlx -- 扩展类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.zbdh -- 指标代号
    ,o.zbmc -- 指标名称
    ,o.zbdw -- 指标单位
    ,o.zbjb -- 指标级别
    ,o.whfs -- 维护方式
    ,o.sfxs -- 是否显示
    ,o.ddsx -- 调度顺序
    ,o.zbpx -- 指标排序
    ,o.zbcc -- 指标层次
    ,o.ddlb -- 调度类别
    ,o.jspl -- 计算频率
    ,o.sjzb -- 上级指标
    ,o.zbzt -- 指标状态
    ,o.dlbz -- 定量标准
    ,o.xszbdh -- 显示指标代号
    ,o.kzlx -- 扩展类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_khdx_zb_bk o
    left join ${iol_schema}.pams_khdx_zb_op n
        on
            o.zbdh = n.zbdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_khdx_zb_cl d
        on
            o.zbdh = d.zbdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_khdx_zb;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_khdx_zb exchange partition p_19000101 with table ${iol_schema}.pams_khdx_zb_cl;
alter table ${iol_schema}.pams_khdx_zb exchange partition p_20991231 with table ${iol_schema}.pams_khdx_zb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khdx_zb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_zb_op purge;
drop table ${iol_schema}.pams_khdx_zb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_khdx_zb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khdx_zb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
