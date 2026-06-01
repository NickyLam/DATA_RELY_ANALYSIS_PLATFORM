/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_law_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_law_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_law_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_law_attach(
    batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,detail_file_name varchar2(200) -- 明细文件名称
    ,law_no varchar2(150) -- 法律文书号
    ,main_file_name varchar2(200) -- 汇总文件名称
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
    ,judiciary_document_id varchar2(180) -- 执法人1证件号码
    ,judiciary_document_id1 varchar2(60) -- 执法人1证件号码1
    ,judiciary_document_type varchar2(4) -- 执法人1证件类型
    ,judiciary_document_type1 varchar2(4) -- 执法人1证件类型1
    ,judiciary_officer_name varchar2(200) -- 执法人1姓名
    ,judiciary_oth_document_id varchar2(60) -- 执法人2证件号码
    ,judiciary_oth_document_id1 varchar2(60) -- 执法人2证件号码1
    ,judiciary_oth_document_type varchar2(4) -- 执法人2证件类型
    ,judiciary_oth_document_type1 varchar2(4) -- 执法人2证件类型1
    ,judiciary_oth_officer_name varchar2(200) -- 执法人2姓名
    ,case_type varchar2(5) -- 案件类型
    ,deduction_judiciary_part varchar2(200) -- 执法部门
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
grant select on ${iol_schema}.ncbs_rb_batch_law_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_law_attach is '批量司法查询附加表';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.detail_file_name is '明细文件名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.main_file_name is '汇总文件名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_document_id1 is '执法人1证件号码1';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_document_type1 is '执法人1证件类型1';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_oth_document_id1 is '执法人2证件号码1';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_oth_document_type1 is '执法人2证件类型1';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.case_type is '案件类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.deduction_judiciary_part is '执法部门';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_attach.etl_timestamp is 'ETL处理时间戳';
