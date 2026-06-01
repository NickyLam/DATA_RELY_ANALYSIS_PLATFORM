/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_accounting_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_accounting_entry
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_accounting_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_accounting_entry(
    v_asset_type_cd varchar2(60) -- 资产类型代码
    ,v_asset_category varchar2(60) -- 资产类别
    ,v_sub_cd varchar2(20) -- 资产科目代码
    ,v_sub_name varchar2(60) -- 资产科目名称
    ,v_asset_three_cls_cd varchar2(10) -- 三分类
    ,v_sub_debit_cd varchar2(20) -- 借方科目代码
    ,v_sub_debit_name varchar2(60) -- 借方科目名称
    ,v_sub_credit_cd varchar2(20) -- 贷方科目代码
    ,v_sub_credit_name varchar2(60) -- 贷方科目名称
    ,sid number(5,0) -- 唯一id
    ,d_effect_dt date -- 
    ,d_lose_efficacy date -- 
    ,v_journalizing_type number(2,0) -- 分录类型
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
grant select on ${iol_schema}.ifrs_sf_accounting_entry to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_accounting_entry to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_accounting_entry is '减值入账规则配置表';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_asset_type_cd is '资产类型代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_asset_category is '资产类别';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_cd is '资产科目代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_name is '资产科目名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_asset_three_cls_cd is '三分类';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_debit_cd is '借方科目代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_debit_name is '借方科目名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_credit_cd is '贷方科目代码';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_sub_credit_name is '贷方科目名称';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.sid is '唯一id';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.d_effect_dt is '';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.d_lose_efficacy is '';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.v_journalizing_type is '分录类型';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.start_dt is '开始时间';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.end_dt is '结束时间';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.id_mark is '增删标志';
comment on column ${iol_schema}.ifrs_sf_accounting_entry.etl_timestamp is 'ETL处理时间戳';
