/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zytsyfxmx
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
create table ${iol_schema}.pams_jxbb_zytsyfxmx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_zytsyfxmx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx_op purge;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zytsyfxmx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zytsyfxmx where 0=1;

create table ${iol_schema}.pams_jxbb_zytsyfxmx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zytsyfxmx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zytsyfxmx_cl(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,fpjs -- 分配角色
            ,zlbl -- 增量比例
            ,bz -- 币种
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,gsjgdh -- 归属机构代号
            ,gsjgmc -- 归属机构名称
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,hyme -- 行员面额
            ,hymeylj -- 行员面额月累计
            ,hymenlj -- 行员面额年累计
            ,hysybj -- 行员剩余本金
            ,hysybjylj -- 行员剩余本金月累计
            ,hysybjnlj -- 行员剩余本金年累计
            ,hypjcb -- 行员平均成本
            ,hypjcbylj -- 行员平均成本月累计
            ,hypjcbnlj -- 行员平均成本年累计
            ,hyzytjj -- 行员折溢摊净价
            ,hyzytjjylj -- 行员折溢摊净价月累计
            ,hyzytjjnlj -- 行员折溢摊净价年累计
            ,hyyjlx -- 行员应计利息
            ,hyyjlxylj -- 行员应计利息月累计
            ,hyyjlxnlj -- 行员应计利息年累计
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,tzid -- 投组id
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,khjg -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,hylxsr -- 行员利息收入
            ,hylxsrylj -- 行员利息收入月累计
            ,hylxsrnlj -- 行员利息收入年累计
            ,hyzyt -- 行员折溢摊
            ,hyzytylj -- 行员折溢摊月累计
            ,hyzytnlj -- 行员折溢摊年累计
            ,hymmjc -- 行员买卖价差
            ,hymmjcylj -- 行员买卖价差月累计
            ,hymmjcnlj -- 行员买卖价差年累计
            ,hyfdyk -- 行员浮动盈亏
            ,hyfdykylj -- 行员浮动盈亏月累计
            ,hyfdyknlj -- 行员浮动盈亏年累计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zytsyfxmx_op(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,fpjs -- 分配角色
            ,zlbl -- 增量比例
            ,bz -- 币种
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,gsjgdh -- 归属机构代号
            ,gsjgmc -- 归属机构名称
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,hyme -- 行员面额
            ,hymeylj -- 行员面额月累计
            ,hymenlj -- 行员面额年累计
            ,hysybj -- 行员剩余本金
            ,hysybjylj -- 行员剩余本金月累计
            ,hysybjnlj -- 行员剩余本金年累计
            ,hypjcb -- 行员平均成本
            ,hypjcbylj -- 行员平均成本月累计
            ,hypjcbnlj -- 行员平均成本年累计
            ,hyzytjj -- 行员折溢摊净价
            ,hyzytjjylj -- 行员折溢摊净价月累计
            ,hyzytjjnlj -- 行员折溢摊净价年累计
            ,hyyjlx -- 行员应计利息
            ,hyyjlxylj -- 行员应计利息月累计
            ,hyyjlxnlj -- 行员应计利息年累计
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,tzid -- 投组id
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,khjg -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,hylxsr -- 行员利息收入
            ,hylxsrylj -- 行员利息收入月累计
            ,hylxsrnlj -- 行员利息收入年累计
            ,hyzyt -- 行员折溢摊
            ,hyzytylj -- 行员折溢摊月累计
            ,hyzytnlj -- 行员折溢摊年累计
            ,hymmjc -- 行员买卖价差
            ,hymmjcylj -- 行员买卖价差月累计
            ,hymmjcnlj -- 行员买卖价差年累计
            ,hyfdyk -- 行员浮动盈亏
            ,hyfdykylj -- 行员浮动盈亏月累计
            ,hyfdyknlj -- 行员浮动盈亏年累计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.jgkhdxdh, o.jgkhdxdh) as jgkhdxdh -- 机构考核对象代号
    ,nvl(n.fpjs, o.fpjs) as fpjs -- 分配角色
    ,nvl(n.zlbl, o.zlbl) as zlbl -- 增量比例
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.hymc, o.hymc) as hymc -- 行员名称
    ,nvl(n.gsjgdh, o.gsjgdh) as gsjgdh -- 归属机构代号
    ,nvl(n.gsjgmc, o.gsjgmc) as gsjgmc -- 归属机构名称
    ,nvl(n.zqdm, o.zqdm) as zqdm -- 债券代码
    ,nvl(n.zqmc, o.zqmc) as zqmc -- 债券名称
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日期
    ,nvl(n.hyme, o.hyme) as hyme -- 行员面额
    ,nvl(n.hymeylj, o.hymeylj) as hymeylj -- 行员面额月累计
    ,nvl(n.hymenlj, o.hymenlj) as hymenlj -- 行员面额年累计
    ,nvl(n.hysybj, o.hysybj) as hysybj -- 行员剩余本金
    ,nvl(n.hysybjylj, o.hysybjylj) as hysybjylj -- 行员剩余本金月累计
    ,nvl(n.hysybjnlj, o.hysybjnlj) as hysybjnlj -- 行员剩余本金年累计
    ,nvl(n.hypjcb, o.hypjcb) as hypjcb -- 行员平均成本
    ,nvl(n.hypjcbylj, o.hypjcbylj) as hypjcbylj -- 行员平均成本月累计
    ,nvl(n.hypjcbnlj, o.hypjcbnlj) as hypjcbnlj -- 行员平均成本年累计
    ,nvl(n.hyzytjj, o.hyzytjj) as hyzytjj -- 行员折溢摊净价
    ,nvl(n.hyzytjjylj, o.hyzytjjylj) as hyzytjjylj -- 行员折溢摊净价月累计
    ,nvl(n.hyzytjjnlj, o.hyzytjjnlj) as hyzytjjnlj -- 行员折溢摊净价年累计
    ,nvl(n.hyyjlx, o.hyyjlx) as hyyjlx -- 行员应计利息
    ,nvl(n.hyyjlxylj, o.hyyjlxylj) as hyyjlxylj -- 行员应计利息月累计
    ,nvl(n.hyyjlxnlj, o.hyyjlxnlj) as hyyjlxnlj -- 行员应计利息年累计
    ,nvl(n.zcfzfl, o.zcfzfl) as zcfzfl -- 资产负债分类
    ,nvl(n.zqdmmc, o.zqdmmc) as zqdmmc -- 债券代码名称
    ,nvl(n.xzrq, o.xzrq) as xzrq -- 修正久期
    ,nvl(n.dv01, o.dv01) as dv01 -- DV01
    ,nvl(n.tzid, o.tzid) as tzid -- 投组id
    ,nvl(n.jytzmc, o.jytzmc) as jytzmc -- 交易投组名称
    ,nvl(n.tzsfl, o.tzsfl) as tzsfl -- 投组三分类
    ,nvl(n.zhid, o.zhid) as zhid -- 账户ID
    ,nvl(n.zhdm, o.zhdm) as zhdm -- 账户代码
    ,nvl(n.zhmc, o.zhmc) as zhmc -- 账户名称
    ,nvl(n.khjg, o.khjg) as khjg -- 部门机构
    ,nvl(n.bzcp, o.bzcp) as bzcp -- 标准产品
    ,nvl(n.dqsyl, o.dqsyl) as dqsyl -- 到期收益率
    ,nvl(n.dcq, o.dcq) as dcq -- 待偿期
    ,nvl(n.zqlx, o.zqlx) as zqlx -- 债券类型
    ,nvl(n.hylxsr, o.hylxsr) as hylxsr -- 行员利息收入
    ,nvl(n.hylxsrylj, o.hylxsrylj) as hylxsrylj -- 行员利息收入月累计
    ,nvl(n.hylxsrnlj, o.hylxsrnlj) as hylxsrnlj -- 行员利息收入年累计
    ,nvl(n.hyzyt, o.hyzyt) as hyzyt -- 行员折溢摊
    ,nvl(n.hyzytylj, o.hyzytylj) as hyzytylj -- 行员折溢摊月累计
    ,nvl(n.hyzytnlj, o.hyzytnlj) as hyzytnlj -- 行员折溢摊年累计
    ,nvl(n.hymmjc, o.hymmjc) as hymmjc -- 行员买卖价差
    ,nvl(n.hymmjcylj, o.hymmjcylj) as hymmjcylj -- 行员买卖价差月累计
    ,nvl(n.hymmjcnlj, o.hymmjcnlj) as hymmjcnlj -- 行员买卖价差年累计
    ,nvl(n.hyfdyk, o.hyfdyk) as hyfdyk -- 行员浮动盈亏
    ,nvl(n.hyfdykylj, o.hyfdykylj) as hyfdykylj -- 行员浮动盈亏月累计
    ,nvl(n.hyfdyknlj, o.hyfdyknlj) as hyfdyknlj -- 行员浮动盈亏年累计
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khdxdh is null
            and n.jgkhdxdh is null
            and n.fpjs is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khdxdh is null
            and n.jgkhdxdh is null
            and n.fpjs is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tjrq is null
            and n.jxdxdh is null
            and n.khdxdh is null
            and n.jgkhdxdh is null
            and n.fpjs is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_zytsyfxmx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_zytsyfxmx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tjrq = n.tjrq
            and o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.jgkhdxdh = n.jgkhdxdh
            and o.fpjs = n.fpjs
