/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fdps_fdp_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fdps_fdp_account
whenever sqlerror continue none;
drop table ${iol_schema}.fdps_fdp_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_fdp_account(
    fdp_account_id varchar2(120) -- 主账号标识
    ,account_no varchar2(120) -- 主账号
    ,actual_balance number(18,2) -- 实际余额
    ,available_balance number(18,2) -- 可用余额
    ,fee_balance number(18,2) -- 手续费子账户余额
    ,interest_balance number(18,2) -- 利息子账户
    ,allow_balance number(18,2) -- 余额子账户
    ,offset_balance number(18,2) -- 轧差子账户
    ,settle_balance number(18,2) -- 中间结算子账户（不纳入主账户总额）
    ,cash_balance number(18,2) -- 返现专户子账户
    ,yes_actual_balance number(18,2) -- 上日实际余额
    ,yes_available_balance number(18,2) -- 上日可用余额
    ,yes_fee_balance number(18,2) -- 上日手续费子账户余额
    ,yes_interest_balance number(18,2) -- 上日利息子账户
    ,yes_allow_balance number(18,2) -- 上日余额子账户
    ,yes_offset_balance number(18,2) -- 上日轧差子账户
    ,yes_settle_balance number(18,2) -- 上日中间结算子账户（不纳入主账户总额）
    ,yes_cash_balance number(18,2) -- 上日返现专户子账户
    ,account_status varchar2(360) -- 账户状态
    ,remark varchar2(1530) -- 备注
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事物时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事物时间
    ,guarant_balance number(18,2) -- 担保子账户
    ,yes_guarant_balance number(18,2) -- 上日担保子账户
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fdps_fdp_account to ${iml_schema};
grant select on ${iol_schema}.fdps_fdp_account to ${icl_schema};
grant select on ${iol_schema}.fdps_fdp_account to ${idl_schema};
grant select on ${iol_schema}.fdps_fdp_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.fdps_fdp_account is '';
comment on column ${iol_schema}.fdps_fdp_account.fdp_account_id is '主账号标识';
comment on column ${iol_schema}.fdps_fdp_account.account_no is '主账号';
comment on column ${iol_schema}.fdps_fdp_account.actual_balance is '实际余额';
comment on column ${iol_schema}.fdps_fdp_account.available_balance is '可用余额';
comment on column ${iol_schema}.fdps_fdp_account.fee_balance is '手续费子账户余额';
comment on column ${iol_schema}.fdps_fdp_account.interest_balance is '利息子账户';
comment on column ${iol_schema}.fdps_fdp_account.allow_balance is '余额子账户';
comment on column ${iol_schema}.fdps_fdp_account.offset_balance is '轧差子账户';
comment on column ${iol_schema}.fdps_fdp_account.settle_balance is '中间结算子账户（不纳入主账户总额）';
comment on column ${iol_schema}.fdps_fdp_account.cash_balance is '返现专户子账户';
comment on column ${iol_schema}.fdps_fdp_account.yes_actual_balance is '上日实际余额';
comment on column ${iol_schema}.fdps_fdp_account.yes_available_balance is '上日可用余额';
comment on column ${iol_schema}.fdps_fdp_account.yes_fee_balance is '上日手续费子账户余额';
comment on column ${iol_schema}.fdps_fdp_account.yes_interest_balance is '上日利息子账户';
comment on column ${iol_schema}.fdps_fdp_account.yes_allow_balance is '上日余额子账户';
comment on column ${iol_schema}.fdps_fdp_account.yes_offset_balance is '上日轧差子账户';
comment on column ${iol_schema}.fdps_fdp_account.yes_settle_balance is '上日中间结算子账户（不纳入主账户总额）';
comment on column ${iol_schema}.fdps_fdp_account.yes_cash_balance is '上日返现专户子账户';
comment on column ${iol_schema}.fdps_fdp_account.account_status is '账户状态';
comment on column ${iol_schema}.fdps_fdp_account.remark is '备注';
comment on column ${iol_schema}.fdps_fdp_account.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.fdps_fdp_account.last_updated_tx_stamp is '最后更新事物时间';
comment on column ${iol_schema}.fdps_fdp_account.created_stamp is '创建时间';
comment on column ${iol_schema}.fdps_fdp_account.created_tx_stamp is '创建事物时间';
comment on column ${iol_schema}.fdps_fdp_account.guarant_balance is '担保子账户';
comment on column ${iol_schema}.fdps_fdp_account.yes_guarant_balance is '上日担保子账户';
comment on column ${iol_schema}.fdps_fdp_account.start_dt is '开始时间';
comment on column ${iol_schema}.fdps_fdp_account.end_dt is '结束时间';
comment on column ${iol_schema}.fdps_fdp_account.id_mark is '增删标志';
comment on column ${iol_schema}.fdps_fdp_account.etl_timestamp is 'ETL处理时间戳';
