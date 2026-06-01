/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_dkzh
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
create table ${iol_schema}.pams_jxdx_dkzh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_dkzh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_dkzh_op purge;
drop table ${iol_schema}.pams_jxdx_dkzh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkzh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_dkzh where 0=1;

create table ${iol_schema}.pams_jxdx_dkzh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_dkzh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_dkzh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_dkzh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账户代号
    ,nvl(n.zzh, o.zzh) as zzh -- 子账户
    ,nvl(n.zhhm, o.zhhm) as zhhm -- 账户户名
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.cph, o.cph) as cph -- 产品号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.yqkm, o.yqkm) as yqkm -- 逾期科目
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.ffrq, o.ffrq) as ffrq -- 发放日期
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日期
    ,nvl(n.xhrq, o.xhrq) as xhrq -- 销户日期
    ,nvl(n.zhzt, o.zhzt) as zhzt -- 账户状态
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.nll, o.nll) as nll -- 年利率
    ,nvl(n.llyhbz, o.llyhbz) as llyhbz -- 利率浮动标志
    ,nvl(n.llyhbl, o.llyhbl) as llyhbl -- 利率浮动比例
    ,nvl(n.pjh, o.pjh) as pjh -- 票据号
    ,nvl(n.hth, o.hth) as hth -- 合同号
    ,nvl(n.dkfs, o.dkfs) as dkfs -- 贷款方式
    ,nvl(n.dkje, o.dkje) as dkje -- 贷款金额
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.zcye, o.zcye) as zcye -- 正常余额
    ,nvl(n.yqye, o.yqye) as yqye -- 逾期余额
    ,nvl(n.daizhiye, o.daizhiye) as daizhiye -- 呆滞余额
    ,nvl(n.daizhangye, o.daizhangye) as daizhangye -- 呆账余额
    ,nvl(n.bzjbl, o.bzjbl) as bzjbl -- 保证金比例
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.qygm, o.qygm) as qygm -- 企业规模
    ,nvl(n.psckzh, o.psckzh) as psckzh -- 派生存款账户
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.xwdkbs, o.xwdkbs) as xwdkbs -- 小微贷款标识
    ,nvl(n.ywpz, o.ywpz) as ywpz -- 业务品种
    ,nvl(n.dkfflb, o.dkfflb) as dkfflb -- 贷款发放类别
    ,nvl(n.hkfs, o.hkfs) as hkfs -- 还款方式
    ,nvl(n.bjyqts, o.bjyqts) as bjyqts -- 本金逾期天数
    ,nvl(n.lxyqts, o.lxyqts) as lxyqts -- 利息逾期天数
    ,nvl(n.jxfs, o.jxfs) as jxfs -- 计息方式
    ,nvl(n.qynll, o.qynll) as qynll -- 逾期年利率
    ,nvl(n.sxed, o.sxed) as sxed -- 授信额度
    ,nvl(n.lsdkbs, o.lsdkbs) as lsdkbs -- 绿色贷款标识
    ,nvl(n.jjh, o.jjh) as jjh -- 借据号
    ,nvl(n.jjzt, o.jjzt) as jjzt -- 拮据状态
    ,nvl(n.zxll, o.zxll) as zxll -- 执行利率
    ,nvl(n.jzll, o.jzll) as jzll -- 基准利率
    ,nvl(n.llfdfs, o.llfdfs) as llfdfs -- 利率浮动方式
    ,nvl(n.jtlxsr, o.jtlxsr) as jtlxsr -- 计提利息收入
    ,nvl(n.zyqrq, o.zyqrq) as zyqrq -- 
    ,nvl(n.hxbz, o.hxbz) as hxbz -- 
    ,nvl(n.sndkbz, o.sndkbz) as sndkbz -- 
    ,nvl(n.lhdkbz, o.lhdkbz) as lhdkbz -- 
    ,nvl(n.wldkbz, o.wldkbz) as wldkbz -- 
    ,nvl(n.se, o.se) as se -- 
    ,nvl(n.drlxsr, o.drlxsr) as drlxsr -- 
    ,nvl(n.bwbs, o.bwbs) as bwbs -- 表外标识
    ,nvl(n.zqjh, o.zqjh) as zqjh -- 子区间号
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
from (select * from ${iol_schema}.pams_jxdx_dkzh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_dkzh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.yqkm <> n.yqkm
        or o.jgdh <> n.jgdh
        or o.khh <> n.khh
        or o.khrq <> n.khrq
        or o.ffrq <> n.ffrq
        or o.qxrq <> n.qxrq
        or o.dqrq <> n.dqrq
        or o.xhrq <> n.xhrq
        or o.zhzt <> n.zhzt
        or o.qx <> n.qx
        or o.nll <> n.nll
        or o.llyhbz <> n.llyhbz
        or o.llyhbl <> n.llyhbl
        or o.pjh <> n.pjh
        or o.hth <> n.hth
        or o.dkfs <> n.dkfs
        or o.dkje <> n.dkje
        or o.zhye <> n.zhye
        or o.zcye <> n.zcye
        or o.yqye <> n.yqye
        or o.daizhiye <> n.daizhiye
        or o.daizhangye <> n.daizhangye
        or o.bzjbl <> n.bzjbl
        or o.hydh <> n.hydh
        or o.zhbs <> n.zhbs
        or o.tjrq <> n.tjrq
        or o.qygm <> n.qygm
        or o.psckzh <> n.psckzh
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.xwdkbs <> n.xwdkbs
        or o.ywpz <> n.ywpz
        or o.dkfflb <> n.dkfflb
        or o.hkfs <> n.hkfs
        or o.bjyqts <> n.bjyqts
        or o.lxyqts <> n.lxyqts
        or o.jxfs <> n.jxfs
        or o.qynll <> n.qynll
        or o.sxed <> n.sxed
        or o.lsdkbs <> n.lsdkbs
        or o.jjh <> n.jjh
        or o.jjzt <> n.jjzt
        or o.zxll <> n.zxll
        or o.jzll <> n.jzll
        or o.llfdfs <> n.llfdfs
        or o.jtlxsr <> n.jtlxsr
        or o.zyqrq <> n.zyqrq
        or o.hxbz <> n.hxbz
        or o.sndkbz <> n.sndkbz
        or o.lhdkbz <> n.lhdkbz
        or o.wldkbz <> n.wldkbz
        or o.se <> n.se
        or o.drlxsr <> n.drlxsr
        or o.bwbs <> n.bwbs
        or o.zqjh <> n.zqjh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_dkzh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_dkzh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.zhdh -- 账户代号
    ,o.zzh -- 子账户
    ,o.zhhm -- 账户户名
    ,o.bz -- 币种
    ,o.cph -- 产品号
    ,o.kmh -- 科目号
    ,o.yqkm -- 逾期科目
    ,o.jgdh -- 机构代号
    ,o.khh -- 客户号
    ,o.khrq -- 开户日期
    ,o.ffrq -- 发放日期
    ,o.qxrq -- 起息日期
    ,o.dqrq -- 到期日期
    ,o.xhrq -- 销户日期
    ,o.zhzt -- 账户状态
    ,o.qx -- 期限
    ,o.nll -- 年利率
    ,o.llyhbz -- 利率浮动标志
    ,o.llyhbl -- 利率浮动比例
    ,o.pjh -- 票据号
    ,o.hth -- 合同号
    ,o.dkfs -- 贷款方式
    ,o.dkje -- 贷款金额
    ,o.zhye -- 账户余额
    ,o.zcye -- 正常余额
    ,o.yqye -- 逾期余额
    ,o.daizhiye -- 呆滞余额
    ,o.daizhangye -- 呆账余额
    ,o.bzjbl -- 保证金比例
    ,o.hydh -- 行员代号
    ,o.zhbs -- 账户标识
    ,o.tjrq -- 统计日期
    ,o.qygm -- 企业规模
    ,o.psckzh -- 派生存款账户
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.xwdkbs -- 小微贷款标识
    ,o.ywpz -- 业务品种
    ,o.dkfflb -- 贷款发放类别
    ,o.hkfs -- 还款方式
    ,o.bjyqts -- 本金逾期天数
    ,o.lxyqts -- 利息逾期天数
    ,o.jxfs -- 计息方式
    ,o.qynll -- 逾期年利率
    ,o.sxed -- 授信额度
    ,o.lsdkbs -- 绿色贷款标识
    ,o.jjh -- 借据号
    ,o.jjzt -- 拮据状态
    ,o.zxll -- 执行利率
    ,o.jzll -- 基准利率
    ,o.llfdfs -- 利率浮动方式
    ,o.jtlxsr -- 计提利息收入
    ,o.zyqrq -- 
    ,o.hxbz -- 
    ,o.sndkbz -- 
    ,o.lhdkbz -- 
    ,o.wldkbz -- 
    ,o.se -- 
    ,o.drlxsr -- 
    ,o.bwbs -- 表外标识
    ,o.zqjh -- 子区间号
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
from ${iol_schema}.pams_jxdx_dkzh_bk o
    left join ${iol_schema}.pams_jxdx_dkzh_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_dkzh_cl d
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
--truncate table ${iol_schema}.pams_jxdx_dkzh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_dkzh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_dkzh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_dkzh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_dkzh exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_dkzh_cl;
alter table ${iol_schema}.pams_jxdx_dkzh exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_dkzh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_dkzh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_dkzh_op purge;
drop table ${iol_schema}.pams_jxdx_dkzh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_dkzh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_dkzh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
