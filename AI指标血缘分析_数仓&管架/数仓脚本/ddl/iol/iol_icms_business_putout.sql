/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_putout
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_putout(
    serialno varchar2(64) -- 出账流水号
    ,executerate number(15,8) -- 执行利率
    ,repaycycle varchar2(36) -- 还款周期
    ,pigeonholedate varchar2(20) -- 归档日期
    ,gainamount number(24,8) -- 递变幅度
    ,productid varchar2(32) -- 产品编号
    ,purpose varchar2(1000) -- 贷款用途(手输描述)
    ,pdgpaymethod varchar2(36) -- 手续费收取方式
    ,repaydate number(22) -- 默认还款日
    ,customerid varchar2(16) -- 客户编号
    ,loanaccountnosub varchar2(128) -- 贷款入账账号(收款账户)子户号
    ,baserate number(15,8) -- 基准利率
    ,policyid varchar2(64) -- 政策编号
    ,occurdate date -- 发生日期
    ,paymenttype varchar2(36) -- 支付方式
    ,completeflag varchar2(2) -- 数据录入完整性标识
    ,inputuserid varchar2(64) -- 登记人
    ,subjectno varchar2(40) -- 科目代码
    ,putoutorgid varchar2(64) -- 出账机构编号(核心机构)
    ,applytype varchar2(64) -- 申请类型
    ,approvestatus varchar2(64) -- 审批状态
    ,updateuserid varchar2(64) -- 更新人
    ,customername varchar2(200) -- 客户名称
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,putoutdate date -- 起息日
    ,updatedate date -- 更新日期
    ,segterm number(22) -- 指定还款计算期限
    ,inputorgid varchar2(64) -- 登记机构
    ,flowtype varchar2(64) -- 流程类型
    ,exchangetime varchar2(40) -- 交易时间
    ,offsheetflag varchar2(36) -- 表内外标志
    ,overdueratefloatvalue number(24,6) -- 逾期利率浮动值
    ,pdgsum number(24,6) -- 手续费金额(元)
    ,jxhjduebillno varchar2(40) -- 借新还旧借据号
    ,rateadjusttype varchar2(4) -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,pdgaccountno varchar2(64) -- 手续费扣费账户
    ,zftransserialno varchar2(80) -- 受托支付止付流水号
    ,contractserialno varchar2(30) -- 合同编号
    ,interestrepaycycle varchar2(36) -- 结息方式
    ,exchangestate varchar2(36) -- 交易状态
    ,bpspreads number(15,8) -- 合同点差
    ,fixedrate number(15,8) -- 固定利率
    ,floatrange number(15,8) -- 浮动幅度
    ,overdueratefloattype varchar2(36) -- 逾期利率浮动方式
    ,remark varchar2(4000) -- 备注
    ,ratemodel varchar2(36) -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,ratefloattype varchar2(36) -- 利率浮动类型浮动利率类型
    ,islowrisk varchar2(2) -- 是否低风险
    ,lendingorgid varchar2(160) -- 贷款机构编号(核心机构)
    ,commissionpaysum number(18,2) -- 受托支付金额
    ,clno varchar2(64) -- 额度编号
    ,segrptamount number(24,6) -- 指定区段拟还本金金额
    ,bailratio number(24,6) -- 保证金比例(%)
    ,transserialno varchar2(80) -- 核心交易流水号
    ,payfrequencyunit varchar2(36) -- 指定周期单位
    ,payfrequency number(22) -- 指定周期
    ,repaytype varchar2(4) -- 还款方式
    ,overduerate number(15,8) -- 逾期执行利率
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,termmonth number(22) -- 期限月
    ,maturity date -- 到期日
    ,gaincyc number(22) -- 递变周期
    ,loanaccountno varchar2(64) -- 贷款入账账号
    ,operateuserid varchar2(8) -- 经办人
    ,contractsum number(24,6) -- 合同金额
    ,bailtransaccount varchar2(80) -- 保证金转出账号
    ,operatedate date -- 经办日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,currency varchar2(3) -- 币种
    ,artificialno varchar2(300) -- 文本合同编号
    ,bailsum number(24,6) -- 保证金金额
    ,vouchtype varchar2(72) -- 主要担保方式
    ,transdate varchar2(20) -- 核心交易日期
    ,secondpayaccount varchar2(64) -- 第二还款账号
    ,bailsubaccount varchar2(5) -- 保证金子户号
    ,putoutcontrol varchar2(1) -- 到日期超批复半年设置，1允许，0禁止
    ,termday number(22) -- 期限天
    ,businesssum number(24,6) -- 本次放款金额
    ,occurtype varchar2(4) -- 发生类型
    ,operateorgid varchar2(64) -- 经办机构
    ,inputdate date -- 登记日期
    ,bailaccount varchar2(80) -- 保证金账号
    ,bailcurrency varchar2(3) -- 保证金币种
    ,settlementaccountname varchar2(160) -- 结算账户(还款账户)名
    ,loanaccountbankname varchar2(200) -- 结算账户(还款账户)开户行
    ,baseratetype varchar2(4) -- 基准利率类型
    ,updateorgid varchar2(64) -- 更新机构
    ,pdgamorfg varchar2(1) -- 手续费是否摊销
    ,loanaccountorgid varchar2(80) -- 贷款入账(收款账户)账户开户机构
    ,belongdept varchar2(36) -- 所属条线
    ,policyversionid varchar2(64) -- 政策版本编号
    ,settlementaccount varchar2(32) -- 结算账号(还款账户)
    ,loanusetype varchar2(6) -- 借款用途类型
    ,loanaccountname varchar2(160) -- 贷款入账(收款账户)账户名
    ,duebillserialno varchar2(80) -- 借据号
    ,pdgpaypercent number(24,6) -- 手续费率
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,remart varchar2(100) -- 计量标记InvestGroup
    ,ratefloatratioorbp varchar2(1) -- 利率浮动类型（1-按比例2-按点差）
    ,cashconcenaccount varchar2(32) -- 资金归集账户
    ,ecodepartmentcode varchar2(18) -- 国民经济类型-EcoDepartmentCode
    ,entscale varchar2(18) -- 企业规模
    ,isfirstloans varchar2(2) -- 是否首次放款-YesNo
    ,ispensionindustry varchar2(10) -- 养老产业标识
    ,migtcustomerid varchar2(64) -- 转换前客户号
    ,migtbusinesstype varchar2(64) -- 转换前产品ID
    ,hangseqno varchar2(50) -- 挂账账户序列号
    ,relacontractno varchar2(64) -- 占用承兑行额度编号
    ,nextsettlementdate varchar2(10) -- 下一结息日
    ,lprrefertype varchar2(2) -- LPR参照方式
    ,othcustomername varchar2(200) -- 对手客户名称
    ,othcustomerid varchar2(32) -- 对手客户编号
    ,subproductname varchar2(10) -- 子产品名称
    ,renewaltype varchar2(10) -- 
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
grant select on ${iol_schema}.icms_business_putout to ${iml_schema};
grant select on ${iol_schema}.icms_business_putout to ${icl_schema};
grant select on ${iol_schema}.icms_business_putout to ${idl_schema};
grant select on ${iol_schema}.icms_business_putout to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_putout is '出账信息表出账信息表';
comment on column ${iol_schema}.icms_business_putout.serialno is '出账流水号';
comment on column ${iol_schema}.icms_business_putout.executerate is '执行利率';
comment on column ${iol_schema}.icms_business_putout.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_business_putout.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_business_putout.gainamount is '递变幅度';
comment on column ${iol_schema}.icms_business_putout.productid is '产品编号';
comment on column ${iol_schema}.icms_business_putout.purpose is '贷款用途(手输描述)';
comment on column ${iol_schema}.icms_business_putout.pdgpaymethod is '手续费收取方式';
comment on column ${iol_schema}.icms_business_putout.repaydate is '默认还款日';
comment on column ${iol_schema}.icms_business_putout.customerid is '客户编号';
comment on column ${iol_schema}.icms_business_putout.loanaccountnosub is '贷款入账账号(收款账户)子户号';
comment on column ${iol_schema}.icms_business_putout.baserate is '基准利率';
comment on column ${iol_schema}.icms_business_putout.policyid is '政策编号';
comment on column ${iol_schema}.icms_business_putout.occurdate is '发生日期';
comment on column ${iol_schema}.icms_business_putout.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_business_putout.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_business_putout.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_putout.subjectno is '科目代码';
comment on column ${iol_schema}.icms_business_putout.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_business_putout.applytype is '申请类型';
comment on column ${iol_schema}.icms_business_putout.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_business_putout.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_putout.customername is '客户名称';
comment on column ${iol_schema}.icms_business_putout.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_business_putout.putoutdate is '起息日';
comment on column ${iol_schema}.icms_business_putout.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_putout.segterm is '指定还款计算期限';
comment on column ${iol_schema}.icms_business_putout.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_putout.flowtype is '流程类型';
comment on column ${iol_schema}.icms_business_putout.exchangetime is '交易时间';
comment on column ${iol_schema}.icms_business_putout.offsheetflag is '表内外标志';
comment on column ${iol_schema}.icms_business_putout.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_business_putout.pdgsum is '手续费金额(元)';
comment on column ${iol_schema}.icms_business_putout.jxhjduebillno is '借新还旧借据号';
comment on column ${iol_schema}.icms_business_putout.rateadjusttype is '利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)';
comment on column ${iol_schema}.icms_business_putout.pdgaccountno is '手续费扣费账户';
comment on column ${iol_schema}.icms_business_putout.zftransserialno is '受托支付止付流水号';
comment on column ${iol_schema}.icms_business_putout.contractserialno is '合同编号';
comment on column ${iol_schema}.icms_business_putout.interestrepaycycle is '结息方式';
comment on column ${iol_schema}.icms_business_putout.exchangestate is '交易状态';
comment on column ${iol_schema}.icms_business_putout.bpspreads is '合同点差';
comment on column ${iol_schema}.icms_business_putout.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_business_putout.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_business_putout.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_business_putout.remark is '备注';
comment on column ${iol_schema}.icms_business_putout.ratemodel is '利率模式利率模式(1固定利率2浮动利率3组合利率)';
comment on column ${iol_schema}.icms_business_putout.ratefloattype is '利率浮动类型浮动利率类型';
comment on column ${iol_schema}.icms_business_putout.islowrisk is '是否低风险';
comment on column ${iol_schema}.icms_business_putout.lendingorgid is '贷款机构编号(核心机构)';
comment on column ${iol_schema}.icms_business_putout.commissionpaysum is '受托支付金额';
comment on column ${iol_schema}.icms_business_putout.clno is '额度编号';
comment on column ${iol_schema}.icms_business_putout.segrptamount is '指定区段拟还本金金额';
comment on column ${iol_schema}.icms_business_putout.bailratio is '保证金比例(%)';
comment on column ${iol_schema}.icms_business_putout.transserialno is '核心交易流水号';
comment on column ${iol_schema}.icms_business_putout.payfrequencyunit is '指定周期单位';
comment on column ${iol_schema}.icms_business_putout.payfrequency is '指定周期';
comment on column ${iol_schema}.icms_business_putout.repaytype is '还款方式';
comment on column ${iol_schema}.icms_business_putout.overduerate is '逾期执行利率';
comment on column ${iol_schema}.icms_business_putout.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_business_putout.termmonth is '期限月';
comment on column ${iol_schema}.icms_business_putout.maturity is '到期日';
comment on column ${iol_schema}.icms_business_putout.gaincyc is '递变周期';
comment on column ${iol_schema}.icms_business_putout.loanaccountno is '贷款入账账号';
comment on column ${iol_schema}.icms_business_putout.operateuserid is '经办人';
comment on column ${iol_schema}.icms_business_putout.contractsum is '合同金额';
comment on column ${iol_schema}.icms_business_putout.bailtransaccount is '保证金转出账号';
comment on column ${iol_schema}.icms_business_putout.operatedate is '经办日期';
comment on column ${iol_schema}.icms_business_putout.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_putout.currency is '币种';
comment on column ${iol_schema}.icms_business_putout.artificialno is '文本合同编号';
comment on column ${iol_schema}.icms_business_putout.bailsum is '保证金金额';
comment on column ${iol_schema}.icms_business_putout.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_business_putout.transdate is '核心交易日期';
comment on column ${iol_schema}.icms_business_putout.secondpayaccount is '第二还款账号';
comment on column ${iol_schema}.icms_business_putout.bailsubaccount is '保证金子户号';
comment on column ${iol_schema}.icms_business_putout.putoutcontrol is '到日期超批复半年设置，1允许，0禁止';
comment on column ${iol_schema}.icms_business_putout.termday is '期限天';
comment on column ${iol_schema}.icms_business_putout.businesssum is '本次放款金额';
comment on column ${iol_schema}.icms_business_putout.occurtype is '发生类型';
comment on column ${iol_schema}.icms_business_putout.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_business_putout.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_putout.bailaccount is '保证金账号';
comment on column ${iol_schema}.icms_business_putout.bailcurrency is '保证金币种';
comment on column ${iol_schema}.icms_business_putout.settlementaccountname is '结算账户(还款账户)名';
comment on column ${iol_schema}.icms_business_putout.loanaccountbankname is '结算账户(还款账户)开户行';
comment on column ${iol_schema}.icms_business_putout.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_business_putout.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_putout.pdgamorfg is '手续费是否摊销';
comment on column ${iol_schema}.icms_business_putout.loanaccountorgid is '贷款入账(收款账户)账户开户机构';
comment on column ${iol_schema}.icms_business_putout.belongdept is '所属条线';
comment on column ${iol_schema}.icms_business_putout.policyversionid is '政策版本编号';
comment on column ${iol_schema}.icms_business_putout.settlementaccount is '结算账号(还款账户)';
comment on column ${iol_schema}.icms_business_putout.loanusetype is '借款用途类型';
comment on column ${iol_schema}.icms_business_putout.loanaccountname is '贷款入账(收款账户)账户名';
comment on column ${iol_schema}.icms_business_putout.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_business_putout.pdgpaypercent is '手续费率';
comment on column ${iol_schema}.icms_business_putout.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_business_putout.remart is '计量标记InvestGroup';
comment on column ${iol_schema}.icms_business_putout.ratefloatratioorbp is '利率浮动类型（1-按比例2-按点差）';
comment on column ${iol_schema}.icms_business_putout.cashconcenaccount is '资金归集账户';
comment on column ${iol_schema}.icms_business_putout.ecodepartmentcode is '国民经济类型-EcoDepartmentCode';
comment on column ${iol_schema}.icms_business_putout.entscale is '企业规模';
comment on column ${iol_schema}.icms_business_putout.isfirstloans is '是否首次放款-YesNo';
comment on column ${iol_schema}.icms_business_putout.ispensionindustry is '养老产业标识';
comment on column ${iol_schema}.icms_business_putout.migtcustomerid is '转换前客户号';
comment on column ${iol_schema}.icms_business_putout.migtbusinesstype is '转换前产品ID';
comment on column ${iol_schema}.icms_business_putout.hangseqno is '挂账账户序列号';
comment on column ${iol_schema}.icms_business_putout.relacontractno is '占用承兑行额度编号';
comment on column ${iol_schema}.icms_business_putout.nextsettlementdate is '下一结息日';
comment on column ${iol_schema}.icms_business_putout.lprrefertype is 'LPR参照方式';
comment on column ${iol_schema}.icms_business_putout.othcustomername is '对手客户名称';
comment on column ${iol_schema}.icms_business_putout.othcustomerid is '对手客户编号';
comment on column ${iol_schema}.icms_business_putout.subproductname is '子产品名称';
comment on column ${iol_schema}.icms_business_putout.renewaltype is '';
comment on column ${iol_schema}.icms_business_putout.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_putout.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_putout.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_putout.etl_timestamp is 'ETL处理时间戳';
