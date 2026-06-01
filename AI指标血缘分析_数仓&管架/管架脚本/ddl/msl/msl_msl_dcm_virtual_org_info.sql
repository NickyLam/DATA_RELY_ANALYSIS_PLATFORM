/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_dcm_virtual_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2020-10-26 新建表本
*/

prompt creating table ${msl_schema}.msl_dcm_virtual_org_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_dcm_virtual_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_dcm_virtual_org_info(
     ORG_NO        VARCHAR2(60)
    ,ORG_NAME      VARCHAR2(100)
    ,SUPER_ORG_NO  VARCHAR2(60)
 )
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_dcm_virtual_org_info to itl;

-- comment
comment on table ${msl_schema}.msl_dcm_virtual_org_info is '虚拟机构补录表';
comment on column ${msl_schema}.msl_dcm_virtual_org_info.org_no is '机构编号';
comment on column ${msl_schema}.msl_dcm_virtual_org_info.org_name is '机构名称';
comment on column ${msl_schema}.msl_dcm_virtual_org_info.super_org_no is '上级机构编号';
