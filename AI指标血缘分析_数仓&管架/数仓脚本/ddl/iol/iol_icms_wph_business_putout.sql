/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_business_putout
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_putout(
    serialno varchar2(64) -- 出账流水号
    ,contractserialno varchar2(30) -- 合同流水号
    ,occurdate varchar2(10) -- 发生日期
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,certtype varchar2(32) -- 证件类型
    ,certid varchar2(128) -- 证件号码
    ,productid varchar2(32) -- 产品编号
    ,internalkey varchar2(50) -- 唯品借据号
    ,creditappno varchar2(50) -- 唯品授信申请流水号
    ,loantype varchar2(6) -- 贷款类型
    ,isscountry varchar2(20) -- 签证国家
    ,loanstatus varchar2(2) -- 放款状态
    ,failreason varchar2(200) -- 失败原因
    ,cyclefreq varchar2(2) -- 结息周期
    ,termtype varchar2(1) -- 贷款期限类型
    ,term varchar2(5) -- 贷款期限
    ,gracedays number(5) -- 宽限期天数
    ,reasoncode varchar2(6) -- 贷款用途
    ,remark1 varchar2(200) -- 备用字段1（行外借据号）
    ,remark2 varchar2(200) -- 备用字段2
    ,businesssum number(24,6) -- 本次放款金额
    ,settlementaccount varchar2(150) -- 结算账号(还款账户)
    ,putoutdate varchar2(10) -- 放款日期
    ,maturity varchar2(10) -- 到期日
    ,loanaccountno varchar2(150) -- 贷款入账账号
    ,repaytype varchar2(4) -- 还款方式
    ,vouchtype varchar2(72) -- 主担保方式
    ,currency varchar2(3) -- 币种
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,ratemodel varchar2(36) -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,paymenttype varchar2(36) -- 放款支付方式
    ,interestrepaycycle varchar2(36) -- 结息方式
    ,baseratetype varchar2(4) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,rateadjusttype varchar2(4) -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,floatrange number(15,8) -- 浮动幅度
    ,executerate number(15,8) -- 执行利率
    ,overdueratefloattype varchar2(36) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,6) -- 逾期利率浮动值
    ,putoutorgid varchar2(64) -- 出账机构编号(核心机构)
    ,lendingorgid varchar2(160) -- 贷款机构编号(核心机构)
    ,overduerate number(24,8) -- 逾期利率
    ,bizdate varchar2(10) -- 流程日期
    ,trandate varchar2(10) -- 交易日期
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
grant select on ${iol_schema}.icms_wph_business_putout to ${iml_schema};
grant select on ${iol_schema}.icms_wph_business_putout to ${icl_schema};
grant select on ${iol_schema}.icms_wph_business_putout to ${idl_schema};
grant select on ${iol_schema}.icms_wph_business_putout to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_business_putout is '唯品会出账信息表';
comment on column ${iol_schema}.icms_wph_business_putout.serialno is '出账流水号';
comment on column ${iol_schema}.icms_wph_business_putout.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_wph_business_putout.occurdate is '发生日期';
comment on column ${iol_schema}.icms_wph_business_putout.customerid is '客户号';
comment on column ${iol_schema}.icms_wph_business_putout.customername is '客户名称';
comment on column ${iol_schema}.icms_wph_business_putout.certtype is '证件类型';
comment on column ${iol_schema}.icms_wph_business_putout.certid is '证件号码';
comment on column ${iol_schema}.icms_wph_business_putout.productid is '产品编号';
comment on column ${iol_schema}.icms_wph_business_putout.internalkey is '唯品借据号';
comment on column ${iol_schema}.icms_wph_business_putout.creditappno is '唯品授信申请流水号';
comment on column ${iol_schema}.icms_wph_business_putout.loantype is '贷款类型';
comment on column ${iol_schema}.icms_wph_business_putout.isscountry is '签证国家';
comment on column ${iol_schema}.icms_wph_business_putout.loanstatus is '放款状态';
comment on column ${iol_schema}.icms_wph_business_putout.failreason is '失败原因';
comment on column ${iol_schema}.icms_wph_business_putout.cyclefreq is '结息周期';
comment on column ${iol_schema}.icms_wph_business_putout.termtype is '贷款期限类型';
comment on column ${iol_schema}.icms_wph_business_putout.term is '贷款期限';
comment on column ${iol_schema}.icms_wph_business_putout.gracedays is '宽限期天数';
comment on column ${iol_schema}.icms_wph_business_putout.reasoncode is '贷款用途';
comment on column ${iol_schema}.icms_wph_business_putout.remark1 is '备用字段1（行外借据号）';
comment on column ${iol_schema}.icms_wph_business_putout.remark2 is '备用字段2';
comment on column ${iol_schema}.icms_wph_business_putout.businesssum is '本次放款金额';
comment on column ${iol_schema}.icms_wph_business_putout.settlementaccount is '结算账号(还款账户)';
comment on column ${iol_schema}.icms_wph_business_putout.putoutdate is '放款日期';
comment on column ${iol_schema}.icms_wph_business_putout.maturity is '到期日';
comment on column ${iol_schema}.icms_wph_business_putout.loanaccountno is '贷款入账账号';
comment on column ${iol_schema}.icms_wph_business_putout.repaytype is '还款方式';
comment on column ${iol_schema}.icms_wph_business_putout.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_wph_business_putout.currency is '币种';
comment on column ${iol_schema}.icms_wph_business_putout.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wph_business_putout.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wph_business_putout.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_business_putout.ratemodel is '利率模式;利率模式(1固定利率；2浮动利率；3组合利率)';
comment on column ${iol_schema}.icms_wph_business_putout.paymenttype is '放款支付方式';
comment on column ${iol_schema}.icms_wph_business_putout.interestrepaycycle is '结息方式';
comment on column ${iol_schema}.icms_wph_business_putout.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wph_business_putout.baserate is '基准利率';
comment on column ${iol_schema}.icms_wph_business_putout.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_wph_business_putout.rateadjusttype is '利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)';
comment on column ${iol_schema}.icms_wph_business_putout.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_wph_business_putout.executerate is '执行利率';
comment on column ${iol_schema}.icms_wph_business_putout.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_wph_business_putout.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_wph_business_putout.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_wph_business_putout.lendingorgid is '贷款机构编号(核心机构)';
comment on column ${iol_schema}.icms_wph_business_putout.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_wph_business_putout.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_business_putout.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_business_putout.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_business_putout.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_business_putout.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_business_putout.etl_timestamp is 'ETL处理时间戳';
