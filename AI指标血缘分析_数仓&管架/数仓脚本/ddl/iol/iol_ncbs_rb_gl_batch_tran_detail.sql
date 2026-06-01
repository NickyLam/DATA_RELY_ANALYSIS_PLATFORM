/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_batch_tran_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_batch_tran_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_batch_tran_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_batch_tran_detail(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,bal_upd_type varchar2(1) -- 余额更新类型
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,hang_write_off_flag varchar2(1) -- 挂销账标志
    ,job_run_id varchar2(50) -- 批处理任务id
    ,od_facility varchar2(1) -- 是否可透支
    ,prod_desc varchar2(200) -- 产品名称
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,subject_desc varchar2(50) -- 科目描述
    ,acct_open_date date -- 账户开户日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,hang_term varchar2(5) -- 挂账期限
    ,link_value number(15) -- 关联键值
    ,counter_dep_flag varchar2(1) -- 是否允许柜面跨行存入许可标识
    ,counter_debt_flag varchar2(1) -- 是否允许柜面跨行支取许可标识
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
grant select on ${iol_schema}.ncbs_rb_gl_batch_tran_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_batch_tran_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_batch_tran_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_batch_tran_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_batch_tran_detail is '内部账户批量开立详细信息表';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.bal_upd_type is '余额更新类型';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.hang_write_off_flag is '挂销账标志';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.od_facility is '是否可透支';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.prod_desc is '产品名称';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.subject_desc is '科目描述';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.hang_term is '挂账期限';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.link_value is '关联键值';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.counter_dep_flag is '是否允许柜面跨行存入许可标识';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.counter_debt_flag is '是否允许柜面跨行支取许可标识';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_gl_batch_tran_detail.etl_timestamp is 'ETL处理时间戳';
