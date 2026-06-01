/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_contract(
    serialno varchar2(30) -- 合同流水号
    ,creditappno varchar2(32) -- 授信申请编号
    ,occurdate date -- 签订日期
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,productid varchar2(32) -- 产品编号
    ,currency varchar2(3) -- 额度/业务币种
    ,businesssum number(24,6) -- 合同金额
    ,term varchar2(5) -- 贷款期限
    ,startdate date -- 合同开始日期
    ,maturity date -- 合同到期日期
    ,iscycle varchar2(5) -- 是否循环(额度),是否循环
    ,islowrisk varchar2(2) -- 是否低风险业务
    ,ratemodel varchar2(18) -- 利率模式,利率模式(1固定利率,2浮动利率,3组合利率)
    ,baseratetype varchar2(5) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,rateadjusttype varchar2(4) -- 利率调整方式,利率调整方式(1立即,2次年初,3次年对月对日,4按月调,5下一个还款日调整)
    ,executerate number(15,8) -- 执行利率
    ,settlementaccount varchar2(50) -- 结算账号
    ,status varchar2(48) -- 合同状态
    ,contracttype varchar2(36) -- 合同类型,合同类型(一般合同/虚拟合同)
    ,putoutorgid varchar2(64) -- 出账机构编号(核心机构)
    ,loanaccountno varchar2(64) -- 入账账户
    ,repaydate number(22) -- 指定还款日
    ,tenantid varchar2(4) -- 租户ID
    ,userid varchar2(20) -- 唯品用户编号
    ,wphproductid varchar2(32) -- 唯品产品编号
    ,loanamount number(18,2) -- 唯品合同金额
    ,loanamountcrop number(18,2) -- 合作方放款金额
    ,loanuse varchar2(8) -- 唯品贷款用途
    ,amortmethod varchar2(4) -- 唯品还款方式
    ,tenor number(22) -- 唯品贷款期数
    ,loandate date -- 唯品放款日期
    ,paymentdate date -- 首次还款时间
    ,creditlimit number(18,2) -- 平台对客授信金额
    ,availablelimit number(18,2) -- 客户可用余额
    ,guaranteecontractno varchar2(32) -- 担保合同号
    ,voucheecontractno varchar2(32) -- 被担保合同号
    ,loancard varchar2(20) -- 放款卡
    ,businesstype varchar2(20) -- 业务类型
    ,applyid varchar2(32) -- 第三方申请编号
    ,loanapplyid varchar2(32) -- 用信申请流水号
    ,failreason varchar2(2048) -- 风控拒绝原因
    ,riskstatus varchar2(32) -- 风控结果
    ,vouchtype varchar2(1) -- 主担保方式
    ,reqbody varchar2(4000) -- 风控请求报文
    ,jkstatus varchar2(2) -- 接口状态
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_wph_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_wph_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_wph_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_wph_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_business_contract is '唯品会合同信息表';
comment on column ${iol_schema}.icms_wph_business_contract.serialno is '合同流水号';
comment on column ${iol_schema}.icms_wph_business_contract.creditappno is '授信申请编号';
comment on column ${iol_schema}.icms_wph_business_contract.occurdate is '签订日期';
comment on column ${iol_schema}.icms_wph_business_contract.customerid is '客户编号';
comment on column ${iol_schema}.icms_wph_business_contract.customername is '客户名称';
comment on column ${iol_schema}.icms_wph_business_contract.productid is '产品编号';
comment on column ${iol_schema}.icms_wph_business_contract.currency is '额度/业务币种';
comment on column ${iol_schema}.icms_wph_business_contract.businesssum is '合同金额';
comment on column ${iol_schema}.icms_wph_business_contract.term is '贷款期限';
comment on column ${iol_schema}.icms_wph_business_contract.startdate is '合同开始日期';
comment on column ${iol_schema}.icms_wph_business_contract.maturity is '合同到期日期';
comment on column ${iol_schema}.icms_wph_business_contract.iscycle is '是否循环(额度),是否循环';
comment on column ${iol_schema}.icms_wph_business_contract.islowrisk is '是否低风险业务';
comment on column ${iol_schema}.icms_wph_business_contract.ratemodel is '利率模式,利率模式(1固定利率,2浮动利率,3组合利率)';
comment on column ${iol_schema}.icms_wph_business_contract.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wph_business_contract.baserate is '基准利率';
comment on column ${iol_schema}.icms_wph_business_contract.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_wph_business_contract.rateadjusttype is '利率调整方式,利率调整方式(1立即,2次年初,3次年对月对日,4按月调,5下一个还款日调整)';
comment on column ${iol_schema}.icms_wph_business_contract.executerate is '执行利率';
comment on column ${iol_schema}.icms_wph_business_contract.settlementaccount is '结算账号';
comment on column ${iol_schema}.icms_wph_business_contract.status is '合同状态';
comment on column ${iol_schema}.icms_wph_business_contract.contracttype is '合同类型,合同类型(一般合同/虚拟合同)';
comment on column ${iol_schema}.icms_wph_business_contract.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_wph_business_contract.loanaccountno is '入账账户';
comment on column ${iol_schema}.icms_wph_business_contract.repaydate is '指定还款日';
comment on column ${iol_schema}.icms_wph_business_contract.tenantid is '租户ID';
comment on column ${iol_schema}.icms_wph_business_contract.userid is '唯品用户编号';
comment on column ${iol_schema}.icms_wph_business_contract.wphproductid is '唯品产品编号';
comment on column ${iol_schema}.icms_wph_business_contract.loanamount is '唯品合同金额';
comment on column ${iol_schema}.icms_wph_business_contract.loanamountcrop is '合作方放款金额';
comment on column ${iol_schema}.icms_wph_business_contract.loanuse is '唯品贷款用途';
comment on column ${iol_schema}.icms_wph_business_contract.amortmethod is '唯品还款方式';
comment on column ${iol_schema}.icms_wph_business_contract.tenor is '唯品贷款期数';
comment on column ${iol_schema}.icms_wph_business_contract.loandate is '唯品放款日期';
comment on column ${iol_schema}.icms_wph_business_contract.paymentdate is '首次还款时间';
comment on column ${iol_schema}.icms_wph_business_contract.creditlimit is '平台对客授信金额';
comment on column ${iol_schema}.icms_wph_business_contract.availablelimit is '客户可用余额';
comment on column ${iol_schema}.icms_wph_business_contract.guaranteecontractno is '担保合同号';
comment on column ${iol_schema}.icms_wph_business_contract.voucheecontractno is '被担保合同号';
comment on column ${iol_schema}.icms_wph_business_contract.loancard is '放款卡';
comment on column ${iol_schema}.icms_wph_business_contract.businesstype is '业务类型';
comment on column ${iol_schema}.icms_wph_business_contract.applyid is '第三方申请编号';
comment on column ${iol_schema}.icms_wph_business_contract.loanapplyid is '用信申请流水号';
comment on column ${iol_schema}.icms_wph_business_contract.failreason is '风控拒绝原因';
comment on column ${iol_schema}.icms_wph_business_contract.riskstatus is '风控结果';
comment on column ${iol_schema}.icms_wph_business_contract.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_wph_business_contract.reqbody is '风控请求报文';
comment on column ${iol_schema}.icms_wph_business_contract.jkstatus is '接口状态';
comment on column ${iol_schema}.icms_wph_business_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wph_business_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wph_business_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_business_contract.etl_timestamp is 'ETL处理时间戳';
