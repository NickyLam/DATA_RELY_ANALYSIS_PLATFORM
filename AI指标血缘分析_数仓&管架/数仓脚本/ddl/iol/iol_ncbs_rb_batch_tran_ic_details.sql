/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_tran_ic_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_tran_ic_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_tran_ic_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_tran_ic_details(
    card_no varchar2(50) -- 卡号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,channel_date date -- 渠道日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,remark1 varchar2(600) -- 备注1
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_batch_tran_ic_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_ic_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_ic_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_ic_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_tran_ic_details is 'ic卡商户批量入账';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_ic_details.etl_timestamp is 'ETL处理时间戳';
