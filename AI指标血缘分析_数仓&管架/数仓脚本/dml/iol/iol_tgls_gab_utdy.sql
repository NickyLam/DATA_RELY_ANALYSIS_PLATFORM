/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gab_utdy
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
create table ${iol_schema}.tgls_gab_utdy_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gab_utdy
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_utdy_op purge;
drop table ${iol_schema}.tgls_gab_utdy_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_utdy_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_utdy where 0=1;

create table ${iol_schema}.tgls_gab_utdy_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gab_utdy where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_utdy_cl(
            stacid -- 账套标记
            ,acctdt -- 账务会计日期（科目日结单日期）
            ,usercd -- 用户代码
            ,brchcd -- 机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,trdram -- 转账借方本期发生额
            ,trdrnm -- 转账借方笔数
            ,trcram -- 转账贷方本期发生额
            ,trcrnm -- 转账贷方笔数
            ,csdram -- 现金借方本期发生额
            ,csdrnm -- 现金借方笔数
            ,cscram -- 现金贷方本期发生额
            ,cscrnm -- 现金贷方笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_utdy_op(
            stacid -- 账套标记
            ,acctdt -- 账务会计日期（科目日结单日期）
            ,usercd -- 用户代码
            ,brchcd -- 机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,trdram -- 转账借方本期发生额
            ,trdrnm -- 转账借方笔数
            ,trcram -- 转账贷方本期发生额
            ,trcrnm -- 转账贷方笔数
            ,csdram -- 现金借方本期发生额
            ,csdrnm -- 现金借方笔数
            ,cscram -- 现金贷方本期发生额
            ,cscrnm -- 现金贷方笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.acctdt, o.acctdt) as acctdt -- 账务会计日期（科目日结单日期）
    ,nvl(n.usercd, o.usercd) as usercd -- 用户代码
    ,nvl(n.brchcd, o.brchcd) as brchcd -- 机构编号
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种代码
    ,nvl(n.trdram, o.trdram) as trdram -- 转账借方本期发生额
    ,nvl(n.trdrnm, o.trdrnm) as trdrnm -- 转账借方笔数
    ,nvl(n.trcram, o.trcram) as trcram -- 转账贷方本期发生额
    ,nvl(n.trcrnm, o.trcrnm) as trcrnm -- 转账贷方笔数
    ,nvl(n.csdram, o.csdram) as csdram -- 现金借方本期发生额
    ,nvl(n.csdrnm, o.csdrnm) as csdrnm -- 现金借方笔数
    ,nvl(n.cscram, o.cscram) as cscram -- 现金贷方本期发生额
    ,nvl(n.cscrnm, o.cscrnm) as cscrnm -- 现金贷方笔数
    ,case when
            n.stacid is null
            and n.acctdt is null
            and n.usercd is null
            and n.brchcd is null
            and n.itemcd is null
            and n.crcycd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.acctdt is null
            and n.usercd is null
            and n.brchcd is null
            and n.itemcd is null
            and n.crcycd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.acctdt is null
            and n.usercd is null
            and n.brchcd is null
            and n.itemcd is null
            and n.crcycd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gab_utdy_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gab_utdy where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.acctdt = n.acctdt
            and o.usercd = n.usercd
            and o.brchcd = n.brchcd
            and o.itemcd = n.itemcd
            and o.crcycd = n.crcycd
where (
        o.stacid is null
        and o.acctdt is null
        and o.usercd is null
        and o.brchcd is null
        and o.itemcd is null
        and o.crcycd is null
    )
    or (
        n.stacid is null
        and n.acctdt is null
        and n.usercd is null
        and n.brchcd is null
        and n.itemcd is null
        and n.crcycd is null
    )
    or (
        o.trdram <> n.trdram
        or o.trdrnm <> n.trdrnm
        or o.trcram <> n.trcram
        or o.trcrnm <> n.trcrnm
        or o.csdram <> n.csdram
        or o.csdrnm <> n.csdrnm
        or o.cscram <> n.cscram
        or o.cscrnm <> n.cscrnm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gab_utdy_cl(
            stacid -- 账套标记
            ,acctdt -- 账务会计日期（科目日结单日期）
            ,usercd -- 用户代码
            ,brchcd -- 机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,trdram -- 转账借方本期发生额
            ,trdrnm -- 转账借方笔数
            ,trcram -- 转账贷方本期发生额
            ,trcrnm -- 转账贷方笔数
            ,csdram -- 现金借方本期发生额
            ,csdrnm -- 现金借方笔数
            ,cscram -- 现金贷方本期发生额
            ,cscrnm -- 现金贷方笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gab_utdy_op(
            stacid -- 账套标记
            ,acctdt -- 账务会计日期（科目日结单日期）
            ,usercd -- 用户代码
            ,brchcd -- 机构编号
            ,itemcd -- 科目编号
            ,crcycd -- 币种代码
            ,trdram -- 转账借方本期发生额
            ,trdrnm -- 转账借方笔数
            ,trcram -- 转账贷方本期发生额
            ,trcrnm -- 转账贷方笔数
            ,csdram -- 现金借方本期发生额
            ,csdrnm -- 现金借方笔数
            ,cscram -- 现金贷方本期发生额
            ,cscrnm -- 现金贷方笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.acctdt -- 账务会计日期（科目日结单日期）
    ,o.usercd -- 用户代码
    ,o.brchcd -- 机构编号
    ,o.itemcd -- 科目编号
    ,o.crcycd -- 币种代码
    ,o.trdram -- 转账借方本期发生额
    ,o.trdrnm -- 转账借方笔数
    ,o.trcram -- 转账贷方本期发生额
    ,o.trcrnm -- 转账贷方笔数
    ,o.csdram -- 现金借方本期发生额
    ,o.csdrnm -- 现金借方笔数
    ,o.cscram -- 现金贷方本期发生额
    ,o.cscrnm -- 现金贷方笔数
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
from ${iol_schema}.tgls_gab_utdy_bk o
    left join ${iol_schema}.tgls_gab_utdy_op n
        on
            o.stacid = n.stacid
            and o.acctdt = n.acctdt
            and o.usercd = n.usercd
            and o.brchcd = n.brchcd
            and o.itemcd = n.itemcd
            and o.crcycd = n.crcycd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gab_utdy_cl d
        on
            o.stacid = d.stacid
            and o.acctdt = d.acctdt
            and o.usercd = d.usercd
            and o.brchcd = d.brchcd
            and o.itemcd = d.itemcd
            and o.crcycd = d.crcycd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gab_utdy;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gab_utdy') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gab_utdy drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gab_utdy add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gab_utdy exchange partition p_${batch_date} with table ${iol_schema}.tgls_gab_utdy_cl;
alter table ${iol_schema}.tgls_gab_utdy exchange partition p_20991231 with table ${iol_schema}.tgls_gab_utdy_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gab_utdy to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gab_utdy_op purge;
drop table ${iol_schema}.tgls_gab_utdy_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gab_utdy_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gab_utdy',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
