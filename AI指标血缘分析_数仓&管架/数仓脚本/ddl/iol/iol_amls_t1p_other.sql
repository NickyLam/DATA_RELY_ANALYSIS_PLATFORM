/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1p_other
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1p_other
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1p_other purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1p_other(
    type_id varchar2(15) -- 类型编号
    ,type_name varchar2(192) -- 类型名称
    ,code_id varchar2(15) -- 代码编号
    ,code_name varchar2(450) -- 代码名称
    ,code_desc varchar2(750) -- 代码描述
    ,is_valid varchar2(2) -- 是否有效
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
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
grant select on ${iol_schema}.amls_t1p_other to ${iml_schema};
grant select on ${iol_schema}.amls_t1p_other to ${icl_schema};
grant select on ${iol_schema}.amls_t1p_other to ${idl_schema};
grant select on ${iol_schema}.amls_t1p_other to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1p_other is '账户类型表';
comment on column ${iol_schema}.amls_t1p_other.type_id is '类型编号';
comment on column ${iol_schema}.amls_t1p_other.type_name is '类型名称';
comment on column ${iol_schema}.amls_t1p_other.code_id is '代码编号';
comment on column ${iol_schema}.amls_t1p_other.code_name is '代码名称';
comment on column ${iol_schema}.amls_t1p_other.code_desc is '代码描述';
comment on column ${iol_schema}.amls_t1p_other.is_valid is '是否有效';
comment on column ${iol_schema}.amls_t1p_other.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t1p_other.creator is '创建人';
comment on column ${iol_schema}.amls_t1p_other.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t1p_other.modifier is '修改人';
comment on column ${iol_schema}.amls_t1p_other.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t1p_other.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t1p_other.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t1p_other.etl_timestamp is 'ETL处理时间戳';
