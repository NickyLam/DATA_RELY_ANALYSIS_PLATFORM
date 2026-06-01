/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_grade_a_score_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_grade_a_score_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_grade_a_score_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_a_score_detail(
    key_id varchar2(60) -- 主键
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,mode_type varchar2(5) -- 评分模型类型
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,var_name varchar2(60) -- 变量名称
    ,var_desc varchar2(120) -- 变量描述
    ,var_value varchar2(60) -- 变量取值
    ,grade number(6,2) -- 评分
    ,remark varchar2(400) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_grade_a_score_detail to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_detail to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_detail to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_grade_a_score_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_grade_a_score_detail is '评分结果明细表';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.mode_type is '评分模型类型';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.var_name is '变量名称';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.var_desc is '变量描述';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.var_value is '变量取值';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.grade is '评分';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.remark is '备注';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_grade_a_score_detail.etl_timestamp is 'ETL处理时间戳';
