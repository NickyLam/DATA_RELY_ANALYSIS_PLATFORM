/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_business_duebill_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_business_duebill_his
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_business_duebill_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_duebill_his(
    bizdate date -- 数据日期 批次日期 yyyyMMdd
    ,serialno varchar2(64) -- 借据编号（第三方/行内）
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
    ,overduedays varchar2(10) -- 逾期天数
    ,overduedate varchar2(20) -- 逾期日期
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
grant select on ${iol_schema}.icms_lhwd_business_duebill_his to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill_his to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill_his to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_business_duebill_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_business_duebill_his is '联合网贷借据历史表';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.bizdate is '数据日期 批次日期 yyyyMMdd';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.serialno is '借据编号（第三方/行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.hxbdserialno is '借据编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.customername is '客户名称';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.putoutserialno is '出账编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.contractserialno is '业务合同编号';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.applyno is '全局流水号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.businessmodel is '业务模式（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.productid is '产品编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.productno is '产品编号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.businesssum is '借据金额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.currency is '借据币种';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.termday is '期限(天)';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.baserate is '基准利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.executerate is '执行利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.rateadjusttype is '执行利率调整方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.rateadjustfrequency is '执行利率调整周期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.floatrange is '执行利率浮动点差BP';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overduedate is '逾期日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overdueratefloatvalue is '逾期利率浮动比例（%）';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.compoundrate is '复利利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.dzhxstatus is '核销标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.wrndate is '核销日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.wrnpriamt is '核销本金';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.wrnintamt is '核销利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.balance is '借据余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intamtbjbalance is '正常本金余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intamtlxbalance is '正常利息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overduebjbalance is '逾期本金余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.overduelxbalance is '逾期利息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.capitalpenaltybalance is '罚息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.interestpenaltybalance is '复息余额';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.ysintamt is '应收利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.ysodpamt is '应收罚息';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.ysodiamt is '应收复息';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.reversalflag is '冲正标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.classifydate is '贷款五级分类认定日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repaytype is '还款方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.paymenttype is '放款支付方式';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.paymentaccountno is '入账账户';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.paymentaccounttype is '入账账户类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.paymentaccountname is '入账账户名';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.paymentaccountbankname is '入账账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repayaccountno is '还款账号';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repayaccounttype is '还款账户类型';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repayaccountname is '还款账户名';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.repayaccountbankname is '还款账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.bankcontriratio is '银行出资比例';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.totalterms is '借据还款计划总期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.curterms is '当前期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.unclearperiods is '未结清期数';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.businessstatus is '借据状态';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.finishdate is '借据结清日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.putoutdate is '发放日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.maturity is '借据到期日';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intnalloantype is '行内贷款类型代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.acrunonacru is '应计非应计代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intsetway is '结息方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intaccrway is '计息方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intratfloatway is '利率浮动方式代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intratfloatdir is '利率浮动方向代码';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.accountflag is '记账标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intrat is '固收利率';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.tdacruint is '当日应计利息';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intoverduedays is '利息逾期天数';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.intoverduedate is '利息逾期日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_business_duebill_his.etl_timestamp is 'ETL处理时间戳';
