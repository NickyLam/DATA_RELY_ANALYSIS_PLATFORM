/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_sys_account_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_sys_account_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_sys_account_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_sys_account_info(
    status varchar2(4) -- 状态
    ,password varchar2(500) -- 登录密码
    ,create_date date -- 创建日期
    ,update_date date -- 修改日期
    ,agent_id varchar2(10) -- agentid
    ,business_group_code varchar2(10) -- 业务组编号（参数配置）
    ,account_code varchar2(30) -- 用户账号
    ,emp_code varchar2(30) -- 员工编号
    ,skill_group_code varchar2(10) -- 技能组编号（参数配置）
    ,pwd_lapse_date date -- 密码过期时间
    ,creater_code varchar2(30) -- 创建者工号
    ,update_code varchar2(30) -- 更新者工号
    ,operator_type_code varchar2(10) -- 用户类型编码（参数配置）
    ,account_lock varchar2(2) -- 锁定用户 0:locked  1:unlock
    ,aworksts varchar2(2) -- 工作状态
    ,tsworkststime varchar2(50) -- 工作状态开始时间
    ,login_num number(22) -- 是否首次登录 (新建用户初始值为1)
    ,reset_password_flag varchar2(4) -- 是否重置密码 (0:未重置  1:重置)新增用户为1
    ,lock_num number(22) -- 登陆失败次数
    ,lock_time date -- 登陆时间
    ,login_server varchar2(20) -- 签入地址(priserver 代表主中心 bakserver 备中心)
    ,media_type varchar2(20) -- 多媒体类型（chat代表在线video视频media多媒体）
    ,media_pic varchar2(300) -- 视频客服不开摄像头背景图
    ,tone_switch varchar2(20) -- 在线客服铃声提醒开关
    ,pro_bank_tone_switch varchar2(20) -- 流程银行提示音提醒开关
    ,softphone_type varchar2(20) -- 软电话类型（websocket/applet:接入方式为websocket/applet）
    ,tracking_remind_tone_switch varchar2(20) -- 小结继续跟进提示音提醒开关
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
grant select on ${iol_schema}.ccdb_sys_account_info to ${iml_schema};
grant select on ${iol_schema}.ccdb_sys_account_info to ${icl_schema};
grant select on ${iol_schema}.ccdb_sys_account_info to ${idl_schema};
grant select on ${iol_schema}.ccdb_sys_account_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_sys_account_info is '用户信息表';
comment on column ${iol_schema}.ccdb_sys_account_info.status is '状态';
comment on column ${iol_schema}.ccdb_sys_account_info.password is '登录密码';
comment on column ${iol_schema}.ccdb_sys_account_info.create_date is '创建日期';
comment on column ${iol_schema}.ccdb_sys_account_info.update_date is '修改日期';
comment on column ${iol_schema}.ccdb_sys_account_info.agent_id is 'agentid';
comment on column ${iol_schema}.ccdb_sys_account_info.business_group_code is '业务组编号（参数配置）';
comment on column ${iol_schema}.ccdb_sys_account_info.account_code is '用户账号';
comment on column ${iol_schema}.ccdb_sys_account_info.emp_code is '员工编号';
comment on column ${iol_schema}.ccdb_sys_account_info.skill_group_code is '技能组编号（参数配置）';
comment on column ${iol_schema}.ccdb_sys_account_info.pwd_lapse_date is '密码过期时间';
comment on column ${iol_schema}.ccdb_sys_account_info.creater_code is '创建者工号';
comment on column ${iol_schema}.ccdb_sys_account_info.update_code is '更新者工号';
comment on column ${iol_schema}.ccdb_sys_account_info.operator_type_code is '用户类型编码（参数配置）';
comment on column ${iol_schema}.ccdb_sys_account_info.account_lock is '锁定用户 0:locked  1:unlock';
comment on column ${iol_schema}.ccdb_sys_account_info.aworksts is '工作状态';
comment on column ${iol_schema}.ccdb_sys_account_info.tsworkststime is '工作状态开始时间';
comment on column ${iol_schema}.ccdb_sys_account_info.login_num is '是否首次登录 (新建用户初始值为1)';
comment on column ${iol_schema}.ccdb_sys_account_info.reset_password_flag is '是否重置密码 (0:未重置  1:重置)新增用户为1';
comment on column ${iol_schema}.ccdb_sys_account_info.lock_num is '登陆失败次数';
comment on column ${iol_schema}.ccdb_sys_account_info.lock_time is '登陆时间';
comment on column ${iol_schema}.ccdb_sys_account_info.login_server is '签入地址(priserver 代表主中心 bakserver 备中心)';
comment on column ${iol_schema}.ccdb_sys_account_info.media_type is '多媒体类型（chat代表在线video视频media多媒体）';
comment on column ${iol_schema}.ccdb_sys_account_info.media_pic is '视频客服不开摄像头背景图';
comment on column ${iol_schema}.ccdb_sys_account_info.tone_switch is '在线客服铃声提醒开关';
comment on column ${iol_schema}.ccdb_sys_account_info.pro_bank_tone_switch is '流程银行提示音提醒开关';
comment on column ${iol_schema}.ccdb_sys_account_info.softphone_type is '软电话类型（websocket/applet:接入方式为websocket/applet）';
comment on column ${iol_schema}.ccdb_sys_account_info.tracking_remind_tone_switch is '小结继续跟进提示音提醒开关';
comment on column ${iol_schema}.ccdb_sys_account_info.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_sys_account_info.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_sys_account_info.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_sys_account_info.etl_timestamp is 'ETL处理时间戳';
