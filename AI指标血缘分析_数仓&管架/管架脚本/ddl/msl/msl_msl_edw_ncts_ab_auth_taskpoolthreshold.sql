/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_taskpoolthreshold
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold(
    ETL_DT DATE
    ,AUTHORGNO VARCHAR2(10)
    ,TASKPOOLID VARCHAR2(10)
    ,THRESHOLD NUMBER(4,2)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold is '机构授权中心参数表';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.AUTHORGNO is '授权机构';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.TASKPOOLID is '任务池编号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.THRESHOLD is '阀值';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpoolthreshold.ID_MARK is '增删标志';
