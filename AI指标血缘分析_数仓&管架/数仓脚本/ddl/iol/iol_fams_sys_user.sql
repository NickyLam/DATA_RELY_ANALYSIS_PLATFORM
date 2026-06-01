/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_sys_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_sys_user
whenever sqlerror continue none;
drop table ${iol_schema}.fams_sys_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_sys_user(
    user_id varchar2(64) -- 用户代码
    ,system_code varchar2(100) -- 系统代码
    ,user_name varchar2(40) -- 用户名称
    ,real_name varchar2(400) -- 真实姓名
    ,mail_addr varchar2(100) -- 邮件地址
    ,phone_num varchar2(40) -- 电话
    ,password varchar2(128) -- 密码
    ,salt varchar2(64) -- 密码盐
    ,dept_code varchar2(64) -- 部门代码（有部门是部门，没有部门是机构）
    ,sso_user_id varchar2(64) -- sso用户名
    ,mob_num varchar2(40) -- 手机号
    ,wechat_num varchar2(40) -- 微信号
    ,admin_flag varchar2(100) -- 管理员标识
    ,last_pass_date date -- 上次密码修改时间
    ,is_frozen varchar2(100) -- 是否冻结
    ,remark varchar2(1200) -- 备注
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_sys_user to ${iml_schema};
grant select on ${iol_schema}.fams_sys_user to ${icl_schema};
grant select on ${iol_schema}.fams_sys_user to ${idl_schema};
grant select on ${iol_schema}.fams_sys_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_sys_user is '用户';
comment on column ${iol_schema}.fams_sys_user.user_id is '用户代码';
comment on column ${iol_schema}.fams_sys_user.system_code is '系统代码';
comment on column ${iol_schema}.fams_sys_user.user_name is '用户名称';
comment on column ${iol_schema}.fams_sys_user.real_name is '真实姓名';
comment on column ${iol_schema}.fams_sys_user.mail_addr is '邮件地址';
comment on column ${iol_schema}.fams_sys_user.phone_num is '电话';
comment on column ${iol_schema}.fams_sys_user.password is '密码';
comment on column ${iol_schema}.fams_sys_user.salt is '密码盐';
comment on column ${iol_schema}.fams_sys_user.dept_code is '部门代码（有部门是部门，没有部门是机构）';
comment on column ${iol_schema}.fams_sys_user.sso_user_id is 'sso用户名';
comment on column ${iol_schema}.fams_sys_user.mob_num is '手机号';
comment on column ${iol_schema}.fams_sys_user.wechat_num is '微信号';
comment on column ${iol_schema}.fams_sys_user.admin_flag is '管理员标识';
comment on column ${iol_schema}.fams_sys_user.last_pass_date is '上次密码修改时间';
comment on column ${iol_schema}.fams_sys_user.is_frozen is '是否冻结';
comment on column ${iol_schema}.fams_sys_user.remark is '备注';
comment on column ${iol_schema}.fams_sys_user.create_user is '创建人';
comment on column ${iol_schema}.fams_sys_user.create_dept is '创建部门';
comment on column ${iol_schema}.fams_sys_user.create_time is '创建时间';
comment on column ${iol_schema}.fams_sys_user.update_user is '更新人';
comment on column ${iol_schema}.fams_sys_user.update_time is '更新时间';
comment on column ${iol_schema}.fams_sys_user.start_dt is '开始时间';
comment on column ${iol_schema}.fams_sys_user.end_dt is '结束时间';
comment on column ${iol_schema}.fams_sys_user.id_mark is '增删标志';
comment on column ${iol_schema}.fams_sys_user.etl_timestamp is 'ETL处理时间戳';
