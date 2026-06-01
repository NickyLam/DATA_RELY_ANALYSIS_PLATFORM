/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_forward_config
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
create table ${iol_schema}.tgls_tax_forward_config_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_forward_config
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_forward_config_op purge;
drop table ${iol_schema}.tgls_tax_forward_config_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_forward_config_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_forward_config where 0=1;

create table ${iol_schema}.tgls_tax_forward_config_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_forward_config where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_forward_config_cl(
            stacid -- 账套标记
            ,itemcd -- 结转自科目编号
            ,valuetp -- 结转取值类型
            ,lenddt -- 结转记账方向
            ,pnjudge -- 正负判断
            ,forwdt -- 结转时点
            ,extend1 -- 扩展字段1
            ,extend2 -- 扩展字段2
            ,extend3 -- 扩展字段3
            ,taxfwsq -- 流水号
            ,itemcdto -- 结转至科目编号
            ,orderi -- 顺序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_forward_config_op(
            stacid -- 账套标记
            ,itemcd -- 结转自科目编号
            ,valuetp -- 结转取值类型
            ,lenddt -- 结转记账方向
            ,pnjudge -- 正负判断
            ,forwdt -- 结转时点
            ,extend1 -- 扩展字段1
            ,extend2 -- 扩展字段2
            ,extend3 -- 扩展字段3
            ,taxfwsq -- 流水号
            ,itemcdto -- 结转至科目编号
            ,orderi -- 顺序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 结转自科目编号
    ,nvl(n.valuetp, o.valuetp) as valuetp -- 结转取值类型
    ,nvl(n.lenddt, o.lenddt) as lenddt -- 结转记账方向
    ,nvl(n.pnjudge, o.pnjudge) as pnjudge -- 正负判断
    ,nvl(n.forwdt, o.forwdt) as forwdt -- 结转时点
    ,nvl(n.extend1, o.extend1) as extend1 -- 扩展字段1
    ,nvl(n.extend2, o.extend2) as extend2 -- 扩展字段2
    ,nvl(n.extend3, o.extend3) as extend3 -- 扩展字段3
    ,nvl(n.taxfwsq, o.taxfwsq) as taxfwsq -- 流水号
    ,nvl(n.itemcdto, o.itemcdto) as itemcdto -- 结转至科目编号
    ,nvl(n.orderi, o.orderi) as orderi -- 顺序
    ,case when
            n.stacid is null
            and n.itemcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.itemcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.itemcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_forward_config_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_forward_config where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.itemcd = n.itemcd
where (
        o.stacid is null
        and o.itemcd is null
    )
    or (
        n.stacid is null
        and n.itemcd is null
    )
    or (
        o.valuetp <> n.valuetp
        or o.lenddt <> n.lenddt
        or o.pnjudge <> n.pnjudge
        or o.forwdt <> n.forwdt
        or o.extend1 <> n.extend1
        or o.extend2 <> n.extend2
        or o.extend3 <> n.extend3
        or o.taxfwsq <> n.taxfwsq
        or o.itemcdto <> n.itemcdto
        or o.orderi <> n.orderi
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_forward_config_cl(
            stacid -- 账套标记
            ,itemcd -- 结转自科目编号
            ,valuetp -- 结转取值类型
            ,lenddt -- 结转记账方向
            ,pnjudge -- 正负判断
            ,forwdt -- 结转时点
            ,extend1 -- 扩展字段1
            ,extend2 -- 扩展字段2
            ,extend3 -- 扩展字段3
            ,taxfwsq -- 流水号
            ,itemcdto -- 结转至科目编号
            ,orderi -- 顺序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_forward_config_op(
            stacid -- 账套标记
            ,itemcd -- 结转自科目编号
            ,valuetp -- 结转取值类型
            ,lenddt -- 结转记账方向
            ,pnjudge -- 正负判断
            ,forwdt -- 结转时点
            ,extend1 -- 扩展字段1
            ,extend2 -- 扩展字段2
            ,extend3 -- 扩展字段3
            ,taxfwsq -- 流水号
            ,itemcdto -- 结转至科目编号
            ,orderi -- 顺序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.itemcd -- 结转自科目编号
    ,o.valuetp -- 结转取值类型
    ,o.lenddt -- 结转记账方向
    ,o.pnjudge -- 正负判断
    ,o.forwdt -- 结转时点
    ,o.extend1 -- 扩展字段1
    ,o.extend2 -- 扩展字段2
    ,o.extend3 -- 扩展字段3
    ,o.taxfwsq -- 流水号
    ,o.itemcdto -- 结转至科目编号
    ,o.orderi -- 顺序
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
from ${iol_schema}.tgls_tax_forward_config_bk o
    left join ${iol_schema}.tgls_tax_forward_config_op n
        on
            o.stacid = n.stacid
            and o.itemcd = n.itemcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_forward_config_cl d
        on
            o.stacid = d.stacid
            and o.itemcd = d.itemcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_forward_config;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_forward_config') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_forward_config drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_forward_config add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_forward_config exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_forward_config_cl;
alter table ${iol_schema}.tgls_tax_forward_config exchange partition p_20991231 with table ${iol_schema}.tgls_tax_forward_config_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_forward_config to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_forward_config_op purge;
drop table ${iol_schema}.tgls_tax_forward_config_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_forward_config_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_forward_config',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
