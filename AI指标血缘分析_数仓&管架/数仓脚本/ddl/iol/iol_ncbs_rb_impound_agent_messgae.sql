/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_impound_agent_messgae
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_impound_agent_messgae
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_impound_agent_messgae(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,agent_department varchar2(20) -- 所属部门
    ,agent_number varchar2(50) -- 办理人编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,agent_document_id varchar2(60) -- 办理人证件号码
    ,agent_document_type varchar2(4) -- 办理人证件类型
    ,agent_name varchar2(200) -- 办理人姓名
    ,transfer_reason varchar2(200) -- 扣划原因
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
grant select on ${iol_schema}.ncbs_rb_impound_agent_messgae to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_impound_agent_messgae to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_agent_messgae to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_agent_messgae to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_impound_agent_messgae is '行内强制扣划办理人信息记录表';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.agent_department is '所属部门';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.agent_number is '办理人编号';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.company is '法人';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.agent_document_id is '办理人证件号码';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.agent_document_type is '办理人证件类型';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.agent_name is '办理人姓名';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.transfer_reason is '扣划原因';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_impound_agent_messgae.etl_timestamp is 'ETL处理时间戳';
