/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_pbss_smg_t_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pbss_smg_t_user
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pbss_smg_t_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pbss_smg_t_user(
    ETL_DT DATE
    ,ID VARCHAR2(32)
    ,USER_CODE VARCHAR2(12)
    ,USER_HXYH_CODE VARCHAR2(12)
    ,USER_NAME VARCHAR2(32)
    ,BR_CODE VARCHAR2(9)
    ,USER_PASS VARCHAR2(32)
    ,ENCRYPT_PARA VARCHAR2(64)
    ,IDENTITY_NO VARCHAR2(18)
    ,SSO_USER_NAME VARCHAR2(32)
    ,NOTES_MAIL VARCHAR2(256)
    ,EMAIL VARCHAR2(32)
    ,TELEPHONE1 VARCHAR2(20)
    ,TELEPHONE2 VARCHAR2(20)
    ,ADDRESS1 VARCHAR2(64)
    ,ADDRESS2 VARCHAR2(64)
    ,USER_STAT VARCHAR2(1)
    ,LOGIN_STAT VARCHAR2(1)
    ,CREATE_TIME DATE
    ,CREATOR_ID VARCHAR2(12)
    ,DEL_TIME DATE
    ,DELE_ID VARCHAR2(12)
    ,MODIFY_TIME TIMESTAMP(6)
    ,MODI_ID VARCHAR2(12)
    ,LAST_PASS_TIME DATE
    ,AUTH_METHOD VARCHAR2(1)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pbss_smg_t_user to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pbss_smg_t_user is '登记平台操作员信息';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.ID is '逻辑主键';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.USER_CODE is '用户代码';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.USER_HXYH_CODE is 'HXYH用户代码';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.USER_NAME is '用户名称';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.BR_CODE is '机构代码';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.USER_PASS is '用户密码';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.ENCRYPT_PARA is '加密参数';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.IDENTITY_NO is '身份证号';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.SSO_USER_NAME is '统一用户名';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.NOTES_MAIL is 'Notes邮箱';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.EMAIL is '用户外部邮箱';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.TELEPHONE1 is '电话号码1';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.TELEPHONE2 is '电话号码2';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.ADDRESS1 is '联系地址1';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.ADDRESS2 is '联系地址2';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.USER_STAT is '用户状态, 0  禁用 ， 1启用';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.LOGIN_STAT is '登录状态[代码1006][0-签退1-签到]';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.CREATE_TIME is '创建日期';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.CREATOR_ID is '创建者ID';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.DEL_TIME is '删除日期';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.DELE_ID is '删除者ID';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.MODIFY_TIME is '维护时间';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.MODI_ID is '维护者ID';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.LAST_PASS_TIME is '上次密码修改日期';
comment on column ${msl_schema}.msl_edw_pbss_smg_t_user.AUTH_METHOD is '用户认证方式[代码0117][1-指纹认证2-密码认证3-特殊人群认证]';
