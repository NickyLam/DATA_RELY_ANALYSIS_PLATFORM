/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_business_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_business_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_business_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_duebill(
    serialno varchar2(50) -- 借据编号
    ,putoutserialno varchar2(64) -- 出账流水号
    ,contractserialno varchar2(30) -- 合同流水号
    ,baseratetype varchar2(4) -- 基准利率类型
    ,repayday number(24,6) -- 还款日
    ,baserate number(15,8) -- 基准利率
    ,overduerate number(24,8) -- 逾期利率
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,floatrange number(15,8) -- 浮动幅度
    ,overdueratefloattype varchar2(72) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,6) -- 逾期利率浮动值
    ,classifyresult varchar2(2) -- 贷款五级分类
    ,repaycycle varchar2(2) -- 还款周期
    ,totalterms number(24,6) -- 总期数
    ,curterm number(24,6) -- 当前期数
    ,putoutorgid varchar2(32) -- 账务机构
    ,manageorgid varchar2(32) -- 管理机构
    ,productid varchar2(32) -- 产品编号
    ,ratemodel varchar2(18) -- 利率模式
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,rateadjusttype varchar2(4) -- 利率调整方式
    ,remart varchar2(200) -- 计量标记-资产三分类
    ,dailyint number(24,6) -- 当日计提利息
    ,dailypnltint number(24,6) -- 当日计提罚息
    ,bankcontriratio number(24,6) -- 银行出资比例
    ,operateuserid varchar2(16) -- 经办人
    ,operateorgid varchar2(32) -- 经办机构
    ,hxduebillno varchar2(30) -- 核心借据号
    ,loantype varchar2(6) -- 贷款类型
    ,clientname varchar2(200) -- 客户名称
    ,documenttype varchar2(10) -- 证件类型
    ,documentid varchar2(75) -- 证件号码
    ,isscountry varchar2(20) -- 签证国家
    ,cyclefreq varchar2(2) -- 结息周期
    ,termtype varchar2(1) -- 贷款期限类型
    ,guarpaiddate varchar2(10) -- 代偿结清日期
    ,ddpercencontri number(5,2) -- 合作方出资比例
    ,intpltyrate number(15,8) -- 复利利率
    ,oslamt number(17,2) -- 未到期本金
    ,odipamt number(17,2) -- 逾期复利
    ,writeoff varchar2(1) -- 核销标志
    ,writeoffamt number(17,2) -- 核销金额
    ,gracedays number(5,0) -- 宽限期天数
    ,nextrepaydate varchar2(10) -- 下一还款日期
    ,accountingstatus varchar2(3) -- 核算状态
    ,reasoncode varchar2(6) -- 贷款用途
    ,remark1 varchar2(200) -- 备用字段1（行外借据号）
    ,remark2 varchar2(200) -- 备用字段2
    ,unionguaranteeflag varchar2(8) -- 融担模式
    ,guaranteeaid varchar2(20) -- 担保方ID1
    ,guaranteearate number(5,2) -- 担保方1担保比例
    ,guaranteeacontractno varchar2(50) -- 客户担保合同编号1
    ,guaranteebid varchar2(20) -- 担保方ID2
    ,guaranteebrate number(5,2) -- 担保方2担保比例
    ,guaranteebcontractno varchar2(50) -- 客户担保合同编号2
    ,putoutdate varchar2(10) -- 发放日期
    ,maturity varchar2(10) -- 贷款到期日
    ,overduedate varchar2(10) -- 逾期日期
    ,cleardate varchar2(10) -- 结清日期
    ,encashamt number(24,6) -- 借据金额
    ,currency varchar2(3) -- 币种
    ,repaymode varchar2(4) -- 还款方式
    ,termmonth varchar2(5) -- 期限
    ,customerid varchar2(16) -- 客户编号
    ,occurdate varchar2(10) -- 发生日期
    ,trandate varchar2(10) -- 交易日期
    ,ovdprinbal number(24,6) -- 逾期本金余额
    ,ovdintbal number(24,6) -- 逾期利息余额
    ,pnltintbal number(24,6) -- 罚息余额
    ,wphproductid varchar2(50) -- 唯品产品编号
    ,daysovd number(22,0) -- 逾期天数
    ,writeofftime varchar2(10) -- 核销时间
    ,executerate number(24,8) -- 执行利率
    ,ovdrate number(24,8) -- 罚息利率
    ,vouchtype varchar2(18) -- 担保方式
    ,repaynum varchar2(150) -- 还款账户
    ,paymentnum varchar2(150) -- 入账账户
    ,balance number(24,6) -- 借据余额
    ,interestrepaycycle varchar2(36) -- 结息方式
    ,interestcalculation varchar2(36) -- 计息方式
    ,paymentbankname varchar2(200) -- 入账账户开户银行名称
    ,paymentbankno varchar2(200) -- 还款账户开户银行编号
    ,paymentorgname varchar2(200) -- 还款账户开户机构名称
    ,normalamt number(24,6) -- 正常本金
    ,normalintamt number(24,6) -- 正常利息
    ,pnltintoverdue number(24,6) -- 应收欠息
    ,pnltinttotal number(24,6) -- 应收罚息
    ,pnltintamt number(24,6) -- 应收利息
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,bizdate varchar2(10) -- 流程日期
    ,pnltodiamt number(24,6) -- 应收复利
    ,classifyresultdate varchar2(10) -- 五级分类认定日期
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
grant select on ${iol_schema}.icms_wph_business_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_wph_business_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_wph_business_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_wph_business_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_business_duebill is '唯品会借据信息表';
comment on column ${iol_schema}.icms_wph_business_duebill.serialno is '借据编号';
comment on column ${iol_schema}.icms_wph_business_duebill.putoutserialno is '出账流水号';
comment on column ${iol_schema}.icms_wph_business_duebill.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_wph_business_duebill.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wph_business_duebill.repayday is '还款日';
comment on column ${iol_schema}.icms_wph_business_duebill.baserate is '基准利率';
comment on column ${iol_schema}.icms_wph_business_duebill.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_wph_business_duebill.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_wph_business_duebill.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_wph_business_duebill.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_wph_business_duebill.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_wph_business_duebill.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_wph_business_duebill.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_wph_business_duebill.totalterms is '总期数';
comment on column ${iol_schema}.icms_wph_business_duebill.curterm is '当前期数';
comment on column ${iol_schema}.icms_wph_business_duebill.putoutorgid is '账务机构';
comment on column ${iol_schema}.icms_wph_business_duebill.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_wph_business_duebill.productid is '产品编号';
comment on column ${iol_schema}.icms_wph_business_duebill.ratemodel is '利率模式';
comment on column ${iol_schema}.icms_wph_business_duebill.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_wph_business_duebill.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_wph_business_duebill.remart is '计量标记-资产三分类';
comment on column ${iol_schema}.icms_wph_business_duebill.dailyint is '当日计提利息';
comment on column ${iol_schema}.icms_wph_business_duebill.dailypnltint is '当日计提罚息';
comment on column ${iol_schema}.icms_wph_business_duebill.bankcontriratio is '银行出资比例';
comment on column ${iol_schema}.icms_wph_business_duebill.operateuserid is '经办人';
comment on column ${iol_schema}.icms_wph_business_duebill.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_wph_business_duebill.hxduebillno is '核心借据号';
comment on column ${iol_schema}.icms_wph_business_duebill.loantype is '贷款类型';
comment on column ${iol_schema}.icms_wph_business_duebill.clientname is '客户名称';
comment on column ${iol_schema}.icms_wph_business_duebill.documenttype is '证件类型';
comment on column ${iol_schema}.icms_wph_business_duebill.documentid is '证件号码';
comment on column ${iol_schema}.icms_wph_business_duebill.isscountry is '签证国家';
comment on column ${iol_schema}.icms_wph_business_duebill.cyclefreq is '结息周期';
comment on column ${iol_schema}.icms_wph_business_duebill.termtype is '贷款期限类型';
comment on column ${iol_schema}.icms_wph_business_duebill.guarpaiddate is '代偿结清日期';
comment on column ${iol_schema}.icms_wph_business_duebill.ddpercencontri is '合作方出资比例';
comment on column ${iol_schema}.icms_wph_business_duebill.intpltyrate is '复利利率';
comment on column ${iol_schema}.icms_wph_business_duebill.oslamt is '未到期本金';
comment on column ${iol_schema}.icms_wph_business_duebill.odipamt is '逾期复利';
comment on column ${iol_schema}.icms_wph_business_duebill.writeoff is '核销标志';
comment on column ${iol_schema}.icms_wph_business_duebill.writeoffamt is '核销金额';
comment on column ${iol_schema}.icms_wph_business_duebill.gracedays is '宽限期天数';
comment on column ${iol_schema}.icms_wph_business_duebill.nextrepaydate is '下一还款日期';
comment on column ${iol_schema}.icms_wph_business_duebill.accountingstatus is '核算状态';
comment on column ${iol_schema}.icms_wph_business_duebill.reasoncode is '贷款用途';
comment on column ${iol_schema}.icms_wph_business_duebill.remark1 is '备用字段1（行外借据号）';
comment on column ${iol_schema}.icms_wph_business_duebill.remark2 is '备用字段2';
comment on column ${iol_schema}.icms_wph_business_duebill.unionguaranteeflag is '融担模式';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteeaid is '担保方ID1';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteearate is '担保方1担保比例';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteeacontractno is '客户担保合同编号1';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteebid is '担保方ID2';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteebrate is '担保方2担保比例';
comment on column ${iol_schema}.icms_wph_business_duebill.guaranteebcontractno is '客户担保合同编号2';
comment on column ${iol_schema}.icms_wph_business_duebill.putoutdate is '发放日期';
comment on column ${iol_schema}.icms_wph_business_duebill.maturity is '贷款到期日';
comment on column ${iol_schema}.icms_wph_business_duebill.overduedate is '逾期日期';
comment on column ${iol_schema}.icms_wph_business_duebill.cleardate is '结清日期';
comment on column ${iol_schema}.icms_wph_business_duebill.encashamt is '借据金额';
comment on column ${iol_schema}.icms_wph_business_duebill.currency is '币种';
comment on column ${iol_schema}.icms_wph_business_duebill.repaymode is '还款方式';
comment on column ${iol_schema}.icms_wph_business_duebill.termmonth is '期限';
comment on column ${iol_schema}.icms_wph_business_duebill.customerid is '客户编号';
comment on column ${iol_schema}.icms_wph_business_duebill.occurdate is '发生日期';
comment on column ${iol_schema}.icms_wph_business_duebill.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_business_duebill.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_wph_business_duebill.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_wph_business_duebill.pnltintbal is '罚息余额';
comment on column ${iol_schema}.icms_wph_business_duebill.wphproductid is '唯品产品编号';
comment on column ${iol_schema}.icms_wph_business_duebill.daysovd is '逾期天数';
comment on column ${iol_schema}.icms_wph_business_duebill.writeofftime is '核销时间';
comment on column ${iol_schema}.icms_wph_business_duebill.executerate is '执行利率';
comment on column ${iol_schema}.icms_wph_business_duebill.ovdrate is '罚息利率';
comment on column ${iol_schema}.icms_wph_business_duebill.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_wph_business_duebill.repaynum is '还款账户';
comment on column ${iol_schema}.icms_wph_business_duebill.paymentnum is '入账账户';
comment on column ${iol_schema}.icms_wph_business_duebill.balance is '借据余额';
comment on column ${iol_schema}.icms_wph_business_duebill.interestrepaycycle is '结息方式';
comment on column ${iol_schema}.icms_wph_business_duebill.interestcalculation is '计息方式';
comment on column ${iol_schema}.icms_wph_business_duebill.paymentbankname is '入账账户开户银行名称';
comment on column ${iol_schema}.icms_wph_business_duebill.paymentbankno is '还款账户开户银行编号';
comment on column ${iol_schema}.icms_wph_business_duebill.paymentorgname is '还款账户开户机构名称';
comment on column ${iol_schema}.icms_wph_business_duebill.normalamt is '正常本金';
comment on column ${iol_schema}.icms_wph_business_duebill.normalintamt is '正常利息';
comment on column ${iol_schema}.icms_wph_business_duebill.pnltintoverdue is '应收欠息';
comment on column ${iol_schema}.icms_wph_business_duebill.pnltinttotal is '应收罚息';
comment on column ${iol_schema}.icms_wph_business_duebill.pnltintamt is '应收利息';
comment on column ${iol_schema}.icms_wph_business_duebill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_business_duebill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wph_business_duebill.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_business_duebill.pnltodiamt is '应收复利';
comment on column ${iol_schema}.icms_wph_business_duebill.classifyresultdate is '五级分类认定日期';
comment on column ${iol_schema}.icms_wph_business_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_business_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_business_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_business_duebill.etl_timestamp is 'ETL处理时间戳';
