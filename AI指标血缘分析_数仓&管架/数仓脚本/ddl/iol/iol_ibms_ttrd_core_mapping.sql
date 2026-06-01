/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_core_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_core_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_core_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_core_mapping(
    subj_org_id varchar2(45) -- 科目机构码
    ,subj_code varchar2(150) -- 科目码
    ,subj_sub_code varchar2(150) -- 科目子码
    ,core_acct_code varchar2(45) -- 核心账户代码
    ,core_acct_name varchar2(300) -- 核心账户名称
    ,currency varchar2(5) -- 币种
    ,inner_acct_sn varchar2(45) -- 内部序列号
    ,core_id number(16,0) -- 主键
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
grant select on ${iol_schema}.ibms_ttrd_core_mapping to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_core_mapping to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_core_mapping to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_core_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_core_mapping is '核心账号映射表';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.subj_org_id is '科目机构码';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.subj_code is '科目码';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.subj_sub_code is '科目子码';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.core_acct_code is '核心账户代码';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.core_acct_name is '核心账户名称';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.inner_acct_sn is '内部序列号';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.core_id is '主键';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_core_mapping.etl_timestamp is 'ETL处理时间戳';
