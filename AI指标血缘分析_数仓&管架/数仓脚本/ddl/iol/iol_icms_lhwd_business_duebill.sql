/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_business_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_duebill(
    serialno varchar2(64) -- 借据编号（第三方/行内）
    ,hxbdserialno varchar2(30) -- 借据编号（行内）
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,putoutserialno varchar2(32) -- 出账编号
    ,contractserialno varchar2(32) -- 业务合同编号
    ,applyno varchar2(64) -- 全局流水号（第三方）
    ,businessmodel varchar2(64) -- 业务模式（第三方）
    ,vouchtype varchar2(18) -- 担保方式
    ,productid varchar2(12) -- 产品编号（行内）
    ,productno varchar2(32) -- 产品编号（第三方）
    ,businesssum number(24,8) -- 借据金额
    ,currency varchar2(3) -- 借据币种
    ,termmonth varchar2(10) -- 期限(月)
    ,termday varchar2(10) -- 期限(天)
    ,repaycycle varchar2(32) -- 还款周期
    ,graceperiod varchar2(10) -- 宽限期
    ,baseratetype varchar2(4) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,executerate number(24,8) -- 执行利率
    ,rateadjusttype varchar2(4) -- 执行利率调整方式
    ,rateadjustfrequency varchar2(32) -- 执行利率调整周期
    ,floatrange number(15,8) -- 执行利率浮动点差BP
    ,overduedays varchar2(10) -- 本金逾期天数
    ,overduedate varchar2(20) -- 本金逾期日期
    ,overduerate number(15,8) -- 逾期利率
    ,overdueratefloattype varchar2(72) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,8) -- 逾期利率浮动比例（%）
    ,compoundrate number(15,8) -- 复利利率
    ,dzhxstatus varchar2(10) -- 核销标志
    ,wrndate varchar2(8) -- 核销日期
    ,wrnpriamt number(24,8) -- 核销本金
    ,wrnintamt number(24,8) -- 核销利息
    ,balance number(24,8) -- 借据余额
    ,intamtbjbalance number(24,8) -- 正常本金余额
    ,intamtlxbalance number(24,8) -- 正常利息余额
    ,overduebjbalance number(24,8) -- 逾期本金余额
    ,overduelxbalance number(24,8) -- 逾期利息余额
    ,capitalpenaltybalance number(24,8) -- 罚息余额
    ,interestpenaltybalance number(24,8) -- 复息余额
    ,ysintamt number(24,8) -- 应收利息
    ,ysodpamt number(24,8) -- 应收罚息
    ,ysodiamt number(24,8) -- 应收复息
    ,reversalflag varchar2(2) -- 冲正标志
    ,classifyresult varchar2(2) -- 贷款五级分类
    ,classifydate date -- 贷款五级分类认定日期
    ,remart varchar2(32) -- 计量标记-资产三分类
    ,repaytype varchar2(4) -- 还款方式
    ,paymenttype varchar2(32) -- 放款支付方式
    ,putoutorgid varchar2(128) -- 出账机构编号(核心机构)
    ,paymentaccountno varchar2(64) -- 入账账户
    ,paymentaccounttype varchar2(64) -- 入账账户类型
    ,paymentaccountname varchar2(500) -- 入账账户名
    ,paymentaccountbankname varchar2(500) -- 入账账户开户机构
    ,repayaccountno varchar2(64) -- 还款账号
    ,repayaccounttype varchar2(64) -- 还款账户类型
    ,repayaccountname varchar2(500) -- 还款账户名
    ,repayaccountbankname varchar2(500) -- 还款账户开户机构
    ,bankcontriratio number(24,6) -- 银行出资比例
    ,totalterms varchar2(10) -- 借据还款计划总期数
    ,curterms varchar2(10) -- 当前期数
    ,unclearperiods varchar2(10) -- 未结清期数
    ,businessstatus varchar2(10) -- 借据状态
    ,finishdate date -- 借据结清日期
    ,putoutdate date -- 发放日期
    ,maturity date -- 借据到期日
    ,creditchannel varchar2(32) -- 授信渠道
    ,intnalloantype varchar2(30) -- 行内贷款类型代码
    ,acrunonacru varchar2(10) -- 应计非应计代码
    ,intsetway varchar2(10) -- 结息方式代码
    ,intaccrway varchar2(10) -- 计息方式代码
    ,intratfloatway varchar2(10) -- 利率浮动方式代码
    ,intratfloatdir varchar2(10) -- 利率浮动方向代码
    ,accountflag varchar2(10) -- 记账标志
    ,intrat number(24,8) -- 固收利率
    ,tdacruint number(24,8) -- 当日应计利息
    ,intoverduedays varchar2(10) -- 利息逾期天数
    ,intoverduedate varchar2(20) -- 利息逾期日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_lhwd_business_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_business_duebill is '联合网贷借据表';
