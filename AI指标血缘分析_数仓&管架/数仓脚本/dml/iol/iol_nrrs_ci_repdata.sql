/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_ci_repdata
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
create table ${iol_schema}.nrrs_ci_repdata_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_ci_repdata;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_repdata_op purge;
drop table ${iol_schema}.nrrs_ci_repdata_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_repdata_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_repdata where 0=1;

create table ${iol_schema}.nrrs_ci_repdata_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_repdata where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_repdata_cl(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,frepcode -- 报表编号
            ,rowno -- 行号
            ,colno -- 列号
            ,coursecode -- 科目代码
            ,fstcoldata -- 第一列数据
            ,sndcoldata -- 第二列数据
            ,showname -- 展示名称
            ,regioncode -- 地区号
            ,repperiod -- 报表周期
            ,reptype -- 财务报表类型
            ,isaudit -- 是否审计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_repdata_op(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,frepcode -- 报表编号
            ,rowno -- 行号
            ,colno -- 列号
            ,coursecode -- 科目代码
            ,fstcoldata -- 第一列数据
            ,sndcoldata -- 第二列数据
            ,showname -- 展示名称
            ,regioncode -- 地区号
            ,repperiod -- 报表周期
            ,reptype -- 财务报表类型
            ,isaudit -- 是否审计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.repno, o.repno) as repno -- 报表期数
    ,nvl(n.caliber, o.caliber) as caliber -- 报表口径
    ,nvl(n.frepcode, o.frepcode) as frepcode -- 报表编号
    ,nvl(n.rowno, o.rowno) as rowno -- 行号
    ,nvl(n.colno, o.colno) as colno -- 列号
    ,nvl(n.coursecode, o.coursecode) as coursecode -- 科目代码
    ,nvl(n.fstcoldata, o.fstcoldata) as fstcoldata -- 第一列数据
    ,nvl(n.sndcoldata, o.sndcoldata) as sndcoldata -- 第二列数据
    ,nvl(n.showname, o.showname) as showname -- 展示名称
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 地区号
    ,nvl(n.repperiod, o.repperiod) as repperiod -- 报表周期
    ,nvl(n.reptype, o.reptype) as reptype -- 财务报表类型
    ,nvl(n.isaudit, o.isaudit) as isaudit -- 是否审计
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.frepcode is null
            and n.rowno is null
            and n.colno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.frepcode is null
            and n.rowno is null
            and n.colno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custid is null
            and n.repno is null
            and n.caliber is null
            and n.frepcode is null
            and n.rowno is null
            and n.colno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_ci_repdata_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_ci_repdata where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custid = n.custid
            and o.repno = n.repno
            and o.caliber = n.caliber
            and o.frepcode = n.frepcode
            and o.rowno = n.rowno
            and o.colno = n.colno
where (
        o.custid is null
        and o.repno is null
        and o.caliber is null
        and o.frepcode is null
        and o.rowno is null
        and o.colno is null
    )
    or (
        n.custid is null
        and n.repno is null
        and n.caliber is null
        and n.frepcode is null
        and n.rowno is null
        and n.colno is null
    )
    or (
        o.coursecode <> n.coursecode
        or o.fstcoldata <> n.fstcoldata
        or o.sndcoldata <> n.sndcoldata
        or o.showname <> n.showname
        or o.regioncode <> n.regioncode
        or o.repperiod <> n.repperiod
        or o.reptype <> n.reptype
        or o.isaudit <> n.isaudit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_repdata_cl(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,frepcode -- 报表编号
            ,rowno -- 行号
            ,colno -- 列号
            ,coursecode -- 科目代码
            ,fstcoldata -- 第一列数据
            ,sndcoldata -- 第二列数据
            ,showname -- 展示名称
            ,regioncode -- 地区号
            ,repperiod -- 报表周期
            ,reptype -- 财务报表类型
            ,isaudit -- 是否审计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_repdata_op(
            custid -- 客户号
            ,repno -- 报表期数
            ,caliber -- 报表口径
            ,frepcode -- 报表编号
            ,rowno -- 行号
            ,colno -- 列号
            ,coursecode -- 科目代码
            ,fstcoldata -- 第一列数据
            ,sndcoldata -- 第二列数据
            ,showname -- 展示名称
            ,regioncode -- 地区号
            ,repperiod -- 报表周期
            ,reptype -- 财务报表类型
            ,isaudit -- 是否审计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 客户号
    ,o.repno -- 报表期数
    ,o.caliber -- 报表口径
    ,o.frepcode -- 报表编号
    ,o.rowno -- 行号
    ,o.colno -- 列号
    ,o.coursecode -- 科目代码
    ,o.fstcoldata -- 第一列数据
    ,o.sndcoldata -- 第二列数据
    ,o.showname -- 展示名称
    ,o.regioncode -- 地区号
    ,o.repperiod -- 报表周期
    ,o.reptype -- 财务报表类型
    ,o.isaudit -- 是否审计
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_ci_repdata_bk o
    left join ${iol_schema}.nrrs_ci_repdata_op n
        on
            o.custid = n.custid
            and o.repno = n.repno
            and o.caliber = n.caliber
            and o.frepcode = n.frepcode
            and o.rowno = n.rowno
            and o.colno = n.colno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_ci_repdata_cl d
        on
            o.custid = d.custid
            and o.repno = d.repno
            and o.caliber = d.caliber
            and o.frepcode = d.frepcode
            and o.rowno = d.rowno
            and o.colno = d.colno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_ci_repdata;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_ci_repdata exchange partition p_19000101 with table ${iol_schema}.nrrs_ci_repdata_cl;
alter table ${iol_schema}.nrrs_ci_repdata exchange partition p_20991231 with table ${iol_schema}.nrrs_ci_repdata_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_ci_repdata to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_repdata_op purge;
drop table ${iol_schema}.nrrs_ci_repdata_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_ci_repdata_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_ci_repdata',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
