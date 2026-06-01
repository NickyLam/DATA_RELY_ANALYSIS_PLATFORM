/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_loan_acct
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
create table ${iol_schema}.tgls_ama_loan_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_ama_loan_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_ama_loan_acct_op purge;
drop table ${iol_schema}.tgls_ama_loan_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_loan_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ama_loan_acct where 0=1;

create table ${iol_schema}.tgls_ama_loan_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ama_loan_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_ama_loan_acct_cl(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_ama_loan_acct_op(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.systid, o.systid) as systid -- 来源系统编号
    ,nvl(n.loanno, o.loanno) as loanno -- 核心贷款账户编号
    ,nvl(n.transq, o.transq) as transq -- 交易流水号
    ,nvl(n.trancd, o.trancd) as trancd -- 子交易
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种，业务字典币种crcy
    ,nvl(n.deptcd, o.deptcd) as deptcd -- 核心网点号
    ,nvl(n.debtno, o.debtno) as debtno -- 核心借据编号
    ,nvl(n.busitp, o.busitp) as busitp -- 业务类型
    ,nvl(n.prducd, o.prducd) as prducd -- 产品编号
    ,nvl(n.lnctno, o.lnctno) as lnctno -- 核心合同编号
    ,nvl(n.odlnno, o.odlnno) as odlnno -- 旧贷款账户编号
    ,nvl(n.descpt, o.descpt) as descpt -- 说明
    ,nvl(n.accrtg, o.accrtg) as accrtg -- 数据字典应计标识，y-应计，n-非应计
    ,nvl(n.amortg, o.amortg) as amortg -- 摊销标识，y-是，n-否
    ,nvl(n.extetg, o.extetg) as extetg -- 展期标识，y-是，n-否
    ,nvl(n.secutg, o.secutg) as secutg -- 资产证券化状态，y-是，n-否
    ,nvl(n.incotg, o.incotg) as incotg -- 撤并标识，y-是，n-否
    ,nvl(n.dscttg, o.dscttg) as dscttg -- 贴息标识，y-贴息，n-非贴息
    ,nvl(n.adittg, o.adittg) as adittg -- 预收息标识，y-预收息，n-非预收息
    ,nvl(n.status, o.status) as status -- 贷款状态,01-正常，02-结清，03-核销
    ,nvl(n.ratenr, o.ratenr) as ratenr -- 正常合同利率
    ,nvl(n.ratecy, o.ratecy) as ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.ovdurt, o.ovdurt) as ovdurt -- 逾期利率
    ,nvl(n.ovducy, o.ovducy) as ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.compra, o.compra) as compra -- 复利利率
    ,nvl(n.compcy, o.compcy) as compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.gracrt, o.gracrt) as gracrt -- 宽限期利率
    ,nvl(n.graccy, o.graccy) as graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.amorfr, o.amorfr) as amorfr -- 摊销频度
    ,nvl(n.stindt, o.stindt) as stindt -- 起息日
    ,nvl(n.nesedt, o.nesedt) as nesedt -- 下次结息日
    ,nvl(n.exindt, o.exindt) as exindt -- 展期到期日
    ,nvl(n.gracdy, o.gracdy) as gracdy -- 宽限期
    ,nvl(n.intetg, o.intetg) as intetg -- 计息标志，y-是，n-否
    ,nvl(n.custcd, o.custcd) as custcd -- 客户编号
    ,nvl(n.custna, o.custna) as custna -- 客户名称
    ,nvl(n.drafcd, o.drafcd) as drafcd -- 承兑人代码
    ,nvl(n.drafna, o.drafna) as drafna -- 承兑人名称
    ,nvl(n.riskcd, o.riskcd) as riskcd -- 贷款五级分类
    ,nvl(n.phascd, o.phascd) as phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
    ,nvl(n.devaam, o.devaam) as devaam -- 贷款减值金额
    ,nvl(n.devatg, o.devatg) as devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
    ,nvl(n.credco, o.credco) as credco -- 贷前费用
    ,nvl(n.issudt, o.issudt) as issudt -- 贷款放款日期
    ,nvl(n.actuam, o.actuam) as actuam -- 贷款放款金额
    ,nvl(n.issuam, o.issuam) as issuam -- 贷款放款金额
    ,nvl(n.expidt, o.expidt) as expidt -- 贷款到期日期
    ,nvl(n.retuwy, o.retuwy) as retuwy -- 还本付息方式
    ,nvl(n.recocy, o.recocy) as recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.recofr, o.recofr) as recofr -- 本金付款频率
    ,nvl(n.reincy, o.reincy) as reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
    ,nvl(n.reinfr, o.reinfr) as reinfr -- 利息付款频率
    ,nvl(n.necodt, o.necodt) as necodt -- 下次还本日
    ,nvl(n.neredt, o.neredt) as neredt -- 下次还息日
    ,nvl(n.prodp1, o.prodp1) as prodp1 -- 产品属性1
    ,nvl(n.prodp2, o.prodp2) as prodp2 -- 产品属性2
    ,nvl(n.prodp3, o.prodp3) as prodp3 -- 产品属性3
    ,nvl(n.prodp4, o.prodp4) as prodp4 -- 产品属性4
    ,nvl(n.prodp5, o.prodp5) as prodp5 -- 产品属性5
    ,nvl(n.prodp6, o.prodp6) as prodp6 -- 产品属性6
    ,nvl(n.prodp7, o.prodp7) as prodp7 -- 产品属性7
    ,nvl(n.prodp8, o.prodp8) as prodp8 -- 产品属性8
    ,nvl(n.prodp9, o.prodp9) as prodp9 -- 产品属性9
    ,nvl(n.prodpa, o.prodpa) as prodpa -- 产品属性10
    ,nvl(n.intead, o.intead) as intead -- 利息调整
    ,nvl(n.accrin, o.accrin) as accrin -- 应计利息
    ,nvl(n.intein, o.intein) as intein -- 利息收入
    ,nvl(n.ofbsci, o.ofbsci) as ofbsci -- 表外应计复利
    ,nvl(n.asseip, o.asseip) as asseip -- 资产减值准备
    ,nvl(n.impaii, o.impaii) as impaii -- 已减值利息收入
    ,nvl(n.intere, o.intere) as intere -- 应收利息
    ,nvl(n.ofbsir, o.ofbsir) as ofbsir -- 表外应收利息
    ,nvl(n.ofbsrc, o.ofbsrc) as ofbsrc -- 表外应收复利
    ,nvl(n.ofbsai, o.ofbsai) as ofbsai -- 表外应计利息
    ,nvl(n.normpr, o.normpr) as normpr -- 正常本金
    ,nvl(n.veripr, o.veripr) as veripr -- 减值本金
    ,nvl(n.inteim, o.inteim) as inteim -- 已减值利息
    ,nvl(n.asselo, o.asselo) as asselo -- 资产减值损失
    ,nvl(n.wrofbd, o.wrofbd) as wrofbd -- 已核销呆账本金
    ,nvl(n.wrofde, o.wrofde) as wrofde -- 已核销呆账已减值利息
    ,nvl(n.wrinbd, o.wrinbd) as wrinbd -- 已核销呆账利息
    ,nvl(n.iminye, o.iminye) as iminye -- 本年利息收入
    ,nvl(n.acinin, o.acinin) as acinin -- 累计利息收入
    ,nvl(n.imiiye, o.imiiye) as imiiye -- 本年已减值利息收入
    ,nvl(n.acimii, o.acimii) as acimii -- 累计已减值利息收入
    ,nvl(n.vataxm, o.vataxm) as vataxm -- 应交增值税
    ,nvl(n.amou01, o.amou01) as amou01 -- 金额01
    ,nvl(n.amou02, o.amou02) as amou02 -- 金额02
    ,nvl(n.amou03, o.amou03) as amou03 -- 金额03
    ,nvl(n.amou04, o.amou04) as amou04 -- 金额04
    ,nvl(n.amou05, o.amou05) as amou05 -- 金额05
    ,nvl(n.amou06, o.amou06) as amou06 -- 金额06
    ,nvl(n.amou07, o.amou07) as amou07 -- 金额07
    ,nvl(n.attra1, o.attra1) as attra1 -- 附加属性1
    ,nvl(n.attra2, o.attra2) as attra2 -- 附加属性2
    ,nvl(n.attra3, o.attra3) as attra3 -- 附加属性3
    ,nvl(n.attra4, o.attra4) as attra4 -- 附加属性4
    ,nvl(n.attra5, o.attra5) as attra5 -- 附加属性5
    ,nvl(n.attra6, o.attra6) as attra6 -- 附加属性6
    ,nvl(n.attra7, o.attra7) as attra7 -- 附加属性7
    ,nvl(n.attra8, o.attra8) as attra8 -- 附加属性8
    ,nvl(n.attra9, o.attra9) as attra9 -- 附加属性9
    ,nvl(n.attraa, o.attraa) as attraa -- 附加属性10
    ,nvl(n.puprtg, o.puprtg) as puprtg -- 客户类型
    ,nvl(n.amorco, o.amorco) as amorco -- 摊余成本
    ,nvl(n.oppotr, o.oppotr) as oppotr -- 对方余额类型
    ,nvl(n.accuto, o.accuto) as accuto -- 累计资产减值损失
    ,nvl(n.netrsq, o.netrsq) as netrsq -- 新交易流水
    ,nvl(n.acasil, o.acasil) as acasil -- 本年资产减值损失
    ,nvl(n.trandt, o.trandt) as trandt -- 交易日期
    ,nvl(n.eventp, o.eventp) as eventp -- 交易场景
    ,nvl(n.reinre, o.reinre) as reinre -- 登记应收利息
    ,nvl(n.regcir, o.regcir) as regcir -- 登记应收复利
    ,nvl(n.reacin, o.reacin) as reacin -- 登记应计利息
    ,nvl(n.reacci, o.reacci) as reacci -- 登记应计复利
    ,nvl(n.regaci, o.regaci) as regaci -- 登记已还利息
    ,nvl(n.regicr, o.regicr) as regicr -- 登记已还复利
    ,nvl(n.invein, o.invein) as invein -- 投资收益
    ,nvl(n.inveye, o.inveye) as inveye -- 本年投资收益
    ,nvl(n.inveto, o.inveto) as inveto -- 累计投资收益
    ,nvl(n.islast, o.islast) as islast -- 是否交易场景的最后一条，1-是，0-否
    ,nvl(n.bathid, o.bathid) as bathid -- 批次号
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构
    ,nvl(n.strkst, o.strkst) as strkst -- 冲正标识
    ,nvl(n.strkdt, o.strkdt) as strkdt -- 被冲正流水日期
    ,nvl(n.strksq, o.strksq) as strksq -- 被冲正流水
    ,nvl(n.evetdn, o.evetdn) as evetdn -- 交易方向
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水号
    ,nvl(n.amou08, o.amou08) as amou08 -- 金额08
    ,nvl(n.amou09, o.amou09) as amou09 -- 金额09
    ,nvl(n.amou10, o.amou10) as amou10 -- 金额10
    ,nvl(n.amou11, o.amou11) as amou11 -- 金额11
    ,nvl(n.amou12, o.amou12) as amou12 -- 金额12
    ,nvl(n.amou13, o.amou13) as amou13 -- 金额13
    ,nvl(n.amou14, o.amou14) as amou14 -- 金额14
    ,nvl(n.amou15, o.amou15) as amou15 -- 金额15
    ,nvl(n.amou16, o.amou16) as amou16 -- 金额16
    ,nvl(n.amou17, o.amou17) as amou17 -- 金额17
    ,nvl(n.amou18, o.amou18) as amou18 -- 金额18
    ,nvl(n.amou19, o.amou19) as amou19 -- 金额19
    ,nvl(n.amou20, o.amou20) as amou20 -- 金额20
    ,nvl(n.collpe, o.collpe) as collpe -- 当天到期的利息
    ,nvl(n.accoin, o.accoin) as accoin -- 当天到期的罚息
    ,nvl(n.compin, o.compin) as compin -- 当前到期的复利
    ,nvl(n.coacin, o.coacin) as coacin -- 罚息
    ,nvl(n.recede, o.recede) as recede -- 复利
    ,nvl(n.collde, o.collde) as collde -- 当日应收未收利息余额
    ,nvl(n.reacpe, o.reacpe) as reacpe -- 逾期利息
    ,nvl(n.coacpe, o.coacpe) as coacpe -- 逾期罚息
    ,nvl(n.recepe, o.recepe) as recepe -- 逾期复利
    ,nvl(n.ovdupr, o.ovdupr) as ovdupr -- 逾期本金
    ,nvl(n.befdept, o.befdept) as befdept -- 变更前机构
    ,nvl(n.aftdept, o.aftdept) as aftdept -- 变更后机构
    ,nvl(n.ncbstranti, o.ncbstranti) as ncbstranti -- 业务发生时点
    ,case when
            n.stacid is null
            and n.systid is null
            and n.loanno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.loanno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.loanno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_ama_loan_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_ama_loan_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.loanno = n.loanno
