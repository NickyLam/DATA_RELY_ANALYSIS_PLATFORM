/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_tyzzh
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
create table ${iol_schema}.pams_jxdx_tyzzh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_tyzzh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tyzzh_op purge;
drop table ${iol_schema}.pams_jxdx_tyzzh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tyzzh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tyzzh where 0=1;

create table ${iol_schema}.pams_jxdx_tyzzh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tyzzh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tyzzh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,pzh -- 凭证号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,zhsx -- 账户属性
            ,qx -- 期限
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,czdm -- 操作代码
            ,dhbz -- 定活标志
            ,jtlxzc -- 计提利息支出
            ,zzkzqr -- 最早可支取日
            ,kh -- 卡号
            ,sfhx -- 是否核心
            ,khje -- 开户金额
            ,zjhm -- 证件号码
            ,ywtxdm -- 业务贴现代码
            ,khjg -- 开户机构
            ,khgybh -- 开户柜员编号
            ,chbz -- 钞汇标志
            ,tyckbz -- 同业存款标志
            ,shhbz -- 睡眠户标志
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,djdqrq -- 冻结到期日期
            ,zdzcbz -- 自动转存标志
            ,yzccs -- 已转存次数
            ,xdckbz -- 协定存款标志
            ,xdll -- 协定利率
            ,xdcklcje -- 协定存款留存金额
            ,bzjbz -- 币种j币种
            ,jgxckbz -- 结构性存款标志
            ,jzll -- 基准利率
            ,ktqzqbz -- 可提前支取标志
            ,kzrbz -- 可转让标志
            ,dfgzzhbz -- 代发工资账户标志
            ,tzckbz -- 通知存款标志
            ,wlckbz -- 网络存款标志
            ,txyckbz -- 同兴赢存款标志
            ,dzybz -- 抵质押标志
            ,dzyje -- 抵质押金额
            ,glhxckzh -- 关联核心存款账户
            ,p2pckbz -- 是否p2p标识
            ,khqd -- 开户渠道类型代码
            ,yhzhzl -- 用户账号种类
            ,zhbh -- 账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tyzzh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,pzh -- 凭证号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,zhsx -- 账户属性
            ,qx -- 期限
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,czdm -- 操作代码
            ,dhbz -- 定活标志
            ,jtlxzc -- 计提利息支出
            ,zzkzqr -- 最早可支取日
            ,kh -- 卡号
            ,sfhx -- 是否核心
            ,khje -- 开户金额
            ,zjhm -- 证件号码
            ,ywtxdm -- 业务贴现代码
            ,khjg -- 开户机构
            ,khgybh -- 开户柜员编号
            ,chbz -- 钞汇标志
            ,tyckbz -- 同业存款标志
            ,shhbz -- 睡眠户标志
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,djdqrq -- 冻结到期日期
            ,zdzcbz -- 自动转存标志
            ,yzccs -- 已转存次数
            ,xdckbz -- 协定存款标志
            ,xdll -- 协定利率
            ,xdcklcje -- 协定存款留存金额
            ,bzjbz -- 币种j币种
            ,jgxckbz -- 结构性存款标志
            ,jzll -- 基准利率
            ,ktqzqbz -- 可提前支取标志
            ,kzrbz -- 可转让标志
            ,dfgzzhbz -- 代发工资账户标志
            ,tzckbz -- 通知存款标志
            ,wlckbz -- 网络存款标志
            ,txyckbz -- 同兴赢存款标志
            ,dzybz -- 抵质押标志
            ,dzyje -- 抵质押金额
            ,glhxckzh -- 关联核心存款账户
            ,p2pckbz -- 是否p2p标识
            ,khqd -- 开户渠道类型代码
            ,yhzhzl -- 用户账号种类
            ,zhbh -- 账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账户代号
    ,nvl(n.zzh, o.zzh) as zzh -- 子账号
    ,nvl(n.zhhm, o.zhhm) as zhhm -- 账户名称
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.cph, o.cph) as cph -- 产品号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.pzh, o.pzh) as pzh -- 凭证号
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日期
    ,nvl(n.xhrq, o.xhrq) as xhrq -- 销户日期
    ,nvl(n.zhzt, o.zhzt) as zhzt -- 账户状态
    ,nvl(n.zhsx, o.zhsx) as zhsx -- 账户属性
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.nll, o.nll) as nll -- 年利率
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.czdm, o.czdm) as czdm -- 操作代码
    ,nvl(n.dhbz, o.dhbz) as dhbz -- 定活标志
    ,nvl(n.jtlxzc, o.jtlxzc) as jtlxzc -- 计提利息支出
    ,nvl(n.zzkzqr, o.zzkzqr) as zzkzqr -- 最早可支取日
    ,nvl(n.kh, o.kh) as kh -- 卡号
    ,nvl(n.sfhx, o.sfhx) as sfhx -- 是否核心
    ,nvl(n.khje, o.khje) as khje -- 开户金额
    ,nvl(n.zjhm, o.zjhm) as zjhm -- 证件号码
    ,nvl(n.ywtxdm, o.ywtxdm) as ywtxdm -- 业务贴现代码
    ,nvl(n.khjg, o.khjg) as khjg -- 开户机构
    ,nvl(n.khgybh, o.khgybh) as khgybh -- 开户柜员编号
    ,nvl(n.chbz, o.chbz) as chbz -- 钞汇标志
    ,nvl(n.tyckbz, o.tyckbz) as tyckbz -- 同业存款标志
    ,nvl(n.shhbz, o.shhbz) as shhbz -- 睡眠户标志
    ,nvl(n.djbz, o.djbz) as djbz -- 冻结标志
    ,nvl(n.djje, o.djje) as djje -- 冻结金额
    ,nvl(n.djdqrq, o.djdqrq) as djdqrq -- 冻结到期日期
    ,nvl(n.zdzcbz, o.zdzcbz) as zdzcbz -- 自动转存标志
    ,nvl(n.yzccs, o.yzccs) as yzccs -- 已转存次数
    ,nvl(n.xdckbz, o.xdckbz) as xdckbz -- 协定存款标志
    ,nvl(n.xdll, o.xdll) as xdll -- 协定利率
    ,nvl(n.xdcklcje, o.xdcklcje) as xdcklcje -- 协定存款留存金额
    ,nvl(n.bzjbz, o.bzjbz) as bzjbz -- 币种j币种
    ,nvl(n.jgxckbz, o.jgxckbz) as jgxckbz -- 结构性存款标志
    ,nvl(n.jzll, o.jzll) as jzll -- 基准利率
    ,nvl(n.ktqzqbz, o.ktqzqbz) as ktqzqbz -- 可提前支取标志
    ,nvl(n.kzrbz, o.kzrbz) as kzrbz -- 可转让标志
    ,nvl(n.dfgzzhbz, o.dfgzzhbz) as dfgzzhbz -- 代发工资账户标志
    ,nvl(n.tzckbz, o.tzckbz) as tzckbz -- 通知存款标志
    ,nvl(n.wlckbz, o.wlckbz) as wlckbz -- 网络存款标志
    ,nvl(n.txyckbz, o.txyckbz) as txyckbz -- 同兴赢存款标志
    ,nvl(n.dzybz, o.dzybz) as dzybz -- 抵质押标志
    ,nvl(n.dzyje, o.dzyje) as dzyje -- 抵质押金额
    ,nvl(n.glhxckzh, o.glhxckzh) as glhxckzh -- 关联核心存款账户
    ,nvl(n.p2pckbz, o.p2pckbz) as p2pckbz -- 是否p2p标识
    ,nvl(n.khqd, o.khqd) as khqd -- 开户渠道类型代码
    ,nvl(n.yhzhzl, o.yhzhzl) as yhzhzl -- 用户账号种类
    ,nvl(n.zhbh, o.zhbh) as zhbh -- 账户编号
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
from (select * from ${iol_schema}.pams_jxdx_tyzzh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_tyzzh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.zhdh <> n.zhdh
        or o.zzh <> n.zzh
        or o.zhhm <> n.zhhm
        or o.bz <> n.bz
        or o.cph <> n.cph
        or o.kmh <> n.kmh
        or o.pzh <> n.pzh
        or o.jgdh <> n.jgdh
        or o.khh <> n.khh
        or o.khrq <> n.khrq
        or o.qxrq <> n.qxrq
        or o.dqrq <> n.dqrq
        or o.xhrq <> n.xhrq
        or o.zhzt <> n.zhzt
        or o.zhsx <> n.zhsx
        or o.qx <> n.qx
        or o.nll <> n.nll
        or o.zhye <> n.zhye
        or o.zhbs <> n.zhbs
        or o.hydh <> n.hydh
        or o.tjrq <> n.tjrq
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.czdm <> n.czdm
        or o.dhbz <> n.dhbz
        or o.jtlxzc <> n.jtlxzc
        or o.zzkzqr <> n.zzkzqr
        or o.kh <> n.kh
        or o.sfhx <> n.sfhx
        or o.khje <> n.khje
        or o.zjhm <> n.zjhm
        or o.ywtxdm <> n.ywtxdm
        or o.khjg <> n.khjg
        or o.khgybh <> n.khgybh
        or o.chbz <> n.chbz
        or o.tyckbz <> n.tyckbz
        or o.shhbz <> n.shhbz
        or o.djbz <> n.djbz
        or o.djje <> n.djje
        or o.djdqrq <> n.djdqrq
        or o.zdzcbz <> n.zdzcbz
        or o.yzccs <> n.yzccs
        or o.xdckbz <> n.xdckbz
        or o.xdll <> n.xdll
        or o.xdcklcje <> n.xdcklcje
        or o.bzjbz <> n.bzjbz
        or o.jgxckbz <> n.jgxckbz
        or o.jzll <> n.jzll
        or o.ktqzqbz <> n.ktqzqbz
        or o.kzrbz <> n.kzrbz
        or o.dfgzzhbz <> n.dfgzzhbz
        or o.tzckbz <> n.tzckbz
        or o.wlckbz <> n.wlckbz
        or o.txyckbz <> n.txyckbz
        or o.dzybz <> n.dzybz
        or o.dzyje <> n.dzyje
        or o.glhxckzh <> n.glhxckzh
        or o.p2pckbz <> n.p2pckbz
        or o.khqd <> n.khqd
        or o.yhzhzl <> n.yhzhzl
        or o.zhbh <> n.zhbh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tyzzh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,pzh -- 凭证号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,zhsx -- 账户属性
            ,qx -- 期限
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,czdm -- 操作代码
            ,dhbz -- 定活标志
            ,jtlxzc -- 计提利息支出
            ,zzkzqr -- 最早可支取日
            ,kh -- 卡号
            ,sfhx -- 是否核心
            ,khje -- 开户金额
            ,zjhm -- 证件号码
            ,ywtxdm -- 业务贴现代码
            ,khjg -- 开户机构
            ,khgybh -- 开户柜员编号
            ,chbz -- 钞汇标志
            ,tyckbz -- 同业存款标志
            ,shhbz -- 睡眠户标志
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,djdqrq -- 冻结到期日期
            ,zdzcbz -- 自动转存标志
            ,yzccs -- 已转存次数
            ,xdckbz -- 协定存款标志
            ,xdll -- 协定利率
            ,xdcklcje -- 协定存款留存金额
            ,bzjbz -- 币种j币种
            ,jgxckbz -- 结构性存款标志
            ,jzll -- 基准利率
            ,ktqzqbz -- 可提前支取标志
            ,kzrbz -- 可转让标志
            ,dfgzzhbz -- 代发工资账户标志
            ,tzckbz -- 通知存款标志
            ,wlckbz -- 网络存款标志
            ,txyckbz -- 同兴赢存款标志
            ,dzybz -- 抵质押标志
            ,dzyje -- 抵质押金额
            ,glhxckzh -- 关联核心存款账户
            ,p2pckbz -- 是否p2p标识
            ,khqd -- 开户渠道类型代码
            ,yhzhzl -- 用户账号种类
            ,zhbh -- 账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tyzzh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,pzh -- 凭证号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,zhsx -- 账户属性
            ,qx -- 期限
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,czdm -- 操作代码
            ,dhbz -- 定活标志
            ,jtlxzc -- 计提利息支出
            ,zzkzqr -- 最早可支取日
            ,kh -- 卡号
            ,sfhx -- 是否核心
            ,khje -- 开户金额
            ,zjhm -- 证件号码
            ,ywtxdm -- 业务贴现代码
            ,khjg -- 开户机构
            ,khgybh -- 开户柜员编号
            ,chbz -- 钞汇标志
            ,tyckbz -- 同业存款标志
            ,shhbz -- 睡眠户标志
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,djdqrq -- 冻结到期日期
            ,zdzcbz -- 自动转存标志
            ,yzccs -- 已转存次数
            ,xdckbz -- 协定存款标志
            ,xdll -- 协定利率
            ,xdcklcje -- 协定存款留存金额
            ,bzjbz -- 币种j币种
            ,jgxckbz -- 结构性存款标志
            ,jzll -- 基准利率
            ,ktqzqbz -- 可提前支取标志
            ,kzrbz -- 可转让标志
            ,dfgzzhbz -- 代发工资账户标志
            ,tzckbz -- 通知存款标志
            ,wlckbz -- 网络存款标志
            ,txyckbz -- 同兴赢存款标志
            ,dzybz -- 抵质押标志
            ,dzyje -- 抵质押金额
            ,glhxckzh -- 关联核心存款账户
            ,p2pckbz -- 是否p2p标识
            ,khqd -- 开户渠道类型代码
            ,yhzhzl -- 用户账号种类
            ,zhbh -- 账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.zhdh -- 账户代号
    ,o.zzh -- 子账号
    ,o.zhhm -- 账户名称
    ,o.bz -- 币种
    ,o.cph -- 产品号
    ,o.kmh -- 科目号
    ,o.pzh -- 凭证号
    ,o.jgdh -- 机构代号
    ,o.khh -- 客户号
    ,o.khrq -- 开户日期
    ,o.qxrq -- 起息日期
    ,o.dqrq -- 到期日期
    ,o.xhrq -- 销户日期
    ,o.zhzt -- 账户状态
    ,o.zhsx -- 账户属性
    ,o.qx -- 期限
    ,o.nll -- 年利率
    ,o.zhye -- 账户余额
    ,o.zhbs -- 账户标识
    ,o.hydh -- 行员代号
    ,o.tjrq -- 统计日期
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.czdm -- 操作代码
    ,o.dhbz -- 定活标志
    ,o.jtlxzc -- 计提利息支出
    ,o.zzkzqr -- 最早可支取日
    ,o.kh -- 卡号
    ,o.sfhx -- 是否核心
    ,o.khje -- 开户金额
    ,o.zjhm -- 证件号码
    ,o.ywtxdm -- 业务贴现代码
    ,o.khjg -- 开户机构
    ,o.khgybh -- 开户柜员编号
    ,o.chbz -- 钞汇标志
    ,o.tyckbz -- 同业存款标志
    ,o.shhbz -- 睡眠户标志
    ,o.djbz -- 冻结标志
    ,o.djje -- 冻结金额
    ,o.djdqrq -- 冻结到期日期
    ,o.zdzcbz -- 自动转存标志
    ,o.yzccs -- 已转存次数
    ,o.xdckbz -- 协定存款标志
    ,o.xdll -- 协定利率
    ,o.xdcklcje -- 协定存款留存金额
    ,o.bzjbz -- 币种j币种
    ,o.jgxckbz -- 结构性存款标志
    ,o.jzll -- 基准利率
    ,o.ktqzqbz -- 可提前支取标志
    ,o.kzrbz -- 可转让标志
    ,o.dfgzzhbz -- 代发工资账户标志
    ,o.tzckbz -- 通知存款标志
    ,o.wlckbz -- 网络存款标志
    ,o.txyckbz -- 同兴赢存款标志
    ,o.dzybz -- 抵质押标志
    ,o.dzyje -- 抵质押金额
    ,o.glhxckzh -- 关联核心存款账户
    ,o.p2pckbz -- 是否p2p标识
    ,o.khqd -- 开户渠道类型代码
    ,o.yhzhzl -- 用户账号种类
    ,o.zhbh -- 账户编号
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
from ${iol_schema}.pams_jxdx_tyzzh_bk o
    left join ${iol_schema}.pams_jxdx_tyzzh_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_tyzzh_cl d
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
--truncate table ${iol_schema}.pams_jxdx_tyzzh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_tyzzh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_tyzzh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_tyzzh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_tyzzh exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_tyzzh_cl;
alter table ${iol_schema}.pams_jxdx_tyzzh exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_tyzzh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_tyzzh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tyzzh_op purge;
drop table ${iol_schema}.pams_jxdx_tyzzh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_tyzzh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_tyzzh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
