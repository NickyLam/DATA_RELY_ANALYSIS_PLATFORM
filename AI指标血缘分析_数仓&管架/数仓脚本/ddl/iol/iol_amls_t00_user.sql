/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t00_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t00_user
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t00_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t00_user(
    organkey varchar2(18) -- 所属机构 仅表示原所属机构
    ,flag varchar2(1) -- 标志位 0:禁用1:正常2:删除
    ,isbuildin varchar2(2) -- 是否内建用户1:是0:否
    ,isadmin varchar2(1) -- 是否管理员  1:管理员0:非管理员
    ,address varchar2(192) -- 用户地址
    ,postalcode varchar2(9) -- 邮政编码
    ,emailaddress varchar2(96) -- 电子邮箱
    ,telephone varchar2(48) -- 电话号码
    ,mobilephone varchar2(48) -- 移动电话
    ,des varchar2(384) -- 简短描述
    ,sex varchar2(2) -- 性别 1:男2:女X:其它
    ,birth varchar2(48) -- 出生年月日
    ,education varchar2(18) -- 学历
    ,isnewuser varchar2(2) -- 是否新建用户1:是0:否
    ,position varchar2(48) -- 职务名称
    ,postitle varchar2(48) -- 职称
    ,worklevel varchar2(48) -- 行员级别
    ,political varchar2(15) -- 政治面貌
    ,indate varchar2(48) -- 入行时间
    ,stafcode varchar2(18) -- 员工号      稽核报告编号 由员工号按规则生成
    ,remark varchar2(384) -- 其它
    ,createdate varchar2(48) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modifydate varchar2(48) -- 修改时间
    ,modifier varchar2(48) -- 修改人员
    ,curr_cd varchar2(8) -- 币种
    ,color varchar2(15) -- 颜色
    ,indextemplate varchar2(48) -- 首页模板
    ,wrongpassword number(22) -- 登录密码错误次数
    ,defgroupkey varchar2(18) -- 默认组
    ,template_id varchar2(24) -- 安全模版主键
    ,template_name varchar2(96) -- 安全模版名称
    ,username varchar2(384) -- 用户名 主键
    ,realname varchar2(384) -- 真实名（中文名）
    ,password varchar2(48) -- 密码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amls_t00_user to ${iml_schema};
grant select on ${iol_schema}.amls_t00_user to ${icl_schema};
grant select on ${iol_schema}.amls_t00_user to ${idl_schema};
grant select on ${iol_schema}.amls_t00_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t00_user is '用户表';
comment on column ${iol_schema}.amls_t00_user.organkey is '所属机构 仅表示原所属机构';
comment on column ${iol_schema}.amls_t00_user.flag is '标志位 0:禁用1:正常2:删除';
comment on column ${iol_schema}.amls_t00_user.isbuildin is '是否内建用户1:是0:否';
comment on column ${iol_schema}.amls_t00_user.isadmin is '是否管理员  1:管理员0:非管理员';
comment on column ${iol_schema}.amls_t00_user.address is '用户地址';
comment on column ${iol_schema}.amls_t00_user.postalcode is '邮政编码';
comment on column ${iol_schema}.amls_t00_user.emailaddress is '电子邮箱';
comment on column ${iol_schema}.amls_t00_user.telephone is '电话号码';
comment on column ${iol_schema}.amls_t00_user.mobilephone is '移动电话';
comment on column ${iol_schema}.amls_t00_user.des is '简短描述';
comment on column ${iol_schema}.amls_t00_user.sex is '性别 1:男2:女X:其它';
comment on column ${iol_schema}.amls_t00_user.birth is '出生年月日';
comment on column ${iol_schema}.amls_t00_user.education is '学历';
comment on column ${iol_schema}.amls_t00_user.isnewuser is '是否新建用户1:是0:否';
comment on column ${iol_schema}.amls_t00_user.position is '职务名称';
comment on column ${iol_schema}.amls_t00_user.postitle is '职称';
comment on column ${iol_schema}.amls_t00_user.worklevel is '行员级别';
comment on column ${iol_schema}.amls_t00_user.political is '政治面貌';
comment on column ${iol_schema}.amls_t00_user.indate is '入行时间';
comment on column ${iol_schema}.amls_t00_user.stafcode is '员工号      稽核报告编号 由员工号按规则生成';
comment on column ${iol_schema}.amls_t00_user.remark is '其它';
comment on column ${iol_schema}.amls_t00_user.createdate is '创建时间';
comment on column ${iol_schema}.amls_t00_user.creator is '创建人';
comment on column ${iol_schema}.amls_t00_user.modifydate is '修改时间';
comment on column ${iol_schema}.amls_t00_user.modifier is '修改人员';
comment on column ${iol_schema}.amls_t00_user.curr_cd is '币种';
comment on column ${iol_schema}.amls_t00_user.color is '颜色';
comment on column ${iol_schema}.amls_t00_user.indextemplate is '首页模板';
comment on column ${iol_schema}.amls_t00_user.wrongpassword is '登录密码错误次数';
comment on column ${iol_schema}.amls_t00_user.defgroupkey is '默认组';
comment on column ${iol_schema}.amls_t00_user.template_id is '安全模版主键';
comment on column ${iol_schema}.amls_t00_user.template_name is '安全模版名称';
comment on column ${iol_schema}.amls_t00_user.username is '用户名 主键';
comment on column ${iol_schema}.amls_t00_user.realname is '真实名（中文名）';
comment on column ${iol_schema}.amls_t00_user.password is '密码';
comment on column ${iol_schema}.amls_t00_user.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t00_user.etl_timestamp is 'ETL处理时间戳';
