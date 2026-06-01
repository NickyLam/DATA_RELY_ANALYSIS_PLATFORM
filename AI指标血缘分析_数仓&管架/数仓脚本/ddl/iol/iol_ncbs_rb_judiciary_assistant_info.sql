/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_judiciary_assistant_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_judiciary_assistant_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_judiciary_assistant_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_judiciary_assistant_info(
    reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,as_option varchar2(1) -- 司法查询操作标识
    ,assistant_content varchar2(50) -- 协助备注
    ,assistant_narrive varchar2(200) -- 协助内容
    ,company varchar2(20) -- 法人
    ,law_no varchar2(150) -- 法律文书号
    ,law_no_name varchar2(50) -- 法律文书名称
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
    ,judiciary_document_id varchar2(180) -- 执法人1证件号码
    ,judiciary_document_id2 varchar2(180) -- 执法人1证件号码2
    ,judiciary_document_type varchar2(4) -- 执法人1证件类型
    ,judiciary_document_type2 varchar2(4) -- 执法人1证件类型2
    ,judiciary_officer_name varchar2(200) -- 执法人1姓名
    ,judiciary_oth_document_id varchar2(60) -- 执法人2证件号码
    ,judiciary_oth_document_id2 varchar2(60) -- 执法人2证件号码2
    ,judiciary_oth_document_type varchar2(4) -- 执法人2证件类型
    ,judiciary_oth_document_type2 varchar2(4) -- 执法人2证件类型2
    ,judiciary_oth_officer_name varchar2(200) -- 执法人2姓名
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_judiciary_assistant_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_judiciary_assistant_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_judiciary_assistant_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_judiciary_assistant_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_judiciary_assistant_info is '司法协助信息登记簿';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.as_option is '司法查询操作标识';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.assistant_content is '协助备注';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.assistant_narrive is '协助内容';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.law_no_name is '法律文书名称';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_document_id2 is '执法人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_document_type2 is '执法人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_oth_document_id2 is '执法人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_oth_document_type2 is '执法人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_judiciary_assistant_info.etl_timestamp is 'ETL处理时间戳';
