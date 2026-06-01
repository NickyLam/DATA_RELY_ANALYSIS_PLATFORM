/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_smg_t_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_smg_t_user
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_smg_t_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_smg_t_user(
    id varchar2(32) -- 逻辑主键
    ,user_code varchar2(12) -- 用户代码
    ,user_hxyh_code varchar2(12) -- HXYH用户代码
    ,user_name varchar2(32) -- 用户名称
    ,br_code varchar2(9) -- 机构代码
    ,user_pass varchar2(32) -- 用户密码
    ,encrypt_para varchar2(64) -- 加密参数
    ,identity_no varchar2(18) -- 身份证号
    ,sso_user_name varchar2(32) -- 统一用户名
    ,notes_mail varchar2(256) -- Notes邮箱
    ,email varchar2(32) -- 用户外部邮箱
    ,telephone1 varchar2(20) -- 电话号码1
    ,telephone2 varchar2(20) -- 电话号码2
    ,address1 varchar2(64) -- 联系地址1
    ,address2 varchar2(64) -- 联系地址2
    ,user_stat varchar2(1) -- 用户状态, 0  禁用 ， 1启用
    ,login_stat varchar2(1) -- 登录状态[代码1006][0-签退1-签到]
    ,create_time date -- 创建日期
    ,creator_id varchar2(12) -- 创建者ID
    ,del_time date -- 删除日期
    ,dele_id varchar2(12) -- 删除者ID
    ,modify_time timestamp -- 维护时间
    ,modi_id varchar2(12) -- 维护者ID
    ,last_pass_time date -- 上次密码修改日期
    ,auth_method varchar2(1) -- 用户认证方式[代码0117][1-指纹认证2-密码认证3-特殊人群认证]
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pbss_smg_t_user to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_smg_t_user is '登记平台操作员信息';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.id is '逻辑主键';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.user_code is '用户代码';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.user_hxyh_code is 'HXYH用户代码';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.user_name is '用户名称';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.br_code is '机构代码';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.user_pass is '用户密码';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.encrypt_para is '加密参数';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.identity_no is '身份证号';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.sso_user_name is '统一用户名';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.notes_mail is 'Notes邮箱';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.email is '用户外部邮箱';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.telephone1 is '电话号码1';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.telephone2 is '电话号码2';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.address1 is '联系地址1';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.address2 is '联系地址2';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.user_stat is '用户状态, 0  禁用 ， 1启用';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.login_stat is '登录状态[代码1006][0-签退1-签到]';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.create_time is '创建日期';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.creator_id is '创建者ID';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.del_time is '删除日期';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.dele_id is '删除者ID';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.modify_time is '维护时间';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.modi_id is '维护者ID';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.last_pass_time is '上次密码修改日期';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.auth_method is '用户认证方式[代码0117][1-指纹认证2-密码认证3-特殊人群认证]';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pbss_smg_t_user.etl_timestamp is 'ETL处理时间戳';