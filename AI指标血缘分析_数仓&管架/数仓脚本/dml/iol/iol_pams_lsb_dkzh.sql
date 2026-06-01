/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_lsb_dkzh
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
create table ${iol_schema}.pams_lsb_dkzh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_lsb_dkzh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_lsb_dkzh_op purge;
drop table ${iol_schema}.pams_lsb_dkzh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_lsb_dkzh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_lsb_dkzh where 0=1;

create table ${iol_schema}.pams_lsb_dkzh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_lsb_dkzh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_lsb_dkzh_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,zhdh -- 账号ID
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,daizhikm -- 
            ,daizhangkm -- 呆账科目
            ,fhdh -- 分行代号
            ,jgdh -- 财务归属机构号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,lldh -- 利率代号
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
            ,daizhiye -- 
            ,daizhangye -- 呆账余额
            ,yswslx -- 应收未收利息
            ,bzjbl -- 保证金比例
            ,hydh -- 核心填写工号
            ,zhbs -- 账户标识：1-对公，2-对私
            ,txbz -- 停息标志
            ,czyh -- 操作用户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhnrjye -- 账户年日均余额
            ,khdkje -- 客户贷款金额
            ,khdkye -- 客户贷款余额
            ,qygm -- 企业规模
            ,gdzl -- 个贷种类
            ,sjfl -- 四级分类
            ,wjfl -- 五级分类
            ,ffbs -- 发放标识
            ,dqbs -- 定期标识
            ,zhyeqj -- 帐户余额区间
            ,khyeqj -- 客户余额区间
            ,dkjeqj -- 贷款金额区间
            ,khjeqj -- 客户金额区间
            ,yqtsqj -- 逾期天数区间
            ,zrdkjeqj -- 责任贷款金额区间
            ,xcbldkbs -- 形成不良贷款标识
            ,xwdkbs -- 小微贷款标识
            ,sndkbs -- 涉农贷款标识
            ,xcdkbs -- 瑕疵贷款标识
            ,yxblbs -- 隐形不良标识
            ,ncwjfl -- 年初五级分类
            ,qxtsqj -- 起息天数区间
            ,ncqxtsqj -- 年初欠息天数区间
            ,llqj -- 利率区间
            ,zgdkbs -- 职工贷款标识
            ,stdkbs -- 
            ,fpdkbs -- 扶贫贷款标识
            ,mzdkbs -- 民政贷款标识
            ,qxbs -- 欠息标识
            ,yswslxqj -- 应收未收利息区间
            ,ywpz -- 业务凭证
            ,dkxz -- 贷款性质
            ,zyqrq -- 转逾期日期
            ,zfyjrq -- 转非应计日期
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,sxed -- 
            ,qynll -- 逾期年利率
            ,khkhbs -- 客户开卡标识
            ,xcfyjdkbs -- 
            ,xcyqdkbs -- 形成逾期贷款标识
            ,bmkkh -- 便民卡卡号
            ,zhjrjye -- 账户季日均余额
            ,zhyrjye -- 账户月日均余额
            ,lxdbs -- 类信贷标识
            ,hxbz -- 核销标志
            ,lsdkbs -- 绿色贷款标识
            ,xsbz -- 
            ,jqrq -- 结清日期
            ,sfzydk -- 是否转移贷款
            ,fdbptdk -- 非打包平台贷款
            ,ypbzjblqj -- 押品类低风险比例区间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_lsb_dkzh_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,zhdh -- 账号ID
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,daizhikm -- 
            ,daizhangkm -- 呆账科目
            ,fhdh -- 分行代号
            ,jgdh -- 财务归属机构号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,lldh -- 利率代号
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
            ,daizhiye -- 
            ,daizhangye -- 呆账余额
            ,yswslx -- 应收未收利息
            ,bzjbl -- 保证金比例
            ,hydh -- 核心填写工号
            ,zhbs -- 账户标识：1-对公，2-对私
            ,txbz -- 停息标志
            ,czyh -- 操作用户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhnrjye -- 账户年日均余额
            ,khdkje -- 客户贷款金额
            ,khdkye -- 客户贷款余额
            ,qygm -- 企业规模
            ,gdzl -- 个贷种类
            ,sjfl -- 四级分类
            ,wjfl -- 五级分类
            ,ffbs -- 发放标识
            ,dqbs -- 定期标识
            ,zhyeqj -- 帐户余额区间
            ,khyeqj -- 客户余额区间
            ,dkjeqj -- 贷款金额区间
            ,khjeqj -- 客户金额区间
            ,yqtsqj -- 逾期天数区间
            ,zrdkjeqj -- 责任贷款金额区间
            ,xcbldkbs -- 形成不良贷款标识
            ,xwdkbs -- 小微贷款标识
            ,sndkbs -- 涉农贷款标识
            ,xcdkbs -- 瑕疵贷款标识
            ,yxblbs -- 隐形不良标识
            ,ncwjfl -- 年初五级分类
            ,qxtsqj -- 起息天数区间
            ,ncqxtsqj -- 年初欠息天数区间
            ,llqj -- 利率区间
            ,zgdkbs -- 职工贷款标识
            ,stdkbs -- 
            ,fpdkbs -- 扶贫贷款标识
            ,mzdkbs -- 民政贷款标识
            ,qxbs -- 欠息标识
            ,yswslxqj -- 应收未收利息区间
            ,ywpz -- 业务凭证
            ,dkxz -- 贷款性质
            ,zyqrq -- 转逾期日期
            ,zfyjrq -- 转非应计日期
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,sxed -- 
            ,qynll -- 逾期年利率
            ,khkhbs -- 客户开卡标识
            ,xcfyjdkbs -- 
            ,xcyqdkbs -- 形成逾期贷款标识
            ,bmkkh -- 便民卡卡号
            ,zhjrjye -- 账户季日均余额
            ,zhyrjye -- 账户月日均余额
            ,lxdbs -- 类信贷标识
            ,hxbz -- 核销标志
            ,lsdkbs -- 绿色贷款标识
            ,xsbz -- 
            ,jqrq -- 结清日期
            ,sfzydk -- 是否转移贷款
            ,fdbptdk -- 非打包平台贷款
            ,ypbzjblqj -- 押品类低风险比例区间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账号ID
    ,nvl(n.zzh, o.zzh) as zzh -- 子账号
    ,nvl(n.zhhm, o.zhhm) as zhhm -- 账户名称
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.cph, o.cph) as cph -- 产品号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.yqkm, o.yqkm) as yqkm -- 逾期科目
    ,nvl(n.daizhikm, o.daizhikm) as daizhikm -- 
    ,nvl(n.daizhangkm, o.daizhangkm) as daizhangkm -- 呆账科目
    ,nvl(n.fhdh, o.fhdh) as fhdh -- 分行代号
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 财务归属机构号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.ffrq, o.ffrq) as ffrq -- 发放日期
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日期
    ,nvl(n.xhrq, o.xhrq) as xhrq -- 销户日期
    ,nvl(n.zhzt, o.zhzt) as zhzt -- 账户状态
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.lldh, o.lldh) as lldh -- 利率代号
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
    ,nvl(n.daizhiye, o.daizhiye) as daizhiye -- 
    ,nvl(n.daizhangye, o.daizhangye) as daizhangye -- 呆账余额
    ,nvl(n.yswslx, o.yswslx) as yswslx -- 应收未收利息
    ,nvl(n.bzjbl, o.bzjbl) as bzjbl -- 保证金比例
    ,nvl(n.hydh, o.hydh) as hydh -- 核心填写工号
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识：1-对公，2-对私
    ,nvl(n.txbz, o.txbz) as txbz -- 停息标志
    ,nvl(n.czyh, o.czyh) as czyh -- 操作用户
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.zhnrjye, o.zhnrjye) as zhnrjye -- 账户年日均余额
    ,nvl(n.khdkje, o.khdkje) as khdkje -- 客户贷款金额
    ,nvl(n.khdkye, o.khdkye) as khdkye -- 客户贷款余额
    ,nvl(n.qygm, o.qygm) as qygm -- 企业规模
    ,nvl(n.gdzl, o.gdzl) as gdzl -- 个贷种类
    ,nvl(n.sjfl, o.sjfl) as sjfl -- 四级分类
    ,nvl(n.wjfl, o.wjfl) as wjfl -- 五级分类
    ,nvl(n.ffbs, o.ffbs) as ffbs -- 发放标识
    ,nvl(n.dqbs, o.dqbs) as dqbs -- 定期标识
    ,nvl(n.zhyeqj, o.zhyeqj) as zhyeqj -- 帐户余额区间
    ,nvl(n.khyeqj, o.khyeqj) as khyeqj -- 客户余额区间
    ,nvl(n.dkjeqj, o.dkjeqj) as dkjeqj -- 贷款金额区间
    ,nvl(n.khjeqj, o.khjeqj) as khjeqj -- 客户金额区间
    ,nvl(n.yqtsqj, o.yqtsqj) as yqtsqj -- 逾期天数区间
    ,nvl(n.zrdkjeqj, o.zrdkjeqj) as zrdkjeqj -- 责任贷款金额区间
    ,nvl(n.xcbldkbs, o.xcbldkbs) as xcbldkbs -- 形成不良贷款标识
    ,nvl(n.xwdkbs, o.xwdkbs) as xwdkbs -- 小微贷款标识
    ,nvl(n.sndkbs, o.sndkbs) as sndkbs -- 涉农贷款标识
    ,nvl(n.xcdkbs, o.xcdkbs) as xcdkbs -- 瑕疵贷款标识
    ,nvl(n.yxblbs, o.yxblbs) as yxblbs -- 隐形不良标识
    ,nvl(n.ncwjfl, o.ncwjfl) as ncwjfl -- 年初五级分类
    ,nvl(n.qxtsqj, o.qxtsqj) as qxtsqj -- 起息天数区间
    ,nvl(n.ncqxtsqj, o.ncqxtsqj) as ncqxtsqj -- 年初欠息天数区间
    ,nvl(n.llqj, o.llqj) as llqj -- 利率区间
    ,nvl(n.zgdkbs, o.zgdkbs) as zgdkbs -- 职工贷款标识
    ,nvl(n.stdkbs, o.stdkbs) as stdkbs -- 
    ,nvl(n.fpdkbs, o.fpdkbs) as fpdkbs -- 扶贫贷款标识
    ,nvl(n.mzdkbs, o.mzdkbs) as mzdkbs -- 民政贷款标识
    ,nvl(n.qxbs, o.qxbs) as qxbs -- 欠息标识
    ,nvl(n.yswslxqj, o.yswslxqj) as yswslxqj -- 应收未收利息区间
    ,nvl(n.ywpz, o.ywpz) as ywpz -- 业务凭证
    ,nvl(n.dkxz, o.dkxz) as dkxz -- 贷款性质
    ,nvl(n.zyqrq, o.zyqrq) as zyqrq -- 转逾期日期
    ,nvl(n.zfyjrq, o.zfyjrq) as zfyjrq -- 转非应计日期
    ,nvl(n.dkfflb, o.dkfflb) as dkfflb -- 贷款发放类别
    ,nvl(n.hkfs, o.hkfs) as hkfs -- 还款方式
    ,nvl(n.bjyqts, o.bjyqts) as bjyqts -- 本金逾期天数
    ,nvl(n.lxyqts, o.lxyqts) as lxyqts -- 利息逾期天数
    ,nvl(n.jxfs, o.jxfs) as jxfs -- 计息方式
    ,nvl(n.sxed, o.sxed) as sxed -- 
    ,nvl(n.qynll, o.qynll) as qynll -- 逾期年利率
    ,nvl(n.khkhbs, o.khkhbs) as khkhbs -- 客户开卡标识
    ,nvl(n.xcfyjdkbs, o.xcfyjdkbs) as xcfyjdkbs -- 
    ,nvl(n.xcyqdkbs, o.xcyqdkbs) as xcyqdkbs -- 形成逾期贷款标识
    ,nvl(n.bmkkh, o.bmkkh) as bmkkh -- 便民卡卡号
    ,nvl(n.zhjrjye, o.zhjrjye) as zhjrjye -- 账户季日均余额
    ,nvl(n.zhyrjye, o.zhyrjye) as zhyrjye -- 账户月日均余额
    ,nvl(n.lxdbs, o.lxdbs) as lxdbs -- 类信贷标识
    ,nvl(n.hxbz, o.hxbz) as hxbz -- 核销标志
    ,nvl(n.lsdkbs, o.lsdkbs) as lsdkbs -- 绿色贷款标识
    ,nvl(n.xsbz, o.xsbz) as xsbz -- 
    ,nvl(n.jqrq, o.jqrq) as jqrq -- 结清日期
    ,nvl(n.sfzydk, o.sfzydk) as sfzydk -- 是否转移贷款
    ,nvl(n.fdbptdk, o.fdbptdk) as fdbptdk -- 非打包平台贷款
    ,nvl(n.ypbzjblqj, o.ypbzjblqj) as ypbzjblqj -- 押品类低风险比例区间
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
            and n.tjrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_lsb_dkzh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_lsb_dkzh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
            and o.tjrq = n.tjrq
