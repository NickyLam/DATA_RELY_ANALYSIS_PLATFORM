/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_loan_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_loan_acct_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_loan_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_loan_acct_h(
    stacid number(19,0) -- 账套标记
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
    ,ratecy varchar2(30) -- 正常利率周期， 数据字典周期：日，月，季，半年，年
    ,ovdurt number(15,8) -- 逾期利率
    ,ovducy varchar2(30) -- 逾期利率周期， 数据字典周期：日，月，季，半年，年
    ,compra number(15,8) -- 复利利率
    ,compcy varchar2(30) -- 复利利率周期， 数据字典周期：日，月，季，半年，年
    ,gracrt number(15,8) -- 宽限期利率
    ,graccy varchar2(30) -- 宽限期利率周期， 数据字典周期：日，月，季，半年，年
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
    ,devatg varchar2(10) -- 减值标识， 数据字典减值标识：y-减值，n-未减值
    ,credco number(20,2) -- 贷前费用
    ,issudt varchar2(8) -- 贷款放款日期
    ,actuam number(20,2) -- 贷款放款金额
    ,issuam number(20,2) -- 贷款放款金额
    ,expidt varchar2(8) -- 贷款到期日期
    ,retuwy varchar2(30) -- 还本付息方式
    ,recocy varchar2(30) -- 本金付款周期， 数据字典周期：日，月，季，半年，年
    ,recofr varchar2(30) -- 本金付款频率
    ,reincy varchar2(30) -- 利息付款周期， 数据字典周期：日，月，季，半年，年
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
    ,trandt varchar2(8) -- 历史表分区字段
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
    ,oritrandt varchar2(8) -- 原表数据日期
    ,remark varchar2(64) -- 历史备份说明
    ,ncbstranti varchar2(20) -- 业务发生时点
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_ama_loan_acct_h to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct_h to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct_h to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acct_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_loan_acct_h is '贷款分户余额历史记录表';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.loanno is '核心贷款账户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.transq is '交易流水号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.crcycd is '币种，业务字典币种crcy';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.deptcd is '核心网点号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.debtno is '核心借据编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.lnctno is '核心合同编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.odlnno is '旧贷款账户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.descpt is '说明';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.accrtg is '数据字典应计标识，y-应计，n-非应计';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amortg is '摊销标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.extetg is '展期标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.secutg is '资产证券化状态，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.incotg is '撤并标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.dscttg is '贴息标识，y-贴息，n-非贴息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.adittg is '预收息标识，y-预收息，n-非预收息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ratenr is '正常合同利率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ratecy is '正常利率周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ovducy is '逾期利率周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.compra is '复利利率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.compcy is '复利利率周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.graccy is '宽限期利率周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.stindt is '起息日';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.nesedt is '下次结息日';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.intetg is '计息标志，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.riskcd is '贷款五级分类';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.phascd is '贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.devatg is '减值标识， 数据字典减值标识：y-减值，n-未减值';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.issudt is '贷款放款日期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.actuam is '贷款放款金额';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.issuam is '贷款放款金额';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.recocy is '本金付款周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reincy is '利息付款周期， 数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.intead is '利息调整';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.accrin is '应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.intein is '利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ofbsci is '表外应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.asseip is '资产减值准备';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.impaii is '已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.intere is '应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ofbsir is '表外应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ofbsrc is '表外应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ofbsai is '表外应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.veripr is '减值本金';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.inteim is '已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.asselo is '资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.wrofbd is '已核销呆账本金';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.wrofde is '已核销呆账已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.wrinbd is '已核销呆账利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.iminye is '本年利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.acinin is '累计利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.imiiye is '本年已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.acimii is '累计已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.vataxm is '应交增值税';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amorco is '摊余成本';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.oppotr is '对方余额类型';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.accuto is '累计资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.netrsq is '新交易流水';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.acasil is '本年资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.trandt is '历史表分区字段';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reinre is '登记应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.regcir is '登记应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reacin is '登记应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reacci is '登记应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.regaci is '登记已还利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.regicr is '登记已还复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.invein is '投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.inveye is '本年投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.inveto is '累计投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.strkst is '冲正标识';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.strkdt is '被冲正流水日期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.strksq is '被冲正流水';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.evetdn is '交易方向';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou08 is '金额08';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou09 is '金额09';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou10 is '金额10';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou11 is '金额11';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou12 is '金额12';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou13 is '金额13';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou14 is '金额14';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou15 is '金额15';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou16 is '金额16';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou17 is '金额17';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou18 is '金额18';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou19 is '金额19';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.amou20 is '金额20';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.collpe is '当天到期的利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.accoin is '当天到期的罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.compin is '当前到期的复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.coacin is '罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.recede is '复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.collde is '当日应收未收利息余额';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.reacpe is '逾期利息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.coacpe is '逾期罚息';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.recepe is '逾期复利';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.befdept is '变更前机构';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.aftdept is '变更后机构';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.oritrandt is '原表数据日期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.remark is '历史备份说明';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.ncbstranti is '业务发生时点';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_loan_acct_h.etl_timestamp is 'ETL处理时间戳';
