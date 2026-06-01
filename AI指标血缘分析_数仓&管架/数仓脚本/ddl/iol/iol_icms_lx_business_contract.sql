/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_contract(
    serialno varchar2(64) -- 合同编号
    ,baserialno varchar2(64) -- 授信编号
    ,relacontractno varchar2(64) -- 关联合同编号
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,businessflag varchar2(6) -- 额度/业务标志
    ,productid varchar2(32) -- 产品编号
    ,occurdate date -- 签订日期
    ,currency varchar2(10) -- 币种
    ,businesssum number(24,6) -- 合同金额
    ,putoutsum number(24,6) -- 实际放款金额
    ,putoutdate date -- 放款日期
    ,termmonth number(24,0) -- 期限(月)
    ,termday number(24,0) -- 期限(天)
    ,startdate date -- 合同开始日期
    ,maturity date -- 合同到期日期
    ,iscycle varchar2(5) -- 是否循环(额度)
    ,risktype varchar2(20) -- 风险类型(额度),风险类型（一般、低风险）
    ,ratemodel varchar2(20) -- 利率模式,利率模式(1固定利率,2浮动利率,3组合利率)
    ,fixedrate number(24,6) -- 固定利率
    ,baseratetype varchar2(10) -- 基准利率类型
    ,baserate number(26,8) -- 基准利率
    ,ratefloattype varchar2(20) -- 利率浮动方式
    ,rateadjusttype varchar2(10) -- 利率调整方式,利率调整方式(1立即,2次年初,3次年对月对日,4按月调,5下一个还款日调整)
    ,floatrange number(24,6) -- 浮动幅度
    ,executerate number(26,8) -- 执行利率
    ,vouchtype varchar2(10) -- 担保方式
    ,repaytype varchar2(10) -- 还款方式,还款方式(01等额本金,02等额本息,03按期付息到期还款,04标准按期付息到期还本,（还款周期按季、半年、年,还款日在3、6、9、12月）,05利随本清,06灵活等额本息,07组合还款)
    ,repaycycle varchar2(10) -- 还款周期,还款周期(1月,2季,3一次,4半年,5年,6双月)
    ,repaydate number(24,0) -- 指定还款日
    ,settlementaccount varchar2(50) -- 结算账号
    ,paymenttype varchar2(32) -- 支付方式
    ,balance number(24,6) -- 合同贷款余额
    ,normalbalance number(24,6) -- 正常余额
    ,overduebalance number(24,6) -- 逾期/垫款金额
    ,status varchar2(32) -- 合同状态
    ,finishdate date -- 终结日期
    ,finishtype varchar2(32) -- 终结类型
    ,finishflag varchar2(5) -- 结清标志
    ,approvestatus varchar2(32) -- 审批状态
    ,remark varchar2(2000) -- 备注
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,creditno varchar2(32) -- 资方授信编号
    ,applyid varchar2(32) -- 用信审批申请编号
    ,availablecontractamt number(24,6) -- 额度可用金额
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
grant select on ${iol_schema}.icms_lx_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_lx_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_lx_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_lx_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_business_contract is '乐信合同表';
comment on column ${iol_schema}.icms_lx_business_contract.serialno is '合同编号';
comment on column ${iol_schema}.icms_lx_business_contract.baserialno is '授信编号';
comment on column ${iol_schema}.icms_lx_business_contract.relacontractno is '关联合同编号';
comment on column ${iol_schema}.icms_lx_business_contract.customerid is '客户编号';
comment on column ${iol_schema}.icms_lx_business_contract.customername is '客户名称';
comment on column ${iol_schema}.icms_lx_business_contract.businessflag is '额度/业务标志';
comment on column ${iol_schema}.icms_lx_business_contract.productid is '产品编号';
comment on column ${iol_schema}.icms_lx_business_contract.occurdate is '签订日期';
comment on column ${iol_schema}.icms_lx_business_contract.currency is '币种';
comment on column ${iol_schema}.icms_lx_business_contract.businesssum is '合同金额';
comment on column ${iol_schema}.icms_lx_business_contract.putoutsum is '实际放款金额';
comment on column ${iol_schema}.icms_lx_business_contract.putoutdate is '放款日期';
comment on column ${iol_schema}.icms_lx_business_contract.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_lx_business_contract.termday is '期限(天)';
comment on column ${iol_schema}.icms_lx_business_contract.startdate is '合同开始日期';
comment on column ${iol_schema}.icms_lx_business_contract.maturity is '合同到期日期';
comment on column ${iol_schema}.icms_lx_business_contract.iscycle is '是否循环(额度)';
comment on column ${iol_schema}.icms_lx_business_contract.risktype is '风险类型(额度),风险类型（一般、低风险）';
comment on column ${iol_schema}.icms_lx_business_contract.ratemodel is '利率模式,利率模式(1固定利率,2浮动利率,3组合利率)';
comment on column ${iol_schema}.icms_lx_business_contract.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_lx_business_contract.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lx_business_contract.baserate is '基准利率';
comment on column ${iol_schema}.icms_lx_business_contract.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_lx_business_contract.rateadjusttype is '利率调整方式,利率调整方式(1立即,2次年初,3次年对月对日,4按月调,5下一个还款日调整)';
comment on column ${iol_schema}.icms_lx_business_contract.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_lx_business_contract.executerate is '执行利率';
comment on column ${iol_schema}.icms_lx_business_contract.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lx_business_contract.repaytype is '还款方式,还款方式(01等额本金,02等额本息,03按期付息到期还款,04标准按期付息到期还本,（还款周期按季、半年、年,还款日在3、6、9、12月）,05利随本清,06灵活等额本息,07组合还款)';
comment on column ${iol_schema}.icms_lx_business_contract.repaycycle is '还款周期,还款周期(1月,2季,3一次,4半年,5年,6双月)';
comment on column ${iol_schema}.icms_lx_business_contract.repaydate is '指定还款日';
comment on column ${iol_schema}.icms_lx_business_contract.settlementaccount is '结算账号';
comment on column ${iol_schema}.icms_lx_business_contract.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_lx_business_contract.balance is '合同贷款余额';
comment on column ${iol_schema}.icms_lx_business_contract.normalbalance is '正常余额';
comment on column ${iol_schema}.icms_lx_business_contract.overduebalance is '逾期/垫款金额';
comment on column ${iol_schema}.icms_lx_business_contract.status is '合同状态';
comment on column ${iol_schema}.icms_lx_business_contract.finishdate is '终结日期';
comment on column ${iol_schema}.icms_lx_business_contract.finishtype is '终结类型';
comment on column ${iol_schema}.icms_lx_business_contract.finishflag is '结清标志';
comment on column ${iol_schema}.icms_lx_business_contract.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_lx_business_contract.remark is '备注';
comment on column ${iol_schema}.icms_lx_business_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_business_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_business_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_business_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_business_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_business_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_business_contract.creditno is '资方授信编号';
comment on column ${iol_schema}.icms_lx_business_contract.applyid is '用信审批申请编号';
comment on column ${iol_schema}.icms_lx_business_contract.availablecontractamt is '额度可用金额';
comment on column ${iol_schema}.icms_lx_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_business_contract.etl_timestamp is 'ETL处理时间戳';
