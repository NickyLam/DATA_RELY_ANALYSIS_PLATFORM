/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_repayment_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_repayment_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_repayment_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_repayment_detail(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,repayterm varchar2(20) -- 还款期数
    ,repaymenttype varchar2(20) -- 还款类型
    ,settledate varchar2(20) -- 结算日
    ,realamounttotal varchar2(200) -- 实还金额总额
    ,lxbusinesssum varchar2(200) -- 实还本金
    ,lxintamt varchar2(200) -- 实还利息
    ,lxqodpamt varchar2(200) -- 实还罚息
    ,guarantyfee varchar2(200) -- 担保费
    ,simulationfee varchar2(200) -- 咨询服务费
    ,creditassessfee varchar2(200) -- 信用评估费
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,repaymentacctype varchar2(32) -- 还款账户类型
    ,repayacctno varchar2(64) -- 还款账户号
    ,currency varchar2(6) -- 币种
    ,repaydate varchar2(20) -- 还款日期
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
grant select on ${iol_schema}.icms_lx_repayment_detail to ${iml_schema};
grant select on ${iol_schema}.icms_lx_repayment_detail to ${icl_schema};
grant select on ${iol_schema}.icms_lx_repayment_detail to ${idl_schema};
grant select on ${iol_schema}.icms_lx_repayment_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_repayment_detail is '乐信还款明细表';
comment on column ${iol_schema}.icms_lx_repayment_detail.assetid is '资产号';
comment on column ${iol_schema}.icms_lx_repayment_detail.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_repayment_detail.repayterm is '还款期数';
comment on column ${iol_schema}.icms_lx_repayment_detail.repaymenttype is '还款类型';
comment on column ${iol_schema}.icms_lx_repayment_detail.settledate is '结算日';
comment on column ${iol_schema}.icms_lx_repayment_detail.realamounttotal is '实还金额总额';
comment on column ${iol_schema}.icms_lx_repayment_detail.lxbusinesssum is '实还本金';
comment on column ${iol_schema}.icms_lx_repayment_detail.lxintamt is '实还利息';
comment on column ${iol_schema}.icms_lx_repayment_detail.lxqodpamt is '实还罚息';
comment on column ${iol_schema}.icms_lx_repayment_detail.guarantyfee is '担保费';
comment on column ${iol_schema}.icms_lx_repayment_detail.simulationfee is '咨询服务费';
comment on column ${iol_schema}.icms_lx_repayment_detail.creditassessfee is '信用评估费';
comment on column ${iol_schema}.icms_lx_repayment_detail.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_repayment_detail.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_repayment_detail.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_repayment_detail.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_repayment_detail.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_repayment_detail.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_repayment_detail.repaymentacctype is '还款账户类型';
comment on column ${iol_schema}.icms_lx_repayment_detail.repayacctno is '还款账户号';
comment on column ${iol_schema}.icms_lx_repayment_detail.currency is '币种';
comment on column ${iol_schema}.icms_lx_repayment_detail.repaydate is '还款日期';
comment on column ${iol_schema}.icms_lx_repayment_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lx_repayment_detail.etl_timestamp is 'ETL处理时间戳';
