/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_authorgnopara
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara(
    ETL_DT DATE
    ,AUTHORGNO VARCHAR2(6)
    ,AUTHORGNAME VARCHAR2(50)
    ,ORAGLEV VARCHAR2(1)
    ,TASKMODE VARCHAR2(1)
    ,DELETEFLAG VARCHAR2(1)
    ,USINGFLAG VARCHAR2(1)
    ,AUTHORGTYPE VARCHAR2(3)
    ,CRTDATE DATE
    ,CRTTELLERNO VARCHAR2(50)
    ,UPDDATE DATE
    ,UPTELLERNO VARCHAR2(50)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara is '机构授权中心参数表';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.AUTHORGNO is '授权中心机构号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.AUTHORGNAME is '授权中心名称';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.ORAGLEV is '授权中心级别';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.TASKMODE is '授权中心任务模式 1-系统推送，2-抢单';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.DELETEFLAG is '删除标识(0-正常 1-已删除)';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.USINGFLAG is '授权中心开启标识(0-未开启 1-启动)';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.AUTHORGTYPE is '授权中心类别(第一位1-总行授权中心，第二位1-分行授权中心，第三位1-网点授权中心)';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.CRTDATE is '创建日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.CRTTELLERNO is '创建柜员号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.UPDDATE is '更新日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.UPTELLERNO is '更新柜员号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara.ID_MARK is '增删标志';
