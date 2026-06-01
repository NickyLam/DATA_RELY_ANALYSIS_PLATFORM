/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_acct_class_bus_incrs
CreateDate: 20220409
FileType:   DDL
Logs:
    郑沛隆 2022-04-09 新建表本
*/

prompt creating table ${idl_schema}.base_d_acct_class_bus_incrs
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_acct_class_bus_incrs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_acct_class_bus_incrs(
    index_no varchar2(60) -- 标准指标编号
    ,org_no varchar2(60) -- 指标所属主体号
    ,sup_org_no varchar2(10) -- 指标所属上级主体号
    ,index_value_d number(38,2) -- 日指标值
    ,index_value_m number(38,2) -- 月指标值
    ,index_value_q number(38,2) -- 季指标值
    ,index_value_y number(38,2) -- 年指标值
    ,espec_dimen_cd1 varchar2(10) -- 特殊维度代码1
    ,espec_dimen_cd2 varchar2(10) -- 特殊维度代码2
    ,espec_dimen_cd3 varchar2(10) -- 特殊维度代码3
    ,espec_dimen_cd4 varchar2(10) -- 特殊维度代码4
    ,espec_dimen_cd5 varchar2(10) -- 特殊维度代码5
    ,remark varchar2(200) -- 备注
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_acct_class_bus_incrs to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_acct_class_bus_incrs is '账户类基础指标结果表_增长';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.index_no is '标准指标编号';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.org_no is '指标所属主体号';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.sup_org_no is '指标所属上级主体号';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.index_value_d is '日指标值';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.index_value_m is '月指标值';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.index_value_q is '季指标值';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.index_value_y is '年指标值';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.espec_dimen_cd1 is '特殊维度代码1';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.espec_dimen_cd2 is '特殊维度代码2';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.espec_dimen_cd3 is '特殊维度代码3';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.espec_dimen_cd4 is '特殊维度代码4';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.espec_dimen_cd5 is '特殊维度代码5';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.remark is '备注';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_acct_class_bus_incrs.etl_timestamp is 'ETL处理时间戳';