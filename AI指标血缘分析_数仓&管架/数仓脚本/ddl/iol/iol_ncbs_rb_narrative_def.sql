/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_narrative_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_narrative_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_narrative_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_narrative_def(
    narrative_class varchar2(2) -- 摘要分类
    ,narrative_class_desc varchar2(100) -- 摘要分类描述
    ,company varchar2(20) -- 法人
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,narrative_code varchar2(30) -- 摘要码
    ,narrative_code_desc varchar2(100) -- 摘要码描述
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
grant select on ${iol_schema}.ncbs_rb_narrative_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_narrative_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_narrative_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_narrative_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_narrative_def is '交易摘要码定义表';
comment on column ${iol_schema}.ncbs_rb_narrative_def.narrative_class is '摘要分类';
comment on column ${iol_schema}.ncbs_rb_narrative_def.narrative_class_desc is '摘要分类描述';
comment on column ${iol_schema}.ncbs_rb_narrative_def.company is '法人';
comment on column ${iol_schema}.ncbs_rb_narrative_def.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_narrative_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_narrative_def.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_narrative_def.narrative_code_desc is '摘要码描述';
comment on column ${iol_schema}.ncbs_rb_narrative_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_narrative_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_narrative_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_narrative_def.etl_timestamp is 'ETL处理时间戳';
