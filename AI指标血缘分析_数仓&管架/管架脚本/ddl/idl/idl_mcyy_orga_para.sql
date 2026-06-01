/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_orga_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_orga_para
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_orga_para purge;

whenever sqlerror exit sql.sqlcode;
create table mcyy_orga_para
(
  org_belong     VARCHAR2(30),
  org_no         VARCHAR2(30),
  org_name       VARCHAR2(80),
  super_org_no   VARCHAR2(30),
  super_org_name VARCHAR2(30),
  accts_org_ind  VARCHAR2(30),
  org_status_cd  VARCHAR2(30),
  org_level      VARCHAR2(18),
  org_level_cd   VARCHAR2(30),
  enty_org_flg   VARCHAR2(30),
  org_abbr       VARCHAR2(120),
  remark         VARCHAR2(120),
  etl_dt         DATE,
  short_name     VARCHAR2(300),
  org_lng        VARCHAR2(300),
  org_lat        VARCHAR2(300)
)
tablespace TBS_MCS_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
