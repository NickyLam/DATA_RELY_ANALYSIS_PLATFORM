/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_white_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_white_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_white_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_white_list(
    client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,stage_code varchar2(50) -- 期次代码
    ,tran_file_result varchar2(1) -- 交易返回结果
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,ch_client_name varchar2(200) -- 客户中文名称
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
grant select on ${iol_schema}.ncbs_rb_dc_white_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_white_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_white_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_white_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_white_list is '预约白名单管理登记簿';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.tran_file_result is '交易返回结果';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_white_list.etl_timestamp is 'ETL处理时间戳';
