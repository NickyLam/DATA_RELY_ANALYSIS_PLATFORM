/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_loan_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_loan_acct
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_loan_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_loan_acct(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,loanno varchar2(60) -- 核心贷款账户编号
    ,transq varchar2(100) -- 交易流水号
    ,trancd varchar2(20) -- 子交易
    ,crcycd varchar2(3) -- 币种，业务字典币种crcy
    ,deptcd varchar2(30) -- 核心网点号
    ,debtno varchar2(60) -- 核心借据编号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,lnctno varchar2(30) -- 核心合同编号
    ,odlnno varchar2(50) -- 旧贷款账户编号
    ,descpt varchar2(240) -- 说明
    ,accrtg varchar2(10) -- 数据字典应计标识，y-应计，n-非应计
    ,amortg varchar2(10) -- 摊销标识，y-是，n-否
    ,extetg varchar2(10) -- 展期标识，y-是，n-否
    ,secutg varchar2(10) -- 资产证券化状态，y-是，n-否
    ,incotg varchar2(10) -- 撤并标识，y-是，n-否
    ,dscttg varchar2(10) -- 贴息标识，y-贴息，n-非贴息
    ,adittg varchar2(10) -- 预收息标识，y-预收息，n-非预收息
    ,status varchar2(4) -- 贷款状态,01-正常，02-结清，03-核销
    ,ratenr number(15,8) -- 正常合同利率
    ,ratecy varchar2(30) -- 正常利率周期，数据字典周期：日，月，季，半年，年
    ,ovdurt number(15,8) -- 逾期利率
    ,ovducy varchar2(30) -- 逾期利率周期，数据字典周期：日，月，季，半年，年
    ,compra number(15,8) -- 复利利率
    ,compcy varchar2(30) -- 复利利率周期，数据字典周期：日，月，季，半年，年
    ,gracrt number(15,8) -- 宽限期利率
    ,graccy varchar2(30) -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
    ,amorfr varchar2(30) -- 摊销频度
    ,stindt varchar2(8) -- 起息日
    ,nesedt varchar2(8) -- 下次结息日
    ,exindt varchar2(8) -- 展期到期日
    ,gracdy number -- 宽限期
    ,intetg varchar2(1) -- 计息标志，y-是，n-否
    ,custcd varchar2(16) -- 客户编号
    ,custna varchar2(200) -- 客户名称
    ,drafcd varchar2(60) -- 承兑人代码
    ,drafna varchar2(150) -- 承兑人名称
    ,riskcd varchar2(2) -- 贷款五级分类
    ,phascd varchar2(30) -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
    ,devaam number(20,2) -- 贷款减值金额
    ,devatg varchar2(10) -- 减值标识，数据字典减值标识：y-减值，n-未减值
    ,credco number(20,2) -- 贷前费用
    ,issudt varchar2(8) -- 贷款放款日期
    ,actuam number(20,2) -- 贷款放款金额
    ,issuam number(20,2) -- 贷款放款金额
    ,expidt varchar2(8) -- 贷款到期日期
    ,retuwy varchar2(30) -- 还本付息方式
    ,recocy varchar2(30) -- 本金付款周期，数据字典周期：日，月，季，半年，年
    ,recofr varchar2(30) -- 本金付款频率
    ,reincy varchar2(30) -- 利息付款周期，数据字典周期：日，月，季，半年，年
    ,reinfr varchar2(30) -- 利息付款频率
    ,necodt varchar2(8) -- 下次还本日
    ,neredt varchar2(8) -- 下次还息日
    ,prodp1 varchar2(30) -- 产品属性1
    ,prodp2 varchar2(30) -- 产品属性2
    ,prodp3 varchar2(30) -- 产品属性3
    ,prodp4 varchar2(30) -- 产品属性4
    ,prodp5 varchar2(30) -- 产品属性5
    ,prodp6 varchar2(30) -- 产品属性6
    ,prodp7 varchar2(30) -- 产品属性7
    ,prodp8 varchar2(30) -- 产品属性8
    ,prodp9 varchar2(30) -- 产品属性9
    ,prodpa varchar2(30) -- 产品属性10
    ,intead number(20,2) -- 利息调整
    ,accrin number(20,2) -- 应计利息
    ,intein number(20,2) -- 利息收入
    ,ofbsci number(20,2) -- 表外应计复利
    ,asseip number(20,2) -- 资产减值准备
    ,impaii number(20,2) -- 已减值利息收入
    ,intere number(20,2) -- 应收利息
    ,ofbsir number(20,2) -- 表外应收利息
    ,ofbsrc number(20,2) -- 表外应收复利
    ,ofbsai number(20,2) -- 表外应计利息
    ,normpr number(20,2) -- 正常本金
    ,veripr number(20,2) -- 减值本金
    ,inteim number(20,2) -- 已减值利息
    ,asselo number(20,2) -- 资产减值损失
    ,wrofbd number(20,2) -- 已核销呆账本金
    ,wrofde number(20,2) -- 已核销呆账已减值利息
    ,wrinbd number(20,2) -- 已核销呆账利息
    ,iminye number(20,2) -- 本年利息收入
    ,acinin number(20,2) -- 累计利息收入
    ,imiiye number(20,2) -- 本年已减值利息收入
    ,acimii number(20,2) -- 累计已减值利息收入
    ,vataxm number(20,2) -- 应交增值税
    ,amou01 number(20,2) -- 金额01
    ,amou02 number(20,2) -- 金额02
    ,amou03 number(20,2) -- 金额03
    ,amou04 number(20,2) -- 金额04
    ,amou05 number(20,2) -- 金额05
    ,amou06 number(20,2) -- 金额06
    ,amou07 number(20,2) -- 金额07
    ,attra1 varchar2(150) -- 附加属性1
    ,attra2 varchar2(150) -- 附加属性2
    ,attra3 varchar2(200) -- 附加属性3
    ,attra4 varchar2(200) -- 附加属性4
    ,attra5 varchar2(150) -- 附加属性5
    ,attra6 varchar2(150) -- 附加属性6
    ,attra7 varchar2(150) -- 附加属性7
    ,attra8 varchar2(150) -- 附加属性8
    ,attra9 varchar2(150) -- 附加属性9
    ,attraa varchar2(150) -- 附加属性10
    ,puprtg varchar2(2) -- 客户类型
    ,amorco number(20,2) -- 摊余成本
    ,oppotr number(20,2) -- 对方余额类型
    ,accuto number(20,2) -- 累计资产减值损失
    ,netrsq varchar2(100) -- 新交易流水
    ,acasil number(20,2) -- 本年资产减值损失
    ,trandt varchar2(8) -- 交易日期
    ,eventp varchar2(30) -- 交易场景
    ,reinre number(20,2) -- 登记应收利息
    ,regcir number(20,2) -- 登记应收复利
    ,reacin number(20,2) -- 登记应计利息
    ,reacci number(20,2) -- 登记应计复利
    ,regaci number(20,2) -- 登记已还利息
    ,regicr number(20,2) -- 登记已还复利
    ,invein number(20,2) -- 投资收益
    ,inveye number(20,2) -- 本年投资收益
    ,inveto number(20,2) -- 累计投资收益
    ,islast varchar2(1) -- 是否交易场景的最后一条，1-是，0-否
    ,bathid varchar2(50) -- 批次号
    ,tranbr varchar2(12) -- 交易机构
    ,strkst varchar2(1) -- 冲正标识
    ,strkdt varchar2(8) -- 被冲正流水日期
    ,strksq varchar2(64) -- 被冲正流水
    ,evetdn varchar2(30) -- 交易方向
    ,bsnssq varchar2(33) -- 全局流水号
    ,amou08 number(20,2) -- 金额08
    ,amou09 number(20,2) -- 金额09
    ,amou10 number(20,2) -- 金额10
    ,amou11 number(20,2) -- 金额11
    ,amou12 number(20,2) -- 金额12
    ,amou13 number(20,2) -- 金额13
    ,amou14 number(20,2) -- 金额14
    ,amou15 number(20,2) -- 金额15
    ,amou16 number(20,2) -- 金额16
    ,amou17 number(20,2) -- 金额17
    ,amou18 number(20,2) -- 金额18
    ,amou19 number(20,2) -- 金额19
    ,amou20 number(20,2) -- 金额20
    ,collpe number -- 当天到期的利息
    ,accoin number -- 当天到期的罚息
    ,compin number -- 当前到期的复利
    ,coacin number -- 罚息
    ,recede number -- 复利
    ,collde number -- 当日应收未收利息余额
    ,reacpe number -- 逾期利息
    ,coacpe number -- 逾期罚息
    ,recepe number -- 逾期复利
    ,ovdupr number -- 逾期本金
    ,befdept varchar2(30) -- 变更前机构
    ,aftdept varchar2(30) -- 变更后机构
    ,ncbstranti varchar2(20) -- 业务发生时点
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_ama_loan_acct to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_loan_acct is '贷款分户余额表';
comment on column ${iol_schema}.tgls_ama_loan_acct.stacid is '账套标记';
comment on column ${iol_schema}.tgls_ama_loan_acct.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.loanno is '核心贷款账户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.transq is '交易流水号';
comment on column ${iol_schema}.tgls_ama_loan_acct.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_loan_acct.crcycd is '币种，业务字典币种crcy';
comment on column ${iol_schema}.tgls_ama_loan_acct.deptcd is '核心网点号';
comment on column ${iol_schema}.tgls_ama_loan_acct.debtno is '核心借据编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_loan_acct.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.lnctno is '核心合同编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.odlnno is '旧贷款账户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.descpt is '说明';
comment on column ${iol_schema}.tgls_ama_loan_acct.accrtg is '数据字典应计标识，y-应计，n-非应计';
comment on column ${iol_schema}.tgls_ama_loan_acct.amortg is '摊销标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.extetg is '展期标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.secutg is '资产证券化状态，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.incotg is '撤并标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.dscttg is '贴息标识，y-贴息，n-非贴息';
comment on column ${iol_schema}.tgls_ama_loan_acct.adittg is '预收息标识，y-预收息，n-非预收息';
comment on column ${iol_schema}.tgls_ama_loan_acct.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ama_loan_acct.ratenr is '正常合同利率';
comment on column ${iol_schema}.tgls_ama_loan_acct.ratecy is '正常利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ama_loan_acct.ovducy is '逾期利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.compra is '复利利率';
comment on column ${iol_schema}.tgls_ama_loan_acct.compcy is '复利利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ama_loan_acct.graccy is '宽限期利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ama_loan_acct.stindt is '起息日';
comment on column ${iol_schema}.tgls_ama_loan_acct.nesedt is '下次结息日';
comment on column ${iol_schema}.tgls_ama_loan_acct.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ama_loan_acct.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ama_loan_acct.intetg is '计息标志，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.custcd is '客户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_loan_acct.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ama_loan_acct.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ama_loan_acct.riskcd is '贷款五级分类';
comment on column ${iol_schema}.tgls_ama_loan_acct.phascd is '贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段';
comment on column ${iol_schema}.tgls_ama_loan_acct.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ama_loan_acct.devatg is '减值标识，数据字典减值标识：y-减值，n-未减值';
comment on column ${iol_schema}.tgls_ama_loan_acct.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ama_loan_acct.issudt is '贷款放款日期';
comment on column ${iol_schema}.tgls_ama_loan_acct.actuam is '贷款放款金额';
comment on column ${iol_schema}.tgls_ama_loan_acct.issuam is '贷款放款金额';
comment on column ${iol_schema}.tgls_ama_loan_acct.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ama_loan_acct.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ama_loan_acct.recocy is '本金付款周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acct.reincy is '利息付款周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acct.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ama_loan_acct.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_loan_acct.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_loan_acct.intead is '利息调整';
comment on column ${iol_schema}.tgls_ama_loan_acct.accrin is '应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.intein is '利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.ofbsci is '表外应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.asseip is '资产减值准备';
comment on column ${iol_schema}.tgls_ama_loan_acct.impaii is '已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.intere is '应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.ofbsir is '表外应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.ofbsrc is '表外应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.ofbsai is '表外应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ama_loan_acct.veripr is '减值本金';
comment on column ${iol_schema}.tgls_ama_loan_acct.inteim is '已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.asselo is '资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct.wrofbd is '已核销呆账本金';
comment on column ${iol_schema}.tgls_ama_loan_acct.wrofde is '已核销呆账已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.wrinbd is '已核销呆账利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.iminye is '本年利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.acinin is '累计利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.imiiye is '本年已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.acimii is '累计已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct.vataxm is '应交增值税';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_loan_acct.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_loan_acct.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_loan_acct.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_loan_acct.amorco is '摊余成本';
comment on column ${iol_schema}.tgls_ama_loan_acct.oppotr is '对方余额类型';
comment on column ${iol_schema}.tgls_ama_loan_acct.accuto is '累计资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct.netrsq is '新交易流水';
comment on column ${iol_schema}.tgls_ama_loan_acct.acasil is '本年资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct.trandt is '交易日期';
comment on column ${iol_schema}.tgls_ama_loan_acct.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_loan_acct.reinre is '登记应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.regcir is '登记应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.reacin is '登记应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.reacci is '登记应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.regaci is '登记已还利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.regicr is '登记已还复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.invein is '投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct.inveye is '本年投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct.inveto is '累计投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_loan_acct.bathid is '批次号';
comment on column ${iol_schema}.tgls_ama_loan_acct.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_ama_loan_acct.strkst is '冲正标识';
comment on column ${iol_schema}.tgls_ama_loan_acct.strkdt is '被冲正流水日期';
comment on column ${iol_schema}.tgls_ama_loan_acct.strksq is '被冲正流水';
comment on column ${iol_schema}.tgls_ama_loan_acct.evetdn is '交易方向';
comment on column ${iol_schema}.tgls_ama_loan_acct.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou08 is '金额08';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou09 is '金额09';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou10 is '金额10';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou11 is '金额11';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou12 is '金额12';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou13 is '金额13';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou14 is '金额14';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou15 is '金额15';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou16 is '金额16';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou17 is '金额17';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou18 is '金额18';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou19 is '金额19';
comment on column ${iol_schema}.tgls_ama_loan_acct.amou20 is '金额20';
comment on column ${iol_schema}.tgls_ama_loan_acct.collpe is '当天到期的利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.accoin is '当天到期的罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct.compin is '当前到期的复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.coacin is '罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct.recede is '复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.collde is '当日应收未收利息余额';
comment on column ${iol_schema}.tgls_ama_loan_acct.reacpe is '逾期利息';
comment on column ${iol_schema}.tgls_ama_loan_acct.coacpe is '逾期罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct.recepe is '逾期复利';
comment on column ${iol_schema}.tgls_ama_loan_acct.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ama_loan_acct.befdept is '变更前机构';
comment on column ${iol_schema}.tgls_ama_loan_acct.aftdept is '变更后机构';
comment on column ${iol_schema}.tgls_ama_loan_acct.ncbstranti is '业务发生时点';
comment on column ${iol_schema}.tgls_ama_loan_acct.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_ama_loan_acct.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_ama_loan_acct.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_ama_loan_acct.etl_timestamp is 'ETL处理时间戳';
