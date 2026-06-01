/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_attr_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_attr_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_attr_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_attr_type(
    attr_class varchar2(10) -- 参数分类
    ,attr_desc varchar2(50) -- 属性描述
    ,attr_key varchar2(30) -- 参数key值
    ,attr_type varchar2(10) -- 参数数据类型
    ,busi_category varchar2(20) -- 业务分类
    ,company varchar2(20) -- 法人
    ,set_value_flag varchar2(1) -- 参数值设置方式
    ,status varchar2(1) -- 状态
    ,use_method varchar2(20) -- 使用方式
    ,value_method varchar2(5) -- 取值方式
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
grant select on ${iol_schema}.ncbs_mb_attr_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_attr_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_attr_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_attr_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_attr_type is '参数定义表';
comment on column ${iol_schema}.ncbs_mb_attr_type.attr_class is '参数分类';
comment on column ${iol_schema}.ncbs_mb_attr_type.attr_desc is '属性描述';
comment on column ${iol_schema}.ncbs_mb_attr_type.attr_key is '参数key值';
comment on column ${iol_schema}.ncbs_mb_attr_type.attr_type is '参数数据类型';
comment on column ${iol_schema}.ncbs_mb_attr_type.busi_category is '业务分类';
comment on column ${iol_schema}.ncbs_mb_attr_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_attr_type.set_value_flag is '参数值设置方式';
comment on column ${iol_schema}.ncbs_mb_attr_type.status is '状态';
comment on column ${iol_schema}.ncbs_mb_attr_type.use_method is '使用方式';
comment on column ${iol_schema}.ncbs_mb_attr_type.value_method is '取值方式';
comment on column ${iol_schema}.ncbs_mb_attr_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_attr_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_attr_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_attr_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_attr_type.etl_timestamp is 'ETL处理时间戳';
