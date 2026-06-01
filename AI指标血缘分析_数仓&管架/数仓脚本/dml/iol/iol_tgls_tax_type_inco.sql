/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_type_inco
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
create table ${iol_schema}.tgls_tax_type_inco_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_type_inco
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_inco_op purge;
drop table ${iol_schema}.tgls_tax_type_inco_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_inco_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_inco where 0=1;

create table ${iol_schema}.tgls_tax_type_inco_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_inco where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_inco_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 缴纳税费
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,proffm -- 利润总额公式
            ,busifm -- 营业总额公式
            ,nstzfm -- 纳税调整公式
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_inco_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 缴纳税费
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,proffm -- 利润总额公式
            ,busifm -- 营业总额公式
            ,nstzfm -- 纳税调整公式
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.taxscd, o.taxscd) as taxscd -- 税种代码
    ,nvl(n.deptcd, o.deptcd) as deptcd -- 机构编号
    ,nvl(n.vatxrt, o.vatxrt) as vatxrt -- 缴纳税费
    ,nvl(n.begndt, o.begndt) as begndt -- 起始日期
    ,nvl(n.endddt, o.endddt) as endddt -- 终止日期
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.proffm, o.proffm) as proffm -- 利润总额公式
    ,nvl(n.busifm, o.busifm) as busifm -- 营业总额公式
    ,nvl(n.nstzfm, o.nstzfm) as nstzfm -- 纳税调整公式
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 弹性域列(备用)
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 弹性域列(备用)
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 弹性域列(备用)
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 弹性域列(备用)
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.taxscd is null
            and n.deptcd is null
            and n.begndt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_type_inco_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_type_inco where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.deptcd = n.deptcd
            and o.begndt = n.begndt
where (
        o.stacid is null
        and o.taxscd is null
        and o.deptcd is null
        and o.begndt is null
    )
    or (
        n.stacid is null
        and n.taxscd is null
        and n.deptcd is null
        and n.begndt is null
    )
    or (
        o.vatxrt <> n.vatxrt
        or o.endddt <> n.endddt
        or o.smrytx <> n.smrytx
        or o.proffm <> n.proffm
        or o.busifm <> n.busifm
        or o.nstzfm <> n.nstzfm
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_inco_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 缴纳税费
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,proffm -- 利润总额公式
            ,busifm -- 营业总额公式
            ,nstzfm -- 纳税调整公式
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_inco_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,vatxrt -- 缴纳税费
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,proffm -- 利润总额公式
            ,busifm -- 营业总额公式
            ,nstzfm -- 纳税调整公式
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.taxscd -- 税种代码
    ,o.deptcd -- 机构编号
    ,o.vatxrt -- 缴纳税费
    ,o.begndt -- 起始日期
    ,o.endddt -- 终止日期
    ,o.smrytx -- 备注
    ,o.proffm -- 利润总额公式
    ,o.busifm -- 营业总额公式
    ,o.nstzfm -- 纳税调整公式
    ,o.attribute1 -- 弹性域列(备用)
    ,o.attribute2 -- 弹性域列(备用)
    ,o.attribute3 -- 弹性域列(备用)
    ,o.attribute4 -- 弹性域列(备用)
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
from ${iol_schema}.tgls_tax_type_inco_bk o
    left join ${iol_schema}.tgls_tax_type_inco_op n
        on
            o.stacid = n.stacid
            and o.taxscd = n.taxscd
            and o.deptcd = n.deptcd
            and o.begndt = n.begndt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_type_inco_cl d
        on
            o.stacid = d.stacid
            and o.taxscd = d.taxscd
            and o.deptcd = d.deptcd
            and o.begndt = d.begndt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_type_inco;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_type_inco') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_type_inco drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_type_inco add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_type_inco exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_type_inco_cl;
alter table ${iol_schema}.tgls_tax_type_inco exchange partition p_20991231 with table ${iol_schema}.tgls_tax_type_inco_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_type_inco to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_inco_op purge;
drop table ${iol_schema}.tgls_tax_type_inco_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_type_inco_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_type_inco',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
