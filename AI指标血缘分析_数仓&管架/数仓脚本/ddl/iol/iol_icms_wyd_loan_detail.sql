/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_loan_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_loan_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_loan_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_loan_detail(
    datadt varchar2(10) -- 数据日期
    ,ietmcd varchar2(20) -- 科目号
    ,orgid varchar2(20) -- 机构号
    ,lendingref varchar2(64) -- 借据号
    ,contractno varchar2(64) -- 借款合同号
    ,applyno varchar2(64) -- 申请号
    ,loantype varchar2(20) -- 贷款种类
    ,agrrelflg varchar2(1) -- 是否涉农贷款
    ,subsidizedflg varchar2(1) -- 是否贴息贷款
    ,agrrelprop varchar2(10) -- 涉农贷款性质
    ,agrspttype varchar2(10) -- 支农贷款类型
    ,realestatetype varchar2(10) -- 房地产类型
    ,laidoffloantype varchar2(10) -- 下岗失业人员小额贷款类型
    ,custid varchar2(40) -- 客户号
    ,custidtype varchar2(20) -- 客户证件类型
    ,custidno varchar2(30) -- 客户证件号码
    ,custname varchar2(60) -- 客户名称
    ,loanpurpose varchar2(100) -- 投向行业
    ,cardstate varchar2(10) -- 账户状态
    ,startdate varchar2(10) -- 发放日期
    ,maturitydate varchar2(10) -- 到期日期
    ,schmaturitydate varchar2(10) -- 约定到期日期
    ,graceperiod number(11) -- 宽限期
    ,rate number(24,6) -- 执行利率
    ,baserate number(12,4) -- 基准利率
    ,ccycd varchar2(10) -- 币种
    ,amount number(20,4) -- 发放金额
    ,balance number(20,4) -- 贷款余额
    ,paymentfeq varchar2(10) -- 还款频率
    ,payway varchar2(10) -- 支付方式
    ,repricingdate varchar2(10) -- 下一利率重定价日
    ,ratetype varchar2(10) -- 利率类型
    ,overduetype varchar2(10) -- 逾期分类
    ,overduedays number(11) -- 逾期天数
    ,intrtyp varchar2(1) -- 计息标志
    ,interest number(20,4) -- 应收利息
    ,prinoddate varchar2(10) -- 本金逾期日期
    ,prinodamt number(20,4) -- 欠本金额
    ,intoddate varchar2(10) -- 利息逾期日期
    ,intodamt number(20,4) -- 欠息金额
    ,subsidizedint number(20,4) -- 应收贴息
    ,actsubsidizedint number(20,4) -- 实收贴息
    ,fundsource varchar2(10) -- 贷款资金来源
    ,extensionflg varchar2(1) -- 是否展期
    ,extensionamt number(20,4) -- 展期金额
    ,extensionstart varchar2(10) -- 展期起始日期
    ,extensionmaturity varchar2(10) -- 展期到期日期
    ,recomflg varchar2(1) -- 是否重组贷款
    ,recomdate varchar2(10) -- 重组日期
    ,bondamt number(20,4) -- 保证金金额
    ,capitalfund number(12,4) -- 资本金比例
    ,housenum number(11) -- 已有住房套数
    ,tenementfee number(20,4) -- 月物业费
    ,personaddloanflg varchar2(1) -- 是否个人住房抵押追加贷款
    ,managementflag varchar2(1) -- 是否经营性物业贷款
    ,smelttype varchar2(1) -- 铝冶炼细分
    ,strategytype varchar2(10) -- 战略新兴产业类型
    ,upgradeflg varchar2(1) -- 工作转型升级标识
    ,generalreserve number(20,4) -- 一般减值准备
    ,specialprep number(20,4) -- 特殊减值准备
    ,prespe number(20,4) -- 专项减值准备
    ,reserve number(20,4) -- 减值准备
    ,housebuycount varchar2(10) -- 购买住房面积
    ,usedlocat varchar2(10) -- 贷款资金使用位置
    ,ratefloattype varchar2(10) -- 利率浮动类型
    ,guartype varchar2(10) -- 担保方式
    ,originalmaturitym number(5) -- 原始期限_月
    ,originalmaturityd number(5) -- 原始期限_日
    ,remainingmaturitym number(5) -- 剩余期限_月
    ,remainingmaturityd number(5) -- 剩余期限_日
    ,beginloangrade varchar2(10) -- 年初五级分类
    ,poverdueamt number(20,4) -- 逾期总金额
    ,agecd varchar2(32) -- 账龄
    ,pcanceldate varchar2(10) -- 撤销日期
    ,pinitterm number(11) -- 总期数
    ,repricingmaturitym number(5,0) -- 利率重定价期限_月
    ,repricingmaturityd number(5,0) -- 利率重定价期限_日
    ,culturesign varchar2(1) -- 文化产业标识
    ,activatedate varchar2(10) -- 入账日期
    ,pmtduedate varchar2(10) -- 本期应还款日期
    ,bankgroupid varchar2(32) -- 银团编号
    ,terminatedate varchar2(10) -- 终止日期
    ,serno varchar2(32) -- 相关业务编号
    ,insurancepaymentflag varchar2(1) -- 保险代偿标志
    ,insurancepaymentdate varchar2(10) -- 保险代偿日期
    ,insurancepaymentprin number(20,4) -- 保险代偿本金
    ,insurancepaymentfee number(20,4) -- 保险代偿利息
    ,terminatereasoncd varchar2(10) -- 终止原因
    ,assetplanno varchar2(32) -- 资管计划No
    ,assettransferorg varchar2(32) -- 合作机构
    ,assettransferamt number(20,4) -- 资产转让金额
    ,assettransferflag varchar2(10) -- 资产转让标记
    ,assettransferdate varchar2(10) -- 资产转让日期
    ,interestpaidamt number(20,4) -- 应计利息冲抵金额
    ,interestallpaiddate varchar2(10) -- 应计利息全部冲抵日期
    ,eventflag varchar2(10) -- 事件标志
    ,eventdate varchar2(10) -- 事件日期
    ,loantypestage varchar2(20) -- 贷款类型
    ,productstcode varchar2(10) -- 子产品代码
    ,pcurrterm number(11) -- 当前期数
    ,bondccy varchar2(10) -- 保证金币种
    ,typeofcust varchar2(20) -- 客户类型
    ,paidoutdate varchar2(64) -- 结清日期
    ,wtodate varchar2(10) -- 核销日期
    ,cardno varchar2(40) -- cnc卡号
    ,limitreportno varchar2(32) -- 授信协议号
    ,bgrepodate varchar2(10) -- 银团回购日期
    ,loanprocessflag varchar2(10) -- 借据状态
    ,claimeddate varchar2(10) -- 状态变更日期
    ,relativeddloanno varchar2(400) -- 无还本续贷借据
    ,monthrate number(12,4) -- 月息率
    ,packetdate varchar2(10) -- 封包日期
    ,packetbalance number(20,4) -- 封包金额
    ,coreenterprisename varchar2(150) -- 核心企业名称
    ,coreprojectid varchar2(50) -- 项目编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 五级分类
    ,classifyresulteleven varchar2(24) -- 十级分类
    ,inreceivebalance number(24,6) -- 应收利息余额
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
grant select on ${iol_schema}.icms_wyd_loan_detail to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_loan_detail to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_loan_detail to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_loan_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_loan_detail is '贷款表内明细信息';
comment on column ${iol_schema}.icms_wyd_loan_detail.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.ietmcd is '科目号';
comment on column ${iol_schema}.icms_wyd_loan_detail.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_loan_detail.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_loan_detail.contractno is '借款合同号';
comment on column ${iol_schema}.icms_wyd_loan_detail.applyno is '申请号';
comment on column ${iol_schema}.icms_wyd_loan_detail.loantype is '贷款种类';
comment on column ${iol_schema}.icms_wyd_loan_detail.agrrelflg is '是否涉农贷款';
comment on column ${iol_schema}.icms_wyd_loan_detail.subsidizedflg is '是否贴息贷款';
comment on column ${iol_schema}.icms_wyd_loan_detail.agrrelprop is '涉农贷款性质';
comment on column ${iol_schema}.icms_wyd_loan_detail.agrspttype is '支农贷款类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.realestatetype is '房地产类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.laidoffloantype is '下岗失业人员小额贷款类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.custid is '客户号';
comment on column ${iol_schema}.icms_wyd_loan_detail.custidtype is '客户证件类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.custidno is '客户证件号码';
comment on column ${iol_schema}.icms_wyd_loan_detail.custname is '客户名称';
comment on column ${iol_schema}.icms_wyd_loan_detail.loanpurpose is '投向行业';
comment on column ${iol_schema}.icms_wyd_loan_detail.cardstate is '账户状态';
comment on column ${iol_schema}.icms_wyd_loan_detail.startdate is '发放日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.maturitydate is '到期日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.schmaturitydate is '约定到期日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_wyd_loan_detail.rate is '执行利率';
comment on column ${iol_schema}.icms_wyd_loan_detail.baserate is '基准利率';
comment on column ${iol_schema}.icms_wyd_loan_detail.ccycd is '币种';
comment on column ${iol_schema}.icms_wyd_loan_detail.amount is '发放金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.balance is '贷款余额';
comment on column ${iol_schema}.icms_wyd_loan_detail.paymentfeq is '还款频率';
comment on column ${iol_schema}.icms_wyd_loan_detail.payway is '支付方式';
comment on column ${iol_schema}.icms_wyd_loan_detail.repricingdate is '下一利率重定价日';
comment on column ${iol_schema}.icms_wyd_loan_detail.ratetype is '利率类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.overduetype is '逾期分类';
comment on column ${iol_schema}.icms_wyd_loan_detail.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_wyd_loan_detail.intrtyp is '计息标志';
comment on column ${iol_schema}.icms_wyd_loan_detail.interest is '应收利息';
comment on column ${iol_schema}.icms_wyd_loan_detail.prinoddate is '本金逾期日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.prinodamt is '欠本金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.intoddate is '利息逾期日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.intodamt is '欠息金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.subsidizedint is '应收贴息';
comment on column ${iol_schema}.icms_wyd_loan_detail.actsubsidizedint is '实收贴息';
comment on column ${iol_schema}.icms_wyd_loan_detail.fundsource is '贷款资金来源';
comment on column ${iol_schema}.icms_wyd_loan_detail.extensionflg is '是否展期';
comment on column ${iol_schema}.icms_wyd_loan_detail.extensionamt is '展期金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.extensionstart is '展期起始日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.extensionmaturity is '展期到期日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.recomflg is '是否重组贷款';
comment on column ${iol_schema}.icms_wyd_loan_detail.recomdate is '重组日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.bondamt is '保证金金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.capitalfund is '资本金比例';
comment on column ${iol_schema}.icms_wyd_loan_detail.housenum is '已有住房套数';
comment on column ${iol_schema}.icms_wyd_loan_detail.tenementfee is '月物业费';
comment on column ${iol_schema}.icms_wyd_loan_detail.personaddloanflg is '是否个人住房抵押追加贷款';
comment on column ${iol_schema}.icms_wyd_loan_detail.managementflag is '是否经营性物业贷款';
comment on column ${iol_schema}.icms_wyd_loan_detail.smelttype is '铝冶炼细分';
comment on column ${iol_schema}.icms_wyd_loan_detail.strategytype is '战略新兴产业类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.upgradeflg is '工作转型升级标识';
comment on column ${iol_schema}.icms_wyd_loan_detail.generalreserve is '一般减值准备';
comment on column ${iol_schema}.icms_wyd_loan_detail.specialprep is '特殊减值准备';
comment on column ${iol_schema}.icms_wyd_loan_detail.prespe is '专项减值准备';
comment on column ${iol_schema}.icms_wyd_loan_detail.reserve is '减值准备';
comment on column ${iol_schema}.icms_wyd_loan_detail.housebuycount is '购买住房面积';
comment on column ${iol_schema}.icms_wyd_loan_detail.usedlocat is '贷款资金使用位置';
comment on column ${iol_schema}.icms_wyd_loan_detail.ratefloattype is '利率浮动类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.guartype is '担保方式';
comment on column ${iol_schema}.icms_wyd_loan_detail.originalmaturitym is '原始期限_月';
comment on column ${iol_schema}.icms_wyd_loan_detail.originalmaturityd is '原始期限_日';
comment on column ${iol_schema}.icms_wyd_loan_detail.remainingmaturitym is '剩余期限_月';
comment on column ${iol_schema}.icms_wyd_loan_detail.remainingmaturityd is '剩余期限_日';
comment on column ${iol_schema}.icms_wyd_loan_detail.beginloangrade is '年初五级分类';
comment on column ${iol_schema}.icms_wyd_loan_detail.poverdueamt is '逾期总金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.agecd is '账龄';
comment on column ${iol_schema}.icms_wyd_loan_detail.pcanceldate is '撤销日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.pinitterm is '总期数';
comment on column ${iol_schema}.icms_wyd_loan_detail.repricingmaturitym is '利率重定价期限_月';
comment on column ${iol_schema}.icms_wyd_loan_detail.repricingmaturityd is '利率重定价期限_日';
comment on column ${iol_schema}.icms_wyd_loan_detail.culturesign is '文化产业标识';
comment on column ${iol_schema}.icms_wyd_loan_detail.activatedate is '入账日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.pmtduedate is '本期应还款日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.bankgroupid is '银团编号';
comment on column ${iol_schema}.icms_wyd_loan_detail.terminatedate is '终止日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.serno is '相关业务编号';
comment on column ${iol_schema}.icms_wyd_loan_detail.insurancepaymentflag is '保险代偿标志';
comment on column ${iol_schema}.icms_wyd_loan_detail.insurancepaymentdate is '保险代偿日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.insurancepaymentprin is '保险代偿本金';
comment on column ${iol_schema}.icms_wyd_loan_detail.insurancepaymentfee is '保险代偿利息';
comment on column ${iol_schema}.icms_wyd_loan_detail.terminatereasoncd is '终止原因';
comment on column ${iol_schema}.icms_wyd_loan_detail.assetplanno is '资管计划No';
comment on column ${iol_schema}.icms_wyd_loan_detail.assettransferorg is '合作机构';
comment on column ${iol_schema}.icms_wyd_loan_detail.assettransferamt is '资产转让金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.assettransferflag is '资产转让标记';
comment on column ${iol_schema}.icms_wyd_loan_detail.assettransferdate is '资产转让日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.interestpaidamt is '应计利息冲抵金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.interestallpaiddate is '应计利息全部冲抵日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.eventflag is '事件标志';
comment on column ${iol_schema}.icms_wyd_loan_detail.eventdate is '事件日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.loantypestage is '贷款类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.productstcode is '子产品代码';
comment on column ${iol_schema}.icms_wyd_loan_detail.pcurrterm is '当前期数';
comment on column ${iol_schema}.icms_wyd_loan_detail.bondccy is '保证金币种';
comment on column ${iol_schema}.icms_wyd_loan_detail.typeofcust is '客户类型';
comment on column ${iol_schema}.icms_wyd_loan_detail.paidoutdate is '结清日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.wtodate is '核销日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.cardno is 'cnc卡号';
comment on column ${iol_schema}.icms_wyd_loan_detail.limitreportno is '授信协议号';
comment on column ${iol_schema}.icms_wyd_loan_detail.bgrepodate is '银团回购日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.loanprocessflag is '借据状态';
comment on column ${iol_schema}.icms_wyd_loan_detail.claimeddate is '状态变更日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.relativeddloanno is '无还本续贷借据';
comment on column ${iol_schema}.icms_wyd_loan_detail.monthrate is '月息率';
comment on column ${iol_schema}.icms_wyd_loan_detail.packetdate is '封包日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.packetbalance is '封包金额';
comment on column ${iol_schema}.icms_wyd_loan_detail.coreenterprisename is '核心企业名称';
comment on column ${iol_schema}.icms_wyd_loan_detail.coreprojectid is '项目编号';
comment on column ${iol_schema}.icms_wyd_loan_detail.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_loan_detail.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_loan_detail.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_loan_detail.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_loan_detail.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_loan_detail.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_loan_detail.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_loan_detail.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_wyd_loan_detail.classifyresulteleven is '十级分类';
comment on column ${iol_schema}.icms_wyd_loan_detail.inreceivebalance is '应收利息余额';
comment on column ${iol_schema}.icms_wyd_loan_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_loan_detail.etl_timestamp is 'ETL处理时间戳';
