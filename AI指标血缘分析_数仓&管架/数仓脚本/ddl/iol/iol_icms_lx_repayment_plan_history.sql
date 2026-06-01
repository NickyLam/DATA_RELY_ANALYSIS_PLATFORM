/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_repayment_plan_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_repayment_plan_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_repayment_plan_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_repayment_plan_history(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,paydate varchar2(20) -- 付款时间
    ,payableday varchar2(20) -- 应还款日
    ,curstageno varchar2(20) -- 当前期数
    ,repaypriamt varchar2(200) -- 应还本金
    ,payint varchar2(200) -- 应还利息
    ,guarantyfee varchar2(200) -- 担保费
    ,simulationfee varchar2(200) -- 咨询服务费
    ,creditassessfee varchar2(200) -- 信用评估费
    ,interest varchar2(200) -- 计提利息
    ,attribute1 varchar2(64) -- 备用字段
    ,lxbusinesssum varchar2(200) -- 实还本金
    ,lxintamt varchar2(200) -- 实还利息
    ,realamounttotal varchar2(200) -- 实还金额总额(期数)
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,prinbal varchar2(200) -- 本金余额
    ,intbal varchar2(200) -- 利息余额
    ,status varchar2(20) -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
    ,cleardate varchar2(20) -- 结清日期
    ,loanterm varchar2(20) -- 总期数
    ,customerid varchar2(16) -- 客户号
    ,productid varchar2(12) -- 产品号
    ,intedate varchar2(20) -- 起息日期
    ,currency varchar2(6) -- 币种
    ,periodpaydate varchar2(20) -- 宽限日期
    ,bizdate varchar2(20) -- 批次时间
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
grant select on ${iol_schema}.icms_lx_repayment_plan_history to ${iml_schema};
grant select on ${iol_schema}.icms_lx_repayment_plan_history to ${icl_schema};
grant select on ${iol_schema}.icms_lx_repayment_plan_history to ${idl_schema};
grant select on ${iol_schema}.icms_lx_repayment_plan_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_repayment_plan_history is '乐信还款计划历史表';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.assetid is '资产号';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.paydate is '付款时间';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.payableday is '应还款日';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.curstageno is '当前期数';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.repaypriamt is '应还本金';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.payint is '应还利息';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.guarantyfee is '担保费';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.simulationfee is '咨询服务费';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.creditassessfee is '信用评估费';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.interest is '计提利息';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.attribute1 is '备用字段';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.lxbusinesssum is '实还本金';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.lxintamt is '实还利息';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.realamounttotal is '实还金额总额(期数)';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.prinbal is '本金余额';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.intbal is '利息余额';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.status is '状态标志(0-正常未到期,1-正常已还清,2-逾期)';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.cleardate is '结清日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.loanterm is '总期数';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.customerid is '客户号';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.productid is '产品号';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.intedate is '起息日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.currency is '币种';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.periodpaydate is '宽限日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.bizdate is '批次时间';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lx_repayment_plan_history.etl_timestamp is 'ETL处理时间戳';
