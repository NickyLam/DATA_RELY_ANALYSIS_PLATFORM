/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_lx_repayment_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_lx_repayment_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_lx_repayment_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_lx_repayment_plan(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,paydate varchar2(20) -- 付款时间
    ,payableday varchar2(20) -- 应还款日
    ,curstageno varchar2(20) -- 当前期数
    ,repaypriamt varchar2(200) -- 应还本金
    ,payint varchar2(200) -- 应还利息
    ,interest varchar2(200) -- 计提利息
    ,attribute1 varchar2(64) -- 备用字段
    ,prinbal varchar2(200) -- 本金余额
    ,intbal varchar2(200) -- 利息余额
    ,status varchar2(20) -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
    ,cleardate varchar2(20) -- 结清日期
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
grant select on ${iol_schema}.icms_tmp_lx_repayment_plan to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_plan to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_plan to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_lx_repayment_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_lx_repayment_plan is '乐信还款计划中间表';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.assetid is '资产号';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.paydate is '付款时间';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.payableday is '应还款日';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.curstageno is '当前期数';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.repaypriamt is '应还本金';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.payint is '应还利息';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.interest is '计提利息';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.attribute1 is '备用字段';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.prinbal is '本金余额';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.intbal is '利息余额';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.status is '状态标志(0-正常未到期,1-正常已还清,2-逾期)';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_lx_repayment_plan.etl_timestamp is 'ETL处理时间戳';
