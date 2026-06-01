/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_sm_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_sm_user
whenever sqlerror continue none;
drop table ${iol_schema}.iers_sm_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_sm_user(
    abledate varchar2(29) -- 生效日期
    ,agreementstatus varchar2(15) -- 协议版本
    ,base_doc_type number(38,0) -- 身份类型
    ,contentlang varchar2(30) -- 内容语种
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,cuserid varchar2(30) -- 用户主键
    ,dataoriginflag number(38,0) -- 分布式
    ,disabledate varchar2(29) -- 失效日期
    ,dr number(10,0) -- 删除标志
    ,email varchar2(75) -- 电子邮件地址
    ,enablestate number(38,0) -- 启用状态
    ,format varchar2(30) -- 数据格式
    ,identityverifycode varchar2(75) -- 认证类型
    ,isca varchar2(2) -- ca用户
    ,islocked varchar2(2) -- 锁定
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,pk_base_doc varchar2(152) -- 身份
    ,pk_customer varchar2(152) -- 
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(152) -- 身份_人员信息
    ,pk_supplier varchar2(152) -- 
    ,pk_usergroupforcreate varchar2(30) -- 所属用户组
    ,pwderrorcount number(38,0) -- 密码错误次数
    ,pwdlevelcode varchar2(75) -- 密码安全级别
    ,pwdparam varchar2(300) -- 密码参数
    ,secondverify varchar2(30) -- 
    ,systype varchar2(75) -- 所属系统
    ,ts varchar2(29) -- 时间戳
    ,user_code varchar2(75) -- 用户编码
    ,user_code_q varchar2(75) -- 用户编码（查询）
    ,user_name varchar2(450) -- 用户名称
    ,user_name2 varchar2(450) -- 用户名称2
    ,user_name3 varchar2(450) -- 用户名称3
    ,user_name4 varchar2(450) -- 用户名称4
    ,user_name5 varchar2(450) -- 用户名称5
    ,user_name6 varchar2(450) -- 用户名称6
    ,user_note varchar2(113) -- 备注
    ,user_password varchar2(75) -- 用户密码
    ,user_type number(38,0) -- 用户类型
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
grant select on ${iol_schema}.iers_sm_user to ${iml_schema};
grant select on ${iol_schema}.iers_sm_user to ${icl_schema};
grant select on ${iol_schema}.iers_sm_user to ${idl_schema};
grant select on ${iol_schema}.iers_sm_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_sm_user is '用户信息表';
comment on column ${iol_schema}.iers_sm_user.abledate is '生效日期';
comment on column ${iol_schema}.iers_sm_user.agreementstatus is '协议版本';
comment on column ${iol_schema}.iers_sm_user.base_doc_type is '身份类型';
comment on column ${iol_schema}.iers_sm_user.contentlang is '内容语种';
comment on column ${iol_schema}.iers_sm_user.creationtime is '创建时间';
comment on column ${iol_schema}.iers_sm_user.creator is '创建人';
comment on column ${iol_schema}.iers_sm_user.cuserid is '用户主键';
comment on column ${iol_schema}.iers_sm_user.dataoriginflag is '分布式';
comment on column ${iol_schema}.iers_sm_user.disabledate is '失效日期';
comment on column ${iol_schema}.iers_sm_user.dr is '删除标志';
comment on column ${iol_schema}.iers_sm_user.email is '电子邮件地址';
comment on column ${iol_schema}.iers_sm_user.enablestate is '启用状态';
comment on column ${iol_schema}.iers_sm_user.format is '数据格式';
comment on column ${iol_schema}.iers_sm_user.identityverifycode is '认证类型';
comment on column ${iol_schema}.iers_sm_user.isca is 'ca用户';
comment on column ${iol_schema}.iers_sm_user.islocked is '锁定';
comment on column ${iol_schema}.iers_sm_user.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_sm_user.modifier is '最后修改人';
comment on column ${iol_schema}.iers_sm_user.pk_base_doc is '身份';
comment on column ${iol_schema}.iers_sm_user.pk_customer is '';
comment on column ${iol_schema}.iers_sm_user.pk_group is '所属集团';
comment on column ${iol_schema}.iers_sm_user.pk_org is '所属组织';
comment on column ${iol_schema}.iers_sm_user.pk_psndoc is '身份_人员信息';
comment on column ${iol_schema}.iers_sm_user.pk_supplier is '';
comment on column ${iol_schema}.iers_sm_user.pk_usergroupforcreate is '所属用户组';
comment on column ${iol_schema}.iers_sm_user.pwderrorcount is '密码错误次数';
comment on column ${iol_schema}.iers_sm_user.pwdlevelcode is '密码安全级别';
comment on column ${iol_schema}.iers_sm_user.pwdparam is '密码参数';
comment on column ${iol_schema}.iers_sm_user.secondverify is '';
comment on column ${iol_schema}.iers_sm_user.systype is '所属系统';
comment on column ${iol_schema}.iers_sm_user.ts is '时间戳';
comment on column ${iol_schema}.iers_sm_user.user_code is '用户编码';
comment on column ${iol_schema}.iers_sm_user.user_code_q is '用户编码（查询）';
comment on column ${iol_schema}.iers_sm_user.user_name is '用户名称';
comment on column ${iol_schema}.iers_sm_user.user_name2 is '用户名称2';
comment on column ${iol_schema}.iers_sm_user.user_name3 is '用户名称3';
comment on column ${iol_schema}.iers_sm_user.user_name4 is '用户名称4';
comment on column ${iol_schema}.iers_sm_user.user_name5 is '用户名称5';
comment on column ${iol_schema}.iers_sm_user.user_name6 is '用户名称6';
comment on column ${iol_schema}.iers_sm_user.user_note is '备注';
comment on column ${iol_schema}.iers_sm_user.user_password is '用户密码';
comment on column ${iol_schema}.iers_sm_user.user_type is '用户类型';
comment on column ${iol_schema}.iers_sm_user.start_dt is '开始时间';
comment on column ${iol_schema}.iers_sm_user.end_dt is '结束时间';
comment on column ${iol_schema}.iers_sm_user.id_mark is '增删标志';
comment on column ${iol_schema}.iers_sm_user.etl_timestamp is 'ETL处理时间戳';
