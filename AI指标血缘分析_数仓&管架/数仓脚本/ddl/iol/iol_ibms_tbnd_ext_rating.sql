/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbnd_ext_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbnd_ext_rating
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbnd_ext_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbnd_ext_rating(
    i_code varchar2(45) -- 交易代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,b_grade varchar2(15) -- 信用评级
    ,b_rating_institution varchar2(1500) -- 主体评级
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,rating_type varchar2(2) -- 0 外部 1内部
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 管道编号
    ,b_id number(22) -- 序号
    ,outlook varchar2(75) -- 评级展望
    ,shadow_grade varchar2(15) -- 影子评级
    ,b_rating_change varchar2(2) -- 评级变动方向0.首次1.维持2.调高3.调低
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_tbnd_ext_rating to ${iml_schema};
grant select on ${iol_schema}.ibms_tbnd_ext_rating to ${icl_schema};
grant select on ${iol_schema}.ibms_tbnd_ext_rating to ${idl_schema};
grant select on ${iol_schema}.ibms_tbnd_ext_rating to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbnd_ext_rating is '债券外部评级表';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.i_code is '交易代码';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.b_grade is '信用评级';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.b_rating_institution is '主体评级';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.end_date is '结束日期';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.rating_type is '0 外部 1内部';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.pipe_id is '管道编号';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.b_id is '序号';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.outlook is '评级展望';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.shadow_grade is '影子评级';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.b_rating_change is '评级变动方向0.首次1.维持2.调高3.调低';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_tbnd_ext_rating.etl_timestamp is 'ETL处理时间戳';
