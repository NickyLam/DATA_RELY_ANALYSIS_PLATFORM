/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1p_pbc_ctvc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1p_pbc_ctvc
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1p_pbc_ctvc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1p_pbc_ctvc(
    ctvckey varchar2(48) -- 对私客户的职业或对公客户的行业类别码
    ,ctvc_type_cd varchar2(2) -- 分类1:个人职业 2:对公行业
    ,ctvcdesc varchar2(192) -- 描述
    ,flag varchar2(2) -- 是否有效
    ,create_dt date -- 创建时间
    ,ctvc_lvl varchar2(2) -- 层级
    ,upctvckey varchar2(48) -- 上层类别码
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
grant select on ${iol_schema}.amls_t1p_pbc_ctvc to ${iml_schema};
grant select on ${iol_schema}.amls_t1p_pbc_ctvc to ${icl_schema};
grant select on ${iol_schema}.amls_t1p_pbc_ctvc to ${idl_schema};
grant select on ${iol_schema}.amls_t1p_pbc_ctvc to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1p_pbc_ctvc is '职业行业表';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.ctvckey is '对私客户的职业或对公客户的行业类别码';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.ctvc_type_cd is '分类1:个人职业 2:对公行业';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.ctvcdesc is '描述';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.flag is '是否有效';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.create_dt is '创建时间';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.ctvc_lvl is '层级';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.upctvckey is '上层类别码';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t1p_pbc_ctvc.etl_timestamp is 'ETL处理时间戳';