where (
        o.stacid is null
        and o.systid is null
        and o.loanno is null
    )
    or (
        n.stacid is null
        and n.systid is null
        and n.loanno is null
    )
    or (
        o.transq <> n.transq
        or o.trancd <> n.trancd
        or o.crcycd <> n.crcycd
        or o.deptcd <> n.deptcd
        or o.debtno <> n.debtno
        or o.busitp <> n.busitp
        or o.prducd <> n.prducd
        or o.lnctno <> n.lnctno
        or o.odlnno <> n.odlnno
        or o.descpt <> n.descpt
        or o.accrtg <> n.accrtg
        or o.amortg <> n.amortg
        or o.extetg <> n.extetg
        or o.secutg <> n.secutg
        or o.incotg <> n.incotg
        or o.dscttg <> n.dscttg
        or o.adittg <> n.adittg
        or o.status <> n.status
        or o.ratenr <> n.ratenr
        or o.ratecy <> n.ratecy
        or o.ovdurt <> n.ovdurt
        or o.ovducy <> n.ovducy
        or o.compra <> n.compra
        or o.compcy <> n.compcy
        or o.gracrt <> n.gracrt
        or o.graccy <> n.graccy
        or o.amorfr <> n.amorfr
        or o.stindt <> n.stindt
        or o.nesedt <> n.nesedt
        or o.exindt <> n.exindt
        or o.gracdy <> n.gracdy
        or o.intetg <> n.intetg
        or o.custcd <> n.custcd
        or o.custna <> n.custna
        or o.drafcd <> n.drafcd
        or o.drafna <> n.drafna
        or o.riskcd <> n.riskcd
        or o.phascd <> n.phascd
        or o.devaam <> n.devaam
        or o.devatg <> n.devatg
        or o.credco <> n.credco
        or o.issudt <> n.issudt
        or o.actuam <> n.actuam
        or o.issuam <> n.issuam
        or o.expidt <> n.expidt
        or o.retuwy <> n.retuwy
        or o.recocy <> n.recocy
        or o.recofr <> n.recofr
        or o.reincy <> n.reincy
        or o.reinfr <> n.reinfr
        or o.necodt <> n.necodt
        or o.neredt <> n.neredt
        or o.prodp1 <> n.prodp1
        or o.prodp2 <> n.prodp2
        or o.prodp3 <> n.prodp3
        or o.prodp4 <> n.prodp4
        or o.prodp5 <> n.prodp5
        or o.prodp6 <> n.prodp6
        or o.prodp7 <> n.prodp7
        or o.prodp8 <> n.prodp8
        or o.prodp9 <> n.prodp9
        or o.prodpa <> n.prodpa
        or o.intead <> n.intead
        or o.accrin <> n.accrin
        or o.intein <> n.intein
        or o.ofbsci <> n.ofbsci
        or o.asseip <> n.asseip
        or o.impaii <> n.impaii
        or o.intere <> n.intere
        or o.ofbsir <> n.ofbsir
        or o.ofbsrc <> n.ofbsrc
        or o.ofbsai <> n.ofbsai
        or o.normpr <> n.normpr
        or o.veripr <> n.veripr
        or o.inteim <> n.inteim
        or o.asselo <> n.asselo
        or o.wrofbd <> n.wrofbd
        or o.wrofde <> n.wrofde
        or o.wrinbd <> n.wrinbd
        or o.iminye <> n.iminye
        or o.acinin <> n.acinin
        or o.imiiye <> n.imiiye
        or o.acimii <> n.acimii
        or o.vataxm <> n.vataxm
        or o.amou01 <> n.amou01
        or o.amou02 <> n.amou02
        or o.amou03 <> n.amou03
        or o.amou04 <> n.amou04
        or o.amou05 <> n.amou05
        or o.amou06 <> n.amou06
        or o.amou07 <> n.amou07
        or o.attra1 <> n.attra1
        or o.attra2 <> n.attra2
        or o.attra3 <> n.attra3
        or o.attra4 <> n.attra4
        or o.attra5 <> n.attra5
        or o.attra6 <> n.attra6
        or o.attra7 <> n.attra7
        or o.attra8 <> n.attra8
        or o.attra9 <> n.attra9
        or o.attraa <> n.attraa
        or o.puprtg <> n.puprtg
        or o.amorco <> n.amorco
        or o.oppotr <> n.oppotr
        or o.accuto <> n.accuto
        or o.netrsq <> n.netrsq
        or o.acasil <> n.acasil
        or o.trandt <> n.trandt
        or o.eventp <> n.eventp
        or o.reinre <> n.reinre
        or o.regcir <> n.regcir
        or o.reacin <> n.reacin
        or o.reacci <> n.reacci
        or o.regaci <> n.regaci
        or o.regicr <> n.regicr
        or o.invein <> n.invein
        or o.inveye <> n.inveye
        or o.inveto <> n.inveto
        or o.islast <> n.islast
        or o.bathid <> n.bathid
        or o.tranbr <> n.tranbr
        or o.strkst <> n.strkst
        or o.strkdt <> n.strkdt
        or o.strksq <> n.strksq
        or o.evetdn <> n.evetdn
        or o.bsnssq <> n.bsnssq
        or o.amou08 <> n.amou08
        or o.amou09 <> n.amou09
        or o.amou10 <> n.amou10
        or o.amou11 <> n.amou11
        or o.amou12 <> n.amou12
        or o.amou13 <> n.amou13
        or o.amou14 <> n.amou14
        or o.amou15 <> n.amou15
        or o.amou16 <> n.amou16
        or o.amou17 <> n.amou17
        or o.amou18 <> n.amou18
        or o.amou19 <> n.amou19
        or o.amou20 <> n.amou20
        or o.collpe <> n.collpe
        or o.accoin <> n.accoin
        or o.compin <> n.compin
        or o.coacin <> n.coacin
        or o.recede <> n.recede
        or o.collde <> n.collde
        or o.reacpe <> n.reacpe
        or o.coacpe <> n.coacpe
        or o.recepe <> n.recepe
        or o.ovdupr <> n.ovdupr
        or o.befdept <> n.befdept
        or o.aftdept <> n.aftdept
        or o.ncbstranti <> n.ncbstranti
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_ama_loan_acct_cl(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_ama_loan_acct_op(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.systid -- 来源系统编号
    ,o.loanno -- 核心贷款账户编号
    ,o.transq -- 交易流水号
    ,o.trancd -- 子交易
    ,o.crcycd -- 币种，业务字典币种crcy
    ,o.deptcd -- 核心网点号
    ,o.debtno -- 核心借据编号
    ,o.busitp -- 业务类型
    ,o.prducd -- 产品编号
    ,o.lnctno -- 核心合同编号
    ,o.odlnno -- 旧贷款账户编号
    ,o.descpt -- 说明
    ,o.accrtg -- 数据字典应计标识，y-应计，n-非应计
    ,o.amortg -- 摊销标识，y-是，n-否
    ,o.extetg -- 展期标识，y-是，n-否
    ,o.secutg -- 资产证券化状态，y-是，n-否
    ,o.incotg -- 撤并标识，y-是，n-否
    ,o.dscttg -- 贴息标识，y-贴息，n-非贴息
    ,o.adittg -- 预收息标识，y-预收息，n-非预收息
    ,o.status -- 贷款状态,01-正常，02-结清，03-核销
    ,o.ratenr -- 正常合同利率
    ,o.ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
    ,o.ovdurt -- 逾期利率
    ,o.ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
    ,o.compra -- 复利利率
    ,o.compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
    ,o.gracrt -- 宽限期利率
    ,o.graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
    ,o.amorfr -- 摊销频度
    ,o.stindt -- 起息日
    ,o.nesedt -- 下次结息日
    ,o.exindt -- 展期到期日
    ,o.gracdy -- 宽限期
    ,o.intetg -- 计息标志，y-是，n-否
    ,o.custcd -- 客户编号
    ,o.custna -- 客户名称
    ,o.drafcd -- 承兑人代码
    ,o.drafna -- 承兑人名称
    ,o.riskcd -- 贷款五级分类
    ,o.phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
    ,o.devaam -- 贷款减值金额
    ,o.devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
    ,o.credco -- 贷前费用
    ,o.issudt -- 贷款放款日期
    ,o.actuam -- 贷款放款金额
    ,o.issuam -- 贷款放款金额
    ,o.expidt -- 贷款到期日期
    ,o.retuwy -- 还本付息方式
    ,o.recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
    ,o.recofr -- 本金付款频率
    ,o.reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
    ,o.reinfr -- 利息付款频率
    ,o.necodt -- 下次还本日
    ,o.neredt -- 下次还息日
    ,o.prodp1 -- 产品属性1
    ,o.prodp2 -- 产品属性2
    ,o.prodp3 -- 产品属性3
    ,o.prodp4 -- 产品属性4
    ,o.prodp5 -- 产品属性5
    ,o.prodp6 -- 产品属性6
    ,o.prodp7 -- 产品属性7
    ,o.prodp8 -- 产品属性8
    ,o.prodp9 -- 产品属性9
    ,o.prodpa -- 产品属性10
    ,o.intead -- 利息调整
    ,o.accrin -- 应计利息
    ,o.intein -- 利息收入
    ,o.ofbsci -- 表外应计复利
    ,o.asseip -- 资产减值准备
    ,o.impaii -- 已减值利息收入
    ,o.intere -- 应收利息
    ,o.ofbsir -- 表外应收利息
    ,o.ofbsrc -- 表外应收复利
    ,o.ofbsai -- 表外应计利息
    ,o.normpr -- 正常本金
    ,o.veripr -- 减值本金
    ,o.inteim -- 已减值利息
    ,o.asselo -- 资产减值损失
    ,o.wrofbd -- 已核销呆账本金
    ,o.wrofde -- 已核销呆账已减值利息
    ,o.wrinbd -- 已核销呆账利息
    ,o.iminye -- 本年利息收入
    ,o.acinin -- 累计利息收入
    ,o.imiiye -- 本年已减值利息收入
    ,o.acimii -- 累计已减值利息收入
    ,o.vataxm -- 应交增值税
    ,o.amou01 -- 金额01
    ,o.amou02 -- 金额02
    ,o.amou03 -- 金额03
    ,o.amou04 -- 金额04
    ,o.amou05 -- 金额05
    ,o.amou06 -- 金额06
    ,o.amou07 -- 金额07
    ,o.attra1 -- 附加属性1
    ,o.attra2 -- 附加属性2
    ,o.attra3 -- 附加属性3
    ,o.attra4 -- 附加属性4
    ,o.attra5 -- 附加属性5
    ,o.attra6 -- 附加属性6
    ,o.attra7 -- 附加属性7
    ,o.attra8 -- 附加属性8
    ,o.attra9 -- 附加属性9
    ,o.attraa -- 附加属性10
    ,o.puprtg -- 客户类型
    ,o.amorco -- 摊余成本
    ,o.oppotr -- 对方余额类型
    ,o.accuto -- 累计资产减值损失
    ,o.netrsq -- 新交易流水
    ,o.acasil -- 本年资产减值损失
    ,o.trandt -- 交易日期
    ,o.eventp -- 交易场景
    ,o.reinre -- 登记应收利息
    ,o.regcir -- 登记应收复利
    ,o.reacin -- 登记应计利息
    ,o.reacci -- 登记应计复利
    ,o.regaci -- 登记已还利息
    ,o.regicr -- 登记已还复利
    ,o.invein -- 投资收益
    ,o.inveye -- 本年投资收益
    ,o.inveto -- 累计投资收益
    ,o.islast -- 是否交易场景的最后一条，1-是，0-否
    ,o.bathid -- 批次号
    ,o.tranbr -- 交易机构
    ,o.strkst -- 冲正标识
    ,o.strkdt -- 被冲正流水日期
    ,o.strksq -- 被冲正流水
    ,o.evetdn -- 交易方向
    ,o.bsnssq -- 全局流水号
    ,o.amou08 -- 金额08
    ,o.amou09 -- 金额09
    ,o.amou10 -- 金额10
    ,o.amou11 -- 金额11
    ,o.amou12 -- 金额12
    ,o.amou13 -- 金额13
    ,o.amou14 -- 金额14
    ,o.amou15 -- 金额15
    ,o.amou16 -- 金额16
    ,o.amou17 -- 金额17
    ,o.amou18 -- 金额18
    ,o.amou19 -- 金额19
    ,o.amou20 -- 金额20
    ,o.collpe -- 当天到期的利息
    ,o.accoin -- 当天到期的罚息
    ,o.compin -- 当前到期的复利
    ,o.coacin -- 罚息
    ,o.recede -- 复利
    ,o.collde -- 当日应收未收利息余额
    ,o.reacpe -- 逾期利息
    ,o.coacpe -- 逾期罚息
    ,o.recepe -- 逾期复利
    ,o.ovdupr -- 逾期本金
    ,o.befdept -- 变更前机构
    ,o.aftdept -- 变更后机构
    ,o.ncbstranti -- 业务发生时点
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
from ${iol_schema}.tgls_ama_loan_acct_bk o
    left join ${iol_schema}.tgls_ama_loan_acct_op n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.loanno = n.loanno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_ama_loan_acct_cl d
        on
            o.stacid = d.stacid
            and o.systid = d.systid
            and o.loanno = d.loanno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_ama_loan_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_ama_loan_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_ama_loan_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_ama_loan_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_ama_loan_acct exchange partition p_${batch_date} with table ${iol_schema}.tgls_ama_loan_acct_cl;
alter table ${iol_schema}.tgls_ama_loan_acct exchange partition p_20991231 with table ${iol_schema}.tgls_ama_loan_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_ama_loan_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_ama_loan_acct_op purge;
drop table ${iol_schema}.tgls_ama_loan_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_ama_loan_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_ama_loan_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
