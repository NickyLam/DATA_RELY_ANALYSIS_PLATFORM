/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_zsjyxx
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
create table ${iol_schema}.pams_jxdx_zsjyxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_zsjyxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_zsjyxx_op purge;
drop table ${iol_schema}.pams_jxdx_zsjyxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_zsjyxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_zsjyxx where 0=1;

create table ${iol_schema}.pams_jxdx_zsjyxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_zsjyxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_zsjyxx_cl(
            jxdxdh -- 绩效对象代号
            ,jyrq -- 交易日期
            ,jylsh -- 交易流水号
            ,kmh -- 科目号
            ,ywxzbz -- 业务系统标识,
            ,ywbh -- 业务编号
            ,jzjgdh -- 记账机构编号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,bz -- 币种
            ,sfdm -- 收费代码,
            ,sfmc -- 收费名称
            ,jyje -- 交易金额
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,ywtxbh -- 业务条线代码,
            ,bzcpbh -- 标准产品编号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,khlx -- 客户类型
            ,sfdjh -- 收费单据号
            ,txlsh -- 摊销流水号
            ,qjlsh -- 全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_zsjyxx_op(
            jxdxdh -- 绩效对象代号
            ,jyrq -- 交易日期
            ,jylsh -- 交易流水号
            ,kmh -- 科目号
            ,ywxzbz -- 业务系统标识,
            ,ywbh -- 业务编号
            ,jzjgdh -- 记账机构编号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,bz -- 币种
            ,sfdm -- 收费代码,
            ,sfmc -- 收费名称
            ,jyje -- 交易金额
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,ywtxbh -- 业务条线代码,
            ,bzcpbh -- 标准产品编号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,khlx -- 客户类型
            ,sfdjh -- 收费单据号
            ,txlsh -- 摊销流水号
            ,qjlsh -- 全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.jyrq, o.jyrq) as jyrq -- 交易日期
    ,nvl(n.jylsh, o.jylsh) as jylsh -- 交易流水号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.ywxzbz, o.ywxzbz) as ywxzbz -- 业务系统标识,
    ,nvl(n.ywbh, o.ywbh) as ywbh -- 业务编号
    ,nvl(n.jzjgdh, o.jzjgdh) as jzjgdh -- 记账机构编号
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账户代号
    ,nvl(n.zzh, o.zzh) as zzh -- 子账号
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.sfdm, o.sfdm) as sfdm -- 收费代码,
    ,nvl(n.sfmc, o.sfmc) as sfmc -- 收费名称
    ,nvl(n.jyje, o.jyje) as jyje -- 交易金额
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.ywtxbh, o.ywtxbh) as ywtxbh -- 业务条线代码,
    ,nvl(n.bzcpbh, o.bzcpbh) as bzcpbh -- 标准产品编号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.khlx, o.khlx) as khlx -- 客户类型
    ,nvl(n.sfdjh, o.sfdjh) as sfdjh -- 收费单据号
    ,nvl(n.txlsh, o.txlsh) as txlsh -- 摊销流水号
    ,nvl(n.qjlsh, o.qjlsh) as qjlsh -- 全局流水号
    ,case when
            n.jxdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxdx_zsjyxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_zsjyxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.jyrq <> n.jyrq
        or o.jylsh <> n.jylsh
        or o.kmh <> n.kmh
        or o.ywxzbz <> n.ywxzbz
        or o.ywbh <> n.ywbh
        or o.jzjgdh <> n.jzjgdh
        or o.zhdh <> n.zhdh
        or o.zzh <> n.zzh
        or o.bz <> n.bz
        or o.sfdm <> n.sfdm
        or o.sfmc <> n.sfmc
        or o.jyje <> n.jyje
        or o.khh <> n.khh
        or o.hydh <> n.hydh
        or o.ywtxbh <> n.ywtxbh
        or o.bzcpbh <> n.bzcpbh
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.tjrq <> n.tjrq
        or o.khlx <> n.khlx
        or o.sfdjh <> n.sfdjh
        or o.txlsh <> n.txlsh
        or o.qjlsh <> n.qjlsh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_zsjyxx_cl(
            jxdxdh -- 绩效对象代号
            ,jyrq -- 交易日期
            ,jylsh -- 交易流水号
            ,kmh -- 科目号
            ,ywxzbz -- 业务系统标识,
            ,ywbh -- 业务编号
            ,jzjgdh -- 记账机构编号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,bz -- 币种
            ,sfdm -- 收费代码,
            ,sfmc -- 收费名称
            ,jyje -- 交易金额
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,ywtxbh -- 业务条线代码,
            ,bzcpbh -- 标准产品编号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,khlx -- 客户类型
            ,sfdjh -- 收费单据号
            ,txlsh -- 摊销流水号
            ,qjlsh -- 全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_zsjyxx_op(
            jxdxdh -- 绩效对象代号
            ,jyrq -- 交易日期
            ,jylsh -- 交易流水号
            ,kmh -- 科目号
            ,ywxzbz -- 业务系统标识,
            ,ywbh -- 业务编号
            ,jzjgdh -- 记账机构编号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,bz -- 币种
            ,sfdm -- 收费代码,
            ,sfmc -- 收费名称
            ,jyje -- 交易金额
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,ywtxbh -- 业务条线代码,
            ,bzcpbh -- 标准产品编号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,khlx -- 客户类型
            ,sfdjh -- 收费单据号
            ,txlsh -- 摊销流水号
            ,qjlsh -- 全局流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.jyrq -- 交易日期
    ,o.jylsh -- 交易流水号
    ,o.kmh -- 科目号
    ,o.ywxzbz -- 业务系统标识,
    ,o.ywbh -- 业务编号
    ,o.jzjgdh -- 记账机构编号
    ,o.zhdh -- 账户代号
    ,o.zzh -- 子账号
    ,o.bz -- 币种
    ,o.sfdm -- 收费代码,
    ,o.sfmc -- 收费名称
    ,o.jyje -- 交易金额
    ,o.khh -- 客户号
    ,o.hydh -- 行员代号
    ,o.ywtxbh -- 业务条线代码,
    ,o.bzcpbh -- 标准产品编号
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.tjrq -- 统计日期
    ,o.khlx -- 客户类型
    ,o.sfdjh -- 收费单据号
    ,o.txlsh -- 摊销流水号
    ,o.qjlsh -- 全局流水号
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
from ${iol_schema}.pams_jxdx_zsjyxx_bk o
    left join ${iol_schema}.pams_jxdx_zsjyxx_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_zsjyxx_cl d
        on
            o.jxdxdh = d.jxdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxdx_zsjyxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_zsjyxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_zsjyxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_zsjyxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_zsjyxx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_zsjyxx_cl;
alter table ${iol_schema}.pams_jxdx_zsjyxx exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_zsjyxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_zsjyxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_zsjyxx_op purge;
drop table ${iol_schema}.pams_jxdx_zsjyxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_zsjyxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_zsjyxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
