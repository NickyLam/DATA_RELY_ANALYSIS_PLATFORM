/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_dict_mult_lang
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_dict_mult_lang
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_dict_mult_lang(
    dict_type varchar2(75) -- 字典分类
    ,dict_sub_type varchar2(75) -- 字典子分类
    ,dict_key varchar2(383) -- 字典键值
    ,dict_lang varchar2(75) -- 语言种类
    ,dict_value varchar2(1500) -- 字典值
    ,dict_key_order number(22,0) -- 字典显示顺序
    ,loadflag varchar2(2) -- 加载类型
    ,isdefault varchar2(2) -- 是否默认值
    ,dict_description varchar2(300) -- 扩展字段描述
    ,front_flag varchar2(2) -- 是否前台使用，0：否；1：是，会加载到js缓存，减少前台请求
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
grant select on ${iol_schema}.ibms_ttrd_dict_mult_lang to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_dict_mult_lang to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_dict_mult_lang to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_dict_mult_lang to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_dict_mult_lang is '';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_type is '字典分类';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_sub_type is '字典子分类';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_key is '字典键值';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_lang is '语言种类';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_value is '字典值';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_key_order is '字典显示顺序';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.loadflag is '加载类型';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.isdefault is '是否默认值';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.dict_description is '扩展字段描述';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.front_flag is '是否前台使用，0：否；1：是，会加载到js缓存，减少前台请求';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_dict_mult_lang.etl_timestamp is 'ETL处理时间戳';
