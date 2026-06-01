/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_logon_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_logon_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_logon_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_logon_flow(
    plf_flowno varchar2(32) -- 流水号
    ,plf_ecifno varchar2(32) -- 全行统一客户号
    ,plf_operationtype varchar2(1) -- 操作类型
    ,plf_result varchar2(11) -- 登陆结果
    ,plf_resultmsg varchar2(300) -- 登陆结果描述
    ,plf_loginid varchar2(64) -- 登陆名
    ,plf_logondate varchar2(14) -- 登陆时间
    ,plf_channel varchar2(16) -- 渠道
    ,plf_deviceno varchar2(64) -- 登录设备号
    ,plf_customerip varchar2(196) -- 客户IP
    ,plf_hostname varchar2(50) -- 当前服务器主机名
    ,plf_src_serverip varchar2(32) -- 请求来源服务器IP
    ,plf_userno varchar2(32) -- 用户顺序号
    ,plf_userid varchar2(64) -- 登录名称
    ,plf_logintype varchar2(2) -- 01安全手机号码(手机APP上送) 02昵称 03账号（实体卡账号） 04证件号 05预留手机号（投融资APP上送） 06 微信登录 11 手势登录 12 指纹登录 13 二维码登录
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
grant select on ${iol_schema}.osbs_pbs_logon_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_logon_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_logon_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_logon_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_logon_flow is '个人客户登陆流水表';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_flowno is '流水号';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_operationtype is '操作类型';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_result is '登陆结果';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_resultmsg is '登陆结果描述';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_loginid is '登陆名';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_logondate is '登陆时间';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_channel is '渠道';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_deviceno is '登录设备号';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_customerip is '客户IP';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_hostname is '当前服务器主机名';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_src_serverip is '请求来源服务器IP';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_userid is '登录名称';
comment on column ${iol_schema}.osbs_pbs_logon_flow.plf_logintype is '01安全手机号码(手机APP上送) 02昵称 03账号（实体卡账号） 04证件号 05预留手机号（投融资APP上送） 06 微信登录 11 手势登录 12 指纹登录 13 二维码登录';
comment on column ${iol_schema}.osbs_pbs_logon_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_pbs_logon_flow.etl_timestamp is 'ETL处理时间戳';
