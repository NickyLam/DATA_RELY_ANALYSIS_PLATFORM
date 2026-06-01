/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_prod_relation_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_prod_relation_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_prod_relation_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_prod_relation_define(
    prod_type varchar2(12) -- 产品编号
    ,assemble_id varchar2(50) -- 组件id
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,part_use_type varchar2(1) -- 指标使用方式
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,sub_prod_type varchar2(12) -- 子产品类型
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
grant select on ${iol_schema}.ncbs_rb_prod_relation_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_prod_relation_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_relation_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_relation_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_prod_relation_define is '产品组装关系定义表';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.assemble_id is '组件id';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.company is '法人';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.part_use_type is '指标使用方式';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.sub_prod_type is '子产品类型';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_prod_relation_define.etl_timestamp is 'ETL处理时间戳';
