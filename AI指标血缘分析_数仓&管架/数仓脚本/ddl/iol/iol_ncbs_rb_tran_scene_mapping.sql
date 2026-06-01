/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_scene_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_scene_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_scene_mapping(
    attr_type varchar2(10) -- 参数数据类型
    ,attr_value varchar2(3000) -- 属性值
    ,company varchar2(20) -- 法人
    ,key_value varchar2(50) -- 参数键值对
    ,status varchar2(1) -- 状态
    ,tran_scene varchar2(50) -- 交易场景
    ,tran_scene_desc varchar2(50) -- 交易场景描述
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,scene_class varchar2(20) -- 场景分类
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
grant select on ${iol_schema}.ncbs_rb_tran_scene_mapping to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_scene_mapping to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_scene_mapping to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_scene_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_scene_mapping is '存款场景映射表';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.attr_type is '参数数据类型';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.attr_value is '属性值';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.key_value is '参数键值对';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.status is '状态';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.tran_scene is '交易场景';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.tran_scene_desc is '交易场景描述';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.scene_class is '场景分类';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_tran_scene_mapping.etl_timestamp is 'ETL处理时间戳';
