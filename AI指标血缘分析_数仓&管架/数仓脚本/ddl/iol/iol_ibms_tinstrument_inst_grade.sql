/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tinstrument_inst_grade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tinstrument_inst_grade
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tinstrument_inst_grade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tinstrument_inst_grade(
    i_code varchar2(45) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,rating_type varchar2(2) -- 外部 1内部
    ,grade number(10,2) -- 
    ,pipe_id number(22,0) -- 
    ,imp_date varchar2(15) -- 
    ,s_grade varchar2(15) -- 
    ,rating_institution varchar2(150) -- 
    ,inside_grade varchar2(15) -- 内部评级
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
grant select on ${iol_schema}.ibms_tinstrument_inst_grade to ${iml_schema};
grant select on ${iol_schema}.ibms_tinstrument_inst_grade to ${icl_schema};
grant select on ${iol_schema}.ibms_tinstrument_inst_grade to ${idl_schema};
grant select on ${iol_schema}.ibms_tinstrument_inst_grade to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tinstrument_inst_grade is '金融工具扩展表';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.i_code is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.a_type is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.m_type is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.rating_type is '外部 1内部';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.grade is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.pipe_id is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.imp_date is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.s_grade is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.rating_institution is '';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.inside_grade is '内部评级';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tinstrument_inst_grade.etl_timestamp is 'ETL处理时间戳';
