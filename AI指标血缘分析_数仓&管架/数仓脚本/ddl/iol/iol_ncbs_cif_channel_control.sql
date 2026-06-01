/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cif_channel_control
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cif_channel_control
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cif_channel_control purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_channel_control(
    control_seq_no varchar2(50) -- 控制编号
    ,control_type varchar2(3) -- 控制类型
    ,auth_user_id varchar2(8) -- 授权柜员
    ,last_change_date date -- 最后修改日期
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,client_no varchar2(16) -- 客户编号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,control_status varchar2(1) -- 控制状态
    ,limit_level varchar2(5) -- 限制级别
    ,document_id varchar2(60) -- 证件号码
    ,start_date date -- 开始日期
    ,end_date date -- 结束日期
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,narrative varchar2(400) -- 摘要
    ,sign_user_id varchar2(8) -- 签约柜员
    ,sign_channel varchar2(20) -- 签约渠道
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,unlost_time varchar2(26) -- 解挂时间
    ,start_date_time varchar2(26) -- 生效时间
    ,end_date_time varchar2(26) -- 失效时间
    ,oper_narrative varchar2(400) -- 操作备注
    ,start_timestamp varchar2(26) -- 加限的交易时间戳
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
grant select on ${iol_schema}.ncbs_cif_channel_control to ${iml_schema};
grant select on ${iol_schema}.ncbs_cif_channel_control to ${icl_schema};
grant select on ${iol_schema}.ncbs_cif_channel_control to ${idl_schema};
grant select on ${iol_schema}.ncbs_cif_channel_control to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cif_channel_control is '客户渠道限制表';
comment on column ${iol_schema}.ncbs_cif_channel_control.control_seq_no is '控制编号';
comment on column ${iol_schema}.ncbs_cif_channel_control.control_type is '控制类型';
comment on column ${iol_schema}.ncbs_cif_channel_control.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cif_channel_control.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cif_channel_control.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cif_channel_control.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cif_channel_control.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cif_channel_control.control_status is '控制状态';
comment on column ${iol_schema}.ncbs_cif_channel_control.limit_level is '限制级别';
comment on column ${iol_schema}.ncbs_cif_channel_control.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_cif_channel_control.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cif_channel_control.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cif_channel_control.company is '法人';
comment on column ${iol_schema}.ncbs_cif_channel_control.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cif_channel_control.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cif_channel_control.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_cif_channel_control.sign_channel is '签约渠道';
comment on column ${iol_schema}.ncbs_cif_channel_control.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_cif_channel_control.unlost_time is '解挂时间';
comment on column ${iol_schema}.ncbs_cif_channel_control.start_date_time is '生效时间';
comment on column ${iol_schema}.ncbs_cif_channel_control.end_date_time is '失效时间';
comment on column ${iol_schema}.ncbs_cif_channel_control.oper_narrative is '操作备注';
comment on column ${iol_schema}.ncbs_cif_channel_control.start_timestamp is '加限的交易时间戳';
comment on column ${iol_schema}.ncbs_cif_channel_control.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cif_channel_control.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cif_channel_control.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cif_channel_control.etl_timestamp is 'ETL处理时间戳';
