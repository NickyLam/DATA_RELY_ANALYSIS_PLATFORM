/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_loan_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_loan_acct_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_loan_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_loan_acct_h(
    stacid number(19) -- 账套
    ,systid varchar2(30) -- 来源系统
    ,datadt varchar2(8) -- 数据日期
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(100) -- 贷款账号
    ,debtno varchar2(100) -- 贷款借据号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,crcycd varchar2(3) -- 币种
    ,lnctno varchar2(100) -- 合同号
    ,odlnno varchar2(100) -- 旧贷款账号
    ,descpt varchar2(240) -- 贷款说明
    ,deptcd varchar2(30) -- 贷款网点
    ,accrtg varchar2(1) -- 应计标识
    ,amortg varchar2(1) -- 摊销标识
    ,extetg varchar2(1) -- 展期标识
    ,secutg varchar2(1) -- 资产证券化状态
    ,incotg varchar2(1) -- 撤并标识
    ,dscttg varchar2(1) -- 贴息标识
    ,adittg varchar2(1) -- 预收息标识
    ,status varchar2(30) -- 贷款状态,01-正常，02-结清，03-核销
    ,ratenr number -- 正常利率
    ,ratecy varchar2(30) -- 正常利率周期
    ,ovdurt number -- 逾期利率
    ,ovducy varchar2(30) -- 逾期利率周期
    ,compra number -- 复利利率
    ,compcy varchar2(30) -- 复利利率周期
    ,gracrt number -- 宽限期利率
    ,graccy varchar2(30) -- 宽限期利率周期
    ,amorfr varchar2(30) -- 摊销频度
    ,stindt varchar2(8) -- 起息日
    ,nesedt varchar2(8) -- 下期结息日
    ,exindt varchar2(8) -- 展期到期日
    ,gracdy number(18) -- 宽限期
    ,intetg varchar2(1) -- 计息标识
    ,custcd varchar2(60) -- 客户代码
    ,custna varchar2(150) -- 客户名称
    ,drafcd varchar2(60) -- 承兑人代码
    ,drafna varchar2(150) -- 承兑人名称
    ,riskcd varchar2(30) -- 五级分类
    ,phascd varchar2(30) -- 贷款阶段
    ,devaam number -- 贷款减值金额
    ,credco number -- 贷前费用
    ,issudt varchar2(8) -- 贷款发放日期
    ,actuam number -- 实际发放金额
    ,issuam number -- 贷款发放金额
    ,expidt varchar2(8) -- 贷款到期日期
    ,retuwy varchar2(30) -- 还本付息方式
    ,recocy varchar2(30) -- 本金付款周期
    ,recofr varchar2(30) -- 本金付款频率
    ,reincy varchar2(30) -- 利息付款周期
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
    ,normpr number -- 正常本金
    ,ovdupr number(20,2) -- 逾期本金
    ,dullpr number -- 呆滞本金
    ,reacin number -- 应收应计利息
    ,coacin number -- 催收应计利息
    ,recede number -- 应收欠息
    ,collde number -- 催收欠息
    ,reacpe number -- 应收应计罚息
    ,coacpe number -- 催收应计罚息
    ,recepe number -- 应收罚息
    ,collpe number -- 催收罚息
    ,accoin number -- 应计复息
    ,compin number -- 复息
    ,accuso number -- 应计贴息
    ,receso number -- 应收贴息
    ,prepin number -- 待摊利息
    ,veripr number(20,2) -- 核销本金
    ,veriin number(20,2) -- 核销利息
    ,income number -- 利息收入
    ,overin number -- 催收贴息
    ,hvvein number -- 已核销本金利息
    ,amou01 number -- 金额01
    ,amou02 number -- 金额02
    ,amou03 number -- 金额03
    ,amou04 number -- 金额04
    ,amou05 number -- 金额05
    ,amou06 number -- 金额06
    ,amou07 number -- 金额07
    ,attra1 varchar2(150) -- 附加属性1
    ,attra2 varchar2(150) -- 附加属性2
    ,attra3 varchar2(150) -- 附加属性3
    ,attra4 varchar2(150) -- 附加属性4
    ,attra5 varchar2(150) -- 附加属性5
    ,attra6 varchar2(150) -- 附加属性6
    ,attra7 varchar2(150) -- 附加属性7
    ,attra8 varchar2(150) -- 附加属性8
    ,attra9 varchar2(150) -- 附加属性9
    ,attraa varchar2(150) -- 附加属性10
    ,puprtg varchar2(2) -- 客户类型
    ,tranti timestamp -- 时间戳
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
grant select on ${iol_schema}.tgls_ami_loan_acct_h to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_h to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_h to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_loan_acct_h is '贷款分户余额接口历史表';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.systid is '来源系统';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.loanno is '贷款账号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.debtno is '贷款借据号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.lnctno is '合同号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.odlnno is '旧贷款账号';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.descpt is '贷款说明';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.deptcd is '贷款网点';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.accrtg is '应计标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amortg is '摊销标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.extetg is '展期标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.secutg is '资产证券化状态';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.incotg is '撤并标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.dscttg is '贴息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.adittg is '预收息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.ratenr is '正常利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.ratecy is '正常利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.ovducy is '逾期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.compra is '复利利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.compcy is '复利利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.graccy is '宽限期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.stindt is '起息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.nesedt is '下期结息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.intetg is '计息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.custcd is '客户代码';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.custna is '客户名称';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.riskcd is '五级分类';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.phascd is '贷款阶段';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.issudt is '贷款发放日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.actuam is '实际发放金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.issuam is '贷款发放金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.recocy is '本金付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.reincy is '利息付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.dullpr is '呆滞本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.reacin is '应收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.coacin is '催收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.recede is '应收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.collde is '催收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.reacpe is '应收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.coacpe is '催收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.recepe is '应收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.collpe is '催收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.accoin is '应计复息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.compin is '复息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.accuso is '应计贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.receso is '应收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.prepin is '待摊利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.veripr is '核销本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.veriin is '核销利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.income is '利息收入';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.overin is '催收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.hvvein is '已核销本金利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.tranti is '时间戳';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_h.etl_timestamp is 'ETL处理时间戳';
