/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_user_client
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_user_client
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_user_client purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_user_client(
    CLIENT_ID NUMBER(11,0)
    ,ENTERPRISE_CODE VARCHAR2(4000)
    ,USER_NAME VARCHAR2(4000)
    ,NAME VARCHAR2(4000)
    ,SEX VARCHAR2(4000)
    ,TELEPHONE VARCHAR2(4000)
    ,PASSWORD VARCHAR2(4000)
    ,EMAIL VARCHAR2(4000)
    ,ACCOUNT VARCHAR2(4000)
    ,STATUS VARCHAR2(4000)
    ,AVAILABLE VARCHAR2(4000)
    ,BRANCH_CODE VARCHAR2(4000)
    ,SYSTEM_TYPE VARCHAR2(4000)
    ,ISDEL NUMBER(11,0)
    ,CREATE_USER VARCHAR2(4000)
    ,CREATE_DATE TIMESTAMP(6)
    ,UPDATE_USER VARCHAR2(4000)
    ,UPDATE_DATE TIMESTAMP(6)
    ,CODE VARCHAR2(4000)
    ,MANAGER_ID VARCHAR2(4000)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_user_client to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_user_client is '用户管理表';
comment on column ${msl_schema}.msl_hgls_user_client.CLIENT_ID is '客户端用户内码';
comment on column ${msl_schema}.msl_hgls_user_client.ENTERPRISE_CODE is '企业用户编码';
comment on column ${msl_schema}.msl_hgls_user_client.USER_NAME is '用户名';
comment on column ${msl_schema}.msl_hgls_user_client.NAME is '姓名';
comment on column ${msl_schema}.msl_hgls_user_client.SEX is '性别';
comment on column ${msl_schema}.msl_hgls_user_client.TELEPHONE is '手机号码';
comment on column ${msl_schema}.msl_hgls_user_client.PASSWORD is '登陆密码';
comment on column ${msl_schema}.msl_hgls_user_client.EMAIL is '邮箱';
comment on column ${msl_schema}.msl_hgls_user_client.ACCOUNT is '帐号/工号';
comment on column ${msl_schema}.msl_hgls_user_client.STATUS is '状态';
comment on column ${msl_schema}.msl_hgls_user_client.AVAILABLE is '账户可用 0：停用 1：可用 ';
comment on column ${msl_schema}.msl_hgls_user_client.BRANCH_CODE is '支行信息code';
comment on column ${msl_schema}.msl_hgls_user_client.SYSTEM_TYPE is '系统类型，1业务系统2营销系统';
comment on column ${msl_schema}.msl_hgls_user_client.ISDEL is '是否删除 0：未删除 ，1：表示删除';
comment on column ${msl_schema}.msl_hgls_user_client.CREATE_USER is '创建人员';
comment on column ${msl_schema}.msl_hgls_user_client.CREATE_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_user_client.UPDATE_USER is '修改人员';
comment on column ${msl_schema}.msl_hgls_user_client.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_user_client.CODE is '唯一编码';
comment on column ${msl_schema}.msl_hgls_user_client.MANAGER_ID is '推荐员对应的客户经理id';
