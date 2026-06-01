/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_index_auth
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_index_auth
whenever sqlerror continue none;
drop table ${idl_schema}.mc_index_auth purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_index_auth(
    index_no_mcs varchar2(150) -- 管驾指标编号
    ,index_clsaa_f_mcs varchar2(500) -- 管驾一级分类
    ,index_clsaa_s_mcs varchar2(500) -- 管驾二级分类
    ,index_clsaa_t_mcs varchar2(500) -- 管驾三级分类
    ,index_name_mcs varchar2(500) -- 指标名称
    ,branch_auth varchar2(500) -- 分行权限: 1-分行可看,0-分行不可看
    ,sbu_branch_auth varchar2(500) -- 支行权限: 1-支行可看,0-支行不可看
    ,create_by varchar2(160) -- 创建者
    ,create_time date -- 创建时间
    ,update_by varchar2(160) -- 更新者
    ,update_time date -- 更新时间
    ,remark varchar2(500) -- 备注
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_index_auth to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_index_auth is '管驾指标权限范围';
comment on column ${idl_schema}.mc_index_auth.index_no_mcs is '管驾指标编号';
comment on column ${idl_schema}.mc_index_auth.index_clsaa_f_mcs is '管驾一级分类';
comment on column ${idl_schema}.mc_index_auth.index_clsaa_s_mcs is '管驾二级分类';
comment on column ${idl_schema}.mc_index_auth.index_clsaa_t_mcs is '管驾三级分类';
comment on column ${idl_schema}.mc_index_auth.index_name_mcs is '指标名称';
comment on column ${idl_schema}.mc_index_auth.branch_auth is '分行权限: 1-分行可看,0-分行不可看';
comment on column ${idl_schema}.mc_index_auth.sbu_branch_auth is '支行权限: 1-支行可看,0-支行不可看';
comment on column ${idl_schema}.mc_index_auth.create_by is '创建者';
comment on column ${idl_schema}.mc_index_auth.create_time is '创建时间';
comment on column ${idl_schema}.mc_index_auth.update_by is '更新者';
comment on column ${idl_schema}.mc_index_auth.update_time is '更新时间';
comment on column ${idl_schema}.mc_index_auth.remark is '备注';
comment on column ${idl_schema}.mc_index_auth.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_index_auth.etl_timestamp is 'ETL处理时间戳';