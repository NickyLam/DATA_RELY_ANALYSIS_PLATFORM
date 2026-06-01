/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_duebill(
    serialno varchar2(30) -- 借据编号
    ,putoutserialno varchar2(64) -- 关联出账编号
    ,contractserialno varchar2(30) -- 关联合同编号
    ,occurdate date -- 发生日期
    ,occurtype varchar2(4) -- 贷款发放类型
    ,vouchtype varchar2(18) -- 主担保方式
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,productid varchar2(32) -- 产品编号
    ,currency varchar2(3) -- 币种
    ,businesssum number(24,6) -- 放款金额
    ,termmonth number(22) -- 期限(月)
    ,termday number(22) -- 期限(天)
    ,putoutdate date -- 发放日期
    ,maturity date -- 约定到期日
    ,actualmaturity date -- 实际到期日
    ,ratemodel varchar2(18) -- 利率模式
    ,baseratetype varchar2(4) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,executerate number(24,8) -- 执行年利率
    ,bailratio number(24,8) -- 保证金比例
    ,bailsum number(24,6) -- 保证金金额
    ,bailaccount varchar2(50) -- 保证金账户编号
    ,repaytype varchar2(4) -- 还款方式
    ,paymenttype varchar2(36) -- 支付方式
    ,repaycycle varchar2(36) -- 还款周期
    ,balance number(24,6) -- 贷款余额
    ,normalbalance number(24,6) -- 正常余额
    ,overduebalance number(24,6) -- 逾期余额
    ,dullbalance number(24,6) -- 呆滞余额
    ,badbalance number(24,6) -- 呆账余额
    ,extendtimes number(4,0) -- 展期次数
    ,innerinterestbalance number(24,6) -- 表内欠息余额
    ,outerinterestbalance number(24,6) -- 表外欠息余额
    ,capitalpenaltybalance number(24,6) -- 逾期罚息余额
    ,interestpenaltybalance number(24,6) -- 复息余额
    ,overduedays number(22,0) -- 贷款逾期天数
    ,owninterestdays number(22) -- 欠息天数
    ,ichangedate date -- 欠息更新日期
    ,graceperiod number(4,0) -- 贷款宽限期
    ,reducereservesum number(24,6) -- 计提准备金额
    ,predictlostsum number(24,6) -- 预测损失金额
    ,finishtype varchar2(36) -- 终结类型
    ,finishdate date -- 终结日期
    ,belongdept varchar2(36) -- 所属条线
    ,offsheetflag varchar2(36) -- 表内外标志
    ,islowrisk varchar2(2) -- 是否低风险
    ,badconfirmdate date -- 首次认定不良日期
    ,classifyresult varchar2(2) -- 贷款五级分类
    ,classifydate date -- 风险分类日期
    ,advanceflag varchar2(1) -- 担保代偿/垫款标志
    ,businessstatus varchar2(36) -- 业务状态
    ,mforgid varchar2(64) -- 主机机构号
    ,relativeduebillno varchar2(64) -- 原始借据号
    ,loanno varchar2(50) -- 贷款卡号
    ,remark varchar2(2000) -- 备注
    ,operatedate date -- 经办日期
    ,operateuserid varchar2(8) -- 业务经办人编号
    ,operateorgid varchar2(64) -- 经办机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,repaydate number(22) -- 默认还款日
    ,mfcustomerid varchar2(80) -- 核心客户号
    ,settlementaccount varchar2(128) -- 结算账号
    ,overduedate varchar2(20) -- 逾期日期
    ,oweinterestdate varchar2(20) -- 欠息日期
    ,classifyresulteleven varchar2(20) -- 风险分类结果（11级）
    ,overduerate number(15,8) -- 逾期利率
    ,mainorgid varchar2(40) -- 机构代号(核心记账机构ID)
    ,remart varchar2(200) -- 计量标记-资产三分类
    ,vouchtype2 varchar2(72) -- 担保方式2
    ,vouchtype3 varchar2(72) -- 担保方式3
    ,rateadjusttype varchar2(4) -- 利率调整方式
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,floatrange number(15,8) -- 浮动幅度
    ,settlementaccountname varchar2(160) -- 结算账户(还款账户)名
    ,loanaccountorgid varchar2(80) -- 贷款入账(出账账户)账户开户机构
    ,overdueratefloattype varchar2(72) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,6) -- 逾期利率浮动值
    ,putoutorgid varchar2(128) -- 出账机构编号(核心机构)
    ,dzhxstatus varchar2(10) -- 呆账核销状态
    ,classifyresultelevendate date -- 十一级分类日期
    ,loanaccountno varchar2(64) -- 贷款入账账号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,loanstatus varchar2(4) -- 贷款状态
    ,zxzflag varchar2(8) -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
    ,assetflag varchar2(2) -- 是否被认定为问题资产
    ,migtcustomerid varchar2(64) -- 转换前客户号
    ,migtbusinesstype varchar2(64) -- 转换前产品ID
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,wrndate varchar2(8) -- 核销日期
    ,repayamt number(24,6) -- 实付金额
    ,prifirstduedate varchar2(8) -- 本金未还最早日期
    ,intfirstduedate varchar2(8) -- 利息未还最早日期
    ,compensateamt number(24,6) -- 代偿金额
    ,yjintamt number(24,6) -- 应计利息
    ,csyjintamt number(24,6) -- 催收应计利息
    ,ysintamt number(24,6) -- 应收欠息
    ,csintamt number(24,6) -- 催收欠息
    ,yjodpamt number(24,6) -- 应计罚息
    ,csyjodpamt number(24,6) -- 催收应计罚息
    ,ysodpamt number(24,6) -- 应收罚息
    ,csodpamt number(24,6) -- 催收罚息
    ,odppostedctddr number(24,6) -- 应收未收罚息
    ,odipostedctddr number(24,6) -- 应收未收复息
    ,yjodiamt number(24,6) -- 应计复息
    ,wrnpriamt number(24,6) -- 核销本金
    ,wrnintamt number(24,6) -- 核销利息
    ,wrnreceiptamt number(24,6) -- 核销回收金额
    ,intdate varchar2(8) -- 下一结息日
    ,accountbalance number(24,6) -- 还款账号余额
    ,accountuserbalance number(24,6) -- 还款账户可用余额
    ,termtype varchar2(1) -- 期限类型
    ,insum number(24,6) -- 累计归还本金
    ,interestinsum number(24,6) -- 累计归还利息
    ,exttradeno varchar2(50) -- 原业务编号
    ,fyjbalamt number(24,6) -- 非应计余额
    ,periods number(22) -- 贷款总期数
    ,remain_periods number(22) -- 剩余还款期数
    ,lastclassifyresultten varchar2(10) -- 上期十级分类标志
    ,lastclassifyresulttendate date -- 上期十级分类日期
    ,classifyfivehchangedate date -- 上一期五级分类变更日期
    ,tenclaind varchar2(2) -- 十级分类人工干预标志1-人工、2-系统
    ,lastclassifyresult varchar2(2) -- 上期五级分类结果
    ,lastclassifyresultdate varchar2(10) -- 上期五级分类完成日期
    ,npltransflag varchar2(3) -- 不良资产转让标识：转入转出
    ,reversalflag varchar2(2) -- 冲正标志：Y-冲正，N-未冲正
    ,risktype varchar2(2) -- 风险业务类型
    ,ratefloatratioorbp varchar2(1) -- 利率浮动类型（1-按比例2-按点差）
    ,loanaccountname varchar2(160) -- 贷款入账(收款账户)账户名
    ,odiflag varchar2(1) -- 是否复利
    ,odpflag varchar2(1) -- 是否罚息
    ,compensatepotype date -- 宽限到期日
    ,gracestartdate date -- 宽限起始日
    ,loanserialno varchar2(64) -- 风险监测关联流水号
    ,whethertorestructuretheloan varchar2(2) -- 是否重组贷款
    ,restructuretheloantype varchar2(8) -- 重组贷款类型
    ,ispensionindustry varchar2(10) -- 养老产业标识
    ,gracetype varchar2(3) -- 宽限期类型
    ,gearprodflag varchar2(1) -- 是否靠档计息标识
    ,absflag varchar2(1) -- 资产证券化标志
    ,intappltype varchar2(1) -- 利率启用方式
    ,rollfreq varchar2(5) -- 利率变更周期
    ,acctspreadrate number(15,8) -- 浮动百分点
    ,intindflag varchar2(1) -- 是否计息
    ,intday varchar2(2) -- 存贷结息日期
    ,inttype varchar2(5) -- 利率类型
    ,interestbalance number(24,6) -- 利息余额
    ,paymentserialno varchar2(64) -- 关联付款申请书编号
    ,actualoverduedays number(22) -- 实际逾期天数（来源核心系统）
    ,notificationstatus varchar2(2) -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
    ,principalbalance number(24,6) -- 本金余额(仅用于对账使用)
    ,tysumcp number(24,6) -- 同业系统本金余额(仅用于对账使用)
    ,originalloandeadline date -- 原贷款到期日
    ,settlementaccountbank varchar2(32) -- 结算账号开户行
    ,settlementaccountnum varchar2(20) -- 结算账户序号
    ,restructuretheloandate date -- 实施重组日期
    ,shareamount number(24,6) -- 分润金额
    ,overduecount number(22) -- 逾期次数
    ,firstoverduedate date -- 首次逾期日期
    ,contoverduedate date -- 连续逾期日期
    ,prioverduedays number(22) -- 本金逾期天数
    ,intoverduedays number(22) -- 利息逾期天数
    ,prioverdueamt number(24,6) -- 本金逾期金额
    ,intoverdueamt number(24,6) -- 利息逾期金额
    ,nextrolldate varchar2(8) -- 下一重定价日期
    ,firstrolldate date -- 首次重定价日期
    ,subproductname varchar2(10) -- 子产品名称
    ,renewaltype varchar2(10) -- 重组类型
    ,outrightsaleflag varchar2(10) -- 卖断式转让标识
    ,incomerighttransferflag varchar2(10) -- 收益权转让标识
    ,recoverflag varchar2(8) -- 实时追缴标识
    ,speciallendflag varchar2(10) -- 专项再贷款标识
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
grant select on ${iol_schema}.icms_business_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_business_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_business_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_business_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_duebill is '借据信息表借据信息表';
comment on column ${iol_schema}.icms_business_duebill.serialno is '借据编号';
comment on column ${iol_schema}.icms_business_duebill.putoutserialno is '关联出账编号';
comment on column ${iol_schema}.icms_business_duebill.contractserialno is '关联合同编号';
comment on column ${iol_schema}.icms_business_duebill.occurdate is '发生日期';
comment on column ${iol_schema}.icms_business_duebill.occurtype is '贷款发放类型';
comment on column ${iol_schema}.icms_business_duebill.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_business_duebill.customerid is '客户编号';
comment on column ${iol_schema}.icms_business_duebill.customername is '客户名称';
comment on column ${iol_schema}.icms_business_duebill.productid is '产品编号';
comment on column ${iol_schema}.icms_business_duebill.currency is '币种';
comment on column ${iol_schema}.icms_business_duebill.businesssum is '放款金额';
comment on column ${iol_schema}.icms_business_duebill.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_business_duebill.termday is '期限(天)';
comment on column ${iol_schema}.icms_business_duebill.putoutdate is '发放日期';
comment on column ${iol_schema}.icms_business_duebill.maturity is '约定到期日';
comment on column ${iol_schema}.icms_business_duebill.actualmaturity is '实际到期日';
comment on column ${iol_schema}.icms_business_duebill.ratemodel is '利率模式';
comment on column ${iol_schema}.icms_business_duebill.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_business_duebill.baserate is '基准利率';
comment on column ${iol_schema}.icms_business_duebill.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_business_duebill.executerate is '执行年利率';
comment on column ${iol_schema}.icms_business_duebill.bailratio is '保证金比例';
comment on column ${iol_schema}.icms_business_duebill.bailsum is '保证金金额';
comment on column ${iol_schema}.icms_business_duebill.bailaccount is '保证金账户编号';
comment on column ${iol_schema}.icms_business_duebill.repaytype is '还款方式';
comment on column ${iol_schema}.icms_business_duebill.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_business_duebill.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_business_duebill.balance is '贷款余额';
comment on column ${iol_schema}.icms_business_duebill.normalbalance is '正常余额';
comment on column ${iol_schema}.icms_business_duebill.overduebalance is '逾期余额';
comment on column ${iol_schema}.icms_business_duebill.dullbalance is '呆滞余额';
comment on column ${iol_schema}.icms_business_duebill.badbalance is '呆账余额';
comment on column ${iol_schema}.icms_business_duebill.extendtimes is '展期次数';
comment on column ${iol_schema}.icms_business_duebill.innerinterestbalance is '表内欠息余额';
comment on column ${iol_schema}.icms_business_duebill.outerinterestbalance is '表外欠息余额';
comment on column ${iol_schema}.icms_business_duebill.capitalpenaltybalance is '逾期罚息余额';
comment on column ${iol_schema}.icms_business_duebill.interestpenaltybalance is '复息余额';
comment on column ${iol_schema}.icms_business_duebill.overduedays is '贷款逾期天数';
comment on column ${iol_schema}.icms_business_duebill.owninterestdays is '欠息天数';
comment on column ${iol_schema}.icms_business_duebill.ichangedate is '欠息更新日期';
comment on column ${iol_schema}.icms_business_duebill.graceperiod is '贷款宽限期';
comment on column ${iol_schema}.icms_business_duebill.reducereservesum is '计提准备金额';
comment on column ${iol_schema}.icms_business_duebill.predictlostsum is '预测损失金额';
comment on column ${iol_schema}.icms_business_duebill.finishtype is '终结类型';
comment on column ${iol_schema}.icms_business_duebill.finishdate is '终结日期';
comment on column ${iol_schema}.icms_business_duebill.belongdept is '所属条线';
comment on column ${iol_schema}.icms_business_duebill.offsheetflag is '表内外标志';
comment on column ${iol_schema}.icms_business_duebill.islowrisk is '是否低风险';
comment on column ${iol_schema}.icms_business_duebill.badconfirmdate is '首次认定不良日期';
comment on column ${iol_schema}.icms_business_duebill.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_business_duebill.classifydate is '风险分类日期';
comment on column ${iol_schema}.icms_business_duebill.advanceflag is '担保代偿/垫款标志';
comment on column ${iol_schema}.icms_business_duebill.businessstatus is '业务状态';
comment on column ${iol_schema}.icms_business_duebill.mforgid is '主机机构号';
comment on column ${iol_schema}.icms_business_duebill.relativeduebillno is '原始借据号';
comment on column ${iol_schema}.icms_business_duebill.loanno is '贷款卡号';
comment on column ${iol_schema}.icms_business_duebill.remark is '备注';
comment on column ${iol_schema}.icms_business_duebill.operatedate is '经办日期';
comment on column ${iol_schema}.icms_business_duebill.operateuserid is '业务经办人编号';
comment on column ${iol_schema}.icms_business_duebill.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_business_duebill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_duebill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_duebill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_duebill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_duebill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_duebill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_duebill.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_duebill.repaydate is '默认还款日';
comment on column ${iol_schema}.icms_business_duebill.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_business_duebill.settlementaccount is '结算账号';
comment on column ${iol_schema}.icms_business_duebill.overduedate is '逾期日期';
comment on column ${iol_schema}.icms_business_duebill.oweinterestdate is '欠息日期';
comment on column ${iol_schema}.icms_business_duebill.classifyresulteleven is '风险分类结果（11级）';
comment on column ${iol_schema}.icms_business_duebill.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_business_duebill.mainorgid is '机构代号(核心记账机构ID)';
comment on column ${iol_schema}.icms_business_duebill.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_business_duebill.vouchtype2 is '担保方式2';
comment on column ${iol_schema}.icms_business_duebill.vouchtype3 is '担保方式3';
comment on column ${iol_schema}.icms_business_duebill.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_business_duebill.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_business_duebill.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_business_duebill.settlementaccountname is '结算账户(还款账户)名';
comment on column ${iol_schema}.icms_business_duebill.loanaccountorgid is '贷款入账(出账账户)账户开户机构';
comment on column ${iol_schema}.icms_business_duebill.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_business_duebill.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_business_duebill.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_business_duebill.dzhxstatus is '呆账核销状态';
comment on column ${iol_schema}.icms_business_duebill.classifyresultelevendate is '十一级分类日期';
comment on column ${iol_schema}.icms_business_duebill.loanaccountno is '贷款入账账号';
comment on column ${iol_schema}.icms_business_duebill.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_business_duebill.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_business_duebill.zxzflag is '支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了';
comment on column ${iol_schema}.icms_business_duebill.assetflag is '是否被认定为问题资产';
comment on column ${iol_schema}.icms_business_duebill.migtcustomerid is '转换前客户号';
comment on column ${iol_schema}.icms_business_duebill.migtbusinesstype is '转换前产品ID';
comment on column ${iol_schema}.icms_business_duebill.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_business_duebill.wrndate is '核销日期';
comment on column ${iol_schema}.icms_business_duebill.repayamt is '实付金额';
comment on column ${iol_schema}.icms_business_duebill.prifirstduedate is '本金未还最早日期';
comment on column ${iol_schema}.icms_business_duebill.intfirstduedate is '利息未还最早日期';
comment on column ${iol_schema}.icms_business_duebill.compensateamt is '代偿金额';
comment on column ${iol_schema}.icms_business_duebill.yjintamt is '应计利息';
comment on column ${iol_schema}.icms_business_duebill.csyjintamt is '催收应计利息';
comment on column ${iol_schema}.icms_business_duebill.ysintamt is '应收欠息';
comment on column ${iol_schema}.icms_business_duebill.csintamt is '催收欠息';
comment on column ${iol_schema}.icms_business_duebill.yjodpamt is '应计罚息';
comment on column ${iol_schema}.icms_business_duebill.csyjodpamt is '催收应计罚息';
comment on column ${iol_schema}.icms_business_duebill.ysodpamt is '应收罚息';
comment on column ${iol_schema}.icms_business_duebill.csodpamt is '催收罚息';
comment on column ${iol_schema}.icms_business_duebill.odppostedctddr is '应收未收罚息';
comment on column ${iol_schema}.icms_business_duebill.odipostedctddr is '应收未收复息';
comment on column ${iol_schema}.icms_business_duebill.yjodiamt is '应计复息';
comment on column ${iol_schema}.icms_business_duebill.wrnpriamt is '核销本金';
comment on column ${iol_schema}.icms_business_duebill.wrnintamt is '核销利息';
comment on column ${iol_schema}.icms_business_duebill.wrnreceiptamt is '核销回收金额';
comment on column ${iol_schema}.icms_business_duebill.intdate is '下一结息日';
comment on column ${iol_schema}.icms_business_duebill.accountbalance is '还款账号余额';
comment on column ${iol_schema}.icms_business_duebill.accountuserbalance is '还款账户可用余额';
comment on column ${iol_schema}.icms_business_duebill.termtype is '期限类型';
comment on column ${iol_schema}.icms_business_duebill.insum is '累计归还本金';
comment on column ${iol_schema}.icms_business_duebill.interestinsum is '累计归还利息';
comment on column ${iol_schema}.icms_business_duebill.exttradeno is '原业务编号';
comment on column ${iol_schema}.icms_business_duebill.fyjbalamt is '非应计余额';
comment on column ${iol_schema}.icms_business_duebill.periods is '贷款总期数';
comment on column ${iol_schema}.icms_business_duebill.remain_periods is '剩余还款期数';
comment on column ${iol_schema}.icms_business_duebill.lastclassifyresultten is '上期十级分类标志';
comment on column ${iol_schema}.icms_business_duebill.lastclassifyresulttendate is '上期十级分类日期';
comment on column ${iol_schema}.icms_business_duebill.classifyfivehchangedate is '上一期五级分类变更日期';
comment on column ${iol_schema}.icms_business_duebill.tenclaind is '十级分类人工干预标志1-人工、2-系统';
comment on column ${iol_schema}.icms_business_duebill.lastclassifyresult is '上期五级分类结果';
comment on column ${iol_schema}.icms_business_duebill.lastclassifyresultdate is '上期五级分类完成日期';
comment on column ${iol_schema}.icms_business_duebill.npltransflag is '不良资产转让标识：转入转出';
comment on column ${iol_schema}.icms_business_duebill.reversalflag is '冲正标志：Y-冲正，N-未冲正';
comment on column ${iol_schema}.icms_business_duebill.risktype is '风险业务类型';
comment on column ${iol_schema}.icms_business_duebill.ratefloatratioorbp is '利率浮动类型（1-按比例2-按点差）';
comment on column ${iol_schema}.icms_business_duebill.loanaccountname is '贷款入账(收款账户)账户名';
comment on column ${iol_schema}.icms_business_duebill.odiflag is '是否复利';
comment on column ${iol_schema}.icms_business_duebill.odpflag is '是否罚息';
comment on column ${iol_schema}.icms_business_duebill.compensatepotype is '宽限到期日';
comment on column ${iol_schema}.icms_business_duebill.gracestartdate is '宽限起始日';
comment on column ${iol_schema}.icms_business_duebill.loanserialno is '风险监测关联流水号';
comment on column ${iol_schema}.icms_business_duebill.whethertorestructuretheloan is '是否重组贷款';
comment on column ${iol_schema}.icms_business_duebill.restructuretheloantype is '重组贷款类型';
comment on column ${iol_schema}.icms_business_duebill.ispensionindustry is '养老产业标识';
comment on column ${iol_schema}.icms_business_duebill.gracetype is '宽限期类型';
comment on column ${iol_schema}.icms_business_duebill.gearprodflag is '是否靠档计息标识';
comment on column ${iol_schema}.icms_business_duebill.absflag is '资产证券化标志';
comment on column ${iol_schema}.icms_business_duebill.intappltype is '利率启用方式';
comment on column ${iol_schema}.icms_business_duebill.rollfreq is '利率变更周期';
comment on column ${iol_schema}.icms_business_duebill.acctspreadrate is '浮动百分点';
comment on column ${iol_schema}.icms_business_duebill.intindflag is '是否计息';
comment on column ${iol_schema}.icms_business_duebill.intday is '存贷结息日期';
comment on column ${iol_schema}.icms_business_duebill.inttype is '利率类型';
comment on column ${iol_schema}.icms_business_duebill.interestbalance is '利息余额';
comment on column ${iol_schema}.icms_business_duebill.paymentserialno is '关联付款申请书编号';
comment on column ${iol_schema}.icms_business_duebill.actualoverduedays is '实际逾期天数（来源核心系统）';
comment on column ${iol_schema}.icms_business_duebill.notificationstatus is '债权通知书状态（客户级债权通知书）01-未确认,02-已确认';
comment on column ${iol_schema}.icms_business_duebill.principalbalance is '本金余额(仅用于对账使用)';
comment on column ${iol_schema}.icms_business_duebill.tysumcp is '同业系统本金余额(仅用于对账使用)';
comment on column ${iol_schema}.icms_business_duebill.originalloandeadline is '原贷款到期日';
comment on column ${iol_schema}.icms_business_duebill.settlementaccountbank is '结算账号开户行';
comment on column ${iol_schema}.icms_business_duebill.settlementaccountnum is '结算账户序号';
comment on column ${iol_schema}.icms_business_duebill.restructuretheloandate is '实施重组日期';
comment on column ${iol_schema}.icms_business_duebill.shareamount is '分润金额';
comment on column ${iol_schema}.icms_business_duebill.overduecount is '逾期次数';
comment on column ${iol_schema}.icms_business_duebill.firstoverduedate is '首次逾期日期';
comment on column ${iol_schema}.icms_business_duebill.contoverduedate is '连续逾期日期';
comment on column ${iol_schema}.icms_business_duebill.prioverduedays is '本金逾期天数';
comment on column ${iol_schema}.icms_business_duebill.intoverduedays is '利息逾期天数';
comment on column ${iol_schema}.icms_business_duebill.prioverdueamt is '本金逾期金额';
comment on column ${iol_schema}.icms_business_duebill.intoverdueamt is '利息逾期金额';
comment on column ${iol_schema}.icms_business_duebill.nextrolldate is '下一重定价日期';
comment on column ${iol_schema}.icms_business_duebill.firstrolldate is '首次重定价日期';
comment on column ${iol_schema}.icms_business_duebill.subproductname is '子产品名称';
comment on column ${iol_schema}.icms_business_duebill.renewaltype is '重组类型';
comment on column ${iol_schema}.icms_business_duebill.outrightsaleflag is '卖断式转让标识';
comment on column ${iol_schema}.icms_business_duebill.incomerighttransferflag is '收益权转让标识';
comment on column ${iol_schema}.icms_business_duebill.recoverflag is '实时追缴标识';
comment on column ${iol_schema}.icms_business_duebill.speciallendflag is '专项再贷款标识';
comment on column ${iol_schema}.icms_business_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_duebill.etl_timestamp is 'ETL处理时间戳';
