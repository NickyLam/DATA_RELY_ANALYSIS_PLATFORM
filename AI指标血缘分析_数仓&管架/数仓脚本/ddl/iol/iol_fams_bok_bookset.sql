/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_bookset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_bookset
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_bookset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_bookset(
    bookset_id varchar2(50) -- 账套代码
    ,bookset_name varchar2(200) -- 账套名称
    ,bookset_fullname varchar2(200) -- 账套全称
    ,bookset_type varchar2(50) -- 账套类别
    ,acct_mode varchar2(50) -- 核算方式
    ,bok_spec_mode varchar2(50) -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
    ,acct_subject_id varchar2(50) -- 核算主体代码
    ,acct_subject_type varchar2(50) -- 核算主体类别
    ,standard_ccy varchar2(50) -- 本位币
    ,bookset_id_tmpl varchar2(32) -- 模板账套代码
    ,acct_standard varchar2(32) -- 会计准则
    ,start_date date -- 账套开始日
    ,end_date date -- 账套结束日
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_bok_bookset to ${iml_schema};
grant select on ${iol_schema}.fams_bok_bookset to ${icl_schema};
grant select on ${iol_schema}.fams_bok_bookset to ${idl_schema};
grant select on ${iol_schema}.fams_bok_bookset to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_bookset is '账套';
comment on column ${iol_schema}.fams_bok_bookset.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_bookset.bookset_name is '账套名称';
comment on column ${iol_schema}.fams_bok_bookset.bookset_fullname is '账套全称';
comment on column ${iol_schema}.fams_bok_bookset.bookset_type is '账套类别';
comment on column ${iol_schema}.fams_bok_bookset.acct_mode is '核算方式';
comment on column ${iol_schema}.fams_bok_bookset.bok_spec_mode is '特殊核算模型，普通分层核算、收益分层核算，普通情况为空';
comment on column ${iol_schema}.fams_bok_bookset.acct_subject_id is '核算主体代码';
comment on column ${iol_schema}.fams_bok_bookset.acct_subject_type is '核算主体类别';
comment on column ${iol_schema}.fams_bok_bookset.standard_ccy is '本位币';
comment on column ${iol_schema}.fams_bok_bookset.bookset_id_tmpl is '模板账套代码';
comment on column ${iol_schema}.fams_bok_bookset.acct_standard is '会计准则';
comment on column ${iol_schema}.fams_bok_bookset.start_date is '账套开始日';
comment on column ${iol_schema}.fams_bok_bookset.end_date is '账套结束日';
comment on column ${iol_schema}.fams_bok_bookset.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_bookset.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_bookset.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_bookset.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_bookset.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_bookset.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_bookset.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_bookset.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_bookset.etl_timestamp is 'ETL处理时间戳';
