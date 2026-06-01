/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_sys_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_sys_user
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_sys_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_sys_user(
    user_id varchar2(32) -- 用户ID
    ,qw_user_id varchar2(64) -- 企微用户ID。开通企微后有值
    ,dept_id varchar2(32) -- 部门ID
    ,user_name varchar2(30) -- 用户名称
    ,user_alias varchar2(100) -- 别名
    ,user_type varchar2(2) -- 用户类型（00超级管理员，01企业管理员，02普通企业用户）
    ,email varchar2(50) -- 用户邮箱
    ,mobile varchar2(60) -- 手机号码
    ,gender varchar2(1) -- 用户性别（1男 2女 3未知）
    ,avatar varchar2(255) -- 头像地址
    ,join_date varchar2(10) -- 入职时间
    ,id_card varchar2(18) -- 身份证号
    ,qrcode varchar2(255) -- 个人二维码
    ,wx_account varchar2(32) -- 个人微信号
    ,qq_account varchar2(20) -- QQ号
    ,telephone varchar2(32) -- 座机
    ,addr varchar2(300) -- 地址
    ,dimission_date varchar2(19) -- 离职日期
    ,birthday varchar2(10) -- 生日
    ,remark varchar2(500) -- 备注
    ,is_allocate number(22) -- 离职是否分配(1:已分配;0:未分配;)
    ,isopenchat number(22) -- 是否开启会话存档 0：关闭 1：开启
    ,corp_id varchar2(32) -- 归属企业
    ,corp_name varchar2(100) -- 归属企业名称
    ,status number(22) -- 状态（1正常 0停用）
    ,qw_status number(22) -- 企微状态：1启用，0停用，-1删除(离职)
    ,create_by varchar2(32) -- 创建人
    ,create_time varchar2(23) -- 创建时间
    ,last_modi_by varchar2(32) -- 最后修改人
    ,last_modi_time varchar2(23) -- 最后修改时间
    ,user_no varchar2(64) -- 员工编号
    ,shop_status number(22) -- 小店状态。1:开启；0：关闭，-1：删除(离职)
    ,auth_flag number(22) -- 是否已核验：0-未核验 1-已核验
    ,sop_flag varchar2(1) -- 客户是否提醒，0是，1否
    ,config_id varchar2(64) -- 二维码配置id
    ,is_dept_leader number(22) -- 是否部门领导。0-否；1-是
    ,direct_leader varchar2(400) -- 直属上级。多个以逗号分隔 QW_USER_ID
    ,post_name varchar2(384) -- 职务
    ,dist_line number(22) -- 是否已分配条线。1：已分配；0：未分配
    ,user_ticket varchar2(512) -- 成员票据。员工授权后可获取敏感信息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scrm_sys_user to ${iml_schema};
grant select on ${iol_schema}.scrm_sys_user to ${icl_schema};
grant select on ${iol_schema}.scrm_sys_user to ${idl_schema};
grant select on ${iol_schema}.scrm_sys_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_sys_user is '用户信息表';
comment on column ${iol_schema}.scrm_sys_user.user_id is '用户ID';
comment on column ${iol_schema}.scrm_sys_user.qw_user_id is '企微用户ID。开通企微后有值';
comment on column ${iol_schema}.scrm_sys_user.dept_id is '部门ID';
comment on column ${iol_schema}.scrm_sys_user.user_name is '用户名称';
comment on column ${iol_schema}.scrm_sys_user.user_alias is '别名';
comment on column ${iol_schema}.scrm_sys_user.user_type is '用户类型（00超级管理员，01企业管理员，02普通企业用户）';
comment on column ${iol_schema}.scrm_sys_user.email is '用户邮箱';
comment on column ${iol_schema}.scrm_sys_user.mobile is '手机号码';
comment on column ${iol_schema}.scrm_sys_user.gender is '用户性别（1男 2女 3未知）';
comment on column ${iol_schema}.scrm_sys_user.avatar is '头像地址';
comment on column ${iol_schema}.scrm_sys_user.join_date is '入职时间';
comment on column ${iol_schema}.scrm_sys_user.id_card is '身份证号';
comment on column ${iol_schema}.scrm_sys_user.qrcode is '个人二维码';
comment on column ${iol_schema}.scrm_sys_user.wx_account is '个人微信号';
comment on column ${iol_schema}.scrm_sys_user.qq_account is 'QQ号';
comment on column ${iol_schema}.scrm_sys_user.telephone is '座机';
comment on column ${iol_schema}.scrm_sys_user.addr is '地址';
comment on column ${iol_schema}.scrm_sys_user.dimission_date is '离职日期';
comment on column ${iol_schema}.scrm_sys_user.birthday is '生日';
comment on column ${iol_schema}.scrm_sys_user.remark is '备注';
comment on column ${iol_schema}.scrm_sys_user.is_allocate is '离职是否分配(1:已分配;0:未分配;)';
comment on column ${iol_schema}.scrm_sys_user.isopenchat is '是否开启会话存档 0：关闭 1：开启';
comment on column ${iol_schema}.scrm_sys_user.corp_id is '归属企业';
comment on column ${iol_schema}.scrm_sys_user.corp_name is '归属企业名称';
comment on column ${iol_schema}.scrm_sys_user.status is '状态（1正常 0停用）';
comment on column ${iol_schema}.scrm_sys_user.qw_status is '企微状态：1启用，0停用，-1删除(离职)';
comment on column ${iol_schema}.scrm_sys_user.create_by is '创建人';
comment on column ${iol_schema}.scrm_sys_user.create_time is '创建时间';
comment on column ${iol_schema}.scrm_sys_user.last_modi_by is '最后修改人';
comment on column ${iol_schema}.scrm_sys_user.last_modi_time is '最后修改时间';
comment on column ${iol_schema}.scrm_sys_user.user_no is '员工编号';
comment on column ${iol_schema}.scrm_sys_user.shop_status is '小店状态。1:开启；0：关闭，-1：删除(离职)';
comment on column ${iol_schema}.scrm_sys_user.auth_flag is '是否已核验：0-未核验 1-已核验';
comment on column ${iol_schema}.scrm_sys_user.sop_flag is '客户是否提醒，0是，1否';
comment on column ${iol_schema}.scrm_sys_user.config_id is '二维码配置id';
comment on column ${iol_schema}.scrm_sys_user.is_dept_leader is '是否部门领导。0-否；1-是';
comment on column ${iol_schema}.scrm_sys_user.direct_leader is '直属上级。多个以逗号分隔 QW_USER_ID';
comment on column ${iol_schema}.scrm_sys_user.post_name is '职务';
comment on column ${iol_schema}.scrm_sys_user.dist_line is '是否已分配条线。1：已分配；0：未分配';
comment on column ${iol_schema}.scrm_sys_user.user_ticket is '成员票据。员工授权后可获取敏感信息';
comment on column ${iol_schema}.scrm_sys_user.start_dt is '开始时间';
comment on column ${iol_schema}.scrm_sys_user.end_dt is '结束时间';
comment on column ${iol_schema}.scrm_sys_user.id_mark is '增删标志';
comment on column ${iol_schema}.scrm_sys_user.etl_timestamp is 'ETL处理时间戳';
