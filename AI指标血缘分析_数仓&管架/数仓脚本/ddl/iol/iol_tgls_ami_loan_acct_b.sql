/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_loan_acct_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_loan_acct_b
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_loan_acct_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_loan_acct_b(
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
    ,custna varchar2(200) -- 客户名称
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
grant select on ${iol_schema}.tgls_ami_loan_acct_b to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_b to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_b to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_loan_acct_b is '贷款分户余额接口备份表';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.systid is '来源系统';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.loanno is '贷款账号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.debtno is '贷款借据号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.lnctno is '合同号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.odlnno is '旧贷款账号';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.descpt is '贷款说明';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.deptcd is '贷款网点';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.accrtg is '应计标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amortg is '摊销标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.extetg is '展期标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.secutg is '资产证券化状态';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.incotg is '撤并标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.dscttg is '贴息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.adittg is '预收息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.ratenr is '正常利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.ratecy is '正常利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.ovducy is '逾期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.compra is '复利利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.compcy is '复利利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.graccy is '宽限期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.stindt is '起息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.nesedt is '下期结息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.intetg is '计息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.custcd is '客户代码';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.custna is '客户名称';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.riskcd is '五级分类';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.phascd is '贷款阶段';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.issudt is '贷款发放日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.actuam is '实际发放金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.issuam is '贷款发放金额';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.recocy is '本金付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.reincy is '利息付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.dullpr is '呆滞本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.reacin is '应收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.coacin is '催收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.recede is '应收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.collde is '催收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.reacpe is '应收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.coacpe is '催收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.recepe is '应收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.collpe is '催收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.accoin is '应计复息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.compin is '复息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.accuso is '应计贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.receso is '应收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.prepin is '待摊利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.veripr is '核销本金';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.veriin is '核销利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.income is '利息收入';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.overin is '催收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.hvvein is '已核销本金利息';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.tranti is '时间戳';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_loan_acct_b.etl_timestamp is 'ETL处理时间戳';
