/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51cfsvcconfig
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
create table ${iol_schema}.mpcs_a51cfsvcconfig_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a51cfsvcconfig;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51cfsvcconfig_op purge;
drop table ${iol_schema}.mpcs_a51cfsvcconfig_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51cfsvcconfig_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51cfsvcconfig where 0=1;

create table ${iol_schema}.mpcs_a51cfsvcconfig_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51cfsvcconfig where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51cfsvcconfig_cl(
            cfgcode -- 业务配置码
            ,levela -- 业务配置级别A
            ,levelb -- 业务配置级别B
            ,levelc -- 业务配置级别C
            ,leveld -- 业务配置级别D
            ,levele -- 业务配置级别E
            ,brnlevel -- 适用机构级别
            ,brnnbr -- 适用的机构号
            ,lowerval -- 数字型级别的下限
            ,value1 -- 业务配置值1
            ,value2 -- 业务配置值2
            ,value3 -- 业务配置值3
            ,value4 -- 业务配置值4
            ,value5 -- 业务配置值5
            ,value6 -- 业务配置值6
            ,value7 -- 业务配置值7
            ,value8 -- 业务配置值8
            ,value9 -- 业务配置值9
            ,value10 -- 业务配置值10
            ,cfgnbr -- 业务配置号
            ,cfgrem -- 业务配置说明
            ,prodnbr -- 管理产品实例号
            ,changdate -- 更新日期
            ,changtime -- 更新时间
            ,reserv20 -- 特殊码20
            ,rcdver -- 记录更新版本号
            ,rcdstatus -- 记录状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51cfsvcconfig_op(
            cfgcode -- 业务配置码
            ,levela -- 业务配置级别A
            ,levelb -- 业务配置级别B
            ,levelc -- 业务配置级别C
            ,leveld -- 业务配置级别D
            ,levele -- 业务配置级别E
            ,brnlevel -- 适用机构级别
            ,brnnbr -- 适用的机构号
            ,lowerval -- 数字型级别的下限
            ,value1 -- 业务配置值1
            ,value2 -- 业务配置值2
            ,value3 -- 业务配置值3
            ,value4 -- 业务配置值4
            ,value5 -- 业务配置值5
            ,value6 -- 业务配置值6
            ,value7 -- 业务配置值7
            ,value8 -- 业务配置值8
            ,value9 -- 业务配置值9
            ,value10 -- 业务配置值10
            ,cfgnbr -- 业务配置号
            ,cfgrem -- 业务配置说明
            ,prodnbr -- 管理产品实例号
            ,changdate -- 更新日期
            ,changtime -- 更新时间
            ,reserv20 -- 特殊码20
            ,rcdver -- 记录更新版本号
            ,rcdstatus -- 记录状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cfgcode, o.cfgcode) as cfgcode -- 业务配置码
    ,nvl(n.levela, o.levela) as levela -- 业务配置级别A
    ,nvl(n.levelb, o.levelb) as levelb -- 业务配置级别B
    ,nvl(n.levelc, o.levelc) as levelc -- 业务配置级别C
    ,nvl(n.leveld, o.leveld) as leveld -- 业务配置级别D
    ,nvl(n.levele, o.levele) as levele -- 业务配置级别E
    ,nvl(n.brnlevel, o.brnlevel) as brnlevel -- 适用机构级别
    ,nvl(n.brnnbr, o.brnnbr) as brnnbr -- 适用的机构号
    ,nvl(n.lowerval, o.lowerval) as lowerval -- 数字型级别的下限
    ,nvl(n.value1, o.value1) as value1 -- 业务配置值1
    ,nvl(n.value2, o.value2) as value2 -- 业务配置值2
    ,nvl(n.value3, o.value3) as value3 -- 业务配置值3
    ,nvl(n.value4, o.value4) as value4 -- 业务配置值4
    ,nvl(n.value5, o.value5) as value5 -- 业务配置值5
    ,nvl(n.value6, o.value6) as value6 -- 业务配置值6
    ,nvl(n.value7, o.value7) as value7 -- 业务配置值7
    ,nvl(n.value8, o.value8) as value8 -- 业务配置值8
    ,nvl(n.value9, o.value9) as value9 -- 业务配置值9
    ,nvl(n.value10, o.value10) as value10 -- 业务配置值10
    ,nvl(n.cfgnbr, o.cfgnbr) as cfgnbr -- 业务配置号
    ,nvl(n.cfgrem, o.cfgrem) as cfgrem -- 业务配置说明
    ,nvl(n.prodnbr, o.prodnbr) as prodnbr -- 管理产品实例号
    ,nvl(n.changdate, o.changdate) as changdate -- 更新日期
    ,nvl(n.changtime, o.changtime) as changtime -- 更新时间
    ,nvl(n.reserv20, o.reserv20) as reserv20 -- 特殊码20
    ,nvl(n.rcdver, o.rcdver) as rcdver -- 记录更新版本号
    ,nvl(n.rcdstatus, o.rcdstatus) as rcdstatus -- 记录状态
    ,case when
            n.cfgcode is null
            and n.levela is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cfgcode is null
            and n.levela is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cfgcode is null
            and n.levela is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a51cfsvcconfig_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a51cfsvcconfig where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cfgcode = n.cfgcode
            and o.levela = n.levela
where (
        o.cfgcode is null
        and o.levela is null
    )
    or (
        n.cfgcode is null
        and n.levela is null
    )
    or (
        o.levelb <> n.levelb
        or o.levelc <> n.levelc
        or o.leveld <> n.leveld
        or o.levele <> n.levele
        or o.brnlevel <> n.brnlevel
        or o.brnnbr <> n.brnnbr
        or o.lowerval <> n.lowerval
        or o.value1 <> n.value1
        or o.value2 <> n.value2
        or o.value3 <> n.value3
        or o.value4 <> n.value4
        or o.value5 <> n.value5
        or o.value6 <> n.value6
        or o.value7 <> n.value7
        or o.value8 <> n.value8
        or o.value9 <> n.value9
        or o.value10 <> n.value10
        or o.cfgnbr <> n.cfgnbr
        or o.cfgrem <> n.cfgrem
        or o.prodnbr <> n.prodnbr
        or o.changdate <> n.changdate
        or o.changtime <> n.changtime
        or o.reserv20 <> n.reserv20
        or o.rcdver <> n.rcdver
        or o.rcdstatus <> n.rcdstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51cfsvcconfig_cl(
            cfgcode -- 业务配置码
            ,levela -- 业务配置级别A
            ,levelb -- 业务配置级别B
            ,levelc -- 业务配置级别C
            ,leveld -- 业务配置级别D
            ,levele -- 业务配置级别E
            ,brnlevel -- 适用机构级别
            ,brnnbr -- 适用的机构号
            ,lowerval -- 数字型级别的下限
            ,value1 -- 业务配置值1
            ,value2 -- 业务配置值2
            ,value3 -- 业务配置值3
            ,value4 -- 业务配置值4
            ,value5 -- 业务配置值5
            ,value6 -- 业务配置值6
            ,value7 -- 业务配置值7
            ,value8 -- 业务配置值8
            ,value9 -- 业务配置值9
            ,value10 -- 业务配置值10
            ,cfgnbr -- 业务配置号
            ,cfgrem -- 业务配置说明
            ,prodnbr -- 管理产品实例号
            ,changdate -- 更新日期
            ,changtime -- 更新时间
            ,reserv20 -- 特殊码20
            ,rcdver -- 记录更新版本号
            ,rcdstatus -- 记录状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51cfsvcconfig_op(
            cfgcode -- 业务配置码
            ,levela -- 业务配置级别A
            ,levelb -- 业务配置级别B
            ,levelc -- 业务配置级别C
            ,leveld -- 业务配置级别D
            ,levele -- 业务配置级别E
            ,brnlevel -- 适用机构级别
            ,brnnbr -- 适用的机构号
            ,lowerval -- 数字型级别的下限
            ,value1 -- 业务配置值1
            ,value2 -- 业务配置值2
            ,value3 -- 业务配置值3
            ,value4 -- 业务配置值4
            ,value5 -- 业务配置值5
            ,value6 -- 业务配置值6
            ,value7 -- 业务配置值7
            ,value8 -- 业务配置值8
            ,value9 -- 业务配置值9
            ,value10 -- 业务配置值10
            ,cfgnbr -- 业务配置号
            ,cfgrem -- 业务配置说明
            ,prodnbr -- 管理产品实例号
            ,changdate -- 更新日期
            ,changtime -- 更新时间
            ,reserv20 -- 特殊码20
            ,rcdver -- 记录更新版本号
            ,rcdstatus -- 记录状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cfgcode -- 业务配置码
    ,o.levela -- 业务配置级别A
    ,o.levelb -- 业务配置级别B
    ,o.levelc -- 业务配置级别C
    ,o.leveld -- 业务配置级别D
    ,o.levele -- 业务配置级别E
    ,o.brnlevel -- 适用机构级别
    ,o.brnnbr -- 适用的机构号
    ,o.lowerval -- 数字型级别的下限
    ,o.value1 -- 业务配置值1
    ,o.value2 -- 业务配置值2
    ,o.value3 -- 业务配置值3
    ,o.value4 -- 业务配置值4
    ,o.value5 -- 业务配置值5
    ,o.value6 -- 业务配置值6
    ,o.value7 -- 业务配置值7
    ,o.value8 -- 业务配置值8
    ,o.value9 -- 业务配置值9
    ,o.value10 -- 业务配置值10
    ,o.cfgnbr -- 业务配置号
    ,o.cfgrem -- 业务配置说明
    ,o.prodnbr -- 管理产品实例号
    ,o.changdate -- 更新日期
    ,o.changtime -- 更新时间
    ,o.reserv20 -- 特殊码20
    ,o.rcdver -- 记录更新版本号
    ,o.rcdstatus -- 记录状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a51cfsvcconfig_bk o
    left join ${iol_schema}.mpcs_a51cfsvcconfig_op n
        on
            o.cfgcode = n.cfgcode
            and o.levela = n.levela
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a51cfsvcconfig_cl d
        on
            o.cfgcode = d.cfgcode
            and o.levela = d.levela
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a51cfsvcconfig;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a51cfsvcconfig exchange partition p_19000101 with table ${iol_schema}.mpcs_a51cfsvcconfig_cl;
alter table ${iol_schema}.mpcs_a51cfsvcconfig exchange partition p_20991231 with table ${iol_schema}.mpcs_a51cfsvcconfig_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51cfsvcconfig to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51cfsvcconfig_op purge;
drop table ${iol_schema}.mpcs_a51cfsvcconfig_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a51cfsvcconfig_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51cfsvcconfig',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
