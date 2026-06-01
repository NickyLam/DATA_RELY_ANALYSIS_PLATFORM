/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_xrt
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
whenever sqlerror continue none ;
create table ${iol_schema}.isbs_xrt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_xrt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_xrt_op purge;
drop table ${iol_schema}.isbs_xrt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_xrt_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.isbs_xrt where 0=1;

create table ${iol_schema}.isbs_xrt_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.isbs_xrt where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.isbs_xrt_op(
        inr -- 唯一ID
        ,cur -- 货币
        ,begdat -- 开始日期
        ,enddat -- 结束日期
        ,buyrat -- 买入价格
        ,midrat -- 中间价格
        ,selrat -- 卖出价格
        ,ttrrat -- 指定买价
        ,odrrat -- 指定卖价
        ,ver -- 版本
        ,resrat -- 卖出参考汇率
        ,rebrat -- 买入参考汇率
        ,ibrrat -- 内部
        ,sel1rat -- 买入价格1
        ,buy1rat -- 钞买入价格
        ,etgextkey -- 实体
        ,xrttim -- XRT时间
        ,inebpr -- 现钞买入价
        ,inespr -- 现钞卖出价
        ,inslpr -- 内部价
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.inr -- 唯一ID
    ,n.cur -- 货币
    ,n.begdat -- 开始日期
    ,n.enddat -- 结束日期
    ,n.buyrat -- 买入价格
    ,n.midrat -- 中间价格
    ,n.selrat -- 卖出价格
    ,n.ttrrat -- 指定买价
    ,n.odrrat -- 指定卖价
    ,n.ver -- 版本
    ,n.resrat -- 卖出参考汇率
    ,n.rebrat -- 买入参考汇率
    ,n.ibrrat -- 内部
    ,n.sel1rat -- 买入价格1
    ,n.buy1rat -- 钞买入价格
    ,n.etgextkey -- 实体
    ,n.xrttim -- XRT时间
    ,n.inebpr -- 现钞买入价
    ,n.inespr -- 现钞卖出价
    ,n.inslpr -- 内部价
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_xrt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.isbs_xrt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        o.cur <> n.cur
        or o.begdat <> n.begdat
        or o.enddat <> n.enddat
        or o.buyrat <> n.buyrat
        or o.midrat <> n.midrat
        or o.selrat <> n.selrat
        or o.ttrrat <> n.ttrrat
        or o.odrrat <> n.odrrat
        or o.ver <> n.ver
        or o.resrat <> n.resrat
        or o.rebrat <> n.rebrat
        or o.ibrrat <> n.ibrrat
        or o.sel1rat <> n.sel1rat
        or o.buy1rat <> n.buy1rat
        or o.etgextkey <> n.etgextkey
        or o.xrttim <> n.xrttim
        or o.inebpr <> n.inebpr
        or o.inespr <> n.inespr
        or o.inslpr <> n.inslpr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_xrt_cl(
            inr -- 唯一ID
        ,cur -- 货币
        ,begdat -- 开始日期
        ,enddat -- 结束日期
        ,buyrat -- 买入价格
        ,midrat -- 中间价格
        ,selrat -- 卖出价格
        ,ttrrat -- 指定买价
        ,odrrat -- 指定卖价
        ,ver -- 版本
        ,resrat -- 卖出参考汇率
        ,rebrat -- 买入参考汇率
        ,ibrrat -- 内部
        ,sel1rat -- 买入价格1
        ,buy1rat -- 钞买入价格
        ,etgextkey -- 实体
        ,xrttim -- XRT时间
        ,inebpr -- 现钞买入价
        ,inespr -- 现钞卖出价
        ,inslpr -- 内部价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_xrt_op(
            inr -- 唯一ID
        ,cur -- 货币
        ,begdat -- 开始日期
        ,enddat -- 结束日期
        ,buyrat -- 买入价格
        ,midrat -- 中间价格
        ,selrat -- 卖出价格
        ,ttrrat -- 指定买价
        ,odrrat -- 指定卖价
        ,ver -- 版本
        ,resrat -- 卖出参考汇率
        ,rebrat -- 买入参考汇率
        ,ibrrat -- 内部
        ,sel1rat -- 买入价格1
        ,buy1rat -- 钞买入价格
        ,etgextkey -- 实体
        ,xrttim -- XRT时间
        ,inebpr -- 现钞买入价
        ,inespr -- 现钞卖出价
        ,inslpr -- 内部价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID
    ,o.cur -- 货币
    ,o.begdat -- 开始日期
    ,o.enddat -- 结束日期
    ,o.buyrat -- 买入价格
    ,o.midrat -- 中间价格
    ,o.selrat -- 卖出价格
    ,o.ttrrat -- 指定买价
    ,o.odrrat -- 指定卖价
    ,o.ver -- 版本
    ,o.resrat -- 卖出参考汇率
    ,o.rebrat -- 买入参考汇率
    ,o.ibrrat -- 内部
    ,o.sel1rat -- 买入价格1
    ,o.buy1rat -- 钞买入价格
    ,o.etgextkey -- 实体
    ,o.xrttim -- XRT时间
    ,o.inebpr -- 现钞买入价
    ,o.inespr -- 现钞卖出价
    ,o.inslpr -- 内部价
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_xrt_bk o
    left join ${iol_schema}.isbs_xrt_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_xrt;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_xrt exchange partition p_19000101 with table ${iol_schema}.isbs_xrt_cl;
alter table ${iol_schema}.isbs_xrt exchange partition p_20991231 with table ${iol_schema}.isbs_xrt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_xrt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_xrt_op purge;
drop table ${iol_schema}.isbs_xrt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_xrt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_xrt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
