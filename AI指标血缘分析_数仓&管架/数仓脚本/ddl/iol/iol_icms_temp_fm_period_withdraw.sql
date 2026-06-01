/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_fm_period_withdraw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_fm_period_withdraw
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_fm_period_withdraw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_fm_period_withdraw(
    business_date varchar2(8) -- 对账日期（D日）
    ,loan_id varchar2(64) -- 贷款借据号
    ,period varchar2(32) -- 期次号，从1开始
    ,withdraw_int_amt varchar2(32) -- 当日计提利息（单位：元）
    ,withdraw_pin_amt varchar2(32) -- 当日计提罚息（单位：元）
    ,withdraw_cin_amt varchar2(32) -- 当日计提复利（单位：元）
    ,accumulated_withdraw_int_amt varchar2(32) -- 累计计提利息（单位：元）
    ,accumulated_withdraw_pin_amt varchar2(32) -- 累计计提罚息（单位：元）
    ,accumulated_withdraw_cin_amt varchar2(32) -- 累计计提复利（单位：元）
    ,asset_identification varchar2(16) -- 资产方标识
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
grant select on ${iol_schema}.icms_temp_fm_period_withdraw to ${iml_schema};
grant select on ${iol_schema}.icms_temp_fm_period_withdraw to ${icl_schema};
grant select on ${iol_schema}.icms_temp_fm_period_withdraw to ${idl_schema};
grant select on ${iol_schema}.icms_temp_fm_period_withdraw to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_fm_period_withdraw is '富民期次计提中间表';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.business_date is '对账日期（D日）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.loan_id is '贷款借据号';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.period is '期次号，从1开始';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.withdraw_int_amt is '当日计提利息（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.withdraw_pin_amt is '当日计提罚息（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.withdraw_cin_amt is '当日计提复利（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.accumulated_withdraw_int_amt is '累计计提利息（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.accumulated_withdraw_pin_amt is '累计计提罚息（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.accumulated_withdraw_cin_amt is '累计计提复利（单位：元）';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.asset_identification is '资产方标识';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_fm_period_withdraw.etl_timestamp is 'ETL处理时间戳';
