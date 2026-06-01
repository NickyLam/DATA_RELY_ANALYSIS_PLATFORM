/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_private_bank_authen
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_private_bank_authen
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_private_bank_authen purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_private_bank_authen(
    apb_no varchar2(32) -- 流水号
    ,apb_channelcode varchar2(8) -- 渠道号
    ,apb_ecifno varchar2(10) -- 客户号
    ,apb_certno varchar2(20) -- 身份证
    ,apb_createtime varchar2(14) -- 创建时间
    ,apb_updatetime varchar2(14) -- 更新时间
    ,apb_enabled varchar2(1) -- 授权是否有效：1、有效;2、失效
    ,apb_appid varchar2(50) -- APPID
    ,apb_loginstatu varchar2(1) -- 登录状态 登录(默认)：0,退出登录：1
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
grant select on ${iol_schema}.osbs_pbs_private_bank_authen to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_private_bank_authen is '小程序网银授权关系表';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_no is '流水号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_channelcode is '渠道号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_ecifno is '客户号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_certno is '身份证';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_createtime is '创建时间';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_updatetime is '更新时间';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_enabled is '授权是否有效：1、有效;2、失效';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_appid is 'APPID';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.apb_loginstatu is '登录状态 登录(默认)：0,退出登录：1';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen.etl_timestamp is 'ETL处理时间戳';
