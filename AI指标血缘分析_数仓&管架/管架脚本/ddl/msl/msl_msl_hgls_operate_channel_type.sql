/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_operate_channel_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_operate_channel_type
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_operate_channel_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_operate_channel_type(
    ID number(18)
    ,CHANNEL_NAME VARCHAR2(4000)
    ,CHANNEL_TYPE VARCHAR2(4000)
    ,CHANNEL_CODE VARCHAR2(4000)
    ,MERCHANT_CODE VARCHAR2(4000)
    ,CHANNEL_INDEX number(18)
    ,CREATE_TIME timestamp(6)
    ,UPDATE_DATE timestamp(6)
    ,ISDEL VARCHAR2(4000)
    ,ENTERPRISE_CODE VARCHAR2(4000)
    ,CODE VARCHAR2(4000)
    ,EMAIL VARCHAR2(4000)
    ,TELEPHONE VARCHAR2(4000)
    ,CREATE_USER_CODE VARCHAR2(4000)
    ,CREATE_INSTITUTION VARCHAR2(4000)
    ,OWNER_INSTITUTION VARCHAR2(4000)
    ,ORG_NUM VARCHAR2(4000)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_operate_channel_type to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_operate_channel_type is '';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.ID is '';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CHANNEL_NAME is '';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CHANNEL_TYPE is '渠道类别:(1.短信 2.软文 3.图片 4.中介 5,自有员工)';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CHANNEL_CODE is '渠道英文编码';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.MERCHANT_CODE is '商家内码';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CHANNEL_INDEX is '排序字段';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CREATE_TIME is '申请日期';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.ISDEL is '删除标识';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.ENTERPRISE_CODE is '企业注册码';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CODE is '唯一编码';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.EMAIL is '邮箱';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.TELEPHONE is '手机';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CREATE_USER_CODE is '创建人code user表';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.CREATE_INSTITUTION is '创建机构code';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.OWNER_INSTITUTION is '归属机构 中文名称';
comment on column ${msl_schema}.msl_hgls_operate_channel_type.ORG_NUM is '归属机构号';
