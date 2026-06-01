/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_type
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
create table ${iol_schema}.tgls_tax_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_op purge;
drop table ${iol_schema}.tgls_tax_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type where 0=1;

create table ${iol_schema}.tgls_tax_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,smrytx -- 备注
            ,cfitem -- 结转至科目编号
            ,dfitem -- 借方科目编号
            ,cfname -- 贷方科目名称
            ,dfname -- 借方科目名称
            ,wlitem -- 往来科目编号
            ,wlname -- 往来科目名称
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,booktp -- 税费户类型（1：国税，2：地税）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,shitem -- 上划科目编号
            ,shname -- 上划科目名称
            ,fcwmod -- 外币计提方式
            ,convrt -- 折算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,smrytx -- 备注
            ,cfitem -- 结转至科目编号
            ,dfitem -- 借方科目编号
            ,cfname -- 贷方科目名称
            ,dfname -- 借方科目名称
            ,wlitem -- 往来科目编号
            ,wlname -- 往来科目名称
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,booktp -- 税费户类型（1：国税，2：地税）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,shitem -- 上划科目编号
            ,shname -- 上划科目名称
            ,fcwmod -- 外币计提方式
            ,convrt -- 折算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.taxscd, o.taxscd) as taxscd -- 税种代码
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.cfitem, o.cfitem) as cfitem -- 结转至科目编号
    ,nvl(n.dfitem, o.dfitem) as dfitem -- 借方科目编号
    ,nvl(n.cfname, o.cfname) as cfname -- 贷方科目名称
    ,nvl(n.dfname, o.dfname) as dfname -- 借方科目名称
    ,nvl(n.wlitem, o.wlitem) as wlitem -- 往来科目编号
    ,nvl(n.wlname, o.wlname) as wlname -- 往来科目名称
    ,nvl(n.begndt, o.begndt) as begndt -- 起始日期
    ,nvl(n.endddt, o.endddt) as endddt -- 终止日期
    ,nvl(n.booktp, o.booktp) as booktp -- 税费户类型（1：国税，2：地税）
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 弹性域列(备用)
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 弹性域列(备用)
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 弹性域列(备用)
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 弹性域列(备用)
    ,nvl(n.shitem, o.shitem) as shitem -- 上划科目编号
    ,nvl(n.shname, o.shname) as shname -- 上划科目名称
    ,nvl(n.fcwmod, o.fcwmod) as fcwmod -- 外币计提方式
    ,nvl(n.convrt, o.convrt) as convrt -- 折算汇率
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.begndt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.begndt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.begndt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.begndt = n.begndt
where (
        o.stacid is null
        and o.taxscd is null
        and o.begndt is null
    )
    or (
        n.stacid is null
        and n.taxscd is null
        and n.begndt is null
    )
    or (
        o.smrytx <> n.smrytx
        or o.cfitem <> n.cfitem
        or o.dfitem <> n.dfitem
        or o.cfname <> n.cfname
        or o.dfname <> n.dfname
        or o.wlitem <> n.wlitem
        or o.wlname <> n.wlname
        or o.endddt <> n.endddt
        or o.booktp <> n.booktp
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
        or o.shitem <> n.shitem
        or o.shname <> n.shname
        or o.fcwmod <> n.fcwmod
        or o.convrt <> n.convrt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,smrytx -- 备注
            ,cfitem -- 结转至科目编号
            ,dfitem -- 借方科目编号
            ,cfname -- 贷方科目名称
            ,dfname -- 借方科目名称
            ,wlitem -- 往来科目编号
            ,wlname -- 往来科目名称
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,booktp -- 税费户类型（1：国税，2：地税）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,shitem -- 上划科目编号
            ,shname -- 上划科目名称
            ,fcwmod -- 外币计提方式
            ,convrt -- 折算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,smrytx -- 备注
            ,cfitem -- 结转至科目编号
            ,dfitem -- 借方科目编号
            ,cfname -- 贷方科目名称
            ,dfname -- 借方科目名称
            ,wlitem -- 往来科目编号
            ,wlname -- 往来科目名称
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,booktp -- 税费户类型（1：国税，2：地税）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,shitem -- 上划科目编号
            ,shname -- 上划科目名称
            ,fcwmod -- 外币计提方式
            ,convrt -- 折算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.taxscd -- 税种代码
    ,o.smrytx -- 备注
    ,o.cfitem -- 结转至科目编号
    ,o.dfitem -- 借方科目编号
    ,o.cfname -- 贷方科目名称
    ,o.dfname -- 借方科目名称
    ,o.wlitem -- 往来科目编号
    ,o.wlname -- 往来科目名称
    ,o.begndt -- 起始日期
    ,o.endddt -- 终止日期
    ,o.booktp -- 税费户类型（1：国税，2：地税）
    ,o.attribute1 -- 弹性域列(备用)
    ,o.attribute2 -- 弹性域列(备用)
    ,o.attribute3 -- 弹性域列(备用)
    ,o.attribute4 -- 弹性域列(备用)
    ,o.shitem -- 上划科目编号
    ,o.shname -- 上划科目名称
    ,o.fcwmod -- 外币计提方式
    ,o.convrt -- 折算汇率
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
from ${iol_schema}.tgls_tax_type_bk o
    left join ${iol_schema}.tgls_tax_type_op n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.begndt = n.begndt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_type_cl d
        on
            o.stacid = d.stacid
            and o.taxscd = d.taxscd
            and o.begndt = d.begndt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_type exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_type_cl;
alter table ${iol_schema}.tgls_tax_type exchange partition p_20991231 with table ${iol_schema}.tgls_tax_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_op purge;
drop table ${iol_schema}.tgls_tax_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
