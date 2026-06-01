/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_acct_manual_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,gl_code varchar2(20) -- 科目代码
    ,reference varchar2(50) -- 交易参考号
    ,batch_no varchar2(50) -- 批次号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,facility_error_code varchar2(10) -- 是否允许透支错误码
    ,facility_error_desc varchar2(50) -- 是否允许透支错误描述
    ,manual_account_flag varchar2(1) -- 是否允许手工记账标识
    ,manual_error_code varchar2(10) -- 手工记账错误码
    ,manual_error_desc varchar2(50) -- 手工记账错误描述
    ,od_facility varchar2(1) -- 是否可透支
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail is '允许手工记账批处理信息';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.facility_error_code is '是否允许透支错误码';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.facility_error_desc is '是否允许透支错误描述';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.manual_account_flag is '是否允许手工记账标识';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.manual_error_code is '手工记账错误码';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.manual_error_desc is '手工记账错误描述';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.od_facility is '是否可透支';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_gl_acct_manual_batch_detail.etl_timestamp is 'ETL处理时间戳';
