/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_attr_value
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_attr_value
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_attr_value purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_attr_value(
    attr_key varchar2(30) -- 参数key值
    ,attr_value varchar2(3000) -- 属性值
    ,company varchar2(20) -- 法人
    ,ref_columns varchar2(50) -- 关联表描述列
    ,ref_condition varchar2(3000) -- 引用条件
    ,ref_table varchar2(50) -- 引用表名
    ,value_desc varchar2(200) -- 参数值描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_mb_attr_value to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_attr_value to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_attr_value to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_attr_value to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_attr_value is '参数值定义表';
comment on column ${iol_schema}.ncbs_mb_attr_value.attr_key is '参数key值';
comment on column ${iol_schema}.ncbs_mb_attr_value.attr_value is '属性值';
comment on column ${iol_schema}.ncbs_mb_attr_value.company is '法人';
comment on column ${iol_schema}.ncbs_mb_attr_value.ref_columns is '关联表描述列';
comment on column ${iol_schema}.ncbs_mb_attr_value.ref_condition is '引用条件';
comment on column ${iol_schema}.ncbs_mb_attr_value.ref_table is '引用表名';
comment on column ${iol_schema}.ncbs_mb_attr_value.value_desc is '参数值描述';
comment on column ${iol_schema}.ncbs_mb_attr_value.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_attr_value.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_attr_value.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_attr_value.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_attr_value.etl_timestamp is 'ETL处理时间戳';
