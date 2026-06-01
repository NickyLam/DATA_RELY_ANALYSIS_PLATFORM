/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_authorgteller
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller(
    ETL_DT DATE
    ,AUTHORGNO VARCHAR2(10)
    ,AUTHTELLERNO VARCHAR2(100)
    ,TELLEROID VARCHAR2(256)
    ,TELLERONLINE VARCHAR2(2)
    ,REALOCATIONFLAG VARCHAR2(1)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller is '授权中心与柜员关系';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.AUTHORGNO is '授权机构';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.AUTHTELLERNO is '授权柜员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.TELLEROID is '授权柜员终端OID';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.TELLERONLINE is '登录状态。0,离线;1,在线';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.REALOCATIONFLAG is '';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller.ID_MARK is '增删标志';
