/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_loan_acch_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_loan_acch_b
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_loan_acch_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_loan_acch_b(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统，业务字典系统标识systid
    ,trandt varchar2(8) -- 交易日期
    ,loanno varchar2(100) -- 核心贷款账号
    ,transq varchar2(100) -- 交易流水号
    ,trancd varchar2(20) -- 子交易
    ,crcycd varchar2(30) -- 币种，业务字典币种crcy
    ,deptcd varchar2(30) -- 核心网点号
    ,debtno varchar2(100) -- 核心借据号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,lnctno varchar2(100) -- 核心合同号
    ,odlnno varchar2(100) -- 旧贷款账号
    ,descpt varchar2(240) -- 说明
    ,accrtg varchar2(10) -- 数据字典应计标识，y-应计，n-非应计
    ,amortg varchar2(10) -- 摊销标识，y-是，n-否
    ,extetg varchar2(10) -- 展期标识，y-是，n-否
    ,secutg varchar2(10) -- 资产证券化状态，y-是，n-否
    ,incotg varchar2(10) -- 撤并标识，y-是，n-否
    ,dscttg varchar2(10) -- 贴息标识，y-贴息，n-非贴息
    ,adittg varchar2(10) -- 预收息标识，y-预收息，n-非预收息
    ,status varchar2(30) -- 贷款状态,01-正常，02-结清，03-核销
    ,ratenr number -- 正常合同利率
    ,ratecy varchar2(30) -- 正常利率周期，数据字典周期：日，月，季，半年，年
    ,ovdurt number -- 逾期利率
    ,ovducy varchar2(30) -- 逾期利率周期，数据字典周期：日，月，季，半年，年
    ,compra number -- 复利利率
    ,compcy varchar2(30) -- 复利利率周期，数据字典周期：日，月，季，半年，年
    ,gracrt number -- 宽限期利率
    ,graccy varchar2(30) -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
    ,amorfr varchar2(30) -- 摊销频度
    ,stindt varchar2(8) -- 起息日
    ,nesedt varchar2(8) -- 下次结息日
    ,exindt varchar2(8) -- 展期到期日
    ,gracdy number -- 宽限期
    ,intetg varchar2(10) -- 计息标识，y-是，n-否
    ,custcd varchar2(60) -- 客户代码
    ,custna varchar2(200) -- 客户名称
    ,drafcd varchar2(60) -- 承兑人代码
    ,drafna varchar2(150) -- 承兑人名称
    ,riskcd varchar2(30) -- 五级分类，数据字典五级分类riskcd：1-正常，2-关注，3-次级，4-可疑，5-损失
    ,phascd varchar2(30) -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
    ,devaam number(20,2) -- 贷款减值金额
    ,devatg varchar2(10) -- 减值标识，数据字典减值标识：y-减值，n-未减值
    ,credco number(20,2) -- 贷前费用
    ,issudt varchar2(8) -- 贷款发放日期
    ,actuam number(20,2) -- 实际发放金额
    ,issuam number(20,2) -- 贷款发放金额
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
    ,tranti timestamp -- 时间戳
    ,sortno number(10) -- 排序
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
grant select on ${iol_schema}.tgls_ama_loan_acch_b to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_loan_acch_b to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acch_b to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_loan_acch_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_loan_acch_b is '贷款分户余额备份表';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.stacid is '账套标记';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.systid is '来源系统，业务字典系统标识systid';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.trandt is '交易日期';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.loanno is '核心贷款账号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.transq is '交易流水号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.crcycd is '币种，业务字典币种crcy';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.deptcd is '核心网点号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.debtno is '核心借据号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.lnctno is '核心合同号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.odlnno is '旧贷款账号';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.descpt is '说明';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.accrtg is '数据字典应计标识，y-应计，n-非应计';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amortg is '摊销标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.extetg is '展期标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.secutg is '资产证券化状态，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.incotg is '撤并标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.dscttg is '贴息标识，y-贴息，n-非贴息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.adittg is '预收息标识，y-预收息，n-非预收息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ratenr is '正常合同利率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ratecy is '正常利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ovducy is '逾期利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.compra is '复利利率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.compcy is '复利利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.graccy is '宽限期利率周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.stindt is '起息日';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.nesedt is '下次结息日';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.intetg is '计息标识，y-是，n-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.custcd is '客户代码';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.riskcd is '五级分类，数据字典五级分类riskcd：1-正常，2-关注，3-次级，4-可疑，5-损失';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.phascd is '贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.devatg is '减值标识，数据字典减值标识：y-减值，n-未减值';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.issudt is '贷款发放日期';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.actuam is '实际发放金额';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.issuam is '贷款发放金额';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.recocy is '本金付款周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.reincy is '利息付款周期，数据字典周期：日，月，季，半年，年';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.intead is '利息调整';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.accrin is '应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.intein is '利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ofbsci is '表外应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.asseip is '资产减值准备';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.impaii is '已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.intere is '应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ofbsir is '表外应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ofbsrc is '表外应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.ofbsai is '表外应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.veripr is '减值本金';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.inteim is '已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.asselo is '资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.wrofbd is '已核销呆账本金';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.wrofde is '已核销呆账已减值利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.wrinbd is '已核销呆账利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.iminye is '本年利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.acinin is '累计利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.imiiye is '本年已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.acimii is '累计已减值利息收入';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.vataxm is '应交增值税';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.amorco is '摊余成本';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.oppotr is '对方余额类型';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.accuto is '累计资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.netrsq is '新交易流水';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.acasil is '本年资产减值损失';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.reinre is '登记应收利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.regcir is '登记应收复利';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.reacin is '登记应计利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.reacci is '登记应计复利';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.regaci is '登记已还利息';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.regicr is '登记已还复利';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.invein is '投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.inveye is '本年投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.inveto is '累计投资收益';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.tranti is '时间戳';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.sortno is '排序';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_loan_acch_b.etl_timestamp is 'ETL处理时间戳';
