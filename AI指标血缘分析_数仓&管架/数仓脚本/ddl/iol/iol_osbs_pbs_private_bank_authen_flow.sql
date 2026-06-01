/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_private_bank_authen_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_private_bank_authen_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_private_bank_authen_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_private_bank_authen_flow(
    apb_flowno varchar2(32) -- 流水表流水号
    ,apb_no varchar2(32) -- 授权表流水号
    ,apb_channelcode varchar2(8) -- 渠道号
    ,apb_ecifno varchar2(10) -- 客户号
    ,apb_certno varchar2(20) -- 身份证
    ,apb_ecifphone varchar2(16) -- ECIF预留手机号
    ,apb_wechatphone varchar2(16) -- 微信客户手机号
    ,apb_updatestatus varchar2(1) -- 更新状态：1、更新  0、不更新 3更新失败
    ,apb_createtime varchar2(14) -- 创建时间
    ,apb_updatetime varchar2(14) -- 更新时间
    ,apb_enabled varchar2(1) -- 授权是否有效：1、有效;2、失效
    ,apb_appid varchar2(50) -- APPID
    ,apb_operation varchar2(10) -- 操作（1、新增2、修改3、删除4、解除授权）
    ,apb_operationstatus varchar2(1) -- 操作状态（0、开始、1、成功、2、失败）
    ,apb_failreasoncode varchar2(10) -- 失败原因代码0没有失败
    ,apb_remake varchar2(30) -- 备注
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
grant select on ${iol_schema}.osbs_pbs_private_bank_authen_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_private_bank_authen_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_private_bank_authen_flow is '小程序网银授权流水表';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_flowno is '流水表流水号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_no is '授权表流水号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_channelcode is '渠道号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_ecifno is '客户号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_certno is '身份证';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_ecifphone is 'ECIF预留手机号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_wechatphone is '微信客户手机号';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_updatestatus is '更新状态：1、更新  0、不更新 3更新失败';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_createtime is '创建时间';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_updatetime is '更新时间';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_enabled is '授权是否有效：1、有效;2、失效';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_appid is 'APPID';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_operation is '操作（1、新增2、修改3、删除4、解除授权）';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_operationstatus is '操作状态（0、开始、1、成功、2、失败）';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_failreasoncode is '失败原因代码0没有失败';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.apb_remake is '备注';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_pbs_private_bank_authen_flow.etl_timestamp is 'ETL处理时间戳';
