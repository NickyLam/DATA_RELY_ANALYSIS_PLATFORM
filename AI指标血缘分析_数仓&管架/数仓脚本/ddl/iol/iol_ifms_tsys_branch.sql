/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_branch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_branch
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_branch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_branch(
    branch_code varchar2(24) -- 
    ,branch_level varchar2(12) -- 
    ,branch_name varchar2(250) -- 
    ,short_name varchar2(250) -- 
    ,parent_code varchar2(24) -- 
    ,branch_path varchar2(384) -- 
    ,remark varchar2(1000) -- 
    ,ext_field_1 varchar2(384) -- 
    ,ext_field_2 varchar2(384) -- 
    ,ext_field_3 varchar2(384) -- 
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
grant select on ${iol_schema}.ifms_tsys_branch to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_branch to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_branch to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_branch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_branch is '系统机构表';
comment on column ${iol_schema}.ifms_tsys_branch.branch_code is '';
comment on column ${iol_schema}.ifms_tsys_branch.branch_level is '';
comment on column ${iol_schema}.ifms_tsys_branch.branch_name is '';
comment on column ${iol_schema}.ifms_tsys_branch.short_name is '';
comment on column ${iol_schema}.ifms_tsys_branch.parent_code is '';
comment on column ${iol_schema}.ifms_tsys_branch.branch_path is '';
comment on column ${iol_schema}.ifms_tsys_branch.remark is '';
comment on column ${iol_schema}.ifms_tsys_branch.ext_field_1 is '';
comment on column ${iol_schema}.ifms_tsys_branch.ext_field_2 is '';
comment on column ${iol_schema}.ifms_tsys_branch.ext_field_3 is '';
comment on column ${iol_schema}.ifms_tsys_branch.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tsys_branch.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tsys_branch.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tsys_branch.etl_timestamp is 'ETL处理时间戳';