where (
        o.jxdxdh is null
        and o.tjrq is null
    )
    or (
        n.jxdxdh is null
        and n.tjrq is null
    )
    or (
        o.zhdh <> n.zhdh
        or o.zzh <> n.zzh
        or o.zhhm <> n.zhhm
        or o.bz <> n.bz
        or o.cph <> n.cph
        or o.kmh <> n.kmh
        or o.yqkm <> n.yqkm
        or o.daizhikm <> n.daizhikm
        or o.daizhangkm <> n.daizhangkm
        or o.fhdh <> n.fhdh
        or o.jgdh <> n.jgdh
        or o.khh <> n.khh
        or o.khrq <> n.khrq
        or o.ffrq <> n.ffrq
        or o.qxrq <> n.qxrq
        or o.dqrq <> n.dqrq
        or o.xhrq <> n.xhrq
        or o.zhzt <> n.zhzt
        or o.qx <> n.qx
        or o.lldh <> n.lldh
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
        or o.yswslx <> n.yswslx
        or o.bzjbl <> n.bzjbl
        or o.hydh <> n.hydh
        or o.zhbs <> n.zhbs
        or o.txbz <> n.txbz
        or o.czyh <> n.czyh
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.zhnrjye <> n.zhnrjye
        or o.khdkje <> n.khdkje
        or o.khdkye <> n.khdkye
        or o.qygm <> n.qygm
        or o.gdzl <> n.gdzl
        or o.sjfl <> n.sjfl
        or o.wjfl <> n.wjfl
        or o.ffbs <> n.ffbs
        or o.dqbs <> n.dqbs
        or o.zhyeqj <> n.zhyeqj
        or o.khyeqj <> n.khyeqj
        or o.dkjeqj <> n.dkjeqj
        or o.khjeqj <> n.khjeqj
        or o.yqtsqj <> n.yqtsqj
        or o.zrdkjeqj <> n.zrdkjeqj
        or o.xcbldkbs <> n.xcbldkbs
        or o.xwdkbs <> n.xwdkbs
        or o.sndkbs <> n.sndkbs
        or o.xcdkbs <> n.xcdkbs
        or o.yxblbs <> n.yxblbs
        or o.ncwjfl <> n.ncwjfl
        or o.qxtsqj <> n.qxtsqj
        or o.ncqxtsqj <> n.ncqxtsqj
        or o.llqj <> n.llqj
        or o.zgdkbs <> n.zgdkbs
        or o.stdkbs <> n.stdkbs
        or o.fpdkbs <> n.fpdkbs
        or o.mzdkbs <> n.mzdkbs
        or o.qxbs <> n.qxbs
        or o.yswslxqj <> n.yswslxqj
        or o.ywpz <> n.ywpz
        or o.dkxz <> n.dkxz
        or o.zyqrq <> n.zyqrq
        or o.zfyjrq <> n.zfyjrq
        or o.dkfflb <> n.dkfflb
        or o.hkfs <> n.hkfs
        or o.bjyqts <> n.bjyqts
        or o.lxyqts <> n.lxyqts
        or o.jxfs <> n.jxfs
        or o.sxed <> n.sxed
        or o.qynll <> n.qynll
        or o.khkhbs <> n.khkhbs
        or o.xcfyjdkbs <> n.xcfyjdkbs
        or o.xcyqdkbs <> n.xcyqdkbs
        or o.bmkkh <> n.bmkkh
        or o.zhjrjye <> n.zhjrjye
        or o.zhyrjye <> n.zhyrjye
        or o.lxdbs <> n.lxdbs
        or o.hxbz <> n.hxbz
        or o.lsdkbs <> n.lsdkbs
        or o.xsbz <> n.xsbz
        or o.jqrq <> n.jqrq
        or o.sfzydk <> n.sfzydk
        or o.fdbptdk <> n.fdbptdk
        or o.ypbzjblqj <> n.ypbzjblqj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_lsb_dkzh_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,zhdh -- 账号ID
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,daizhikm -- 
            ,daizhangkm -- 呆账科目
            ,fhdh -- 分行代号
            ,jgdh -- 财务归属机构号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,lldh -- 利率代号
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
            ,daizhiye -- 
            ,daizhangye -- 呆账余额
            ,yswslx -- 应收未收利息
            ,bzjbl -- 保证金比例
            ,hydh -- 核心填写工号
            ,zhbs -- 账户标识：1-对公，2-对私
            ,txbz -- 停息标志
            ,czyh -- 操作用户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhnrjye -- 账户年日均余额
            ,khdkje -- 客户贷款金额
            ,khdkye -- 客户贷款余额
            ,qygm -- 企业规模
            ,gdzl -- 个贷种类
            ,sjfl -- 四级分类
            ,wjfl -- 五级分类
            ,ffbs -- 发放标识
            ,dqbs -- 定期标识
            ,zhyeqj -- 帐户余额区间
            ,khyeqj -- 客户余额区间
            ,dkjeqj -- 贷款金额区间
            ,khjeqj -- 客户金额区间
            ,yqtsqj -- 逾期天数区间
            ,zrdkjeqj -- 责任贷款金额区间
            ,xcbldkbs -- 形成不良贷款标识
            ,xwdkbs -- 小微贷款标识
            ,sndkbs -- 涉农贷款标识
            ,xcdkbs -- 瑕疵贷款标识
            ,yxblbs -- 隐形不良标识
            ,ncwjfl -- 年初五级分类
            ,qxtsqj -- 起息天数区间
            ,ncqxtsqj -- 年初欠息天数区间
            ,llqj -- 利率区间
            ,zgdkbs -- 职工贷款标识
            ,stdkbs -- 
            ,fpdkbs -- 扶贫贷款标识
            ,mzdkbs -- 民政贷款标识
            ,qxbs -- 欠息标识
            ,yswslxqj -- 应收未收利息区间
            ,ywpz -- 业务凭证
            ,dkxz -- 贷款性质
            ,zyqrq -- 转逾期日期
            ,zfyjrq -- 转非应计日期
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,sxed -- 
            ,qynll -- 逾期年利率
            ,khkhbs -- 客户开卡标识
            ,xcfyjdkbs -- 
            ,xcyqdkbs -- 形成逾期贷款标识
            ,bmkkh -- 便民卡卡号
            ,zhjrjye -- 账户季日均余额
            ,zhyrjye -- 账户月日均余额
            ,lxdbs -- 类信贷标识
            ,hxbz -- 核销标志
            ,lsdkbs -- 绿色贷款标识
            ,xsbz -- 
            ,jqrq -- 结清日期
            ,sfzydk -- 是否转移贷款
            ,fdbptdk -- 非打包平台贷款
            ,ypbzjblqj -- 押品类低风险比例区间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_lsb_dkzh_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,zhdh -- 账号ID
            ,zzh -- 子账号
            ,zhhm -- 账户名称
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,daizhikm -- 
            ,daizhangkm -- 呆账科目
            ,fhdh -- 分行代号
            ,jgdh -- 财务归属机构号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,lldh -- 利率代号
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
            ,daizhiye -- 
            ,daizhangye -- 呆账余额
            ,yswslx -- 应收未收利息
            ,bzjbl -- 保证金比例
            ,hydh -- 核心填写工号
            ,zhbs -- 账户标识：1-对公，2-对私
            ,txbz -- 停息标志
            ,czyh -- 操作用户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhnrjye -- 账户年日均余额
            ,khdkje -- 客户贷款金额
            ,khdkye -- 客户贷款余额
            ,qygm -- 企业规模
            ,gdzl -- 个贷种类
            ,sjfl -- 四级分类
            ,wjfl -- 五级分类
            ,ffbs -- 发放标识
            ,dqbs -- 定期标识
            ,zhyeqj -- 帐户余额区间
            ,khyeqj -- 客户余额区间
            ,dkjeqj -- 贷款金额区间
            ,khjeqj -- 客户金额区间
            ,yqtsqj -- 逾期天数区间
            ,zrdkjeqj -- 责任贷款金额区间
            ,xcbldkbs -- 形成不良贷款标识
            ,xwdkbs -- 小微贷款标识
            ,sndkbs -- 涉农贷款标识
            ,xcdkbs -- 瑕疵贷款标识
            ,yxblbs -- 隐形不良标识
            ,ncwjfl -- 年初五级分类
            ,qxtsqj -- 起息天数区间
            ,ncqxtsqj -- 年初欠息天数区间
            ,llqj -- 利率区间
            ,zgdkbs -- 职工贷款标识
            ,stdkbs -- 
            ,fpdkbs -- 扶贫贷款标识
            ,mzdkbs -- 民政贷款标识
            ,qxbs -- 欠息标识
            ,yswslxqj -- 应收未收利息区间
            ,ywpz -- 业务凭证
            ,dkxz -- 贷款性质
            ,zyqrq -- 转逾期日期
            ,zfyjrq -- 转非应计日期
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,sxed -- 
            ,qynll -- 逾期年利率
            ,khkhbs -- 客户开卡标识
            ,xcfyjdkbs -- 
            ,xcyqdkbs -- 形成逾期贷款标识
            ,bmkkh -- 便民卡卡号
            ,zhjrjye -- 账户季日均余额
            ,zhyrjye -- 账户月日均余额
            ,lxdbs -- 类信贷标识
            ,hxbz -- 核销标志
            ,lsdkbs -- 绿色贷款标识
            ,xsbz -- 
            ,jqrq -- 结清日期
            ,sfzydk -- 是否转移贷款
            ,fdbptdk -- 非打包平台贷款
            ,ypbzjblqj -- 押品类低风险比例区间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.tjrq -- 统计日期
    ,o.zhdh -- 账号ID
    ,o.zzh -- 子账号
    ,o.zhhm -- 账户名称
    ,o.bz -- 币种
    ,o.cph -- 产品号
    ,o.kmh -- 科目号
    ,o.yqkm -- 逾期科目
    ,o.daizhikm -- 
    ,o.daizhangkm -- 呆账科目
    ,o.fhdh -- 分行代号
    ,o.jgdh -- 财务归属机构号
    ,o.khh -- 客户号
    ,o.khrq -- 开户日期
    ,o.ffrq -- 发放日期
    ,o.qxrq -- 起息日期
    ,o.dqrq -- 到期日期
    ,o.xhrq -- 销户日期
    ,o.zhzt -- 账户状态
    ,o.qx -- 期限
    ,o.lldh -- 利率代号
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
    ,o.daizhiye -- 
    ,o.daizhangye -- 呆账余额
    ,o.yswslx -- 应收未收利息
    ,o.bzjbl -- 保证金比例
    ,o.hydh -- 核心填写工号
    ,o.zhbs -- 账户标识：1-对公，2-对私
    ,o.txbz -- 停息标志
    ,o.czyh -- 操作用户
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.zhnrjye -- 账户年日均余额
    ,o.khdkje -- 客户贷款金额
    ,o.khdkye -- 客户贷款余额
    ,o.qygm -- 企业规模
    ,o.gdzl -- 个贷种类
    ,o.sjfl -- 四级分类
    ,o.wjfl -- 五级分类
    ,o.ffbs -- 发放标识
    ,o.dqbs -- 定期标识
    ,o.zhyeqj -- 帐户余额区间
    ,o.khyeqj -- 客户余额区间
    ,o.dkjeqj -- 贷款金额区间
    ,o.khjeqj -- 客户金额区间
    ,o.yqtsqj -- 逾期天数区间
    ,o.zrdkjeqj -- 责任贷款金额区间
    ,o.xcbldkbs -- 形成不良贷款标识
    ,o.xwdkbs -- 小微贷款标识
    ,o.sndkbs -- 涉农贷款标识
    ,o.xcdkbs -- 瑕疵贷款标识
    ,o.yxblbs -- 隐形不良标识
    ,o.ncwjfl -- 年初五级分类
    ,o.qxtsqj -- 起息天数区间
    ,o.ncqxtsqj -- 年初欠息天数区间
    ,o.llqj -- 利率区间
    ,o.zgdkbs -- 职工贷款标识
    ,o.stdkbs -- 
    ,o.fpdkbs -- 扶贫贷款标识
    ,o.mzdkbs -- 民政贷款标识
    ,o.qxbs -- 欠息标识
    ,o.yswslxqj -- 应收未收利息区间
    ,o.ywpz -- 业务凭证
    ,o.dkxz -- 贷款性质
    ,o.zyqrq -- 转逾期日期
    ,o.zfyjrq -- 转非应计日期
    ,o.dkfflb -- 贷款发放类别
    ,o.hkfs -- 还款方式
    ,o.bjyqts -- 本金逾期天数
    ,o.lxyqts -- 利息逾期天数
    ,o.jxfs -- 计息方式
    ,o.sxed -- 
    ,o.qynll -- 逾期年利率
    ,o.khkhbs -- 客户开卡标识
    ,o.xcfyjdkbs -- 
    ,o.xcyqdkbs -- 形成逾期贷款标识
    ,o.bmkkh -- 便民卡卡号
    ,o.zhjrjye -- 账户季日均余额
    ,o.zhyrjye -- 账户月日均余额
    ,o.lxdbs -- 类信贷标识
    ,o.hxbz -- 核销标志
    ,o.lsdkbs -- 绿色贷款标识
    ,o.xsbz -- 
    ,o.jqrq -- 结清日期
    ,o.sfzydk -- 是否转移贷款
    ,o.fdbptdk -- 非打包平台贷款
    ,o.ypbzjblqj -- 押品类低风险比例区间
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
from ${iol_schema}.pams_lsb_dkzh_bk o
    left join ${iol_schema}.pams_lsb_dkzh_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.tjrq = n.tjrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_lsb_dkzh_cl d
        on
            o.jxdxdh = d.jxdxdh
            and o.tjrq = d.tjrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_lsb_dkzh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_lsb_dkzh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_lsb_dkzh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_lsb_dkzh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_lsb_dkzh exchange partition p_${batch_date} with table ${iol_schema}.pams_lsb_dkzh_cl;
alter table ${iol_schema}.pams_lsb_dkzh exchange partition p_20991231 with table ${iol_schema}.pams_lsb_dkzh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_lsb_dkzh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_lsb_dkzh_op purge;
drop table ${iol_schema}.pams_lsb_dkzh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_lsb_dkzh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_lsb_dkzh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
