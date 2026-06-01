/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_fm_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_fm_repay_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_fm_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_fm_repay_plan(
    business_date varchar2(8) -- 业务日期 D日
    ,loan_id varchar2(64) -- 借据号
    ,period varchar2(32) -- 期次 从1开始
    ,start_date varchar2(8) -- 开始日期
    ,end_date varchar2(8) -- 计息结束日期
    ,settle_date varchar2(8) -- 结清日期
    ,pri_amt varchar2(32) -- 应还本金
    ,repay_pri_amt varchar2(32) -- 实还本金
    ,int_amt varchar2(32) -- 应还利息
    ,repay_int_amt varchar2(32) -- 实还利息
    ,relief_int_amt varchar2(32) -- 减免利息
    ,pin_amt varchar2(32) -- 应还罚息
    ,repay_pin_amt varchar2(32) -- 实还罚息
    ,relief_pin_amt varchar2(32) -- 减免罚息
    ,cin_amt varchar2(32) -- 应还复利
    ,repay_cin_amt varchar2(32) -- 实还复利
    ,relief_cin_amt varchar2(32) -- 减免复利
    ,plan_status varchar2(1) -- 本期状态 1-正常 2-逾期 3-结清
    ,finance_type varchar2(1) -- 资产类型 1-联合出资 2-机构全资
    ,ovd_days varchar2(32) -- 逾期天数
    ,repayment_date varchar2(8) -- 到期日期
    ,asset_identification varchar2(16) -- 资产标识
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
grant select on ${iol_schema}.icms_temp_fm_repay_plan to ${iml_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_plan to ${icl_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_plan to ${idl_schema};
grant select on ${iol_schema}.icms_temp_fm_repay_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_fm_repay_plan is '富民日初还款计划中间表';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.business_date is '业务日期 D日';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.loan_id is '借据号';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.period is '期次 从1开始';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.start_date is '开始日期';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.end_date is '计息结束日期';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.settle_date is '结清日期';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.pri_amt is '应还本金';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.repay_pri_amt is '实还本金';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.int_amt is '应还利息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.repay_int_amt is '实还利息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.relief_int_amt is '减免利息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.pin_amt is '应还罚息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.repay_pin_amt is '实还罚息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.relief_pin_amt is '减免罚息';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.cin_amt is '应还复利';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.repay_cin_amt is '实还复利';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.relief_cin_amt is '减免复利';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.plan_status is '本期状态 1-正常 2-逾期 3-结清';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.finance_type is '资产类型 1-联合出资 2-机构全资';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.ovd_days is '逾期天数';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.repayment_date is '到期日期';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.asset_identification is '资产标识';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_fm_repay_plan.etl_timestamp is 'ETL处理时间戳';
