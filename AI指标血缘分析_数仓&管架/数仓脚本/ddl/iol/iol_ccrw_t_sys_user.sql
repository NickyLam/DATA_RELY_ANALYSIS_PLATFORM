/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccrw_t_sys_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccrw_t_sys_user
whenever sqlerror continue none;
drop table ${iol_schema}.ccrw_t_sys_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccrw_t_sys_user(
    user_id varchar2(96) -- 用户ID
    ,user_name varchar2(300) -- 用户姓名
    ,login_name varchar2(300) -- 登陆名
    ,tel varchar2(150) -- 手机号
    ,landline varchar2(150) -- 座机号码
    ,password varchar2(300) -- 密码
    ,sex varchar2(3) -- 性别
    ,org_id varchar2(96) -- 所属机构
    ,role_id varchar2(96) -- 当前角色
    ,role_ids varchar2(960) -- 拥有的全部角色
    ,status varchar2(3) -- 用户状态
    ,sort_no number(22) -- 排序号
    ,remark varchar2(1200) -- 备注
    ,ver number(22) -- 数据版本
    ,vir_flag varchar2(30) -- 
    ,law_org_id varchar2(96) -- 法人机构号
    ,id_card_no varchar2(63) -- 身份证号码
    ,addr varchar2(765) -- 联系地址
    ,email varchar2(150) -- 邮箱地址
    ,teller_no varchar2(96) -- 柜员号
    ,working_years number(22) -- 工作年限
    ,wechat_no varchar2(96) -- 微信号
    ,org_addr varchar2(384) -- 机构地址
    ,is_teamer varchar2(30) -- 是否显示在对公团队榜单 1-是,0-否
    ,is_protection varchar2(30) -- 是否保护期 1-是,0-否
    ,is_show_mgr_rank varchar2(3) -- 是否显示在对公客户经理榜单 1-是,0-否
    ,protection_time_start date -- 保护期开始日期
    ,protection_time_end date -- 保护期结束日期
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
grant select on ${iol_schema}.ccrw_t_sys_user to ${iml_schema};
grant select on ${iol_schema}.ccrw_t_sys_user to ${icl_schema};
grant select on ${iol_schema}.ccrw_t_sys_user to ${idl_schema};
grant select on ${iol_schema}.ccrw_t_sys_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccrw_t_sys_user is 'SYS_10_用户表';
comment on column ${iol_schema}.ccrw_t_sys_user.user_id is '用户ID';
comment on column ${iol_schema}.ccrw_t_sys_user.user_name is '用户姓名';
comment on column ${iol_schema}.ccrw_t_sys_user.login_name is '登陆名';
comment on column ${iol_schema}.ccrw_t_sys_user.tel is '手机号';
comment on column ${iol_schema}.ccrw_t_sys_user.landline is '座机号码';
comment on column ${iol_schema}.ccrw_t_sys_user.password is '密码';
comment on column ${iol_schema}.ccrw_t_sys_user.sex is '性别';
comment on column ${iol_schema}.ccrw_t_sys_user.org_id is '所属机构';
comment on column ${iol_schema}.ccrw_t_sys_user.role_id is '当前角色';
comment on column ${iol_schema}.ccrw_t_sys_user.role_ids is '拥有的全部角色';
comment on column ${iol_schema}.ccrw_t_sys_user.status is '用户状态';
comment on column ${iol_schema}.ccrw_t_sys_user.sort_no is '排序号';
comment on column ${iol_schema}.ccrw_t_sys_user.remark is '备注';
comment on column ${iol_schema}.ccrw_t_sys_user.ver is '数据版本';
comment on column ${iol_schema}.ccrw_t_sys_user.vir_flag is '';
comment on column ${iol_schema}.ccrw_t_sys_user.law_org_id is '法人机构号';
comment on column ${iol_schema}.ccrw_t_sys_user.id_card_no is '身份证号码';
comment on column ${iol_schema}.ccrw_t_sys_user.addr is '联系地址';
comment on column ${iol_schema}.ccrw_t_sys_user.email is '邮箱地址';
comment on column ${iol_schema}.ccrw_t_sys_user.teller_no is '柜员号';
comment on column ${iol_schema}.ccrw_t_sys_user.working_years is '工作年限';
comment on column ${iol_schema}.ccrw_t_sys_user.wechat_no is '微信号';
comment on column ${iol_schema}.ccrw_t_sys_user.org_addr is '机构地址';
comment on column ${iol_schema}.ccrw_t_sys_user.is_teamer is '是否显示在对公团队榜单 1-是,0-否';
comment on column ${iol_schema}.ccrw_t_sys_user.is_protection is '是否保护期 1-是,0-否';
comment on column ${iol_schema}.ccrw_t_sys_user.is_show_mgr_rank is '是否显示在对公客户经理榜单 1-是,0-否';
comment on column ${iol_schema}.ccrw_t_sys_user.protection_time_start is '保护期开始日期';
comment on column ${iol_schema}.ccrw_t_sys_user.protection_time_end is '保护期结束日期';
comment on column ${iol_schema}.ccrw_t_sys_user.start_dt is '开始时间';
comment on column ${iol_schema}.ccrw_t_sys_user.end_dt is '结束时间';
comment on column ${iol_schema}.ccrw_t_sys_user.id_mark is '增删标志';
comment on column ${iol_schema}.ccrw_t_sys_user.etl_timestamp is 'ETL处理时间戳';