where (
        o.tjrq is null
        and o.jxdxdh is null
        and o.khdxdh is null
        and o.jgkhdxdh is null
        and o.fpjs is null
    )
    or (
        n.tjrq is null
        and n.jxdxdh is null
        and n.khdxdh is null
        and n.jgkhdxdh is null
        and n.fpjs is null
    )
    or (
        o.zlbl <> n.zlbl
        or o.bz <> n.bz
        or o.hydh <> n.hydh
        or o.hymc <> n.hymc
        or o.gsjgdh <> n.gsjgdh
        or o.gsjgmc <> n.gsjgmc
        or o.zqdm <> n.zqdm
        or o.zqmc <> n.zqmc
        or o.qxrq <> n.qxrq
        or o.dqrq <> n.dqrq
        or o.hyme <> n.hyme
        or o.hymeylj <> n.hymeylj
        or o.hymenlj <> n.hymenlj
        or o.hysybj <> n.hysybj
        or o.hysybjylj <> n.hysybjylj
        or o.hysybjnlj <> n.hysybjnlj
        or o.hypjcb <> n.hypjcb
        or o.hypjcbylj <> n.hypjcbylj
        or o.hypjcbnlj <> n.hypjcbnlj
        or o.hyzytjj <> n.hyzytjj
        or o.hyzytjjylj <> n.hyzytjjylj
        or o.hyzytjjnlj <> n.hyzytjjnlj
        or o.hyyjlx <> n.hyyjlx
        or o.hyyjlxylj <> n.hyyjlxylj
        or o.hyyjlxnlj <> n.hyyjlxnlj
        or o.zcfzfl <> n.zcfzfl
        or o.zqdmmc <> n.zqdmmc
        or o.xzrq <> n.xzrq
        or o.dv01 <> n.dv01
        or o.tzid <> n.tzid
        or o.jytzmc <> n.jytzmc
        or o.tzsfl <> n.tzsfl
        or o.zhid <> n.zhid
        or o.zhdm <> n.zhdm
        or o.zhmc <> n.zhmc
        or o.khjg <> n.khjg
        or o.bzcp <> n.bzcp
        or o.dqsyl <> n.dqsyl
        or o.dcq <> n.dcq
        or o.zqlx <> n.zqlx
        or o.hylxsr <> n.hylxsr
        or o.hylxsrylj <> n.hylxsrylj
        or o.hylxsrnlj <> n.hylxsrnlj
        or o.hyzyt <> n.hyzyt
        or o.hyzytylj <> n.hyzytylj
        or o.hyzytnlj <> n.hyzytnlj
        or o.hymmjc <> n.hymmjc
        or o.hymmjcylj <> n.hymmjcylj
        or o.hymmjcnlj <> n.hymmjcnlj
        or o.hyfdyk <> n.hyfdyk
        or o.hyfdykylj <> n.hyfdykylj
        or o.hyfdyknlj <> n.hyfdyknlj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zytsyfxmx_cl(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,fpjs -- 分配角色
            ,zlbl -- 增量比例
            ,bz -- 币种
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,gsjgdh -- 归属机构代号
            ,gsjgmc -- 归属机构名称
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,hyme -- 行员面额
            ,hymeylj -- 行员面额月累计
            ,hymenlj -- 行员面额年累计
            ,hysybj -- 行员剩余本金
            ,hysybjylj -- 行员剩余本金月累计
            ,hysybjnlj -- 行员剩余本金年累计
            ,hypjcb -- 行员平均成本
            ,hypjcbylj -- 行员平均成本月累计
            ,hypjcbnlj -- 行员平均成本年累计
            ,hyzytjj -- 行员折溢摊净价
            ,hyzytjjylj -- 行员折溢摊净价月累计
            ,hyzytjjnlj -- 行员折溢摊净价年累计
            ,hyyjlx -- 行员应计利息
            ,hyyjlxylj -- 行员应计利息月累计
            ,hyyjlxnlj -- 行员应计利息年累计
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,tzid -- 投组id
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,khjg -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,hylxsr -- 行员利息收入
            ,hylxsrylj -- 行员利息收入月累计
            ,hylxsrnlj -- 行员利息收入年累计
            ,hyzyt -- 行员折溢摊
            ,hyzytylj -- 行员折溢摊月累计
            ,hyzytnlj -- 行员折溢摊年累计
            ,hymmjc -- 行员买卖价差
            ,hymmjcylj -- 行员买卖价差月累计
            ,hymmjcnlj -- 行员买卖价差年累计
            ,hyfdyk -- 行员浮动盈亏
            ,hyfdykylj -- 行员浮动盈亏月累计
            ,hyfdyknlj -- 行员浮动盈亏年累计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zytsyfxmx_op(
            tjrq -- 统计日期
            ,jxdxdh -- 绩效对象代号
            ,khdxdh -- 考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,fpjs -- 分配角色
            ,zlbl -- 增量比例
            ,bz -- 币种
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,gsjgdh -- 归属机构代号
            ,gsjgmc -- 归属机构名称
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,hyme -- 行员面额
            ,hymeylj -- 行员面额月累计
            ,hymenlj -- 行员面额年累计
            ,hysybj -- 行员剩余本金
            ,hysybjylj -- 行员剩余本金月累计
            ,hysybjnlj -- 行员剩余本金年累计
            ,hypjcb -- 行员平均成本
            ,hypjcbylj -- 行员平均成本月累计
            ,hypjcbnlj -- 行员平均成本年累计
            ,hyzytjj -- 行员折溢摊净价
            ,hyzytjjylj -- 行员折溢摊净价月累计
            ,hyzytjjnlj -- 行员折溢摊净价年累计
            ,hyyjlx -- 行员应计利息
            ,hyyjlxylj -- 行员应计利息月累计
            ,hyyjlxnlj -- 行员应计利息年累计
            ,zcfzfl -- 资产负债分类
            ,zqdmmc -- 债券代码名称
            ,xzrq -- 修正久期
            ,dv01 -- DV01
            ,tzid -- 投组id
            ,jytzmc -- 交易投组名称
            ,tzsfl -- 投组三分类
            ,zhid -- 账户ID
            ,zhdm -- 账户代码
            ,zhmc -- 账户名称
            ,khjg -- 部门机构
            ,bzcp -- 标准产品
            ,dqsyl -- 到期收益率
            ,dcq -- 待偿期
            ,zqlx -- 债券类型
            ,hylxsr -- 行员利息收入
            ,hylxsrylj -- 行员利息收入月累计
            ,hylxsrnlj -- 行员利息收入年累计
            ,hyzyt -- 行员折溢摊
            ,hyzytylj -- 行员折溢摊月累计
            ,hyzytnlj -- 行员折溢摊年累计
            ,hymmjc -- 行员买卖价差
            ,hymmjcylj -- 行员买卖价差月累计
            ,hymmjcnlj -- 行员买卖价差年累计
            ,hyfdyk -- 行员浮动盈亏
            ,hyfdykylj -- 行员浮动盈亏月累计
            ,hyfdyknlj -- 行员浮动盈亏年累计
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tjrq -- 统计日期
    ,o.jxdxdh -- 绩效对象代号
    ,o.khdxdh -- 考核对象代号
    ,o.jgkhdxdh -- 机构考核对象代号
    ,o.fpjs -- 分配角色
    ,o.zlbl -- 增量比例
    ,o.bz -- 币种
    ,o.hydh -- 行员代号
    ,o.hymc -- 行员名称
    ,o.gsjgdh -- 归属机构代号
    ,o.gsjgmc -- 归属机构名称
    ,o.zqdm -- 债券代码
    ,o.zqmc -- 债券名称
    ,o.qxrq -- 起息日期
    ,o.dqrq -- 到期日期
    ,o.hyme -- 行员面额
    ,o.hymeylj -- 行员面额月累计
    ,o.hymenlj -- 行员面额年累计
    ,o.hysybj -- 行员剩余本金
    ,o.hysybjylj -- 行员剩余本金月累计
    ,o.hysybjnlj -- 行员剩余本金年累计
    ,o.hypjcb -- 行员平均成本
    ,o.hypjcbylj -- 行员平均成本月累计
    ,o.hypjcbnlj -- 行员平均成本年累计
    ,o.hyzytjj -- 行员折溢摊净价
    ,o.hyzytjjylj -- 行员折溢摊净价月累计
    ,o.hyzytjjnlj -- 行员折溢摊净价年累计
    ,o.hyyjlx -- 行员应计利息
    ,o.hyyjlxylj -- 行员应计利息月累计
    ,o.hyyjlxnlj -- 行员应计利息年累计
    ,o.zcfzfl -- 资产负债分类
    ,o.zqdmmc -- 债券代码名称
    ,o.xzrq -- 修正久期
    ,o.dv01 -- DV01
    ,o.tzid -- 投组id
    ,o.jytzmc -- 交易投组名称
    ,o.tzsfl -- 投组三分类
    ,o.zhid -- 账户ID
    ,o.zhdm -- 账户代码
    ,o.zhmc -- 账户名称
    ,o.khjg -- 部门机构
    ,o.bzcp -- 标准产品
    ,o.dqsyl -- 到期收益率
    ,o.dcq -- 待偿期
    ,o.zqlx -- 债券类型
    ,o.hylxsr -- 行员利息收入
    ,o.hylxsrylj -- 行员利息收入月累计
    ,o.hylxsrnlj -- 行员利息收入年累计
    ,o.hyzyt -- 行员折溢摊
    ,o.hyzytylj -- 行员折溢摊月累计
    ,o.hyzytnlj -- 行员折溢摊年累计
    ,o.hymmjc -- 行员买卖价差
    ,o.hymmjcylj -- 行员买卖价差月累计
    ,o.hymmjcnlj -- 行员买卖价差年累计
    ,o.hyfdyk -- 行员浮动盈亏
    ,o.hyfdykylj -- 行员浮动盈亏月累计
    ,o.hyfdyknlj -- 行员浮动盈亏年累计
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
from ${iol_schema}.pams_jxbb_zytsyfxmx_bk o
    left join ${iol_schema}.pams_jxbb_zytsyfxmx_op n
        on
            o.tjrq = n.tjrq
            and o.jxdxdh = n.jxdxdh
            and o.khdxdh = n.khdxdh
            and o.jgkhdxdh = n.jgkhdxdh
            and o.fpjs = n.fpjs
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_zytsyfxmx_cl d
        on
            o.tjrq = d.tjrq
            and o.jxdxdh = d.jxdxdh
            and o.khdxdh = d.khdxdh
            and o.jgkhdxdh = d.jgkhdxdh
            and o.fpjs = d.fpjs
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_zytsyfxmx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_zytsyfxmx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_zytsyfxmx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_zytsyfxmx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_zytsyfxmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zytsyfxmx_cl;
alter table ${iol_schema}.pams_jxbb_zytsyfxmx exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_zytsyfxmx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zytsyfxmx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx_op purge;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_zytsyfxmx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zytsyfxmx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
