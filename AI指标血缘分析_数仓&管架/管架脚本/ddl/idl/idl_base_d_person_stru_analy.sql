/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_person_stru_analy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_person_stru_analy
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_person_stru_analy purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_person_stru_analy(
    orgno varchar2(6) -- 机构编号
    ,id number(18) -- 人员ID
    ,name varchar2(150)          -- 人员姓名
    ,sex number(18) -- 性别
    ,born_date timestamp(6) -- 出生日期
    ,job_date timestamp(6) -- 工作日期
    ,position number(18) -- 岗位ID
    ,isservice number(2) -- 是否营运人员
    ,status number(18) -- 人员状态
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_person_stru_analy to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_person_stru_analy is '职业人员结构表';
comment on column ${idl_schema}.base_d_person_stru_analy.orgno is '机构编号';
comment on column ${idl_schema}.base_d_person_stru_analy.id is '人员ID';
comment on column ${idl_schema}.base_d_person_stru_analy.name is '人员姓名';
comment on column ${idl_schema}.base_d_person_stru_analy.sex is '性别';
comment on column ${idl_schema}.base_d_person_stru_analy.born_date is '出生日期';
comment on column ${idl_schema}.base_d_person_stru_analy.job_date is '工作日期';
comment on column ${idl_schema}.base_d_person_stru_analy.position is '岗位ID';
comment on column ${idl_schema}.base_d_person_stru_analy.isservice is '是否营运人员';
comment on column ${idl_schema}.base_d_person_stru_analy.status is '人员状态';
comment on column ${idl_schema}.base_d_person_stru_analy.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_person_stru_analy.etl_timestamp is 'ETL处理时间戳';