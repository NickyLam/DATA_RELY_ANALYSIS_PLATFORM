/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_buss_detsub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_buss_detsub
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_buss_detsub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_buss_detsub(
    bookset_id varchar2(50) -- 账套代码
    ,detail_subject_no varchar2(300) -- 四级科目号
    ,detail_subject_name varchar2(500) -- 四级科目名称
    ,fsubject_id varchar2(32) -- 上级科目号
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,detail_subject_no_tail varchar2(300) -- 四级科目尾号，不含三级科目
    ,detail_subname_tail varchar2(500) -- 四级科目尾号名称
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
grant select on ${iol_schema}.fams_bok_buss_detsub to ${iml_schema};
grant select on ${iol_schema}.fams_bok_buss_detsub to ${icl_schema};
grant select on ${iol_schema}.fams_bok_buss_detsub to ${idl_schema};
grant select on ${iol_schema}.fams_bok_buss_detsub to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_buss_detsub is '业务明细科目';
comment on column ${iol_schema}.fams_bok_buss_detsub.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_buss_detsub.detail_subject_no is '四级科目号';
comment on column ${iol_schema}.fams_bok_buss_detsub.detail_subject_name is '四级科目名称';
comment on column ${iol_schema}.fams_bok_buss_detsub.fsubject_id is '上级科目号';
comment on column ${iol_schema}.fams_bok_buss_detsub.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_buss_detsub.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_buss_detsub.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_buss_detsub.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_buss_detsub.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_buss_detsub.detail_subject_no_tail is '四级科目尾号，不含三级科目';
comment on column ${iol_schema}.fams_bok_buss_detsub.detail_subname_tail is '四级科目尾号名称';
comment on column ${iol_schema}.fams_bok_buss_detsub.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_buss_detsub.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_buss_detsub.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_buss_detsub.etl_timestamp is 'ETL处理时间戳';
