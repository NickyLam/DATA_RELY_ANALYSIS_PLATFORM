/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_tbps_cpr_login_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_tbps_cpr_login_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_tbps_cpr_login_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_tbps_cpr_login_flow(
    etl_dt date -- 数据日期
    ,clf_logno varchar2(32) -- 访问流水号
    ,clf_userno varchar2(32) -- 用户顺序号
    ,clf_ecifno varchar2(32) -- 全行统一客户号
    ,clf_state varchar2(1) -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
    ,clf_date varchar2(8) -- 日期
    ,clf_time varchar2(6) -- 时间
    ,clf_customerip varchar2(256) -- 客户IP
    ,clf_channel varchar2(4) -- 客户渠道标识(PC)
    ,clf_logintype varchar2(1) -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
    ,clf_returncode varchar2(512) -- 返回码
    ,clf_returnmsg varchar2(1024) -- 返回信息
    ,clf_ifp_sid varchar2(64) -- sessionId
    ,clf_hostip varchar2(40) -- 服务IP
    ,clf_wxcode varchar2(64) -- 微信号
    ,clf_useragent varchar2(512) -- 客户浏览器类型
    ,clf_token varchar2(256) -- 跳转登录token
    ,clf_globalflow varchar2(32) -- 全局流水
    ,clf_clientmac varchar2(64) -- 客户MAC地址
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_tbps_cpr_login_flow to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_tbps_cpr_login_flow is '登录记录表';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_logno is '访问流水号';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_userno is '用户顺序号';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_ecifno is '全行统一客户号';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_state is '状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_date is '日期';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_time is '时间';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_customerip is '客户IP';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_channel is '客户渠道标识(PC)';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_logintype is '登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_returncode is '返回码';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_returnmsg is '返回信息';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_ifp_sid is 'sessionId';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_hostip is '服务IP';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_wxcode is '微信号';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_useragent is '客户浏览器类型';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_token is '跳转登录token';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_globalflow is '全局流水';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.clf_clientmac is '客户MAC地址';
comment on column ${itl_schema}.itl_edw_tbps_cpr_login_flow.etl_timestamp is 'ETL处理时间戳';