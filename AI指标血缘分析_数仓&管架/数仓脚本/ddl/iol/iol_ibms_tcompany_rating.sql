/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tcompany_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tcompany_rating
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tcompany_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tcompany_rating(
    comp_name varchar2(300) -- 发行人名称
    ,rating_type varchar2(2) -- 0 内部 1外部
    ,grade varchar2(15) -- 评级
    ,rating_institution varchar2(300) -- 评级机构
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 导入管道
    ,comp_code varchar2(150) -- 发行人代码
    ,outlook varchar2(75) -- 评级展望
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
grant select on ${iol_schema}.ibms_tcompany_rating to ${iml_schema};
grant select on ${iol_schema}.ibms_tcompany_rating to ${icl_schema};
grant select on ${iol_schema}.ibms_tcompany_rating to ${idl_schema};
grant select on ${iol_schema}.ibms_tcompany_rating to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tcompany_rating is '发行机构评级表';
comment on column ${iol_schema}.ibms_tcompany_rating.comp_name is '发行人名称';
comment on column ${iol_schema}.ibms_tcompany_rating.rating_type is '0 内部 1外部';
comment on column ${iol_schema}.ibms_tcompany_rating.grade is '评级';
comment on column ${iol_schema}.ibms_tcompany_rating.rating_institution is '评级机构';
comment on column ${iol_schema}.ibms_tcompany_rating.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_tcompany_rating.end_date is '结束日期';
comment on column ${iol_schema}.ibms_tcompany_rating.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tcompany_rating.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tcompany_rating.comp_code is '发行人代码';
comment on column ${iol_schema}.ibms_tcompany_rating.outlook is '评级展望';
comment on column ${iol_schema}.ibms_tcompany_rating.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_tcompany_rating.etl_timestamp is 'ETL处理时间戳';
