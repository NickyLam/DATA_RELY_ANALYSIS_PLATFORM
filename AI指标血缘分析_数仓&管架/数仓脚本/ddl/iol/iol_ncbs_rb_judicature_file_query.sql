/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_judicature_file_query
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_judicature_file_query
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_judicature_file_query purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_judicature_file_query(
    file_name varchar2(200) -- 文件名称
    ,batch_no varchar2(50) -- 批次号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,file_error_msg varchar2(200) -- 文件未生成错误描述
    ,query_condition varchar2(50) -- 查询条件
    ,query_option varchar2(10) -- 查询选项
    ,query_type varchar2(10) -- 查询类型
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,tran_file_result varchar2(1) -- 交易返回结果
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
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
grant select on ${iol_schema}.ncbs_rb_judicature_file_query to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_judicature_file_query to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_judicature_file_query to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_judicature_file_query to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_judicature_file_query is '有权机关查询申请文件表';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.company is '法人';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.file_error_msg is '文件未生成错误描述';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.query_condition is '查询条件';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.query_option is '查询选项';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.query_type is '查询类型';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.tran_file_result is '交易返回结果';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_judicature_file_query.etl_timestamp is 'ETL处理时间戳';
