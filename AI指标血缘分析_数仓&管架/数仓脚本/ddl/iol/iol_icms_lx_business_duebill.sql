/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_business_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_duebill(
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
    ,daysovd number(22,0) -- 逾期天数
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
    ,intrate number(15,8) -- 正常利率
    ,intrateunit varchar2(1) -- 正常利率类型
    ,ovdrate number(15,8) -- 罚息利率
    ,ovdrateunit varchar2(1) -- 罚息利率类型
    ,prepmtfeerate varchar2(16) -- 提前还款手续费率
    ,remart varchar2(200) -- 计量标记-资产三分类
    ,dailyint number(24,6) -- 当日计提利息
    ,dailypnltint number(24,6) -- 当日计提罚息
    ,vouchtype varchar2(18) -- 担保方式
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
grant select on ${iol_schema}.icms_lx_business_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_lx_business_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_lx_business_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_lx_business_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_business_duebill is '乐信借据信息表';
comment on column ${iol_schema}.icms_lx_business_duebill.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_business_duebill.putoutserialno is '出账流水号';
comment on column ${iol_schema}.icms_lx_business_duebill.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_lx_business_duebill.customerid is '客户号';
comment on column ${iol_schema}.icms_lx_business_duebill.customername is '客户名称';
comment on column ${iol_schema}.icms_lx_business_duebill.status is '状态';
comment on column ${iol_schema}.icms_lx_business_duebill.termmonth is '期限';
comment on column ${iol_schema}.icms_lx_business_duebill.ratemodel is '利率模式';
comment on column ${iol_schema}.icms_lx_business_duebill.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill.baserate is '基准利率';
comment on column ${iol_schema}.icms_lx_business_duebill.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_lx_business_duebill.executerate is '执行利率';
comment on column ${iol_schema}.icms_lx_business_duebill.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lx_business_duebill.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_lx_business_duebill.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_lx_business_duebill.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_lx_business_duebill.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_lx_business_duebill.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_lx_business_duebill.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_lx_business_duebill.applydate is '申请日期';
comment on column ${iol_schema}.icms_lx_business_duebill.startdate is '开始日期';
comment on column ${iol_schema}.icms_lx_business_duebill.enddate is '到期日期';
comment on column ${iol_schema}.icms_lx_business_duebill.overduedate is '逾期日期';
comment on column ${iol_schema}.icms_lx_business_duebill.cleardate is '结清日期';
comment on column ${iol_schema}.icms_lx_business_duebill.encashamt is '借据金额';
comment on column ${iol_schema}.icms_lx_business_duebill.currency is '币种';
comment on column ${iol_schema}.icms_lx_business_duebill.repaymode is '还款方式';
comment on column ${iol_schema}.icms_lx_business_duebill.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_lx_business_duebill.totalterms is '总期数';
comment on column ${iol_schema}.icms_lx_business_duebill.curterm is '当前期数';
comment on column ${iol_schema}.icms_lx_business_duebill.repayday is '还款日';
comment on column ${iol_schema}.icms_lx_business_duebill.graceday is '宽限期';
comment on column ${iol_schema}.icms_lx_business_duebill.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_lx_business_duebill.loanform is '贷款形态';
comment on column ${iol_schema}.icms_lx_business_duebill.printotal is '应还本金';
comment on column ${iol_schema}.icms_lx_business_duebill.prinrepay is '已还本金';
comment on column ${iol_schema}.icms_lx_business_duebill.prinbal is '正常本金余额';
comment on column ${iol_schema}.icms_lx_business_duebill.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_lx_business_duebill.intplan is '计划利息';
comment on column ${iol_schema}.icms_lx_business_duebill.inttotal is '应还利息';
comment on column ${iol_schema}.icms_lx_business_duebill.intrepay is '已还利息';
comment on column ${iol_schema}.icms_lx_business_duebill.intdiscount is '减免利息';
comment on column ${iol_schema}.icms_lx_business_duebill.intbal is '利息余额';
comment on column ${iol_schema}.icms_lx_business_duebill.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_lx_business_duebill.pnltinttotal is '应收罚息';
comment on column ${iol_schema}.icms_lx_business_duebill.pnltintrepay is '已还罚息';
comment on column ${iol_schema}.icms_lx_business_duebill.pnltintdiscount is '减免罚息';
comment on column ${iol_schema}.icms_lx_business_duebill.pnltintbal is '罚息余额';
comment on column ${iol_schema}.icms_lx_business_duebill.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_lx_business_duebill.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_lx_business_duebill.daysovd is '逾期天数';
comment on column ${iol_schema}.icms_lx_business_duebill.interesttransferstatus is '非应计状态';
comment on column ${iol_schema}.icms_lx_business_duebill.loanresponsetime is '支付返回成功时间';
comment on column ${iol_schema}.icms_lx_business_duebill.writeoffstatus is '核销状态';
comment on column ${iol_schema}.icms_lx_business_duebill.writeofftime is '核销时间';
comment on column ${iol_schema}.icms_lx_business_duebill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_business_duebill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_business_duebill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_business_duebill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_business_duebill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_business_duebill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_business_duebill.startterm is '开始期序';
comment on column ${iol_schema}.icms_lx_business_duebill.endterm is '结束期序';
comment on column ${iol_schema}.icms_lx_business_duebill.intrate is '正常利率';
comment on column ${iol_schema}.icms_lx_business_duebill.intrateunit is '正常利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill.ovdrate is '罚息利率';
comment on column ${iol_schema}.icms_lx_business_duebill.ovdrateunit is '罚息利率类型';
comment on column ${iol_schema}.icms_lx_business_duebill.prepmtfeerate is '提前还款手续费率';
comment on column ${iol_schema}.icms_lx_business_duebill.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_lx_business_duebill.dailyint is '当日计提利息';
comment on column ${iol_schema}.icms_lx_business_duebill.dailypnltint is '当日计提罚息';
comment on column ${iol_schema}.icms_lx_business_duebill.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lx_business_duebill.repaynum is '还款账户';
comment on column ${iol_schema}.icms_lx_business_duebill.repaynumtype is '还款账户类型';
comment on column ${iol_schema}.icms_lx_business_duebill.paymentnum is '入账账户';
comment on column ${iol_schema}.icms_lx_business_duebill.paymentnumtype is '入账账户类型';
comment on column ${iol_schema}.icms_lx_business_duebill.operateuserid is '经办人';
comment on column ${iol_schema}.icms_lx_business_duebill.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_lx_business_duebill.putoutorgid is '账务机构';
comment on column ${iol_schema}.icms_lx_business_duebill.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_lx_business_duebill.productid is '产品编号';
comment on column ${iol_schema}.icms_lx_business_duebill.loanpurpose is '投向行业';
comment on column ${iol_schema}.icms_lx_business_duebill.interesttype is '计息方式';
comment on column ${iol_schema}.icms_lx_business_duebill.bankproportion is '银行出资比例';
comment on column ${iol_schema}.icms_lx_business_duebill.fivecateadjdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_lx_business_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_business_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_business_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_business_duebill.etl_timestamp is 'ETL处理时间戳';
