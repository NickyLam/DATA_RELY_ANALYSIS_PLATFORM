/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_gjs
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
create table ${iol_schema}.pams_jxdx_gjs_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_gjs
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_gjs_op purge;
drop table ${iol_schema}.pams_jxdx_gjs_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_gjs_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_gjs where 0=1;

create table ${iol_schema}.pams_jxdx_gjs_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_gjs where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_gjs_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,ddh -- 行内订单号
            ,yhlsh -- 银行流水号
            ,jyrq -- 交易日期
            ,ddrq -- 订单日期
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,cpcs -- 产品成色
            ,hjl -- 含金量
            ,hyl -- 含银量
            ,gmsl -- 购买数量
            ,gysmc -- 供应商名称
            ,xsqd -- 销售渠道
            ,jydj -- 交易单价
            ,zhye -- 账户余额
            ,sxf -- 手续费
            ,hydh -- 行员代号
            ,sjly -- 数据来源
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,zhdh -- 账户代号
            ,cpfldm -- 产品分类代码
            ,tdrq -- 退单日期
            ,scddh -- 商城订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_gjs_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,ddh -- 行内订单号
            ,yhlsh -- 银行流水号
            ,jyrq -- 交易日期
            ,ddrq -- 订单日期
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,cpcs -- 产品成色
            ,hjl -- 含金量
            ,hyl -- 含银量
            ,gmsl -- 购买数量
            ,gysmc -- 供应商名称
            ,xsqd -- 销售渠道
            ,jydj -- 交易单价
            ,zhye -- 账户余额
            ,sxf -- 手续费
            ,hydh -- 行员代号
            ,sjly -- 数据来源
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,zhdh -- 账户代号
            ,cpfldm -- 产品分类代码
            ,tdrq -- 退单日期
            ,scddh -- 商城订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.ddh, o.ddh) as ddh -- 行内订单号
    ,nvl(n.yhlsh, o.yhlsh) as yhlsh -- 银行流水号
    ,nvl(n.jyrq, o.jyrq) as jyrq -- 交易日期
    ,nvl(n.ddrq, o.ddrq) as ddrq -- 订单日期
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khmc, o.khmc) as khmc -- 客户名称
    ,nvl(n.cph, o.cph) as cph -- 产品号
    ,nvl(n.cpmc, o.cpmc) as cpmc -- 产品名称
    ,nvl(n.cpcs, o.cpcs) as cpcs -- 产品成色
    ,nvl(n.hjl, o.hjl) as hjl -- 含金量
    ,nvl(n.hyl, o.hyl) as hyl -- 含银量
    ,nvl(n.gmsl, o.gmsl) as gmsl -- 购买数量
    ,nvl(n.gysmc, o.gysmc) as gysmc -- 供应商名称
    ,nvl(n.xsqd, o.xsqd) as xsqd -- 销售渠道
    ,nvl(n.jydj, o.jydj) as jydj -- 交易单价
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.sxf, o.sxf) as sxf -- 手续费
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.sjly, o.sjly) as sjly -- 数据来源
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账户代号
    ,nvl(n.cpfldm, o.cpfldm) as cpfldm -- 产品分类代码
    ,nvl(n.tdrq, o.tdrq) as tdrq -- 退单日期
    ,nvl(n.scddh, o.scddh) as scddh -- 商城订单号
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
from (select * from ${iol_schema}.pams_jxdx_gjs_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_gjs where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.tjrq <> n.tjrq
        or o.ddh <> n.ddh
        or o.yhlsh <> n.yhlsh
        or o.jyrq <> n.jyrq
        or o.ddrq <> n.ddrq
        or o.jgdh <> n.jgdh
        or o.khh <> n.khh
        or o.khmc <> n.khmc
        or o.cph <> n.cph
        or o.cpmc <> n.cpmc
        or o.cpcs <> n.cpcs
        or o.hjl <> n.hjl
        or o.hyl <> n.hyl
        or o.gmsl <> n.gmsl
        or o.gysmc <> n.gysmc
        or o.xsqd <> n.xsqd
        or o.jydj <> n.jydj
        or o.zhye <> n.zhye
        or o.sxf <> n.sxf
        or o.hydh <> n.hydh
        or o.sjly <> n.sjly
        or o.khdxdh <> n.khdxdh
        or o.gxhslx <> n.gxhslx
        or o.zhdh <> n.zhdh
        or o.cpfldm <> n.cpfldm
        or o.tdrq <> n.tdrq
        or o.scddh <> n.scddh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_gjs_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,ddh -- 行内订单号
            ,yhlsh -- 银行流水号
            ,jyrq -- 交易日期
            ,ddrq -- 订单日期
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,cpcs -- 产品成色
            ,hjl -- 含金量
            ,hyl -- 含银量
            ,gmsl -- 购买数量
            ,gysmc -- 供应商名称
            ,xsqd -- 销售渠道
            ,jydj -- 交易单价
            ,zhye -- 账户余额
            ,sxf -- 手续费
            ,hydh -- 行员代号
            ,sjly -- 数据来源
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,zhdh -- 账户代号
            ,cpfldm -- 产品分类代码
            ,tdrq -- 退单日期
            ,scddh -- 商城订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_gjs_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,ddh -- 行内订单号
            ,yhlsh -- 银行流水号
            ,jyrq -- 交易日期
            ,ddrq -- 订单日期
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,cpcs -- 产品成色
            ,hjl -- 含金量
            ,hyl -- 含银量
            ,gmsl -- 购买数量
            ,gysmc -- 供应商名称
            ,xsqd -- 销售渠道
            ,jydj -- 交易单价
            ,zhye -- 账户余额
            ,sxf -- 手续费
            ,hydh -- 行员代号
            ,sjly -- 数据来源
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,zhdh -- 账户代号
            ,cpfldm -- 产品分类代码
            ,tdrq -- 退单日期
            ,scddh -- 商城订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.tjrq -- 统计日期
    ,o.ddh -- 行内订单号
    ,o.yhlsh -- 银行流水号
    ,o.jyrq -- 交易日期
    ,o.ddrq -- 订单日期
    ,o.jgdh -- 机构代号
    ,o.khh -- 客户号
    ,o.khmc -- 客户名称
    ,o.cph -- 产品号
    ,o.cpmc -- 产品名称
    ,o.cpcs -- 产品成色
    ,o.hjl -- 含金量
    ,o.hyl -- 含银量
    ,o.gmsl -- 购买数量
    ,o.gysmc -- 供应商名称
    ,o.xsqd -- 销售渠道
    ,o.jydj -- 交易单价
    ,o.zhye -- 账户余额
    ,o.sxf -- 手续费
    ,o.hydh -- 行员代号
    ,o.sjly -- 数据来源
    ,o.khdxdh -- 考核对象代号
    ,o.gxhslx -- 关系函数类型
    ,o.zhdh -- 账户代号
    ,o.cpfldm -- 产品分类代码
    ,o.tdrq -- 退单日期
    ,o.scddh -- 商城订单号
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
from ${iol_schema}.pams_jxdx_gjs_bk o
    left join ${iol_schema}.pams_jxdx_gjs_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_gjs_cl d
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
--truncate table ${iol_schema}.pams_jxdx_gjs;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_gjs') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_gjs drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_gjs add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_gjs exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_gjs_cl;
alter table ${iol_schema}.pams_jxdx_gjs exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_gjs_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_gjs to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_gjs_op purge;
drop table ${iol_schema}.pams_jxdx_gjs_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_gjs_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_gjs',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
