/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_accounting_entry_estimation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_accounting_entry_estimation
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_accounting_entry_estimation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_accounting_entry_estimation(
    sid varchar2(10) -- 序号
    ,v_asset_type_cd varchar2(60) -- 三分类
    ,v_assets_class_name varchar2(60) -- 资产类别名称
    ,v_assets_accounts_cd varchar2(60) -- 资产代码
    ,v_assets_accounts_name varchar2(60) -- 资产名称
    ,v_sub_debit_cd varchar2(60) -- 借方科目代码
    ,v_sub_debit_name varchar2(60) -- 借方科目名称
    ,v_reportforms_debit_name varchar2(60) -- 借方报表名称
    ,v_sub_credit_cd varchar2(60) -- 贷方科目代码
    ,v_sub_credit_name varchar2(60) -- 贷方科目名称
    ,v_reportforms_credit_name varchar2(60) -- 贷方报表名称
    ,v_debit_credit_cd varchar2(60) -- 借贷标识
    ,d_effect_dt date -- 生效日期
    ,d_lose_efficacy date -- 失效日期
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
grant select on ${iol_schema}.ifrs_sf_accounting_entry_estimation to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry_estimation to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry_estimation to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry_estimation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_accounting_entry_estimation is '估值入账分录表';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.sid is '序号';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_asset_type_cd is '三分类';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_assets_class_name is '资产类别名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_assets_accounts_cd is '资产代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_assets_accounts_name is '资产名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_sub_debit_cd is '借方科目代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_sub_debit_name is '借方科目名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_reportforms_debit_name is '借方报表名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_sub_credit_cd is '贷方科目代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_sub_credit_name is '贷方科目名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_reportforms_credit_name is '贷方报表名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.v_debit_credit_cd is '借贷标识';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.d_effect_dt is '生效日期';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.d_lose_efficacy is '失效日期';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_sf_accounting_entry_estimation.etl_timestamp is 'ETL处理时间戳';
