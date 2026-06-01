/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_fm_period_withdraw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_fm_period_withdraw
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_fm_period_withdraw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_fm_period_withdraw(
    businessdate varchar2(8) -- 对账日期（D日）
    ,loanid varchar2(64) -- 贷款借据号
    ,period number(4) -- 期次号，从1开始
    ,withdrawintamt number(18,2) -- 当日计提利息（单位：元）
    ,withdrawpinamt number(18,2) -- 当日计提罚息（单位：元）
    ,withdrawcinamt number(18,2) -- 当日计提复利（单位：元）
    ,accumulatedwithdrawintamt number(18,2) -- 累计计提利息（单位：元）
    ,accumulatedwithdrawpinamt number(18,2) -- 累计计提罚息（单位：元）
    ,accumulatedwithdrawcinamt number(18,2) -- 累计计提复利（单位：元）
    ,assetidentification varchar2(16) -- 资产方标识
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
grant select on ${iol_schema}.icms_lhwd_fm_period_withdraw to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_fm_period_withdraw to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_period_withdraw to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_period_withdraw to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_fm_period_withdraw is '联合网贷富民期次计提表';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.businessdate is '对账日期（D日）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.loanid is '贷款借据号';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.period is '期次号，从1开始';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.withdrawintamt is '当日计提利息（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.withdrawpinamt is '当日计提罚息（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.withdrawcinamt is '当日计提复利（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.accumulatedwithdrawintamt is '累计计提利息（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.accumulatedwithdrawpinamt is '累计计提罚息（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.accumulatedwithdrawcinamt is '累计计提复利（单位：元）';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.assetidentification is '资产方标识';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhwd_fm_period_withdraw.etl_timestamp is 'ETL处理时间戳';
