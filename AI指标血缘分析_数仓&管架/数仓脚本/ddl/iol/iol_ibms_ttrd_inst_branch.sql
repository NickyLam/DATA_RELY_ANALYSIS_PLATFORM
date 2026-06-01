/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_inst_branch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_inst_branch
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_inst_branch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_inst_branch(
    branch_code varchar2(45) -- 分支机构号
    ,i_id number(16,0) -- 所属机构号
    ,branch_name varchar2(383) -- 分支机构名称
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
grant select on ${iol_schema}.ibms_ttrd_inst_branch to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_inst_branch to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_inst_branch to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_inst_branch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_inst_branch is '机构网点';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.branch_code is '分支机构号';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.i_id is '所属机构号';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.branch_name is '分支机构名称';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_inst_branch.etl_timestamp is 'ETL处理时间戳';