comment on column ${iol_schema}.icms_lhwd_business_duebill.serialno is '借据编号（第三方/行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.hxbdserialno is '借据编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill.customername is '客户名称';
comment on column ${iol_schema}.icms_lhwd_business_duebill.putoutserialno is '出账编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill.contractserialno is '业务合同编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill.applyno is '全局流水号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.businessmodel is '业务模式（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill.productid is '产品编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.productno is '产品编号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.businesssum is '借据金额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.currency is '借据币种';
comment on column ${iol_schema}.icms_lhwd_business_duebill.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_lhwd_business_duebill.termday is '期限(天)';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill.baserate is '基准利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill.executerate is '执行利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill.rateadjusttype is '执行利率调整方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill.rateadjustfrequency is '执行利率调整周期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.floatrange is '执行利率浮动点差BP';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overduedays is '本金逾期天数';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overduedate is '本金逾期日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overdueratefloatvalue is '逾期利率浮动比例（%）';
comment on column ${iol_schema}.icms_lhwd_business_duebill.compoundrate is '复利利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill.dzhxstatus is '核销标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill.wrndate is '核销日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.wrnpriamt is '核销本金';
comment on column ${iol_schema}.icms_lhwd_business_duebill.wrnintamt is '核销利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill.balance is '借据余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intamtbjbalance is '正常本金余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intamtlxbalance is '正常利息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overduebjbalance is '逾期本金余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.overduelxbalance is '逾期利息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.capitalpenaltybalance is '罚息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.interestpenaltybalance is '复息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill.ysintamt is '应收利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill.ysodpamt is '应收罚息';
comment on column ${iol_schema}.icms_lhwd_business_duebill.ysodiamt is '应收复息';
comment on column ${iol_schema}.icms_lhwd_business_duebill.reversalflag is '冲正标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_lhwd_business_duebill.classifydate is '贷款五级分类认定日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repaytype is '还款方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill.paymenttype is '放款支付方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_lhwd_business_duebill.paymentaccountno is '入账账户';
comment on column ${iol_schema}.icms_lhwd_business_duebill.paymentaccounttype is '入账账户类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill.paymentaccountname is '入账账户名';
comment on column ${iol_schema}.icms_lhwd_business_duebill.paymentaccountbankname is '入账账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repayaccountno is '还款账号';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repayaccounttype is '还款账户类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repayaccountname is '还款账户名';
comment on column ${iol_schema}.icms_lhwd_business_duebill.repayaccountbankname is '还款账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill.bankcontriratio is '银行出资比例';
comment on column ${iol_schema}.icms_lhwd_business_duebill.totalterms is '借据还款计划总期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill.curterms is '当前期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill.unclearperiods is '未结清期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill.businessstatus is '借据状态';
comment on column ${iol_schema}.icms_lhwd_business_duebill.finishdate is '借据结清日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.putoutdate is '发放日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.maturity is '借据到期日';
comment on column ${iol_schema}.icms_lhwd_business_duebill.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intnalloantype is '行内贷款类型代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.acrunonacru is '应计非应计代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intsetway is '结息方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intaccrway is '计息方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intratfloatway is '利率浮动方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intratfloatdir is '利率浮动方向代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill.accountflag is '记账标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intrat is '固收利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill.tdacruint is '当日应计利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intoverduedays is '利息逾期天数';
comment on column ${iol_schema}.icms_lhwd_business_duebill.intoverduedate is '利息逾期日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_business_duebill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_business_duebill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_business_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_business_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill.etl_timestamp is 'ETL处理时间戳';
