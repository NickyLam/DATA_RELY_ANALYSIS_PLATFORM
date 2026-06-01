/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_loan_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_loan_acct
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_loan_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_loan_acct(
    stacid number(19) -- 账套
    ,systid varchar2(30) -- 来源系统编号
    ,datadt varchar2(8) -- 数据日期
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(60) -- 贷款账户编号
    ,debtno varchar2(60) -- 贷款借据编号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,crcycd varchar2(3) -- 币种
    ,lnctno varchar2(30) -- 合同编号
    ,odlnno varchar2(50) -- 旧贷款账户编号
    ,descpt varchar2(240) -- 贷款说明
    ,deptcd varchar2(30) -- 贷款网点
    ,accrtg varchar2(1) -- 应计标识
    ,amortg varchar2(1) -- 摊销标识
    ,extetg varchar2(1) -- 展期标识
    ,secutg varchar2(1) -- 资产证券化状态
    ,incotg varchar2(1) -- 撤并标识
    ,dscttg varchar2(1) -- 贴息标识
    ,adittg varchar2(1) -- 预收息标识
    ,status varchar2(4) -- 贷款状态,01-正常，02-结清，03-核销
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
    ,intetg varchar2(1) -- 计息标志
    ,custcd varchar2(60) -- 客户代码
    ,custna varchar2(150) -- 客户名称
    ,drafcd varchar2(60) -- 承兑人代码
    ,drafna varchar2(150) -- 承兑人名称
    ,riskcd varchar2(2) -- 贷款五级分类
    ,phascd varchar2(30) -- 贷款阶段
    ,devaam number -- 贷款减值金额
    ,credco number -- 贷前费用
    ,issudt varchar2(8) -- 贷款放款日期
    ,actuam number -- 实际发放金额
    ,issuam number(20,2) -- 贷款放款金额
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
    ,ovdupr number -- 逾期本金
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
    ,tranti timestamp -- 时间
    ,amou08 number -- 金额08
    ,amou09 number -- 金额09
    ,amou10 number -- 金额10
    ,amou11 number -- 金额11
    ,amou12 number -- 金额12
    ,amou13 number -- 金额13
    ,amou14 number -- 金额14
    ,amou15 number -- 金额15
    ,amou16 number -- 金额16
    ,amou17 number -- 金额17
    ,amou18 number -- 金额18
    ,amou19 number -- 金额19
    ,amou20 number -- 金额20
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
grant select on ${iol_schema}.tgls_ami_loan_acct to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_loan_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_loan_acct is '贷款分户余额接口表';
comment on column ${iol_schema}.tgls_ami_loan_acct.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_loan_acct.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_loan_acct.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_loan_acct.loanno is '贷款账户编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.debtno is '贷款借据编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_loan_acct.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_loan_acct.lnctno is '合同编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.odlnno is '旧贷款账户编号';
comment on column ${iol_schema}.tgls_ami_loan_acct.descpt is '贷款说明';
comment on column ${iol_schema}.tgls_ami_loan_acct.deptcd is '贷款网点';
comment on column ${iol_schema}.tgls_ami_loan_acct.accrtg is '应计标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.amortg is '摊销标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.extetg is '展期标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.secutg is '资产证券化状态';
comment on column ${iol_schema}.tgls_ami_loan_acct.incotg is '撤并标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.dscttg is '贴息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.adittg is '预收息标识';
comment on column ${iol_schema}.tgls_ami_loan_acct.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ami_loan_acct.ratenr is '正常利率';
comment on column ${iol_schema}.tgls_ami_loan_acct.ratecy is '正常利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.ovdurt is '逾期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct.ovducy is '逾期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.compra is '复利利率';
comment on column ${iol_schema}.tgls_ami_loan_acct.compcy is '复利利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.gracrt is '宽限期利率';
comment on column ${iol_schema}.tgls_ami_loan_acct.graccy is '宽限期利率周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ami_loan_acct.stindt is '起息日';
comment on column ${iol_schema}.tgls_ami_loan_acct.nesedt is '下期结息日';
comment on column ${iol_schema}.tgls_ami_loan_acct.exindt is '展期到期日';
comment on column ${iol_schema}.tgls_ami_loan_acct.gracdy is '宽限期';
comment on column ${iol_schema}.tgls_ami_loan_acct.intetg is '计息标志';
comment on column ${iol_schema}.tgls_ami_loan_acct.custcd is '客户代码';
comment on column ${iol_schema}.tgls_ami_loan_acct.custna is '客户名称';
comment on column ${iol_schema}.tgls_ami_loan_acct.drafcd is '承兑人代码';
comment on column ${iol_schema}.tgls_ami_loan_acct.drafna is '承兑人名称';
comment on column ${iol_schema}.tgls_ami_loan_acct.riskcd is '贷款五级分类';
comment on column ${iol_schema}.tgls_ami_loan_acct.phascd is '贷款阶段';
comment on column ${iol_schema}.tgls_ami_loan_acct.devaam is '贷款减值金额';
comment on column ${iol_schema}.tgls_ami_loan_acct.credco is '贷前费用';
comment on column ${iol_schema}.tgls_ami_loan_acct.issudt is '贷款放款日期';
comment on column ${iol_schema}.tgls_ami_loan_acct.actuam is '实际发放金额';
comment on column ${iol_schema}.tgls_ami_loan_acct.issuam is '贷款放款金额';
comment on column ${iol_schema}.tgls_ami_loan_acct.expidt is '贷款到期日期';
comment on column ${iol_schema}.tgls_ami_loan_acct.retuwy is '还本付息方式';
comment on column ${iol_schema}.tgls_ami_loan_acct.recocy is '本金付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.recofr is '本金付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct.reincy is '利息付款周期';
comment on column ${iol_schema}.tgls_ami_loan_acct.reinfr is '利息付款频率';
comment on column ${iol_schema}.tgls_ami_loan_acct.necodt is '下次还本日';
comment on column ${iol_schema}.tgls_ami_loan_acct.neredt is '下次还息日';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ami_loan_acct.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ami_loan_acct.dullpr is '呆滞本金';
comment on column ${iol_schema}.tgls_ami_loan_acct.reacin is '应收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct.coacin is '催收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_acct.recede is '应收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct.collde is '催收欠息';
comment on column ${iol_schema}.tgls_ami_loan_acct.reacpe is '应收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct.coacpe is '催收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct.recepe is '应收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct.collpe is '催收罚息';
comment on column ${iol_schema}.tgls_ami_loan_acct.accoin is '应计复息';
comment on column ${iol_schema}.tgls_ami_loan_acct.compin is '复息';
comment on column ${iol_schema}.tgls_ami_loan_acct.accuso is '应计贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct.receso is '应收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct.prepin is '待摊利息';
comment on column ${iol_schema}.tgls_ami_loan_acct.veripr is '核销本金';
comment on column ${iol_schema}.tgls_ami_loan_acct.veriin is '核销利息';
comment on column ${iol_schema}.tgls_ami_loan_acct.income is '利息收入';
comment on column ${iol_schema}.tgls_ami_loan_acct.overin is '催收贴息';
comment on column ${iol_schema}.tgls_ami_loan_acct.hvvein is '已核销本金利息';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_loan_acct.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_loan_acct.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_loan_acct.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ami_loan_acct.tranti is '时间';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou08 is '金额08';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou09 is '金额09';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou10 is '金额10';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou11 is '金额11';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou12 is '金额12';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou13 is '金额13';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou14 is '金额14';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou15 is '金额15';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou16 is '金额16';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou17 is '金额17';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou18 is '金额18';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou19 is '金额19';
comment on column ${iol_schema}.tgls_ami_loan_acct.amou20 is '金额20';
comment on column ${iol_schema}.tgls_ami_loan_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_loan_acct.etl_timestamp is 'ETL处理时间戳';
