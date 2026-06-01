/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_institution_rating_inner
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_institution_rating_inner
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_rating_inner(
    i_id number(22,0) -- 机构id
    ,i_name varchar2(383) -- 公司名称
    ,grade varchar2(15) -- 评级
    ,beg_date varchar2(15) -- 生效日期
    ,end_date varchar2(15) -- 失效日期
    ,imp_date varchar2(29) -- 导入时间
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
grant select on ${iol_schema}.ibms_ttrd_institution_rating_inner to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_rating_inner to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_rating_inner to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_rating_inner to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_institution_rating_inner is '客户评级信息';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.i_id is '机构id';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.i_name is '公司名称';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.grade is '评级';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.beg_date is '生效日期';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.end_date is '失效日期';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.imp_date is '导入时间';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_institution_rating_inner.etl_timestamp is 'ETL处理时间戳';
