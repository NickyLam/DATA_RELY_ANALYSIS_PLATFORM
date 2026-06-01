/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_user_team
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_user_team
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_user_team purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_user_team(
  team_id         NUMBER(11) not null,
  code            VARCHAR2(480),
  enterprise_code VARCHAR2(30),
  isdel           VARCHAR2(4),
  team_name       VARCHAR2(300),
  create_date     TIMESTAMP(6),
  update_date     TIMESTAMP(6),
  creator         NUMBER(11),
  branch_code     VARCHAR2(480)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_user_team to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_user_team is '小组管理表';
comment on column ${msl_schema}.msl_hgls_user_team.TEAM_ID is '自增主键';
comment on column ${msl_schema}.msl_hgls_user_team.CODE is '内码';
comment on column ${msl_schema}.msl_hgls_user_team.ENTERPRISE_CODE is '企业编码';
comment on column ${msl_schema}.msl_hgls_user_team.ISDEL is '删除标识:0.未删除,1.已删除';
comment on column ${msl_schema}.msl_hgls_user_team.TEAM_NAME is '';
comment on column ${msl_schema}.msl_hgls_user_team.CREATE_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_user_team.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_user_team.CREATOR is '创建人';
comment on column ${msl_schema}.msl_hgls_user_team.BRANCH_CODE is '机构code';
alter table ${msl_schema}.msl_hgls_user_team add primary key (TEAM_ID);
