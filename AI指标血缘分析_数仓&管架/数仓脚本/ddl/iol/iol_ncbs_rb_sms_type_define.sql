/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_sms_type_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_sms_type_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_sms_type_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_sms_type_define(
    client_indicator varchar2(1) -- 客户标识
    ,company varchar2(20) -- 法人
    ,match_condition varchar2(3000) -- 检查内容(匹配条件)
    ,require_agr_flag varchar2(1) -- 是否需要短信签约
    ,send_method varchar2(1) -- 发送方式
    ,send_priority varchar2(1) -- 短信发送优先级
    ,sms_client_type varchar2(1) -- 短信客户类型
    ,sms_desc varchar2(200) -- 短信类型描述
    ,sms_send_time varchar2(26) -- 短信发送时间
    ,sms_send_type varchar2(50) -- 短信发送类型
    ,sms_template varchar2(500) -- 短信模板
    ,sms_tran_type varchar2(10) -- 交易类型范围
    ,sms_type varchar2(50) -- 短信类型
    ,template_flag varchar2(1) -- 是否使用短信模板
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,remind_days number(5) -- 提前提醒天数
    ,sms_min_amt number(17,2) -- 短信发送最小金额
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
grant select on ${iol_schema}.ncbs_rb_sms_type_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_sms_type_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_sms_type_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_sms_type_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_sms_type_define is '短信类型定义表';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.client_indicator is '客户标识';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.company is '法人';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.match_condition is '检查内容(匹配条件)';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.require_agr_flag is '是否需要短信签约';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.send_method is '发送方式';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.send_priority is '短信发送优先级';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_client_type is '短信客户类型';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_desc is '短信类型描述';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_send_time is '短信发送时间';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_send_type is '短信发送类型';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_template is '短信模板';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_tran_type is '交易类型范围';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_type is '短信类型';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.template_flag is '是否使用短信模板';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.remind_days is '提前提醒天数';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.sms_min_amt is '短信发送最小金额';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_sms_type_define.etl_timestamp is 'ETL处理时间戳';
