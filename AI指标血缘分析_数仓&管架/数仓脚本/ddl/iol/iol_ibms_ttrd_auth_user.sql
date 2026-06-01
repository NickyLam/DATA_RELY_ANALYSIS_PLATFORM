/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_auth_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_auth_user
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_auth_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_auth_user(
    user_id number(19,0) -- 用户id
    ,user_name varchar2(150) -- 姓名
    ,i_id number(19,0) -- 组织机构id
    ,email varchar2(192) -- 邮箱
    ,tel_num varchar2(48) -- 座机号码
    ,mobile_num varchar2(48) -- 手机号码
    ,employee_card_no varchar2(96) -- 工牌号
    ,full_chinese_spell varchar2(375) -- 姓名拼音
    ,password varchar2(768) -- 密码的md5值
    ,account varchar2(48) -- 登录帐号
    ,birth_day varchar2(15) -- 出生日期
    ,flag number(5,0) -- 0:普通用户，1:系统管理员
    ,status number(5,0) -- 帐号状态(0:启用,-1:停用,1:未启用)
    ,head_chinese_spell varchar2(150) -- 姓名拼音头字母
    ,create_time varchar2(35) -- 创建时间
    ,update_time varchar2(35) -- 修改时间
    ,is_first_login varchar2(2) -- 是否首次登陆：1是，0否
    ,pwd_update_date varchar2(15) -- 密码修改日期
    ,input_pwd_error_times number(2,0) -- 密码输入错误次数
    ,password_history varchar2(768) -- 注销额度
    ,state varchar2(2) -- 记录状态（已生效1、未生效0）
    ,update_user number(19,0) -- 修改用户id
    ,qq_number varchar2(48) -- qq号码
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
grant select on ${iol_schema}.ibms_ttrd_auth_user to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_auth_user to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_auth_user to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_auth_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_auth_user is '用户表';
comment on column ${iol_schema}.ibms_ttrd_auth_user.user_id is '用户id';
comment on column ${iol_schema}.ibms_ttrd_auth_user.user_name is '姓名';
comment on column ${iol_schema}.ibms_ttrd_auth_user.i_id is '组织机构id';
comment on column ${iol_schema}.ibms_ttrd_auth_user.email is '邮箱';
comment on column ${iol_schema}.ibms_ttrd_auth_user.tel_num is '座机号码';
comment on column ${iol_schema}.ibms_ttrd_auth_user.mobile_num is '手机号码';
comment on column ${iol_schema}.ibms_ttrd_auth_user.employee_card_no is '工牌号';
comment on column ${iol_schema}.ibms_ttrd_auth_user.full_chinese_spell is '姓名拼音';
comment on column ${iol_schema}.ibms_ttrd_auth_user.password is '密码的md5值';
comment on column ${iol_schema}.ibms_ttrd_auth_user.account is '登录帐号';
comment on column ${iol_schema}.ibms_ttrd_auth_user.birth_day is '出生日期';
comment on column ${iol_schema}.ibms_ttrd_auth_user.flag is '0:普通用户，1:系统管理员';
comment on column ${iol_schema}.ibms_ttrd_auth_user.status is '帐号状态(0:启用,-1:停用,1:未启用)';
comment on column ${iol_schema}.ibms_ttrd_auth_user.head_chinese_spell is '姓名拼音头字母';
comment on column ${iol_schema}.ibms_ttrd_auth_user.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_auth_user.update_time is '修改时间';
comment on column ${iol_schema}.ibms_ttrd_auth_user.is_first_login is '是否首次登陆：1是，0否';
comment on column ${iol_schema}.ibms_ttrd_auth_user.pwd_update_date is '密码修改日期';
comment on column ${iol_schema}.ibms_ttrd_auth_user.input_pwd_error_times is '密码输入错误次数';
comment on column ${iol_schema}.ibms_ttrd_auth_user.password_history is '注销额度';
comment on column ${iol_schema}.ibms_ttrd_auth_user.state is '记录状态（已生效1、未生效0）';
comment on column ${iol_schema}.ibms_ttrd_auth_user.update_user is '修改用户id';
comment on column ${iol_schema}.ibms_ttrd_auth_user.qq_number is 'qq号码';
comment on column ${iol_schema}.ibms_ttrd_auth_user.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_auth_user.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_auth_user.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_auth_user.etl_timestamp is 'ETL处理时间戳';
