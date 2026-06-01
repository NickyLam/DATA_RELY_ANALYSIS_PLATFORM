/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_zytsyfx
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
create table ${iol_schema}.pams_jxdx_zytsyfx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_zytsyfx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_zytsyfx_op purge;
drop table ${iol_schema}.pams_jxdx_zytsyfx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_zytsyfx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_zytsyfx where 0=1;

create table ${iol_schema}.pams_jxdx_zytsyfx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_zytsyfx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_zytsyfx_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 数据日期
            ,zqdm -- 债券代码
            ,tzid -- 投组id
            ,zqmc -- 债券名称
            ,qxrq -- 起息日
            ,dqrq -- 到期日
            ,me -- 面额
            ,sybj -- 剩余本金
            ,pjcb -- 平均成本
            ,zytjj -- 折溢摊净价
            ,yjlx -- 应计利息
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,bz -- 币别
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,jgdh -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,lxsr -- 利息收入
            ,zyt -- 折溢摊
            ,mmjc -- 买卖价差
            ,fdyk -- 浮动盈亏
            ,hydh -- 行员代号
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_zytsyfx_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 数据日期
            ,zqdm -- 债券代码
            ,tzid -- 投组id
            ,zqmc -- 债券名称
            ,qxrq -- 起息日
            ,dqrq -- 到期日
            ,me -- 面额
            ,sybj -- 剩余本金
            ,pjcb -- 平均成本
            ,zytjj -- 折溢摊净价
            ,yjlx -- 应计利息
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,bz -- 币别
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,jgdh -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,lxsr -- 利息收入
            ,zyt -- 折溢摊
            ,mmjc -- 买卖价差
            ,fdyk -- 浮动盈亏
            ,hydh -- 行员代号
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 数据日期
    ,nvl(n.zqdm, o.zqdm) as zqdm -- 债券代码
    ,nvl(n.tzid, o.tzid) as tzid -- 投组id
    ,nvl(n.zqmc, o.zqmc) as zqmc -- 债券名称
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日
    ,nvl(n.me, o.me) as me -- 面额
    ,nvl(n.sybj, o.sybj) as sybj -- 剩余本金
    ,nvl(n.pjcb, o.pjcb) as pjcb -- 平均成本
    ,nvl(n.zytjj, o.zytjj) as zytjj -- 折溢摊净价
    ,nvl(n.yjlx, o.yjlx) as yjlx -- 应计利息
    ,nvl(n.zcfzfl, o.zcfzfl) as zcfzfl -- 资产负债分类
    ,nvl(n.zqdmmc, o.zqdmmc) as zqdmmc -- 债券代码名称
    ,nvl(n.bz, o.bz) as bz -- 币别
    ,nvl(n.xzrq, o.xzrq) as xzrq -- 修正久期
    ,nvl(n.dv01, o.dv01) as dv01 -- DV01
    ,nvl(n.jytzmc, o.jytzmc) as jytzmc -- 交易投组名称
    ,nvl(n.tzsfl, o.tzsfl) as tzsfl -- 投组三分类
    ,nvl(n.zhid, o.zhid) as zhid -- 账户ID
    ,nvl(n.zhdm, o.zhdm) as zhdm -- 账户代码
    ,nvl(n.zhmc, o.zhmc) as zhmc -- 账户名称
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 部门机构
    ,nvl(n.bzcp, o.bzcp) as bzcp -- 标准产品
    ,nvl(n.dqsyl, o.dqsyl) as dqsyl -- 到期收益率
    ,nvl(n.dcq, o.dcq) as dcq -- 待偿期
    ,nvl(n.zqlx, o.zqlx) as zqlx -- 债券类型
    ,nvl(n.lxsr, o.lxsr) as lxsr -- 利息收入
    ,nvl(n.zyt, o.zyt) as zyt -- 折溢摊
    ,nvl(n.mmjc, o.mmjc) as mmjc -- 买卖价差
    ,nvl(n.fdyk, o.fdyk) as fdyk -- 浮动盈亏
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
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
from (select * from ${iol_schema}.pams_jxdx_zytsyfx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_zytsyfx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.zqdm <> n.zqdm
        or o.tzid <> n.tzid
        or o.zqmc <> n.zqmc
        or o.qxrq <> n.qxrq
        or o.dqrq <> n.dqrq
        or o.me <> n.me
        or o.sybj <> n.sybj
        or o.pjcb <> n.pjcb
        or o.zytjj <> n.zytjj
        or o.yjlx <> n.yjlx
        or o.zcfzfl <> n.zcfzfl
        or o.zqdmmc <> n.zqdmmc
        or o.bz <> n.bz
        or o.xzrq <> n.xzrq
        or o.dv01 <> n.dv01
        or o.jytzmc <> n.jytzmc
        or o.tzsfl <> n.tzsfl
        or o.zhid <> n.zhid
        or o.zhdm <> n.zhdm
        or o.zhmc <> n.zhmc
        or o.jgdh <> n.jgdh
        or o.bzcp <> n.bzcp
        or o.dqsyl <> n.dqsyl
        or o.dcq <> n.dcq
        or o.zqlx <> n.zqlx
        or o.lxsr <> n.lxsr
        or o.zyt <> n.zyt
        or o.mmjc <> n.mmjc
        or o.fdyk <> n.fdyk
        or o.hydh <> n.hydh
        or o.khdxdh <> n.khdxdh
        or o.gxhslx <> n.gxhslx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_zytsyfx_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 数据日期
            ,zqdm -- 债券代码
            ,tzid -- 投组id
            ,zqmc -- 债券名称
            ,qxrq -- 起息日
            ,dqrq -- 到期日
            ,me -- 面额
            ,sybj -- 剩余本金
            ,pjcb -- 平均成本
            ,zytjj -- 折溢摊净价
            ,yjlx -- 应计利息
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,bz -- 币别
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,jgdh -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,lxsr -- 利息收入
            ,zyt -- 折溢摊
            ,mmjc -- 买卖价差
            ,fdyk -- 浮动盈亏
            ,hydh -- 行员代号
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_zytsyfx_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 数据日期
            ,zqdm -- 债券代码
            ,tzid -- 投组id
            ,zqmc -- 债券名称
            ,qxrq -- 起息日
            ,dqrq -- 到期日
            ,me -- 面额
            ,sybj -- 剩余本金
            ,pjcb -- 平均成本
            ,zytjj -- 折溢摊净价
            ,yjlx -- 应计利息
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,bz -- 币别
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,jgdh -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,lxsr -- 利息收入
            ,zyt -- 折溢摊
            ,mmjc -- 买卖价差
            ,fdyk -- 浮动盈亏
            ,hydh -- 行员代号
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.tjrq -- 数据日期
    ,o.zqdm -- 债券代码
    ,o.tzid -- 投组id
    ,o.zqmc -- 债券名称
    ,o.qxrq -- 起息日
    ,o.dqrq -- 到期日
    ,o.me -- 面额
    ,o.sybj -- 剩余本金
    ,o.pjcb -- 平均成本
    ,o.zytjj -- 折溢摊净价
    ,o.yjlx -- 应计利息
    ,o.zcfzfl -- 资产负债分类
    ,o.zqdmmc -- 债券代码名称
    ,o.bz -- 币别
    ,o.xzrq -- 修正久期
    ,o.dv01 -- DV01
    ,o.jytzmc -- 交易投组名称
    ,o.tzsfl -- 投组三分类
    ,o.zhid -- 账户ID
    ,o.zhdm -- 账户代码
    ,o.zhmc -- 账户名称
    ,o.jgdh -- 部门机构
    ,o.bzcp -- 标准产品
    ,o.dqsyl -- 到期收益率
    ,o.dcq -- 待偿期
    ,o.zqlx -- 债券类型
    ,o.lxsr -- 利息收入
    ,o.zyt -- 折溢摊
    ,o.mmjc -- 买卖价差
    ,o.fdyk -- 浮动盈亏
    ,o.hydh -- 行员代号
    ,o.khdxdh -- 考核对象代号
    ,o.gxhslx -- 关系函数类型
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
from ${iol_schema}.pams_jxdx_zytsyfx_bk o
    left join ${iol_schema}.pams_jxdx_zytsyfx_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_zytsyfx_cl d
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
--truncate table ${iol_schema}.pams_jxdx_zytsyfx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_zytsyfx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_zytsyfx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_zytsyfx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_zytsyfx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_zytsyfx_cl;
alter table ${iol_schema}.pams_jxdx_zytsyfx exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_zytsyfx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_zytsyfx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_zytsyfx_op purge;
drop table ${iol_schema}.pams_jxdx_zytsyfx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_zytsyfx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_zytsyfx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
