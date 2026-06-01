/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_taskpooltrade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade(
    ETL_DT DATE
    ,AUTHORGNO VARCHAR2(10)
    ,TASKPOOLID VARCHAR2(10)
    ,CHANNELCODE VARCHAR2(3)
    ,TRADECODE VARCHAR2(100)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade is '任务池与交易关系';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade.AUTHORGNO is '授权机构';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade.TASKPOOLID is '任务池编号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade.CHANNELCODE is '渠道码';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade.TRADECODE is '交易码';
