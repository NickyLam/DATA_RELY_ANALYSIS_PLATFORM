/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_business_duebill_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_business_duebill_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_business_duebill_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_duebill_history(
    capitalloanno varchar2(64) -- 借据号
    ,putoutserialno varchar2(64) -- 出账流水号
    ,contractserialno varchar2(64) -- 合同流水号
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,status varchar2(10) -- 状态
    ,termmonth varchar2(10) -- 期限
    ,ratemodel varchar2(18) -- 利率模式
    ,baseratetype varchar2(4) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,executerate number(24,8) -- 执行利率
    ,overduerate number(24,8) -- 逾期利率
    ,rateadjusttype varchar2(4) -- 利率调整方式
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,floatrange number(15,8) -- 浮动幅度
    ,overdueratefloattype varchar2(72) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,6) -- 逾期利率浮动值
    ,classifyresult varchar2(2) -- 贷款五级分类
    ,applydate varchar2(8) -- 申请日期
    ,startdate varchar2(8) -- 开始日期
    ,enddate varchar2(8) -- 到期日期
    ,overduedate date -- 逾期日期
    ,cleardate varchar2(64) -- 结清日期
    ,encashamt number(24,6) -- 借据金额
    ,currency varchar2(3) -- 币种
    ,repaymode varchar2(2) -- 还款方式
    ,repaycycle varchar2(1) -- 还款周期
    ,totalterms number(24,6) -- 总期数
    ,curterm number(24,6) -- 当前期数
    ,repayday number(24,6) -- 还款日
    ,graceday number(24,6) -- 宽限期
    ,loanstatus varchar2(2) -- 贷款状态
    ,loanform varchar2(1) -- 贷款形态
    ,printotal number(24,6) -- 应还本金
    ,prinrepay number(24,6) -- 已还本金
    ,prinbal number(24,6) -- 正常本金余额
    ,ovdprinbal number(24,6) -- 逾期本金余额
    ,intplan number(24,6) -- 计划利息
    ,inttotal number(24,6) -- 应还利息
    ,intrepay number(24,6) -- 已还利息
    ,intdiscount number(24,6) -- 减免利息
    ,intbal number(24,6) -- 利息余额
    ,ovdintbal number(24,6) -- 逾期利息余额
    ,pnltinttotal number(24,6) -- 应收罚息
    ,pnltintrepay number(24,6) -- 已还罚息
    ,pnltintdiscount number(24,6) -- 减免罚息
    ,pnltintbal number(24,6) -- 罚息余额
    ,prepmtfeerepay number(24,6) -- 已还提前还款手续费
    ,outloanchannelno varchar2(64) -- 平台订单号
    ,daysovd number(24,6) -- 逾期天数
    ,interesttransferstatus varchar2(1) -- 非应计状态
    ,loanresponsetime varchar2(14) -- 支付返回成功时间
    ,writeoffstatus varchar2(2) -- 核销状态
    ,writeofftime varchar2(14) -- 核销时间
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,startterm varchar2(64) -- 开始期序
    ,endterm varchar2(64) -- 结束期序
    ,intrate varchar2(16) -- 正常利率
    ,intrateunit varchar2(1) -- 正常利率类型
    ,ovdrate varchar2(16) -- 罚息利率
    ,ovdrateunit varchar2(1) -- 罚息利率类型
    ,prepmtfeerate varchar2(16) -- 提前还款手续费率
    ,remart varchar2(200) -- 计量标记-资产三分类
    ,dailyint number(24,6) -- 当日计提利息
    ,dailypnltint number(24,6) -- 当日计提罚息
    ,vouchtype varchar2(18) -- 主担保方式
    ,repaynum varchar2(64) -- 还款账户
    ,repaynumtype varchar2(64) -- 还款账户类型
    ,paymentnum varchar2(64) -- 入账账户
    ,paymentnumtype varchar2(64) -- 入账账户类型
    ,operateuserid varchar2(16) -- 经办人
    ,operateorgid varchar2(16) -- 经办机构
    ,putoutorgid varchar2(16) -- 账务机构
    ,manageorgid varchar2(16) -- 管理机构
    ,productid varchar2(12) -- 产品编号
    ,loanpurpose varchar2(10) -- 投向行业
    ,interesttype varchar2(10) -- 计息方式
    ,bankproportion varchar2(10) -- 银行出资比例
    ,fivecateadjdate varchar2(20) -- 五级分类认定日期
    ,bizdate varchar2(20) -- 数据日期
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
grant select on ${iol_schema}.icms_lx_business_duebill_history to ${iml_schema};
grant select on ${iol_schema}.icms_lx_business_duebill_history to ${icl_schema};
grant select on ${iol_schema}.icms_lx_business_duebill_history to ${idl_schema};
grant select on ${iol_schema}.icms_lx_business_duebill_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_business_duebill_history is '乐信借据信息表备份表';
comment on column ${iol_schema}.icms_lx_business_duebill_history.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.putoutserialno is '出账流水号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.customerid is '客户号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.customername is '客户名称';
comment on column ${iol_schema}.icms_lx_business_duebill_history.status is '状态';
comment on column ${iol_schema}.icms_lx_business_duebill_history.termmonth is '期限';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ratemodel is '利率模式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill_history.baserate is '基准利率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.executerate is '执行利率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_lx_business_duebill_history.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_lx_business_duebill_history.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_lx_business_duebill_history.applydate is '申请日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.startdate is '开始日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.enddate is '到期日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.overduedate is '逾期日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.cleardate is '结清日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.encashamt is '借据金额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.currency is '币种';
comment on column ${iol_schema}.icms_lx_business_duebill_history.repaymode is '还款方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.totalterms is '总期数';
comment on column ${iol_schema}.icms_lx_business_duebill_history.curterm is '当前期数';
comment on column ${iol_schema}.icms_lx_business_duebill_history.repayday is '还款日';
comment on column ${iol_schema}.icms_lx_business_duebill_history.graceday is '宽限期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_lx_business_duebill_history.loanform is '贷款形态';
comment on column ${iol_schema}.icms_lx_business_duebill_history.printotal is '应还本金';
comment on column ${iol_schema}.icms_lx_business_duebill_history.prinrepay is '已还本金';
comment on column ${iol_schema}.icms_lx_business_duebill_history.prinbal is '正常本金余额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intplan is '计划利息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.inttotal is '应还利息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intrepay is '已还利息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intdiscount is '减免利息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intbal is '利息余额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.pnltinttotal is '应收罚息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.pnltintrepay is '已还罚息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.pnltintdiscount is '减免罚息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.pnltintbal is '罚息余额';
comment on column ${iol_schema}.icms_lx_business_duebill_history.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_lx_business_duebill_history.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.daysovd is '逾期天数';
comment on column ${iol_schema}.icms_lx_business_duebill_history.interesttransferstatus is '非应计状态';
comment on column ${iol_schema}.icms_lx_business_duebill_history.loanresponsetime is '支付返回成功时间';
comment on column ${iol_schema}.icms_lx_business_duebill_history.writeoffstatus is '核销状态';
comment on column ${iol_schema}.icms_lx_business_duebill_history.writeofftime is '核销时间';
comment on column ${iol_schema}.icms_lx_business_duebill_history.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_business_duebill_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_business_duebill_history.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_business_duebill_history.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_business_duebill_history.startterm is '开始期序';
comment on column ${iol_schema}.icms_lx_business_duebill_history.endterm is '结束期序';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intrate is '正常利率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.intrateunit is '正常利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ovdrate is '罚息利率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.ovdrateunit is '罚息利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill_history.prepmtfeerate is '提前还款手续费率';
comment on column ${iol_schema}.icms_lx_business_duebill_history.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_lx_business_duebill_history.dailyint is '当日计提利息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.dailypnltint is '当日计提罚息';
comment on column ${iol_schema}.icms_lx_business_duebill_history.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.repaynum is '还款账户';
comment on column ${iol_schema}.icms_lx_business_duebill_history.repaynumtype is '还款账户类型';
comment on column ${iol_schema}.icms_lx_business_duebill_history.paymentnum is '入账账户';
comment on column ${iol_schema}.icms_lx_business_duebill_history.paymentnumtype is '入账账户类型';
comment on column ${iol_schema}.icms_lx_business_duebill_history.operateuserid is '经办人';
comment on column ${iol_schema}.icms_lx_business_duebill_history.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_lx_business_duebill_history.putoutorgid is '账务机构';
comment on column ${iol_schema}.icms_lx_business_duebill_history.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_lx_business_duebill_history.productid is '产品编号';
comment on column ${iol_schema}.icms_lx_business_duebill_history.loanpurpose is '投向行业';
comment on column ${iol_schema}.icms_lx_business_duebill_history.interesttype is '计息方式';
comment on column ${iol_schema}.icms_lx_business_duebill_history.bankproportion is '银行出资比例';
comment on column ${iol_schema}.icms_lx_business_duebill_history.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.bizdate is '数据日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lx_business_duebill_history.etl_timestamp is 'ETL处理时间戳';
